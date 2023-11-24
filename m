Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEC92FC36;
	Fri, 24 Nov 2023 19:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHbT8176"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FFEC433C7;
	Fri, 24 Nov 2023 19:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853318;
	bh=lvtUD0ZJeJ4xQz/cNMM22sWiLGWZSEvY13on6D9KbMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHbT8176OkhKgO8APXDKjhj+jtP5R2xnqWPqTmTLBhC+XyagrJSx6hwBs9GVaFEQx
	 BsmK6zP9PPd6JB58xcqbNsN/SuCjurzBHOzO18F+kePGTEV5mkqK+H3gll/C8z5Yil
	 JaASnivlLSmjW/2DpOJTXWmxvcDHUzVXtcaY/ZfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/297] xfs: convert buf_cancel_table allocation to kmalloc_array
Date: Fri, 24 Nov 2023 17:53:03 +0000
Message-ID: <20231124172005.202343160@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 910bbdf2f4d7df46781bc9b723048f5ebed3d0d7 ]

While we're messing around with how recovery allocates and frees the
buffer cancellation table, convert the allocation to use kmalloc_array
instead of the old kmem_alloc APIs, and make it handle a null return,
even though that's not likely.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |  2 +-
 fs/xfs/xfs_buf_item_recover.c   | 14 ++++++++++----
 fs/xfs/xfs_log_recover.c        |  4 +++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index b8b65a6e9b1ec..81a065b0b5710 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -120,7 +120,7 @@ int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
 		struct xfs_inode **ipp);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
-void xlog_alloc_buf_cancel_table(struct xlog *log);
+int xlog_alloc_buf_cancel_table(struct xlog *log);
 void xlog_free_buf_cancel_table(struct xlog *log);
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 635f7f8ed9c2d..31cbe7deebfaf 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1025,19 +1025,25 @@ xlog_check_buf_cancel_table(
 }
 #endif
 
-void
+int
 xlog_alloc_buf_cancel_table(
 	struct xlog	*log)
 {
+	void		*p;
 	int		i;
 
 	ASSERT(log->l_buf_cancel_table == NULL);
 
-	log->l_buf_cancel_table = kmem_zalloc(XLOG_BC_TABLE_SIZE *
-						 sizeof(struct list_head),
-						 0);
+	p = kmalloc_array(XLOG_BC_TABLE_SIZE, sizeof(struct list_head),
+			  GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	log->l_buf_cancel_table = p;
 	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
 		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
+
+	return 0;
 }
 
 void
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 18d8eebc2d445..aeb01d4c0423b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3256,7 +3256,9 @@ xlog_do_log_recovery(
 	 * First do a pass to find all of the cancelled buf log items.
 	 * Store them in the buf_cancel_table for use in the second pass.
 	 */
-	xlog_alloc_buf_cancel_table(log);
+	error = xlog_alloc_buf_cancel_table(log);
+	if (error)
+		return error;
 
 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
 				      XLOG_RECOVER_PASS1, NULL);
-- 
2.42.0



