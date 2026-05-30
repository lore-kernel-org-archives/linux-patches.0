Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34107332EA7;
	Sat, 30 May 2026 16:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159644; cv=none; b=HrFof3vt/1G3J2UrIIyPBaWoovgRmtme9E8C0SDL9dB6LQPd2MtRIO1A+fmWgKfuYFaEDVk47zCNERIPsogHURsPAyJK1z8OF5WKq8vP01FHJzkGy9gRWEWGmBkglQqfwNlu8EewVilWU5/xNYrHYKEBYSU7MmaQ6IOP5c+6zZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159644; c=relaxed/simple;
	bh=8BciliVHJLAOV3lYAp2JrdgEOCfh9jWcPwbPp414+jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xj92U7f9neUdvXlfqDXvYqiulzpnf/sbJx8IkP3akc927+dp4kcqykzIQAuxLlpIWYSgAs2JUw5M4EONBZN5g1I3XDuJa22LVAS64x4NyvbJs6mRSuTPRsfm679K2rMNKzUSfDPnOtvWDkoQnJEpsdASnvyJLvFdHMQXTcqSth4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwQ1gmLa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwQ1gmLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4841F00893;
	Sat, 30 May 2026 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159643;
	bh=UdxcDceqwkpVOEBQcAZM080okm/uAfChjxO3Qifp0B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwQ1gmLapiXM5UyrbQMKD+xS+MTo+7jf7hlXg1LPcs5uGWb1pzvwdXnuYIbb/jys6
	 Rhuk66u0YOdh3NZBzVsnMrt040vPYYYtUS4ZqqkQcwVCg+0jMNhWZnqXxGUP203bQI
	 p22v6O+hzHiTSBIiiM612boizJZj3C1+jf2x1Xyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.1 137/969] f2fs: fix null-ptr-deref in f2fs_submit_page_bio()
Date: Sat, 30 May 2026 17:54:21 +0200
Message-ID: <20260530160304.349921226@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4760,9 +4760,6 @@ static int __init init_f2fs_fs(void)
 	err = register_shrinker(&f2fs_shrinker_info, "f2fs-shrinker");
 	if (err)
 		goto free_sysfs;
-	err = register_filesystem(&f2fs_fs_type);
-	if (err)
-		goto free_shrinker;
 	f2fs_create_root_stats();
 	err = f2fs_init_post_read_processing();
 	if (err)
@@ -4786,6 +4783,7 @@ static int __init init_f2fs_fs(void)
 	if (err)
 		goto free_compress_cache;
 	err = f2fs_init_xattr_cache();
+	err = register_filesystem(&f2fs_fs_type);
 	if (err)
 		goto free_casefold_cache;
 	return 0;
@@ -4805,8 +4803,6 @@ free_post_read:
 	f2fs_destroy_post_read_processing();
 free_root_stats:
 	f2fs_destroy_root_stats();
-	unregister_filesystem(&f2fs_fs_type);
-free_shrinker:
 	unregister_shrinker(&f2fs_shrinker_info);
 free_sysfs:
 	f2fs_exit_sysfs();
@@ -4830,6 +4826,7 @@ fail:
 
 static void __exit exit_f2fs_fs(void)
 {
+	unregister_filesystem(&f2fs_fs_type);
 	f2fs_destroy_xattr_cache();
 	f2fs_destroy_casefold_cache();
 	f2fs_destroy_compress_cache();
@@ -4839,7 +4836,6 @@ static void __exit exit_f2fs_fs(void)
 	f2fs_destroy_iostat_processing();
 	f2fs_destroy_post_read_processing();
 	f2fs_destroy_root_stats();
-	unregister_filesystem(&f2fs_fs_type);
 	unregister_shrinker(&f2fs_shrinker_info);
 	f2fs_exit_sysfs();
 	f2fs_destroy_garbage_collection_cache();


