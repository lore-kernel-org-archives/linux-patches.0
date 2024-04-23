Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6802785274;
	Tue, 23 Apr 2024 21:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908569; cv=none; b=tHTWFmbBNKKRlFAVU1K9iCA6oirapJs2y5t1+g8mnx4Nvk0QQpKdN0b+/ittW0q4rZoGNLlhGHwPtO9US9T3JnsOPQeF7aTRh7uix2kB8+itBdvEpqOoG5Y0NvrRmoyC/xNlTvDkpdsT0EJpJ+yWCNMD82uywD28eTDLZZPxdyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908569; c=relaxed/simple;
	bh=1DNpKNDT2aKd7S4XrUQ0nm6r9BBx4hZhESJVRsVsEGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBR7A1BcEDSxnBS/jH46FrHQjHGeRqtBog9LzBLeg9PH+nq28JbKAF/uvylvwJDOgZSRKdbvg8QJrMd9GRMgpyKBlFxVLD97//G8Zhq1zYMQMHW8BnnGZXw6jTqC83zEujH5gb5EfDX2kEeIOCWo4YD75AeQjc6I+eH0h3l3yXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MX/63uPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MX/63uPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39839C4AF08;
	Tue, 23 Apr 2024 21:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908569;
	bh=1DNpKNDT2aKd7S4XrUQ0nm6r9BBx4hZhESJVRsVsEGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MX/63uPjsK1vp1+XBRZlk3P6nACoCdk/VNCyYZCvpcgv9FPGJYgGNR/hlByLomepC
	 pmeZ4Ek/ppfPL6lMjCtywNWXl185/lc1qVxCA0YCLnt80XgMxN2EeggEMApBM9Y7ij
	 TMec5Q3MoCnpwkF9ZaymzLRxPClMk7fmZwBSDHXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/158] smb: client: refresh referral without acquiring refpath_lock
Date: Tue, 23 Apr 2024 14:37:22 -0700
Message-ID: <20240423213855.867965991@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

[ Upstream commit 0a05ad21d77a188d06481c36d6016805a881bcc0 ]

Avoid refreshing DFS referral with refpath_lock acquired as the I/O
could block for a while due to a potentially disconnected or slow DFS
root server and then making other threads - that use same @server and
don't require a DFS root server - unable to make any progress.

Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/dfs_cache.c | 44 +++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 0552a864ff08f..11c8efecf7aa1 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1172,8 +1172,8 @@ static bool is_ses_good(struct cifs_ses *ses)
 	return ret;
 }
 
-/* Refresh dfs referral of tcon and mark it for reconnect if needed */
-static int __refresh_tcon(const char *path, struct cifs_ses *ses, bool force_refresh)
+/* Refresh dfs referral of @ses and mark it for reconnect if needed */
+static void __refresh_ses_referral(struct cifs_ses *ses, bool force_refresh)
 {
 	struct TCP_Server_Info *server = ses->server;
 	DFS_CACHE_TGT_LIST(old_tl);
@@ -1181,10 +1181,21 @@ static int __refresh_tcon(const char *path, struct cifs_ses *ses, bool force_ref
 	bool needs_refresh = false;
 	struct cache_entry *ce;
 	unsigned int xid;
+	char *path = NULL;
 	int rc = 0;
 
 	xid = get_xid();
 
+	mutex_lock(&server->refpath_lock);
+	if (server->leaf_fullpath) {
+		path = kstrdup(server->leaf_fullpath + 1, GFP_ATOMIC);
+		if (!path)
+			rc = -ENOMEM;
+	}
+	mutex_unlock(&server->refpath_lock);
+	if (!path)
+		goto out;
+
 	down_read(&htable_rw_lock);
 	ce = lookup_cache_entry(path);
 	needs_refresh = force_refresh || IS_ERR(ce) || cache_entry_expired(ce);
@@ -1218,19 +1229,17 @@ static int __refresh_tcon(const char *path, struct cifs_ses *ses, bool force_ref
 	free_xid(xid);
 	dfs_cache_free_tgts(&old_tl);
 	dfs_cache_free_tgts(&new_tl);
-	return rc;
+	kfree(path);
 }
 
-static int refresh_tcon(struct cifs_tcon *tcon, bool force_refresh)
+static inline void refresh_ses_referral(struct cifs_ses *ses)
 {
-	struct TCP_Server_Info *server = tcon->ses->server;
-	struct cifs_ses *ses = tcon->ses;
+	__refresh_ses_referral(ses, false);
+}
 
-	mutex_lock(&server->refpath_lock);
-	if (server->leaf_fullpath)
-		__refresh_tcon(server->leaf_fullpath + 1, ses, force_refresh);
-	mutex_unlock(&server->refpath_lock);
-	return 0;
+static inline void force_refresh_ses_referral(struct cifs_ses *ses)
+{
+	__refresh_ses_referral(ses, true);
 }
 
 /**
@@ -1271,25 +1280,20 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	 */
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 
-	return refresh_tcon(tcon, true);
+	force_refresh_ses_referral(tcon->ses);
+	return 0;
 }
 
 /* Refresh all DFS referrals related to DFS tcon */
 void dfs_cache_refresh(struct work_struct *work)
 {
-	struct TCP_Server_Info *server;
 	struct cifs_tcon *tcon;
 	struct cifs_ses *ses;
 
 	tcon = container_of(work, struct cifs_tcon, dfs_cache_work.work);
 
-	for (ses = tcon->ses; ses; ses = ses->dfs_root_ses) {
-		server = ses->server;
-		mutex_lock(&server->refpath_lock);
-		if (server->leaf_fullpath)
-			__refresh_tcon(server->leaf_fullpath + 1, ses, false);
-		mutex_unlock(&server->refpath_lock);
-	}
+	for (ses = tcon->ses; ses; ses = ses->dfs_root_ses)
+		refresh_ses_referral(ses);
 
 	queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
 			   atomic_read(&dfs_cache_ttl) * HZ);
-- 
2.43.0



