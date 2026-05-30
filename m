Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE92C267B05;
	Sat, 30 May 2026 17:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162982; cv=none; b=XvXPm3iN9fHRLei9CoWSo8tG2P9y2b/IKm4QwcZi0dDAaAMGhz4o4QdFAgi1CQvhC29O0cHYuUURgcbGnymkzWeic9ybiald1RHvRGE6O7l0Tf1J392fHbbhvNva2eiu5a4jzf75bS2yTIB907N+Keg4xzzC7PJ8a9qox0IUVGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162982; c=relaxed/simple;
	bh=B/9nb6FM0ZDCI8GAWgeLoqU3pKRV3sCJ2qgcvV9CeDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYbc80Oqe9qGYZQzot4XIY8VohZNVUX+ZOagH8T0sssMP50YStKgGjq3ekAI1YvEDzyDhXPMotbpPD1BWnMkg9bVQz8TAJ25OYmILQisZRuumE5plHGEvTk7hwH37rVGH2Lhl5sx6dUZifTinlfzG2cAGCGe3uHW0UnESKzXGVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5kAeB8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5kAeB8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F10D1F00893;
	Sat, 30 May 2026 17:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162981;
	bh=ci4GkJtiLaxe9bFaabNjScvZ6Vlf6zGUUt5v5/uqeEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5kAeB8OupeWpt8BrAQF5xeJWu5BP8BSdBL7SssHwqZNnWEBuZNxa1ToJUUrpTbG3
	 BXUfDQVa9+48XPkWOa7wISZr/FR7nJ5vtdi1wyjeq1kkM2wEuaWj0Tjb0RKXKfCCr9
	 fHDyjC5TqgqCmP39L4DEGYrPkgL2KeyQABhzOqQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 5.15 122/776] f2fs: fix null-ptr-deref in f2fs_submit_page_bio()
Date: Sat, 30 May 2026 17:57:16 +0200
Message-ID: <20260530160243.528920947@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ye Bin <yebin10@huawei.com>

commit b7d0a97b28083084ebdd8e5c6bccd12e6ec18faa upstream.

There's issue as follows when concurrently installing the f2fs.ko
module and mounting the f2fs file system:
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
RIP: 0010:__bio_alloc+0x2fb/0x6c0 [f2fs]
Call Trace:
 <TASK>
 f2fs_submit_page_bio+0x126/0x8b0 [f2fs]
 __get_meta_page+0x1d4/0x920 [f2fs]
 get_checkpoint_version.constprop.0+0x2b/0x3c0 [f2fs]
 validate_checkpoint+0xac/0x290 [f2fs]
 f2fs_get_valid_checkpoint+0x207/0x950 [f2fs]
 f2fs_fill_super+0x1007/0x39b0 [f2fs]
 mount_bdev+0x183/0x250
 legacy_get_tree+0xf4/0x1e0
 vfs_get_tree+0x88/0x340
 do_new_mount+0x283/0x5e0
 path_mount+0x2b2/0x15b0
 __x64_sys_mount+0x1fe/0x270
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Above issue happens as the biset of the f2fs file system is not
initialized before register "f2fs_fs_type".
To address above issue just register "f2fs_fs_type" at the last in
init_f2fs_fs(). Ensure that all f2fs file system resources are
initialized.

Fixes: f543805fcd60 ("f2fs: introduce private bioset")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Minor context conflict resolved. ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4634,9 +4634,6 @@ static int __init init_f2fs_fs(void)
 	err = register_shrinker(&f2fs_shrinker_info);
 	if (err)
 		goto free_sysfs;
-	err = register_filesystem(&f2fs_fs_type);
-	if (err)
-		goto free_shrinker;
 	f2fs_create_root_stats();
 	err = f2fs_init_post_read_processing();
 	if (err)
@@ -4660,6 +4657,7 @@ static int __init init_f2fs_fs(void)
 	if (err)
 		goto free_compress_cache;
 	err = f2fs_init_xattr_cache();
+	err = register_filesystem(&f2fs_fs_type);
 	if (err)
 		goto free_casefold_cache;
 	return 0;
@@ -4679,8 +4677,6 @@ free_post_read:
 	f2fs_destroy_post_read_processing();
 free_root_stats:
 	f2fs_destroy_root_stats();
-	unregister_filesystem(&f2fs_fs_type);
-free_shrinker:
 	unregister_shrinker(&f2fs_shrinker_info);
 free_sysfs:
 	f2fs_exit_sysfs();
@@ -4704,6 +4700,7 @@ fail:
 
 static void __exit exit_f2fs_fs(void)
 {
+	unregister_filesystem(&f2fs_fs_type);
 	f2fs_destroy_xattr_cache();
 	f2fs_destroy_casefold_cache();
 	f2fs_destroy_compress_cache();
@@ -4713,7 +4710,6 @@ static void __exit exit_f2fs_fs(void)
 	f2fs_destroy_iostat_processing();
 	f2fs_destroy_post_read_processing();
 	f2fs_destroy_root_stats();
-	unregister_filesystem(&f2fs_fs_type);
 	unregister_shrinker(&f2fs_shrinker_info);
 	f2fs_exit_sysfs();
 	f2fs_destroy_garbage_collection_cache();


