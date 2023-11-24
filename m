Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7524839FD0;
	Fri, 24 Nov 2023 18:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Th2se05j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0935C433C8;
	Fri, 24 Nov 2023 18:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850048;
	bh=F3Db+A/s41z/4lZPB3VLkUjThVHd+Uo288WxOIQZAXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Th2se05jnG7Se1SJRe9vOrC1HfrKB7rRvprNNXPvxNWmEeNhSVl29WkVQGTeS0lhi
	 pdwU77RVnjAh82hrpjzFdgrhufkjY76EcrCKflqYfpmLjV8a0hU+npqhThL/vkyYSS
	 xrIHgGo7Qkg/wv3QXV+Nd7TD05yWRk+ZfySycmy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Bachmakov <e.bachmakov@gmail.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 424/530] smb: client: fix mount when dns_resolver key is not available
Date: Fri, 24 Nov 2023 17:49:50 +0000
Message-ID: <20231124172040.970792168@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

commit 5e2fd17f434d2fed78efb123e2fc6711e4f598f1 upstream.

There was a wrong assumption that with CONFIG_CIFS_DFS_UPCALL=y there
would always be a dns_resolver key set up so we could unconditionally
upcall to resolve UNC hostname rather than using the value provided by
mount(2).

Only require it when performing automount of junctions within a DFS
share so users that don't have dns_resolver key still can mount their
regular shares with server hostname resolved by mount.cifs(8).

Fixes: 348a04a8d113 ("smb: client: get rid of dfs code dep in namespace.c")
Cc: stable@vger.kernel.org
Tested-by: Eduard Bachmakov <e.bachmakov@gmail.com>
Reported-by: Eduard Bachmakov <e.bachmakov@gmail.com>
Closes: https://lore.kernel.org/all/CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com/
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs.c        |   18 +++++++++++++-----
 fs/smb/client/fs_context.h |    1 +
 fs/smb/client/namespace.c  |   17 +++++++++++++++--
 3 files changed, 29 insertions(+), 7 deletions(-)

--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -263,15 +263,23 @@ out:
 	return rc;
 }
 
-/* Resolve UNC hostname in @ctx->source and set ip addr in @ctx->dstaddr */
+/*
+ * If @ctx->dfs_automount, then update @ctx->dstaddr earlier with the DFS root
+ * server from where we'll start following any referrals.  Otherwise rely on the
+ * value provided by mount(2) as the user might not have dns_resolver key set up
+ * and therefore failing to upcall to resolve UNC hostname under @ctx->source.
+ */
 static int update_fs_context_dstaddr(struct smb3_fs_context *ctx)
 {
 	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
-	int rc;
+	int rc = 0;
 
-	rc = dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
-	if (!rc)
-		cifs_set_port(addr, ctx->port);
+	if (!ctx->nodfs && ctx->dfs_automount) {
+		rc = dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
+		if (!rc)
+			cifs_set_port(addr, ctx->port);
+		ctx->dfs_automount = false;
+	}
 	return rc;
 }
 
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -268,6 +268,7 @@ struct smb3_fs_context {
 	bool witness:1; /* use witness protocol */
 	char *leaf_fullpath;
 	struct cifs_ses *dfs_root_ses;
+	bool dfs_automount:1; /* set for dfs automount only */
 };
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -117,6 +117,18 @@ cifs_build_devname(char *nodename, const
 	return dev;
 }
 
+static bool is_dfs_mount(struct dentry *dentry)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	bool ret;
+
+	spin_lock(&tcon->tc_lock);
+	ret = !!tcon->origin_fullpath;
+	spin_unlock(&tcon->tc_lock);
+	return ret;
+}
+
 /* Return full path out of a dentry set for automount */
 static char *automount_fullpath(struct dentry *dentry, void *page)
 {
@@ -212,8 +224,9 @@ static struct vfsmount *cifs_do_automoun
 		ctx->source = NULL;
 		goto out;
 	}
-	cifs_dbg(FYI, "%s: ctx: source=%s UNC=%s prepath=%s\n",
-		 __func__, ctx->source, ctx->UNC, ctx->prepath);
+	ctx->dfs_automount = is_dfs_mount(mntpt);
+	cifs_dbg(FYI, "%s: ctx: source=%s UNC=%s prepath=%s dfs_automount=%d\n",
+		 __func__, ctx->source, ctx->UNC, ctx->prepath, ctx->dfs_automount);
 
 	mnt = fc_mount(fc);
 out:


