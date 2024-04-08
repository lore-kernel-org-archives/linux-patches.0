Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892C22DF73;
	Mon,  8 Apr 2024 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584171; cv=none; b=lcXwrW0L/a0kR7kMY/JyP7X1GYDtk+cocVxWUKVXBoIkyzmazTbnqKF5fzEANeMro0iCbcZGq/88PYAOclYsrB20ii25fB4PbhF1/+yrMbPSF69gTMl35bYJOJjnlKWQ2eQQUu+lH6G9Nby7e95KCXGWOukvMfw+vroJotkdS34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584171; c=relaxed/simple;
	bh=l406DONaeMHUoMUQAyLTgm2hqUTAdf/E5ovYI1qvxM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nex6e/sJiMJpYOvTxpilplDEUjlHcftjVti5gsAghSW0hTRSyu0O7MFX83wv5UPBdgmt34R16CFAI1eAc2r2EOhLxEfguHyIpDMUw3cpc4xccoCWPN4+ruLWBm0kUjLPaKhBJajTeliy2u/EAWJsLZ2ZY5Yy/t7CBgQ1XnYm0xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLFZ4k9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLFZ4k9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14286C433F1;
	Mon,  8 Apr 2024 13:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584171;
	bh=l406DONaeMHUoMUQAyLTgm2hqUTAdf/E5ovYI1qvxM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLFZ4k9aY9bql0qN6R2opcOYgTyDiYwtf0f8opmcrP8yR19F6TU/W1oIt0u5sdERC
	 KyMTLOMhw1zDbk6X0HY2tfX6bfaC83UEeNsTXEa53YlgRnyBMf4/lFtAMskSg4lIyD
	 kMA++xpd0x6my2gskrNI4DvCW0vNgtI3W5E2+0vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 246/273] smb: client: handle DFS tcons in cifs_construct_tcon()
Date: Mon,  8 Apr 2024 14:58:41 +0200
Message-ID: <20240408125317.081690256@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 4a5ba0e0bfe552ac7451f57e304f6343c3d87f89 upstream.

The tcons created by cifs_construct_tcon() on multiuser mounts must
also be able to failover and refresh DFS referrals, so set the
appropriate fields in order to get a full DFS tcon.  They could be
shared among different superblocks later, too.

Cc: stable@vger.kernel.org # 6.4+
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404021518.3Xu2VU4s-lkp@intel.com/
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3996,6 +3996,7 @@ cifs_construct_tcon(struct cifs_sb_info
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon = NULL;
 	struct smb3_fs_context *ctx;
+	char *origin_fullpath = NULL;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (ctx == NULL)
@@ -4019,6 +4020,7 @@ cifs_construct_tcon(struct cifs_sb_info
 	ctx->sign = master_tcon->ses->sign;
 	ctx->seal = master_tcon->seal;
 	ctx->witness = master_tcon->use_witness;
+	ctx->dfs_root_ses = master_tcon->ses->dfs_root_ses;
 
 	rc = cifs_set_vol_auth(ctx, master_tcon->ses);
 	if (rc) {
@@ -4038,12 +4040,39 @@ cifs_construct_tcon(struct cifs_sb_info
 		goto out;
 	}
 
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	spin_lock(&master_tcon->tc_lock);
+	if (master_tcon->origin_fullpath) {
+		spin_unlock(&master_tcon->tc_lock);
+		origin_fullpath = dfs_get_path(cifs_sb, cifs_sb->ctx->source);
+		if (IS_ERR(origin_fullpath)) {
+			tcon = ERR_CAST(origin_fullpath);
+			origin_fullpath = NULL;
+			cifs_put_smb_ses(ses);
+			goto out;
+		}
+	} else {
+		spin_unlock(&master_tcon->tc_lock);
+	}
+#endif
+
 	tcon = cifs_get_tcon(ses, ctx);
 	if (IS_ERR(tcon)) {
 		cifs_put_smb_ses(ses);
 		goto out;
 	}
 
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	if (origin_fullpath) {
+		spin_lock(&tcon->tc_lock);
+		tcon->origin_fullpath = origin_fullpath;
+		spin_unlock(&tcon->tc_lock);
+		origin_fullpath = NULL;
+		queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
+				   dfs_cache_get_ttl() * HZ);
+	}
+#endif
+
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(ses))
 		reset_cifs_unix_caps(0, tcon, NULL, ctx);
@@ -4052,6 +4081,7 @@ cifs_construct_tcon(struct cifs_sb_info
 out:
 	kfree(ctx->username);
 	kfree_sensitive(ctx->password);
+	kfree(origin_fullpath);
 	kfree(ctx);
 
 	return tcon;


