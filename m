Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A687BAE7;
	Mon,  8 Apr 2024 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583716; cv=none; b=ZNNzjfAe2OBhTGYVCFfXztzJl1DZneoyulF5Yxa3jj6nUURYdGPppVu72PhKJsfq4+nX0pLCTCgwFw+U0XdHVbtc7HsP8CUr24t4C17h+Yu+5ZP0LlHX+JT2WkxfISWIyrADlrWvz3ldsiJXx8d6gLkCDZtoEfjWEoysW/rxiCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583716; c=relaxed/simple;
	bh=wNlBOqvB5mBl/it/gMI/wbDvV+ZJY2JTGbobo4OzRiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wd+JUcbiKpJ5bSiJiMoLc04AFkf2/4ho1DGZujpRWlYsxC7zMY9Z+l9rNhgg7uxbNNc7sy3PgBPNtlrmEs4fRW17zbIwn+qG6HftcaKK4WaN16YYU+QvJN/hRM9X3qioIZyRfX1UGei74H7WBBDt7U1JEEEJ5OlFipG72fNn9sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCBYiPDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCBYiPDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB22DC433C7;
	Mon,  8 Apr 2024 13:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583716;
	bh=wNlBOqvB5mBl/it/gMI/wbDvV+ZJY2JTGbobo4OzRiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCBYiPDGgMGm6BgKR7HAOF51F+Tz3VDoB1GQvjMGw6Is57rfSWO3e0iw98PitHYio
	 5KI1H8eL3e09Xw80/3mHSI5ikeR826MJBU4kYTv8Kt3Dxu4x/mpDo5CMB6NFiq/lD0
	 KZDzH+QZHDdS22vWOMM9vpB5U823pU4yMeDESHaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 226/252] smb: client: handle DFS tcons in cifs_construct_tcon()
Date: Mon,  8 Apr 2024 14:58:45 +0200
Message-ID: <20240408125313.670611348@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
@@ -3988,6 +3988,7 @@ cifs_construct_tcon(struct cifs_sb_info
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon = NULL;
 	struct smb3_fs_context *ctx;
+	char *origin_fullpath = NULL;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (ctx == NULL)
@@ -4011,6 +4012,7 @@ cifs_construct_tcon(struct cifs_sb_info
 	ctx->sign = master_tcon->ses->sign;
 	ctx->seal = master_tcon->seal;
 	ctx->witness = master_tcon->use_witness;
+	ctx->dfs_root_ses = master_tcon->ses->dfs_root_ses;
 
 	rc = cifs_set_vol_auth(ctx, master_tcon->ses);
 	if (rc) {
@@ -4030,12 +4032,39 @@ cifs_construct_tcon(struct cifs_sb_info
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
@@ -4044,6 +4073,7 @@ cifs_construct_tcon(struct cifs_sb_info
 out:
 	kfree(ctx->username);
 	kfree_sensitive(ctx->password);
+	kfree(origin_fullpath);
 	kfree(ctx);
 
 	return tcon;


