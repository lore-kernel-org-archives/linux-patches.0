Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C0C23CE;
	Tue,  3 Dec 2024 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241774; cv=none; b=DSLuZobjQ25eCRdX2uLBt8s1ahCAla6wrGhUlcO8rOInkFvWUu7gNTvM2vdU6GkeqZrl2pnOssPwPcsfaBjoqiF0xgmn0WCltwZkniGEDykgq0QMq3VOQBCuuTn97J0ay1kiSld5lEBjB2zlCkqok1RM37vUssE4xnaWWDEfGo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241774; c=relaxed/simple;
	bh=T/4HU6OWKt+WJdSqN9GghWypeEwp2jm3ZyGP8kGRv54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uw5Ez1PMeciZaER1wPH7rUxUeFUZLlRb1e4gbhA28pPRmNaxSwIdRn6tCSRtLf1567tUYSi+1/tTCP0S40OEpMByY9de662yF9cL1V7m/pFN4/KVav2KS4IHk/M0/2cWvYufQPgEO33XrYW9Q7hwurj9zF/ZknGX6eC5FTOjFs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jBdxLYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jBdxLYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59463C4CECF;
	Tue,  3 Dec 2024 16:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241774;
	bh=T/4HU6OWKt+WJdSqN9GghWypeEwp2jm3ZyGP8kGRv54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jBdxLYeJ6XOZV0QK1UZz82Vl0vSvRMc/cYUiqfCqqdpPuzicft3NF+csrYM3ouWS
	 ZGe3GtCRBHcQICZ3HX4wOTRXPjpdBiabvBBckWnWPTt7NSYSeGnlZ/Ox8df0sCMGmn
	 qVRd47Z0CUTDLBPNbjympr+nENEcQF2Yo12xPGVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 481/826] f2fs: fix null-ptr-deref in f2fs_submit_page_bio()
Date: Tue,  3 Dec 2024 15:43:28 +0100
Message-ID: <20241203144802.526196739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit b7d0a97b28083084ebdd8e5c6bccd12e6ec18faa ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 87ab5696bd482..8d4ecb2e855e6 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4991,9 +4991,6 @@ static int __init init_f2fs_fs(void)
 	err = f2fs_init_shrinker();
 	if (err)
 		goto free_sysfs;
-	err = register_filesystem(&f2fs_fs_type);
-	if (err)
-		goto free_shrinker;
 	f2fs_create_root_stats();
 	err = f2fs_init_post_read_processing();
 	if (err)
@@ -5016,7 +5013,12 @@ static int __init init_f2fs_fs(void)
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
@@ -5031,8 +5033,6 @@ static int __init init_f2fs_fs(void)
 	f2fs_destroy_post_read_processing();
 free_root_stats:
 	f2fs_destroy_root_stats();
-	unregister_filesystem(&f2fs_fs_type);
-free_shrinker:
 	f2fs_exit_shrinker();
 free_sysfs:
 	f2fs_exit_sysfs();
@@ -5056,6 +5056,7 @@ static int __init init_f2fs_fs(void)
 
 static void __exit exit_f2fs_fs(void)
 {
+	unregister_filesystem(&f2fs_fs_type);
 	f2fs_destroy_casefold_cache();
 	f2fs_destroy_compress_cache();
 	f2fs_destroy_compress_mempool();
@@ -5064,7 +5065,6 @@ static void __exit exit_f2fs_fs(void)
 	f2fs_destroy_iostat_processing();
 	f2fs_destroy_post_read_processing();
 	f2fs_destroy_root_stats();
-	unregister_filesystem(&f2fs_fs_type);
 	f2fs_exit_shrinker();
 	f2fs_exit_sysfs();
 	f2fs_destroy_garbage_collection_cache();
-- 
2.43.0



