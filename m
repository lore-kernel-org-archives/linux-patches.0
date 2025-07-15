Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE40C2E3AED;
	Tue, 15 Jul 2025 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586050; cv=none; b=aWTAY/kgLXLMs0HFZGo2k5KDrRMlwiwziPy3CX3UxQBWFz3zbhjiVT5i1BEAfZOOUbuJ6A9CH3vjmj2B/OOkM93jqK2qHsR6mUZW2soO2tws1H7eUb4y+UjlNxgHRVtXDmTra4btLFGvFQrIHH2UMS4hY8keUYb/OZg33mf0nCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586050; c=relaxed/simple;
	bh=Urhc0WLito1KGueqNqdBS4Odv4ildhAqkrljrcoyk8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyfEBWP/fOpMhhvhZ7tgv+bnf2Yv2KPv/iHNqMfin91ut0UIixfxn+PkJ6SNkoPHLRLYOaGt5AOYqaFAMmzxKE6MOGiJpYMXlKcMHiYrYFmo/OL+LGQ4w9yHSlOo9XkSQvklWEsPgQyZ1+/1NZIvKJdiKtcVN+IFxv5rZkg66aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVdQf9uq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVdQf9uq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDC7C4CEE3;
	Tue, 15 Jul 2025 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586049;
	bh=Urhc0WLito1KGueqNqdBS4Odv4ildhAqkrljrcoyk8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVdQf9uqHEs4Bd2n8/FGJcxbdxtWLqKBbegzyvwq36k8L7mXO3ocw2zw6ah/bmxgm
	 0EhqHRVgioCtMKOUUYiINuaKjDwLtAR3jE+LRifYiRkQ7OUbvgqiXfjZpYiuaiZiux
	 Fr7xU/ijtzVyOPlkpfIyGfombuzBSd98z3LhFCaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/109] smb: client: avoid unnecessary reconnects when refreshing referrals
Date: Tue, 15 Jul 2025 15:13:31 +0200
Message-ID: <20250715130801.886545460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 242d23efc987151ecd34bc0cae4c0b737494fc40 ]

Do not mark tcons for reconnect when current connection matches any of
the targets returned by new referral even when there is no cached
entry.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 74ebd02163fd ("cifs: all initializations for tcon should happen in tcon_info_alloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/dfs_cache.c | 187 ++++++++++++++++++++++++--------------
 1 file changed, 117 insertions(+), 70 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 11c8efecf7aa1..3cf7c88489be4 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1095,16 +1095,18 @@ int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
 	return 0;
 }
 
-static bool target_share_equal(struct TCP_Server_Info *server, const char *s1, const char *s2)
+static bool target_share_equal(struct cifs_tcon *tcon, const char *s1)
 {
-	char unc[sizeof("\\\\") + SERVER_NAME_LENGTH] = {0};
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct sockaddr_storage ss;
 	const char *host;
+	const char *s2 = &tcon->tree_name[1];
 	size_t hostlen;
-	struct sockaddr_storage ss;
+	char unc[sizeof("\\\\") + SERVER_NAME_LENGTH] = {0};
 	bool match;
 	int rc;
 
-	if (strcasecmp(s1, s2))
+	if (strcasecmp(s2, s1))
 		return false;
 
 	/*
@@ -1128,34 +1130,6 @@ static bool target_share_equal(struct TCP_Server_Info *server, const char *s1, c
 	return match;
 }
 
-/*
- * Mark dfs tcon for reconnecting when the currently connected tcon does not match any of the new
- * target shares in @refs.
- */
-static void mark_for_reconnect_if_needed(struct TCP_Server_Info *server,
-					 const char *path,
-					 struct dfs_cache_tgt_list *old_tl,
-					 struct dfs_cache_tgt_list *new_tl)
-{
-	struct dfs_cache_tgt_iterator *oit, *nit;
-
-	for (oit = dfs_cache_get_tgt_iterator(old_tl); oit;
-	     oit = dfs_cache_get_next_tgt(old_tl, oit)) {
-		for (nit = dfs_cache_get_tgt_iterator(new_tl); nit;
-		     nit = dfs_cache_get_next_tgt(new_tl, nit)) {
-			if (target_share_equal(server,
-					       dfs_cache_get_tgt_name(oit),
-					       dfs_cache_get_tgt_name(nit))) {
-				dfs_cache_noreq_update_tgthint(path, nit);
-				return;
-			}
-		}
-	}
-
-	cifs_dbg(FYI, "%s: no cached or matched targets. mark dfs share for reconnect.\n", __func__);
-	cifs_signal_cifsd_for_reconnect(server, true);
-}
-
 static bool is_ses_good(struct cifs_ses *ses)
 {
 	struct TCP_Server_Info *server = ses->server;
@@ -1172,41 +1146,35 @@ static bool is_ses_good(struct cifs_ses *ses)
 	return ret;
 }
 
-/* Refresh dfs referral of @ses and mark it for reconnect if needed */
-static void __refresh_ses_referral(struct cifs_ses *ses, bool force_refresh)
+static char *get_ses_refpath(struct cifs_ses *ses)
 {
 	struct TCP_Server_Info *server = ses->server;
-	DFS_CACHE_TGT_LIST(old_tl);
-	DFS_CACHE_TGT_LIST(new_tl);
-	bool needs_refresh = false;
-	struct cache_entry *ce;
-	unsigned int xid;
-	char *path = NULL;
-	int rc = 0;
-
-	xid = get_xid();
+	char *path = ERR_PTR(-ENOENT);
 
 	mutex_lock(&server->refpath_lock);
 	if (server->leaf_fullpath) {
 		path = kstrdup(server->leaf_fullpath + 1, GFP_ATOMIC);
 		if (!path)
-			rc = -ENOMEM;
+			path = ERR_PTR(-ENOMEM);
 	}
 	mutex_unlock(&server->refpath_lock);
-	if (!path)
-		goto out;
+	return path;
+}
 
-	down_read(&htable_rw_lock);
-	ce = lookup_cache_entry(path);
-	needs_refresh = force_refresh || IS_ERR(ce) || cache_entry_expired(ce);
-	if (!IS_ERR(ce)) {
-		rc = get_targets(ce, &old_tl);
-		cifs_dbg(FYI, "%s: get_targets: %d\n", __func__, rc);
-	}
-	up_read(&htable_rw_lock);
+/* Refresh dfs referral of @ses */
+static void refresh_ses_referral(struct cifs_ses *ses)
+{
+	struct cache_entry *ce;
+	unsigned int xid;
+	char *path;
+	int rc = 0;
 
-	if (!needs_refresh) {
-		rc = 0;
+	xid = get_xid();
+
+	path = get_ses_refpath(ses);
+	if (IS_ERR(path)) {
+		rc = PTR_ERR(path);
+		path = NULL;
 		goto out;
 	}
 
@@ -1217,29 +1185,106 @@ static void __refresh_ses_referral(struct cifs_ses *ses, bool force_refresh)
 		goto out;
 	}
 
-	ce = cache_refresh_path(xid, ses, path, true);
-	if (!IS_ERR(ce)) {
-		rc = get_targets(ce, &new_tl);
+	ce = cache_refresh_path(xid, ses, path, false);
+	if (!IS_ERR(ce))
 		up_read(&htable_rw_lock);
-		cifs_dbg(FYI, "%s: get_targets: %d\n", __func__, rc);
-		mark_for_reconnect_if_needed(server, path, &old_tl, &new_tl);
-	}
+	else
+		rc = PTR_ERR(ce);
 
 out:
 	free_xid(xid);
-	dfs_cache_free_tgts(&old_tl);
-	dfs_cache_free_tgts(&new_tl);
 	kfree(path);
 }
 
-static inline void refresh_ses_referral(struct cifs_ses *ses)
+static int __refresh_tcon_referral(struct cifs_tcon *tcon,
+				   const char *path,
+				   struct dfs_info3_param *refs,
+				   int numrefs, bool force_refresh)
 {
-	__refresh_ses_referral(ses, false);
+	struct cache_entry *ce;
+	bool reconnect = force_refresh;
+	int rc = 0;
+	int i;
+
+	if (unlikely(!numrefs))
+		return 0;
+
+	if (force_refresh) {
+		for (i = 0; i < numrefs; i++) {
+			/* TODO: include prefix paths in the matching */
+			if (target_share_equal(tcon, refs[i].node_name)) {
+				reconnect = false;
+				break;
+			}
+		}
+	}
+
+	down_write(&htable_rw_lock);
+	ce = lookup_cache_entry(path);
+	if (!IS_ERR(ce)) {
+		if (force_refresh || cache_entry_expired(ce))
+			rc = update_cache_entry_locked(ce, refs, numrefs);
+	} else if (PTR_ERR(ce) == -ENOENT) {
+		ce = add_cache_entry_locked(refs, numrefs);
+	}
+	up_write(&htable_rw_lock);
+
+	if (IS_ERR(ce))
+		rc = PTR_ERR(ce);
+	if (reconnect) {
+		cifs_tcon_dbg(FYI, "%s: mark for reconnect\n", __func__);
+		cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
+	}
+	return rc;
 }
 
-static inline void force_refresh_ses_referral(struct cifs_ses *ses)
+static void refresh_tcon_referral(struct cifs_tcon *tcon, bool force_refresh)
 {
-	__refresh_ses_referral(ses, true);
+	struct dfs_info3_param *refs = NULL;
+	struct cache_entry *ce;
+	struct cifs_ses *ses;
+	unsigned int xid;
+	bool needs_refresh;
+	char *path;
+	int numrefs = 0;
+	int rc = 0;
+
+	xid = get_xid();
+	ses = tcon->ses;
+
+	path = get_ses_refpath(ses);
+	if (IS_ERR(path)) {
+		rc = PTR_ERR(path);
+		path = NULL;
+		goto out;
+	}
+
+	down_read(&htable_rw_lock);
+	ce = lookup_cache_entry(path);
+	needs_refresh = force_refresh || IS_ERR(ce) || cache_entry_expired(ce);
+	if (!needs_refresh) {
+		up_read(&htable_rw_lock);
+		goto out;
+	}
+	up_read(&htable_rw_lock);
+
+	ses = CIFS_DFS_ROOT_SES(ses);
+	if (!is_ses_good(ses)) {
+		cifs_dbg(FYI, "%s: skip cache refresh due to disconnected ipc\n",
+			 __func__);
+		goto out;
+	}
+
+	rc = get_dfs_referral(xid, ses, path, &refs, &numrefs);
+	if (!rc) {
+		rc = __refresh_tcon_referral(tcon, path, refs,
+					     numrefs, force_refresh);
+	}
+
+out:
+	free_xid(xid);
+	kfree(path);
+	free_dfs_info_array(refs, numrefs);
 }
 
 /**
@@ -1280,7 +1325,7 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	 */
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 
-	force_refresh_ses_referral(tcon->ses);
+	refresh_tcon_referral(tcon, true);
 	return 0;
 }
 
@@ -1291,9 +1336,11 @@ void dfs_cache_refresh(struct work_struct *work)
 	struct cifs_ses *ses;
 
 	tcon = container_of(work, struct cifs_tcon, dfs_cache_work.work);
+	ses = tcon->ses->dfs_root_ses;
 
-	for (ses = tcon->ses; ses; ses = ses->dfs_root_ses)
+	for (; ses; ses = ses->dfs_root_ses)
 		refresh_ses_referral(ses);
+	refresh_tcon_referral(tcon, false);
 
 	queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
 			   atomic_read(&dfs_cache_ttl) * HZ);
-- 
2.39.5



