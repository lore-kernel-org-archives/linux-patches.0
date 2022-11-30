Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1161F79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A979C433D7;
	Wed, 30 Nov 2022 18:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833696;
	bh=fO+6KrYpgxNYsfifLhSBcohkhGWUinWTzwRTcOPU92c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXTGCQBdMPX1gEpTwzOxDityw8mFLJdqXnMrWrT+DFMlaE90a3CxQJ2gFv0eoUYu6
	 WWT5vKJqRF6Ayff1ZKX5CjkOHPmfHl1CszF3Hdua1S5KvWH//mj98iJxIM5hH/aPHh
	 70MmXPeJrH7GPmAr2FViy+NsXmNf+sL1U4GLZL7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	syzbot+462da39f0667b357c4b6@syzkaller.appspotmail.com
Subject: [PATCH 5.15 187/206] fuse: lock inode unconditionally in fuse_fallocate()
Date: Wed, 30 Nov 2022 19:23:59 +0100
Message-Id: <20221130180537.774748181@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miklos Szeredi <mszeredi@redhat.com>

commit 44361e8cf9ddb23f17bdcc40ca944abf32e83e79 upstream.

file_modified() must be called with inode lock held.  fuse_fallocate()
didn't lock the inode in case of just FALLOC_KEEP_SIZE flags value, which
resulted in a kernel Warning in notify_change().

Lock the inode unconditionally, like all other fallocate implementations
do.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Reported-and-tested-by: syzbot+462da39f0667b357c4b6@syzkaller.appspotmail.com
Fixes: 4a6f278d4827 ("fuse: add file_modified() to fallocate")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |   41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2937,11 +2937,9 @@ static long fuse_file_fallocate(struct f
 		.mode = mode
 	};
 	int err;
-	bool lock_inode = !(mode & FALLOC_FL_KEEP_SIZE) ||
-			   (mode & (FALLOC_FL_PUNCH_HOLE |
-				    FALLOC_FL_ZERO_RANGE));
-
-	bool block_faults = FUSE_IS_DAX(inode) && lock_inode;
+	bool block_faults = FUSE_IS_DAX(inode) &&
+		(!(mode & FALLOC_FL_KEEP_SIZE) ||
+		 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 		     FALLOC_FL_ZERO_RANGE))
@@ -2950,22 +2948,20 @@ static long fuse_file_fallocate(struct f
 	if (fm->fc->no_fallocate)
 		return -EOPNOTSUPP;
 
-	if (lock_inode) {
-		inode_lock(inode);
-		if (block_faults) {
-			filemap_invalidate_lock(inode->i_mapping);
-			err = fuse_dax_break_layouts(inode, 0, 0);
-			if (err)
-				goto out;
-		}
-
-		if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)) {
-			loff_t endbyte = offset + length - 1;
-
-			err = fuse_writeback_range(inode, offset, endbyte);
-			if (err)
-				goto out;
-		}
+	inode_lock(inode);
+	if (block_faults) {
+		filemap_invalidate_lock(inode->i_mapping);
+		err = fuse_dax_break_layouts(inode, 0, 0);
+		if (err)
+			goto out;
+	}
+
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)) {
+		loff_t endbyte = offset + length - 1;
+
+		err = fuse_writeback_range(inode, offset, endbyte);
+		if (err)
+			goto out;
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
@@ -3015,8 +3011,7 @@ out:
 	if (block_faults)
 		filemap_invalidate_unlock(inode->i_mapping);
 
-	if (lock_inode)
-		inode_unlock(inode);
+	inode_unlock(inode);
 
 	fuse_flush_time_update(inode);
 


