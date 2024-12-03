Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3331F669E;
	Tue,  3 Dec 2024 14:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237717; cv=none; b=DtmClqAbpCBukAfPYwgIQQZCaFaJEHmcFTQ4yN77YttHOz2HBH91O3ZUDQA0tFxXBH8mLGRCz0jRUqZsAYsK83xyd/xfigi6fDpe5KUxVuQTP9dswApBAv8zBrhHhsiLTJt5TjdOnfescqua98Udt8JoCE4c5gwam5fzY0gCma0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237717; c=relaxed/simple;
	bh=HchyDmJd/DpR2EjdzOVUPeIaJJtz5JKnSqgdwHDN2p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5ToeW1ZdjPNl0rPWIUzKI6OrqUVAaaf8/W9SGftBUB/P9L6/AvN3AIVDhmc6FEcCEg9fc9wGfEb1VePyc5lVhIoVwa96G1nNYZnn4VrZus688uBxlRRezEZw6voGET68n33VcdPucVvIDZHEPr9WLM4BoDFsnuK0tQzVzoFPPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KM0hbkgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KM0hbkgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7335BC4CED8;
	Tue,  3 Dec 2024 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237716;
	bh=HchyDmJd/DpR2EjdzOVUPeIaJJtz5JKnSqgdwHDN2p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KM0hbkgqHEKJk2TmlASr0hoUPSgBdIU2YU4uTSFa2vrjRtGW49YZRyUTwRRykTy7W
	 odh1jMcYLTwZee3qa7iZgY3Gw1kpvU3kQuNTJHZz57Z32ga5Sm3RgxLOgM+26VrcP2
	 T+mLo2Q5ZlYAAvM6q1DTUyZTmtYw3gNSd9cYnMMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill ODonnell <bodonnel@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 050/817] efs: fix the efs new mount api implementation
Date: Tue,  3 Dec 2024 15:33:42 +0100
Message-ID: <20241203143957.625487387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bill O'Donnell <bodonnel@redhat.com>

[ Upstream commit 51ceeb1a8142537b9f65aeaac6c301560a948197 ]

Commit 39a6c668e4 (efs: convert efs to use the new mount api)
did not include anything from v2 and v3 that were also submitted.
Fix this by bringing in those changes that were proposed in v2 and
v3.

Fixes: 39a6c668e4 efs: convert efs to use the new mount api.

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
Link: https://lore.kernel.org/r/20241014190241.4093825-1-bodonnel@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/efs/super.c | 43 +++----------------------------------------
 1 file changed, 3 insertions(+), 40 deletions(-)

diff --git a/fs/efs/super.c b/fs/efs/super.c
index e4421c10caebe..c59086b7eabfe 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -15,7 +15,6 @@
 #include <linux/vfs.h>
 #include <linux/blkdev.h>
 #include <linux/fs_context.h>
-#include <linux/fs_parser.h>
 #include "efs.h"
 #include <linux/efs_vh.h>
 #include <linux/efs_fs_sb.h>
@@ -49,15 +48,6 @@ static struct pt_types sgi_pt_types[] = {
 	{0,		NULL}
 };
 
-enum {
-	Opt_explicit_open,
-};
-
-static const struct fs_parameter_spec efs_param_spec[] = {
-	fsparam_flag    ("explicit-open",       Opt_explicit_open),
-	{}
-};
-
 /*
  * File system definition and registration.
  */
@@ -67,7 +57,6 @@ static struct file_system_type efs_fs_type = {
 	.kill_sb		= efs_kill_sb,
 	.fs_flags		= FS_REQUIRES_DEV,
 	.init_fs_context	= efs_init_fs_context,
-	.parameters		= efs_param_spec,
 };
 MODULE_ALIAS_FS("efs");
 
@@ -265,7 +254,8 @@ static int efs_fill_super(struct super_block *s, struct fs_context *fc)
 	if (!sb_set_blocksize(s, EFS_BLOCKSIZE)) {
 		pr_err("device does not support %d byte blocks\n",
 			EFS_BLOCKSIZE);
-		return -EINVAL;
+		return invalf(fc, "device does not support %d byte blocks\n",
+			      EFS_BLOCKSIZE);
 	}
 
 	/* read the vh (volume header) block */
@@ -327,43 +317,22 @@ static int efs_fill_super(struct super_block *s, struct fs_context *fc)
 	return 0;
 }
 
-static void efs_free_fc(struct fs_context *fc)
-{
-	kfree(fc->fs_private);
-}
-
 static int efs_get_tree(struct fs_context *fc)
 {
 	return get_tree_bdev(fc, efs_fill_super);
 }
 
-static int efs_parse_param(struct fs_context *fc, struct fs_parameter *param)
-{
-	int token;
-	struct fs_parse_result result;
-
-	token = fs_parse(fc, efs_param_spec, param, &result);
-	if (token < 0)
-		return token;
-	return 0;
-}
-
 static int efs_reconfigure(struct fs_context *fc)
 {
 	sync_filesystem(fc->root->d_sb);
+	fc->sb_flags |= SB_RDONLY;
 
 	return 0;
 }
 
-struct efs_context {
-	unsigned long s_mount_opts;
-};
-
 static const struct fs_context_operations efs_context_opts = {
-	.parse_param	= efs_parse_param,
 	.get_tree	= efs_get_tree,
 	.reconfigure	= efs_reconfigure,
-	.free		= efs_free_fc,
 };
 
 /*
@@ -371,12 +340,6 @@ static const struct fs_context_operations efs_context_opts = {
  */
 static int efs_init_fs_context(struct fs_context *fc)
 {
-	struct efs_context *ctx;
-
-	ctx = kzalloc(sizeof(struct efs_context), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
-	fc->fs_private = ctx;
 	fc->ops = &efs_context_opts;
 
 	return 0;
-- 
2.43.0



