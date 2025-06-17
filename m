Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBD02F2343;
	Tue, 17 Jun 2025 15:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175562; cv=none; b=TPjYYAxhcd+gQjQmmawmWvk7v7BT/sTMoYqXucvOiL127vMvJRshHspCeaKAnPqSQ63+dm2kWiyhmZkEPoM92420lUYvb18gLRjNeSehLmNN2myq1y038P81p73x69goTVWhykLXS2JJg+nFNZesVSMpu0Ph8VFNH/ReB5AdrXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175562; c=relaxed/simple;
	bh=rdq6UMwM6bLhj+N8L59NLeGPep4+KeK6bstnlr3+hEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azDB+pFdeN1F6W2JvcL+FhVAsfcHuF4VSdQzpkX09+PIzGr4gEArq21nxcd40TONMw7vAC0Sq3HjHBY0SdsLww3E6O6lcGsVn5iI0QGMBhOxE/keM3lbt4PJz2o40YYOXN1qkIc+Yl6TIFgRpjBdi7TlLL+B42CgCr7TVdkQdVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nPdMskz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nPdMskz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3D2C4CEE7;
	Tue, 17 Jun 2025 15:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175562;
	bh=rdq6UMwM6bLhj+N8L59NLeGPep4+KeK6bstnlr3+hEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nPdMskzaruSXyS5OSSViHS0pHnJsb6jIoACnvlO1+wKO/WeYO0fBBTKnx0x/1TZW
	 qITTh2EkOOR85nFlhn6gSmnm91iQpha3HSFxkkSOJeafH5Ed/cUTzQuvVncmBIBuQA
	 vvxDhmPbaeIGkqSqJMDVo5k+H3lZK/3bkFivyL1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Prusakowski <jprusakowski@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/512] f2fs: fix to detect gcing page in f2fs_is_cp_guaranteed()
Date: Tue, 17 Jun 2025 17:21:48 +0200
Message-ID: <20250617152425.354021049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit aa1be8dd64163eca4dde7fd2557eb19927a06a47 ]

Jan Prusakowski reported a f2fs bug as below:

f2fs/007 will hang kernel during testing w/ below configs:

kernel 6.12.18 (from pixel-kernel/android16-6.12)
export MKFS_OPTIONS="-O encrypt -O extra_attr -O project_quota -O quota"
export F2FS_MOUNT_OPTIONS="test_dummy_encryption,discard,fsync_mode=nobarrier,reserve_root=32768,checkpoint_merge,atgc"

cat /proc/<umount_proc_id>/stack
f2fs_wait_on_all_pages+0xa3/0x130
do_checkpoint+0x40c/0x5d0
f2fs_write_checkpoint+0x258/0x550
kill_f2fs_super+0x14f/0x190
deactivate_locked_super+0x30/0xb0
cleanup_mnt+0xba/0x150
task_work_run+0x59/0xa0
syscall_exit_to_user_mode+0x12d/0x130
do_syscall_64+0x57/0x110
entry_SYSCALL_64_after_hwframe+0x76/0x7e

cat /sys/kernel/debug/f2fs/status

  - IO_W (CP: -256, Data:  256, Flush: (   0    0    1), Discard: (   0    0)) cmd:    0 undiscard:   0

CP IOs reference count becomes negative.

The root cause is:

After 4961acdd65c9 ("f2fs: fix to tag gcing flag on page during block
migration"), we will tag page w/ gcing flag for raw page of cluster
during its migration.

However, if the inode is both encrypted and compressed, during
ioc_decompress(), it will tag page w/ gcing flag, and it increase
F2FS_WB_DATA reference count:
- f2fs_write_multi_page
 - f2fs_write_raw_page
  - f2fs_write_single_page
   - do_write_page
    - f2fs_submit_page_write
     - WB_DATA_TYPE(bio_page, fio->compressed_page)
     : bio_page is encrypted, so mapping is NULL, and fio->compressed_page
       is NULL, it returns F2FS_WB_DATA
     - inc_page_count(.., F2FS_WB_DATA)

Then, during end_io(), it decrease F2FS_WB_CP_DATA reference count:
- f2fs_write_end_io
 - f2fs_compress_write_end_io
  - fscrypt_pagecache_folio
  : get raw page from encrypted page
  - WB_DATA_TYPE(&folio->page, false)
  : raw page has gcing flag, it returns F2FS_WB_CP_DATA
  - dec_page_count(.., F2FS_WB_CP_DATA)

In order to fix this issue, we need to detect gcing flag in raw page
in f2fs_is_cp_guaranteed().

Fixes: 4961acdd65c9 ("f2fs: fix to tag gcing flag on page during block migration")
Reported-by: Jan Prusakowski <jprusakowski@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8564441cef9bc..62c7fd1168a15 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -54,7 +54,7 @@ bool f2fs_is_cp_guaranteed(struct page *page)
 	struct f2fs_sb_info *sbi;
 
 	if (fscrypt_is_bounce_page(page))
-		return false;
+		return page_private_gcing(fscrypt_pagecache_page(page));
 
 	inode = mapping->host;
 	sbi = F2FS_I_SB(inode);
-- 
2.39.5



