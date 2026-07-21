Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E239A3C9ED9;
	Tue, 21 Jul 2026 18:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659907; cv=none; b=ndjtpX7qXGsht/gtRaSCukSq+997BAryBmx2ZG4qO6cD1NqqSLVZiGBMBs9SB4ZJf/KCxrHQwLn+D39xsMLUyMCxHdx/quHOh2/Lc1d0dTQGgKpdGbaI+ZQMS/oFyMVGCgzG543YDSVkEb0adJk7642B8kfDMWBU0s+Owe4OXk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659907; c=relaxed/simple;
	bh=Kc96MytVSOHX+LVjdUqqHlqX0jYEn3B5FEytTP2rVEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfI6cX/iTXv4DgUStDVh/ShFoewu8FTxGkHNd8HaCAgol8GjhQy/6gwhI0SSKkVs/ImRCvnUHgHb/uSIuKGKMR6uPjWbpDjfdKTGps3MO2+v94vEcGaFB3mjSsByLv/fnRqYqPJzDYv1kf2oM+HkUT4Kte07MhQhFFCc8HsdmhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THy9KO6V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THy9KO6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A191F00A3A;
	Tue, 21 Jul 2026 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659905;
	bh=mFieBKsLpdguzy3PzCf3WTkAer6G/CYoD1sgSVJ3cMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THy9KO6VSk4cYclmcb2cbuV0H+4elT4z3kypNSsqY1CKCZBt1yMppKzHxtkiHwz0i
	 SW1NQ/pGOrkscTnb1AJYFcWDi5g8xd6CO+TGKWrgnPk/VmUDkUoB/C1a4uvk9WLkI3
	 lM9EjYo7Pi6G0IWjCgRyHO7f4sma2kCkoe7DKTnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0776/2077] smb: client: fix conflicting option validation for new mount API
Date: Tue, 21 Jul 2026 17:07:29 +0200
Message-ID: <20260721152611.101139514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit 10ce03879f935f756bc8a386b3fa3a1c7264d950 ]

Apply conflicting option validation consistently across all the new
mount API paths, for both mount and remount.

Some checks were only applied during initial mount validation, while
others were handled during option parsing, causing mount and
remount/reconfigure to behave differently.

Move the conflicting option checks into smb3_handle_conflicting_options()
and call it from the common validation paths, including for
multichannel/max_channels handling.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 102 +++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 49 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2f86158f85d7b6..fd4b13cd654d90 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -693,6 +693,41 @@ static int smb3_handle_conflicting_options(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
 
+	if (ctx->rdma && ctx->vals->protocol_id < SMB30_PROT_ID) {
+		cifs_errorf(fc, "SMB Direct requires Version >=3.0\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ctx->multiuser && !IS_ENABLED(CONFIG_KEYS)) {
+		cifs_errorf(fc, "Multiuser mounts require kernels with CONFIG_KEYS enabled\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ctx->multiuser && ctx->upcall_target == UPTARGET_MOUNT) {
+		cifs_errorf(fc, "multiuser mount option not supported with upcalltarget set as 'mount'\n");
+		return -EINVAL;
+	}
+
+	if (ctx->uid_specified && !ctx->forceuid_specified) {
+		ctx->override_uid = 1;
+		pr_notice("enabling forceuid mount option implicitly because uid= option is specified\n");
+	}
+
+	if (ctx->gid_specified && !ctx->forcegid_specified) {
+		ctx->override_gid = 1;
+		pr_notice("enabling forcegid mount option implicitly because gid= option is specified\n");
+	}
+
+	if (ctx->override_uid && !ctx->uid_specified) {
+		ctx->override_uid = 0;
+		pr_notice("ignoring forceuid mount option specified with no uid= option\n");
+	}
+
+	if (ctx->override_gid && !ctx->gid_specified) {
+		ctx->override_gid = 0;
+		pr_notice("ignoring forcegid mount option specified with no gid= option\n");
+	}
+
 	if (ctx->multichannel_specified) {
 		if (ctx->multichannel) {
 			if (!ctx->max_channels_specified) {
@@ -711,19 +746,14 @@ static int smb3_handle_conflicting_options(struct fs_context *fc)
 				return -EINVAL;
 			}
 		}
-	} else {
-		if (ctx->max_channels_specified) {
-			if (ctx->max_channels > 1)
-				ctx->multichannel = true;
-			else
-				ctx->multichannel = false;
-		} else {
+	} else if (ctx->max_channels_specified) {
+		if (ctx->max_channels > 1)
+			ctx->multichannel = true;
+		else
 			ctx->multichannel = false;
-			ctx->max_channels = 1;
-		}
 	}
 
-	//resetting default values as remount doesn't initialize fs_context again
+	/* clear parse-time latches so they don't persist across remounts */
 	ctx->multichannel_specified = false;
 	ctx->max_channels_specified = false;
 
@@ -804,28 +834,23 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 		if (ret < 0)
 			break;
 	}
-	return ret ?: smb3_handle_conflicting_options(fc);
+	return ret;
 }
 
 /*
- * Validate the preparsed information in the config.
+ * smb3_fs_context_validate - check initial-mount-only constraints:
+ * UNC presence, address resolution, dialect warnings
+ *
+ * @fc: generic mount context
  */
 static int smb3_fs_context_validate(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
+	int rc;
 
-	if (ctx->rdma && ctx->vals->protocol_id < SMB30_PROT_ID) {
-		cifs_errorf(fc, "SMB Direct requires Version >=3.0\n");
-		return -EOPNOTSUPP;
-	}
-
-#ifndef CONFIG_KEYS
-	/* Muliuser mounts require CONFIG_KEYS support */
-	if (ctx->multiuser) {
-		cifs_errorf(fc, "Multiuser mounts require kernels with CONFIG_KEYS enabled\n");
-		return -1;
-	}
-#endif
+	rc = smb3_handle_conflicting_options(fc);
+	if (rc)
+		return rc;
 
 	if (ctx->got_version == false)
 		pr_warn_once("No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3.1.1), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3.1.1 (or even SMB3 or SMB2.1) specify vers=1.0 on mount.\n");
@@ -860,26 +885,6 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 	/* set the port that we got earlier */
 	cifs_set_port((struct sockaddr *)&ctx->dstaddr, ctx->port);
 
-	if (ctx->uid_specified && !ctx->forceuid_specified) {
-		ctx->override_uid = 1;
-		pr_notice("enabling forceuid mount option implicitly because uid= option is specified\n");
-	}
-
-	if (ctx->gid_specified && !ctx->forcegid_specified) {
-		ctx->override_gid = 1;
-		pr_notice("enabling forcegid mount option implicitly because gid= option is specified\n");
-	}
-
-	if (ctx->override_uid && !ctx->uid_specified) {
-		ctx->override_uid = 0;
-		pr_notice("ignoring forceuid mount option specified with no uid= option\n");
-	}
-
-	if (ctx->override_gid && !ctx->gid_specified) {
-		ctx->override_gid = 0;
-		pr_notice("ignoring forcegid mount option specified with no gid= option\n");
-	}
-
 	return 0;
 }
 
@@ -1078,6 +1083,10 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (rc)
 		return rc;
 
+	rc = smb3_handle_conflicting_options(fc);
+	if (rc)
+		return rc;
+
 	old_ctx = kzalloc_obj(*old_ctx);
 	if (!old_ctx)
 		return -ENOMEM;
@@ -1933,11 +1942,6 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	}
 	/* case Opt_ignore: - is ignored as expected ... */
 
-	if (ctx->multiuser && ctx->upcall_target == UPTARGET_MOUNT) {
-		cifs_errorf(fc, "multiuser mount option not supported with upcalltarget set as 'mount'\n");
-		goto cifs_parse_mount_err;
-	}
-
 	return 0;
 
  cifs_parse_mount_err:
-- 
2.53.0



