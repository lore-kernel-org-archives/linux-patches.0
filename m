Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0B01E98E4;
	Wed, 15 Jan 2025 11:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938810; cv=none; b=qglLovGFU0EVFFr0lBSIIuQJexpAlang1JajbqKEvcxg3ngRokyKYlHKDD/xdLkBImyYVjNSUEGdTpcgdzWCTFt26Vymu/gu4bBogE2vnffsXTsYzSkDFUWRJih/xTw5iLvrvx0zf/kash2FZC6tk8Bj9Hzsi/tHpYEwdiOfAGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938810; c=relaxed/simple;
	bh=HYJt2j0OO1UA/KsRRr6TY0f2DqcVfy53sL9o0smbp50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POJg9aWDypmluD6QuQqvT5K7VcOWHVPxhaYm6AaOJPIL3nzFxuAi/kWi4JDwW0cRbdAPMxpqWWa7CWRwSGvYn3YK/+JddhQKrZ+D0SeYjfKp3MB0slP2v6Vl2/4BdQ/KlYY/Yr7Mw9AJ8pWnETYdkezqNm/l5ZmK7bmnxjh5rJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbXQDk1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbXQDk1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2F6C4CEE4;
	Wed, 15 Jan 2025 11:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938810;
	bh=HYJt2j0OO1UA/KsRRr6TY0f2DqcVfy53sL9o0smbp50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbXQDk1AZ9batfHSk+Vq5d0mA/QFyyy0yri+kuxbb6S+DOtOWLOY0g4GpqJxVIpQn
	 zs4aL9AFqTYvQdEtly+3f5rjUh5HHQITKT7dfWy+DXJ4rwxEJnukgV0EyLdhwKhqFc
	 9UExWv4UK4o/TbuZVYoY9mi5HT8O+feuCs3IOZU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bin Lan <lanbincn@qq.com>
Subject: [PATCH 6.6 077/129] f2fs: fix null-ptr-deref in f2fs_submit_page_bio()
Date: Wed, 15 Jan 2025 11:37:32 +0100
Message-ID: <20250115103557.440984416@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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
Signed-off-by: Bin Lan <lanbincn@qq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4931,9 +4931,6 @@ static int __init init_f2fs_fs(void)
 	err = register_shrinker(&f2fs_shrinker_info, "f2fs-shrinker");
 	if (err)
 		goto free_sysfs;
-	err = register_filesystem(&f2fs_fs_type);
-	if (err)
-		goto free_shrinker;
 	f2fs_create_root_stats();
 	err = f2fs_init_post_read_processing();
 	if (err)
@@ -4956,7 +4953,12 @@ static int __init init_f2fs_fs(void)
 	err = f2fs_create_casefold_cache();
 	if (err)
 		goto free_compress_cache;
+	err = register_filesystem(&f2fs_fs_type);
+	if (err)
+		goto free_casefold_cache;
 	return 0;
+free_casefold_cache:
+	f2fs_destroy_casefold_cache();
 free_compress_cache:
 	f2fs_destroy_compress_cache();
 free_compress_mempool:
@@ -4971,8 +4973,6 @@ free_post_read:
 	f2fs_destroy_post_read_processing();
 free_root_stats:
 	f2fs_destroy_root_stats();
-	unregister_filesystem(&f2fs_fs_type);
-free_shrinker:
 	unregister_shrinker(&f2fs_shrinker_info);
 free_sysfs:
 	f2fs_exit_sysfs();
@@ -4996,6 +4996,7 @@ fail:
 
 static void __exit exit_f2fs_fs(void)
 {
+	unregister_filesystem(&f2fs_fs_type);
 	f2fs_destroy_casefold_cache();
 	f2fs_destroy_compress_cache();
 	f2fs_destroy_compress_mempool();
@@ -5004,7 +5005,6 @@ static void __exit exit_f2fs_fs(void)
 	f2fs_destroy_iostat_processing();
 	f2fs_destroy_post_read_processing();
 	f2fs_destroy_root_stats();
-	unregister_filesystem(&f2fs_fs_type);
 	unregister_shrinker(&f2fs_shrinker_info);
 	f2fs_exit_sysfs();
 	f2fs_destroy_garbage_collection_cache();


