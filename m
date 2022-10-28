Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A453823A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8BAC433C1;
	Fri, 28 Oct 2022 12:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666958668;
	bh=oKj/oXU0MoN0t/0g4U5W9dGK3RaEh2aNrJWANmkqIHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6wnIb8gPvFAo8Hs6L6HZIFqQv6X/VsA4zhoo8p0LaISNbdGc2fe09X+z++RkW9tJ
	 w71sChyr7aMAQcWEBgZfcbaf6CY86Dx0QpCSN3UnudBtHXdgffXBXtblLGLIkKJVth
	 xBa2gqsNHtnp0nK9kZ6HuUIFWJOu7LZC0uzrZP2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Yan Wang <wangyan122@huawei.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 01/73] ocfs2: clear dinode links count in case of error
Date: Fri, 28 Oct 2022 14:02:58 +0200
Message-Id: <20221028120232.421972390@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 28f4821b1b53e0649706912e810c6c232fc506f9 upstream.

In ocfs2_mknod(), if error occurs after dinode successfully allocated,
ocfs2 i_links_count will not be 0.

So even though we clear inode i_nlink before iput in error handling, it
still won't wipe inode since we'll refresh inode from dinode during inode
lock.  So just like clear inode i_nlink, we clear ocfs2 i_links_count as
well.  Also do the same change for ocfs2_symlink().

Link: https://lkml.kernel.org/r/20221017130227.234480-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Yan Wang <wangyan122@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/namei.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -231,6 +231,7 @@ static int ocfs2_mknod(struct inode *dir
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dirfe;
+	struct ocfs2_dinode *fe = NULL;
 	struct buffer_head *new_fe_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
@@ -381,6 +382,7 @@ static int ocfs2_mknod(struct inode *dir
 		goto leave;
 	}
 
+	fe = (struct ocfs2_dinode *) new_fe_bh->b_data;
 	if (S_ISDIR(mode)) {
 		status = ocfs2_fill_new_dir(osb, handle, dir, inode,
 					    new_fe_bh, data_ac, meta_ac);
@@ -453,8 +455,11 @@ roll_back:
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
@@ -2023,8 +2028,11 @@ bail:
 					ocfs2_clusters_to_bytes(osb->sb, 1));
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)


