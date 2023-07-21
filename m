Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65FA1F94D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45C5C433C7;
	Fri, 21 Jul 2023 16:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956618;
	bh=76vKWCsM1/KpX1GgX9YgkvuQQEH/ceGW4EVWQ23J8OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUpzO8v1z7femh+KwWt6z2q3yAngX1Uj0rcIpP6THVY3aNKObzpGim9vJ5NSttgY1
	 AvOwdpu4zYrE6dyh90vntW9IxkJYy/XWNmhIX7E/mFelFR8oLef7wT+NPHPHlK4XKf
	 f/hapWjtiqQU+c13BTaBbihWtsKvsjZ6hLS3hXjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH 6.4 222/292] ceph: fix blindly expanding the readahead windows
Date: Fri, 21 Jul 2023 18:05:31 +0200
Message-ID: <20230721160538.405416763@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

commit dc94bb8f271c079f69583d0f12a489aaf5202751 upstream.

Blindly expanding the readahead windows will cause unneccessary
pagecache thrashing and also will introduce the network workload.
We should disable expanding the windows if the readahead is disabled
and also shouldn't expand the windows too much.

Expanding forward firstly instead of expanding backward for possible
sequential reads.

Bound `rreq->len` to the actual file size to restore the previous page
cache usage.

The posix_fadvise may change the maximum size of a file readahead.

Cc: stable@vger.kernel.org
Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
Link: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
Link: https://www.spinics.net/lists/ceph-users/msg76183.html
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-and-tested-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -187,16 +187,42 @@ static void ceph_netfs_expand_readahead(
 	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_layout *lo = &ci->i_layout;
+	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
+	loff_t end = rreq->start + rreq->len, new_end;
+	struct ceph_netfs_request_data *priv = rreq->netfs_priv;
+	unsigned long max_len;
 	u32 blockoff;
-	u64 blockno;
 
-	/* Expand the start downward */
-	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
-	rreq->start = blockno * lo->stripe_unit;
-	rreq->len += blockoff;
+	if (priv) {
+		/* Readahead is disabled by posix_fadvise POSIX_FADV_RANDOM */
+		if (priv->file_ra_disabled)
+			max_pages = 0;
+		else
+			max_pages = priv->file_ra_pages;
 
-	/* Now, round up the length to the next block */
-	rreq->len = roundup(rreq->len, lo->stripe_unit);
+	}
+
+	/* Readahead is disabled */
+	if (!max_pages)
+		return;
+
+	max_len = max_pages << PAGE_SHIFT;
+
+	/*
+	 * Try to expand the length forward by rounding up it to the next
+	 * block, but do not exceed the file size, unless the original
+	 * request already exceeds it.
+	 */
+	new_end = min(round_up(end, lo->stripe_unit), rreq->i_size);
+	if (new_end > end && new_end <= rreq->start + max_len)
+		rreq->len = new_end - rreq->start;
+
+	/* Try to expand the start downward */
+	div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
+	if (rreq->len + blockoff <= max_len) {
+		rreq->start -= blockoff;
+		rreq->len += blockoff;
+	}
 }
 
 static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)


