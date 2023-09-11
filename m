Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5C61170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C462CC433C8;
	Mon, 11 Sep 2023 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441880;
	bh=udAOpIMbBqyBv7kg1qssYjbpDgJnxBgsbkcO5ERcvM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwPWDhUkbSK9zmNo+omcix+d7cf2cxstjLQiSoILzmuIeb3Dj5XA4T0D/B5u506PS
	 0/IUX9S0Pwo7SJqVLme3DEph3X8Ex1Zudi1vuYOYlMAG49lmzvvgalzeU9SWoXV/jK
	 +yD/B4z8JF+mdCEKAUGmDzKjVXqNoiX2PCa4m21U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 551/739] f2fs: fix to avoid mmap vs set_compress_option case
Date: Mon, 11 Sep 2023 15:45:50 +0200
Message-ID: <20230911134706.480188958@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit b5ab3276eb69cacf44ecfb11b2bfab73096ff4e4 ]

Compression option in inode should not be changed after they have
been used, however, it may happen in below race case:

Thread A				Thread B
- f2fs_ioc_set_compress_option
 - check f2fs_is_mmap_file()
 - check get_dirty_pages()
 - check F2FS_HAS_BLOCKS()
					- f2fs_file_mmap
					 - set_inode_flag(FI_MMAP_FILE)
					- fault
					 - do_page_mkwrite
					  - f2fs_vm_page_mkwrite
					  - f2fs_get_block_locked
					 - fault_dirty_shared_page
					  - set_page_dirty
 - update i_compress_algorithm
 - update i_log_cluster_size
 - update i_cluster_size

Avoid such race condition by covering f2fs_file_mmap() w/ i_sem lock,
meanwhile add mmap file check condition in f2fs_may_compress() as well.

Fixes: e1e8debec656 ("f2fs: add F2FS_IOC_SET_COMPRESS_OPTION ioctl")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h |  3 ++-
 fs/f2fs/file.c | 23 ++++++++++++++++++-----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c7cb2177b2527..d372bedb0fe4e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4483,7 +4483,8 @@ static inline bool f2fs_low_mem_mode(struct f2fs_sb_info *sbi)
 static inline bool f2fs_may_compress(struct inode *inode)
 {
 	if (IS_SWAPFILE(inode) || f2fs_is_pinned_file(inode) ||
-		f2fs_is_atomic_file(inode) || f2fs_has_inline_data(inode))
+		f2fs_is_atomic_file(inode) || f2fs_has_inline_data(inode) ||
+		f2fs_is_mmap_file(inode))
 		return false;
 	return S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode);
 }
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 093039dee9920..d9073afe021fd 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -526,7 +526,11 @@ static int f2fs_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	file_accessed(file);
 	vma->vm_ops = &f2fs_file_vm_ops;
+
+	f2fs_down_read(&F2FS_I(inode)->i_sem);
 	set_inode_flag(inode, FI_MMAP_FILE);
+	f2fs_up_read(&F2FS_I(inode)->i_sem);
+
 	return 0;
 }
 
@@ -1919,12 +1923,19 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
 			int err = f2fs_convert_inline_inode(inode);
 			if (err)
 				return err;
-			if (!f2fs_may_compress(inode))
-				return -EINVAL;
-			if (S_ISREG(inode->i_mode) && F2FS_HAS_BLOCKS(inode))
+
+			f2fs_down_write(&F2FS_I(inode)->i_sem);
+			if (!f2fs_may_compress(inode) ||
+					(S_ISREG(inode->i_mode) &&
+					F2FS_HAS_BLOCKS(inode))) {
+				f2fs_up_write(&F2FS_I(inode)->i_sem);
 				return -EINVAL;
-			if (set_compress_context(inode))
-				return -EOPNOTSUPP;
+			}
+			err = set_compress_context(inode);
+			f2fs_up_write(&F2FS_I(inode)->i_sem);
+
+			if (err)
+				return err;
 		}
 	}
 
@@ -3976,6 +3987,7 @@ static int f2fs_ioc_set_compress_option(struct file *filp, unsigned long arg)
 	file_start_write(filp);
 	inode_lock(inode);
 
+	f2fs_down_write(&F2FS_I(inode)->i_sem);
 	if (f2fs_is_mmap_file(inode) || get_dirty_pages(inode)) {
 		ret = -EBUSY;
 		goto out;
@@ -3995,6 +4007,7 @@ static int f2fs_ioc_set_compress_option(struct file *filp, unsigned long arg)
 		f2fs_warn(sbi, "compression algorithm is successfully set, "
 			"but current kernel doesn't support this algorithm.");
 out:
+	f2fs_up_write(&F2FS_I(inode)->i_sem);
 	inode_unlock(inode);
 	file_end_write(filp);
 
-- 
2.40.1



