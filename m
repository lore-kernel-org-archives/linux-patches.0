Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE51BA36
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD310C433C8;
	Mon, 26 Jun 2023 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804433;
	bh=rSEb/w50RTkiFKiOzkPGyvLE6/1Q7fd6nKAAIBZYvxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xh6ydESiHY0UaICAypirNzPtQygeKl+BUIzKugUZiAJ1lf20jouanb1MDlIdjhgy5
	 frXoT45dJza7kqd3Kn5JSvTv9gNVvUHkjyKjKHZKEIfEjF0952NLpX8MvAlDlmB/Y7
	 3ECSUNvoEFyB2GKP3sPrPBvM5HNdkd9a+etOGYRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/170] gfs2: Dont get stuck writing page onto itself under direct I/O
Date: Mon, 26 Jun 2023 20:12:04 +0200
Message-ID: <20230626180807.432250916@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit fa58cc888d67e640e354d8b3ceef877ea167b0cf ]

When a direct I/O write is performed, iomap_dio_rw() invalidates the
part of the page cache which the write is going to before carrying out
the write.  In the odd case, the direct I/O write will be reading from
the same page it is writing to.  gfs2 carries out writes with page
faults disabled, so it should have been obvious that this page
invalidation can cause iomap_dio_rw() to never make any progress.
Currently, gfs2 will end up in an endless retry loop in
gfs2_file_direct_write() instead, though.

Break this endless loop by limiting the number of retries and falling
back to buffered I/O after that.

Also simplify should_fault_in_pages() sightly and add a comment to make
the above case easier to understand.

Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 60c6fb91fb589..bc6cd5f4b1077 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -783,9 +783,13 @@ static inline bool should_fault_in_pages(struct iov_iter *i,
 	if (!user_backed_iter(i))
 		return false;
 
+	/*
+	 * Try to fault in multiple pages initially.  When that doesn't result
+	 * in any progress, fall back to a single page.
+	 */
 	size = PAGE_SIZE;
 	offs = offset_in_page(iocb->ki_pos);
-	if (*prev_count != count || !*window_size) {
+	if (*prev_count != count) {
 		size_t nr_dirtied;
 
 		nr_dirtied = max(current->nr_dirtied_pause -
@@ -869,6 +873,7 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	size_t prev_count = 0, window_size = 0;
 	size_t written = 0;
+	bool enough_retries;
 	ssize_t ret;
 
 	/*
@@ -912,11 +917,17 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	if (ret > 0)
 		written = ret;
 
+	enough_retries = prev_count == iov_iter_count(from) &&
+			 window_size <= PAGE_SIZE;
 	if (should_fault_in_pages(from, iocb, &prev_count, &window_size)) {
 		gfs2_glock_dq(gh);
 		window_size -= fault_in_iov_iter_readable(from, window_size);
-		if (window_size)
-			goto retry;
+		if (window_size) {
+			if (!enough_retries)
+				goto retry;
+			/* fall back to buffered I/O */
+			ret = 0;
+		}
 	}
 out_unlock:
 	if (gfs2_holder_queued(gh))
-- 
2.39.2



