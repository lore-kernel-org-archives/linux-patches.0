Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CCA18C92B;
	Tue, 30 Jul 2024 17:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359305; cv=none; b=mX6V28nhq+ta9DXZR3VuH38zyYidwtlwYKY1gjuQqx+ZaPSJECvgdnPTpl3y6VFOeR0XjQkIZa26CRPBL+w39V0rdQxP+N5kUr4eCCMph3bl9uXOI/1j0mxPBg0XR38hhcM/sV+qoZfWfzJnexAMfJ743ZgK08tUoSXRwt5w0ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359305; c=relaxed/simple;
	bh=JJncERrCrbhl6Nf8rjACeETzC/zzniwBDXP8Rx1CH8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRjgRqBF9oMmXNfDH+FxEa1qV5Ua9aPCjEES29lZ7gymON6Q27lFnFiL465/1s+A597hzOutkZt0N9tvj24d0uROxto6YeMM2t+FdWtTcGmWTE9oD+lLLqRa8x1GtYeaoH2/7uxyFwRTd39kvm9nRFS0JL79JJqn+Y63IIwJO94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZ69yNVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZ69yNVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80362C32782;
	Tue, 30 Jul 2024 17:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359305;
	bh=JJncERrCrbhl6Nf8rjACeETzC/zzniwBDXP8Rx1CH8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZ69yNVlmC5+lAISCKznsT00yQP9X3aHTRZ6bUCeqdFVX3x1WUlKjLUtHD0MIxXo2
	 WIFfcT1WAa/azMS+uXZGJ7ZMYCFfZuZXG56ZadVXwBi208AoSVB4VQRQ6O7dPfGfYa
	 efjfHqOthH+/lkhydRrMK3cBSUKT4iYpOj7qsjl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+848062ba19c8782ca5c8@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 438/568] f2fs: fix return value of f2fs_convert_inline_inode()
Date: Tue, 30 Jul 2024 17:49:05 +0200
Message-ID: <20240730151656.988695260@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit a8eb3de28e7a365690c61161e7a07a4fc7c60bbf upstream.

If device is readonly, make f2fs_convert_inline_inode()
return EROFS instead of zero, otherwise it may trigger
panic during writeback of inline inode's dirty page as
below:

 f2fs_write_single_data_page+0xbb6/0x1e90 fs/f2fs/data.c:2888
 f2fs_write_cache_pages fs/f2fs/data.c:3187 [inline]
 __f2fs_write_data_pages fs/f2fs/data.c:3342 [inline]
 f2fs_write_data_pages+0x1efe/0x3a90 fs/f2fs/data.c:3369
 do_writepages+0x359/0x870 mm/page-writeback.c:2634
 filemap_fdatawrite_wbc+0x125/0x180 mm/filemap.c:397
 __filemap_fdatawrite_range mm/filemap.c:430 [inline]
 file_write_and_wait_range+0x1aa/0x290 mm/filemap.c:788
 f2fs_do_sync_file+0x68a/0x1ae0 fs/f2fs/file.c:276
 generic_write_sync include/linux/fs.h:2806 [inline]
 f2fs_file_write_iter+0x7bd/0x24e0 fs/f2fs/file.c:4977
 call_write_iter include/linux/fs.h:2114 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xa72/0xc90 fs/read_write.c:590
 ksys_write+0x1a0/0x2c0 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Cc: stable@vger.kernel.org
Reported-by: syzbot+848062ba19c8782ca5c8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/000000000000d103ce06174d7ec3@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inline.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -203,8 +203,10 @@ int f2fs_convert_inline_inode(struct ino
 	struct page *ipage, *page;
 	int err = 0;
 
-	if (!f2fs_has_inline_data(inode) ||
-			f2fs_hw_is_readonly(sbi) || f2fs_readonly(sbi->sb))
+	if (f2fs_hw_is_readonly(sbi) || f2fs_readonly(sbi->sb))
+		return -EROFS;
+
+	if (!f2fs_has_inline_data(inode))
 		return 0;
 
 	err = f2fs_dquot_initialize(inode);


