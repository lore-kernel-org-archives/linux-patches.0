Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F7C20F090;
	Tue, 17 Jun 2025 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174698; cv=none; b=eJQe8uZw0KgXX4T4HkLU9G9nZo9F+Ia97yUVJrYVA3EwpJStZQZyOsZLhk1jfMiwjiNUoaNcbtu2iAo9PwE0fJDAeYiQDVjvvrkoSvHoWz/qvvB/11UHLjiYrJAAPMzYzuGZExLr3AUm8hJvIxExnhU0Sx4ocqlWw7PII07Ln5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174698; c=relaxed/simple;
	bh=EfcLCXvC/g5/D2vhi3TM2z3/hK44MkJZc5TuYidHWl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VN8Eh/zIslRZd3uifwNOI2yKujfzBOq2JSXUnZwwpEgKbqaZWvSKgN7rzEVIb62ncEchqIH1FSAeCnWEclvh/8iMdF80jWVasFg3+CU5Njcx/mKr+SLOp4MDonetun//ohLn/nSXlHm3vJAsoT7bdmMszdhIsQ4NDWa/z/gRbpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7vEj1we; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7vEj1we"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA46C4CEE3;
	Tue, 17 Jun 2025 15:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174698;
	bh=EfcLCXvC/g5/D2vhi3TM2z3/hK44MkJZc5TuYidHWl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7vEj1weaEws0x3aZ48/q2VaCfnLmMCD4UY7ymum+AlqLjlfGkBUQlqUtwDykYtmY
	 0PZJErFKHHo1uuzU5LcOHQRNeovtg34/ZDEQdoor/HsoCHLU4qEZ+Ox4XsyU5jIvo1
	 lPAb8sL0zZ2dw9WfSk7uWJX7fCzwYqM2ufa5b9nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Prusakowski <jprusakowski@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/356] f2fs: fix to detect gcing page in f2fs_is_cp_guaranteed()
Date: Tue, 17 Jun 2025 17:23:38 +0200
Message-ID: <20250617152342.370440076@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index 5a3fa2f887a79..a123bb26acd8b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -55,7 +55,7 @@ bool f2fs_is_cp_guaranteed(struct page *page)
 	struct f2fs_sb_info *sbi;
 
 	if (fscrypt_is_bounce_page(page))
-		return false;
+		return page_private_gcing(fscrypt_pagecache_page(page));
 
 	inode = mapping->host;
 	sbi = F2FS_I_SB(inode);
-- 
2.39.5



