Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20072E0B45;
	Tue,  8 Jul 2025 16:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992392; cv=none; b=R48rCxthyfGgjzyQxWN0OqbQ/5XABwpHQGNfvxl907HeXFRS/cyxvPfBVKxZxNxs2gNUNwzenrwdH6pV6Wxj9AIbwTDR+gm7YGQ4uH9xA4pZ+oDCkcilm+Iy9suYq4fCEz7xXAho809x5JnjkxW/BJCI33Icw1Eef/BP+Eqv4sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992392; c=relaxed/simple;
	bh=Xw3e3dmg0GHOgJdqzrj0az74XjMerZDBG+rK5Zs7fqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qitzv/0FGEY/kG1q0Ga7Kfj/jdiyX3P1Mm6XhnYDTFhOMj2mi7cuX458k+fFJ8J1R0caGG67Pf+F3gjDc/QdqemBDRziOZ+fGo6EraVdibrAVjPeqKJMfYk3ymorghprpOxPcDCGBNd8pksuAW9jTAMxrrKTaIbf/9k+sfFD2S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmt8cKuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmt8cKuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F17C4CEED;
	Tue,  8 Jul 2025 16:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992391;
	bh=Xw3e3dmg0GHOgJdqzrj0az74XjMerZDBG+rK5Zs7fqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmt8cKuQDwD5w3gkQEDP7ThScZE9M6hl7F+R0M0PYtdevQS4twlsZKT4zZar75W5M
	 Myyiklp8oKpu4C0oBVRQ01iM5RzgsujdDqw2OE75G0uSZHPvAbOjmqMsXbJ3X4oFqV
	 8cCLSmev7EZTN3cZnff7J9+ihM95FUV1zR3MrqOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/132] f2fs: prevent writing without fallocate() for pinned files
Date: Tue,  8 Jul 2025 18:23:05 +0200
Message-ID: <20250708162232.805219002@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 3fdd89b452c2ea5e2195d6e315bef122769584c9 ]

In a case writing without fallocate(), we can't guarantee it's allocated
in the conventional area for zoned stroage. To make it consistent across
storage devices, we disallow it regardless of storage device types.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: ba8dac350faf ("f2fs: fix to zero post-eof page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 3e3822115d1e4..2eff37cc37601 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -57,7 +57,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dnode_of_data dn;
-	bool need_alloc = true;
+	bool need_alloc = !f2fs_is_pinned_file(inode);
 	int err = 0;
 	vm_fault_t ret;
 
@@ -114,19 +114,18 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 		goto out_sem;
 	}
 
+	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	if (need_alloc) {
 		/* block allocation */
-		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		err = f2fs_get_block_locked(&dn, page->index);
-	}
-
-#ifdef CONFIG_F2FS_FS_COMPRESSION
-	if (!need_alloc) {
-		set_new_dnode(&dn, inode, NULL, NULL, 0);
+	} else {
 		err = f2fs_get_dnode_of_data(&dn, page->index, LOOKUP_NODE);
 		f2fs_put_dnode(&dn);
+		if (f2fs_is_pinned_file(inode) &&
+		    !__is_valid_data_blkaddr(dn.data_blkaddr))
+			err = -EIO;
 	}
-#endif
+
 	if (err) {
 		unlock_page(page);
 		goto out_sem;
@@ -3332,7 +3331,7 @@ static int f2fs_ioc_set_pin_file(struct file *filp, unsigned long arg)
 		goto done;
 	}
 
-	if (f2fs_sb_has_blkzoned(sbi) && F2FS_HAS_BLOCKS(inode)) {
+	if (F2FS_HAS_BLOCKS(inode)) {
 		ret = -EFBIG;
 		goto out;
 	}
@@ -4919,6 +4918,8 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	bool dio;
 	bool may_need_sync = true;
 	int preallocated;
+	const loff_t pos = iocb->ki_pos;
+	const ssize_t count = iov_iter_count(from);
 	ssize_t ret;
 
 	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode)))) {
@@ -4940,6 +4941,12 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		inode_lock(inode);
 	}
 
+	if (f2fs_is_pinned_file(inode) &&
+	    !f2fs_overwrite_io(inode, pos, count)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
 	ret = f2fs_write_checks(iocb, from);
 	if (ret <= 0)
 		goto out_unlock;
-- 
2.39.5



