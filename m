Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C591D545;
	Thu, 23 May 2024 13:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470841; cv=none; b=kZnZdYJIYkgDjYnX0NrYv6U1SkKPX4Dt5u3/iHExniC8uO04x6Iu4YOUsoAcbGlCYfScAnZokKfUiLxfsvV9kref6DqWFotQg5AhvrLQZn2ZP9SXK8QLe0cxFqEAJWgHLbJKJMo2VAmUc1e+d5ZboI7v8g4SKtj6Zq3DeN412/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470841; c=relaxed/simple;
	bh=k+ziPZXthm2VZUPSWuPI2OiGTNsoecG365M5gsgLGao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEP5sUdrok5dcOOUwy+9MQltnVVxU6o+o7WlFwJctrrpCjg4p+a1OzWRloJH97K2Zq2hnwCELCkkGN9N/doQEgBQjH7CF+/rh78Rkuo0kB3cDARy6gcgb9KlgFzy7IOmUZSGPWQ0U+N1LiCzu3cHy1cxIFH+g03Wj4FEXZVqyG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeI+2kRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeI+2kRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D496C3277B;
	Thu, 23 May 2024 13:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470841;
	bh=k+ziPZXthm2VZUPSWuPI2OiGTNsoecG365M5gsgLGao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeI+2kRxcsQcYq/bn8VbXRW44MlPBD1tLVphScOUMZJqoBbylRXoA8csvW9zegu5e
	 3FHmaG+xYLvw68MU9EjVzFF0mdoka2GX3Xx/9pPs0RoBR1vRPpmhq41NJSCqVr00wl
	 lsgWm74OmE3XYR6N/3gOxC/5XXLJxukzmhwq3DVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Baokun Li <libaokun1@huawei.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 6.6 088/102] erofs: reliably distinguish block based and fscache mode
Date: Thu, 23 May 2024 15:13:53 +0200
Message-ID: <20240523130345.787954431@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 7af2ae1b1531feab5d38ec9c8f472dc6cceb4606 upstream.

When erofs_kill_sb() is called in block dev based mode, s_bdev may not
have been initialised yet, and if CONFIG_EROFS_FS_ONDEMAND is enabled,
it will be mistaken for fscache mode, and then attempt to free an anon_dev
that has never been allocated, triggering the following warning:

============================================
ida_free called for id=0 which is not allocated.
WARNING: CPU: 14 PID: 926 at lib/idr.c:525 ida_free+0x134/0x140
Modules linked in:
CPU: 14 PID: 926 Comm: mount Not tainted 6.9.0-rc3-dirty #630
RIP: 0010:ida_free+0x134/0x140
Call Trace:
 <TASK>
 erofs_kill_sb+0x81/0x90
 deactivate_locked_super+0x35/0x80
 get_tree_bdev+0x136/0x1e0
 vfs_get_tree+0x2c/0xf0
 do_new_mount+0x190/0x2f0
 [...]
============================================

Now when erofs_kill_sb() is called, erofs_sb_info must have been
initialised, so use sbi->fsid to distinguish between the two modes.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20240419123611.947084-3-libaokun1@huawei.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/super.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -786,17 +786,13 @@ static int erofs_init_fs_context(struct
 
 static void erofs_kill_sb(struct super_block *sb)
 {
-	struct erofs_sb_info *sbi;
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
-	if (erofs_is_fscache_mode(sb))
+	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && sbi->fsid)
 		kill_anon_super(sb);
 	else
 		kill_block_super(sb);
 
-	sbi = EROFS_SB(sb);
-	if (!sbi)
-		return;
-
 	erofs_free_dev_context(sbi->devs);
 	fs_put_dax(sbi->dax_dev, NULL);
 	erofs_fscache_unregister_fs(sb);


