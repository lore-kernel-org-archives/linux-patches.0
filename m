Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310F322259B;
	Tue,  8 Jul 2025 16:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992386; cv=none; b=JeEn7jean6qDs2p0kiG5FqyjM1dFdaZ+c6XNRhJJkZUNE+DBAgF0rLYeLwhhGFEFE0bH4cfM0J0ILBMeKf1k6RU6WDnadC/gtXWZ4or+N5P38QnXffbiqTvuOfcFIyr9Hy9NYs3YcbEaOByl0ybw93mP2iE/iNuyZngkBo0WVRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992386; c=relaxed/simple;
	bh=8GaY386EHtDSs5SgU3TBFEdrf8hk30jasuLweZMrXz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6aWZAgmqgvQ3mCT79KeA3Izb8S5U1r0idFKvx6QtYDdfFP+JJOJ+c8IbOLgSuGRZYhIFdULmiJ4xrjC3yiaFeKTQHVwsn2dMpQt1ZK0vALbI1WOc01KOBuU3pnqGVTNSrl4ILtPTemV1QjkU1lvPgIZS9UcdUDKfoRe/cMER8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKTkncBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKTkncBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A003AC4CEED;
	Tue,  8 Jul 2025 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992386;
	bh=8GaY386EHtDSs5SgU3TBFEdrf8hk30jasuLweZMrXz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKTkncBcZSb6ZvngJjnAkmStBesAQTjZMcBnPukWZONRz2SPo5BSi33KmEGfKZ2Oa
	 DN5PEa5gKoN4aS/Hn/InnXihMy4Cw/AEEztQunY1ghbcdbzpUhztQRw775e73ALbRz
	 krGYyuZiUQYodA4/WbD7N4cbqVnHiiKTlnxpALTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/132] f2fs: add tracepoint for f2fs_vm_page_mkwrite()
Date: Tue,  8 Jul 2025 18:23:04 +0200
Message-ID: <20250708162232.780052058@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 87f3afd366f7c668be0269efda8a89741a3ea6b3 ]

This patch adds to support tracepoint for f2fs_vm_page_mkwrite(),
meanwhile it prints more details for trace_f2fs_filemap_fault().

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: ba8dac350faf ("f2fs: fix to zero post-eof page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c              | 25 ++++++++++++++----------
 include/trace/events/f2fs.h | 39 ++++++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ae129044c52f4..3e3822115d1e4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -46,7 +46,7 @@ static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
 		f2fs_update_iostat(F2FS_I_SB(inode), inode,
 					APP_MAPPED_READ_IO, F2FS_BLKSIZE);
 
-	trace_f2fs_filemap_fault(inode, vmf->pgoff, (unsigned long)ret);
+	trace_f2fs_filemap_fault(inode, vmf->pgoff, vmf->vma->vm_flags, ret);
 
 	return ret;
 }
@@ -59,26 +59,29 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	struct dnode_of_data dn;
 	bool need_alloc = true;
 	int err = 0;
+	vm_fault_t ret;
 
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return VM_FAULT_SIGBUS;
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED))
-		return VM_FAULT_SIGBUS;
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+		err = -EIO;
+		goto out;
+	}
 
 	if (unlikely(f2fs_cp_error(sbi))) {
 		err = -EIO;
-		goto err;
+		goto out;
 	}
 
 	if (!f2fs_is_checkpoint_ready(sbi)) {
 		err = -ENOSPC;
-		goto err;
+		goto out;
 	}
 
 	err = f2fs_convert_inline_inode(inode);
 	if (err)
-		goto err;
+		goto out;
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	if (f2fs_compressed_file(inode)) {
@@ -86,7 +89,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 
 		if (ret < 0) {
 			err = ret;
-			goto err;
+			goto out;
 		} else if (ret) {
 			need_alloc = false;
 		}
@@ -153,13 +156,15 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	f2fs_update_iostat(sbi, inode, APP_MAPPED_IO, F2FS_BLKSIZE);
 	f2fs_update_time(sbi, REQ_TIME);
 
-	trace_f2fs_vm_page_mkwrite(page, DATA);
 out_sem:
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 
 	sb_end_pagefault(inode->i_sb);
-err:
-	return vmf_fs_error(err);
+out:
+	ret = vmf_fs_error(err);
+
+	trace_f2fs_vm_page_mkwrite(inode, page->index, vmf->vma->vm_flags, ret);
+	return ret;
 }
 
 static const struct vm_operations_struct f2fs_file_vm_ops = {
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index b6ffae01a8cd8..f2ce7f6da8797 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -1284,13 +1284,6 @@ DEFINE_EVENT(f2fs__page, f2fs_set_page_dirty,
 	TP_ARGS(page, type)
 );
 
-DEFINE_EVENT(f2fs__page, f2fs_vm_page_mkwrite,
-
-	TP_PROTO(struct page *page, int type),
-
-	TP_ARGS(page, type)
-);
-
 TRACE_EVENT(f2fs_replace_atomic_write_block,
 
 	TP_PROTO(struct inode *inode, struct inode *cow_inode, pgoff_t index,
@@ -1328,30 +1321,50 @@ TRACE_EVENT(f2fs_replace_atomic_write_block,
 		__entry->recovery)
 );
 
-TRACE_EVENT(f2fs_filemap_fault,
+DECLARE_EVENT_CLASS(f2fs_mmap,
 
-	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long ret),
+	TP_PROTO(struct inode *inode, pgoff_t index,
+			vm_flags_t flags, vm_fault_t ret),
 
-	TP_ARGS(inode, index, ret),
+	TP_ARGS(inode, index, flags, ret),
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(ino_t,	ino)
 		__field(pgoff_t, index)
-		__field(unsigned long, ret)
+		__field(vm_flags_t, flags)
+		__field(vm_fault_t, ret)
 	),
 
 	TP_fast_assign(
 		__entry->dev	= inode->i_sb->s_dev;
 		__entry->ino	= inode->i_ino;
 		__entry->index	= index;
+		__entry->flags	= flags;
 		__entry->ret	= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, index = %lu, ret = %lx",
+	TP_printk("dev = (%d,%d), ino = %lu, index = %lu, flags: %s, ret: %s",
 		show_dev_ino(__entry),
 		(unsigned long)__entry->index,
-		__entry->ret)
+		__print_flags(__entry->flags, "|", FAULT_FLAG_TRACE),
+		__print_flags(__entry->ret, "|", VM_FAULT_RESULT_TRACE))
+);
+
+DEFINE_EVENT(f2fs_mmap, f2fs_filemap_fault,
+
+	TP_PROTO(struct inode *inode, pgoff_t index,
+			vm_flags_t flags, vm_fault_t ret),
+
+	TP_ARGS(inode, index, flags, ret)
+);
+
+DEFINE_EVENT(f2fs_mmap, f2fs_vm_page_mkwrite,
+
+	TP_PROTO(struct inode *inode, pgoff_t index,
+			vm_flags_t flags, vm_fault_t ret),
+
+	TP_ARGS(inode, index, flags, ret)
 );
 
 TRACE_EVENT(f2fs_writepages,
-- 
2.39.5



