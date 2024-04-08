Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FBB79F0;
	Mon,  8 Apr 2024 13:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584139; cv=none; b=pTn0j81GUZ0PHLKi4xBxMpuGgw2yOFscbucOy4eHmeevU2auTl4KnGhMcUbSdabmKGlIOESLwP6WtMakXdAOwxmdwgA1ahNZ1I2/ksImnFebQzPGrXoczOd3DiWybwO/lsYx5c5GFPXX3GKxx323GnEHabRJUAjducBQ2Tx+vvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584139; c=relaxed/simple;
	bh=qYZkIg7CwvsOs5ML1cn9OGrnsM8MIkCqOZLEVQpGigU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdrrMRDwZsqPPQaHtBC7Il/5uBAZSDmjxNIn/ZKFwyTwpIp7nOF+95FSorX4rS/siZZBJCFhD8N5JFl0Pv084vfMYlPcbymI1CszDyF0CfW8vEEKMvR5bUp60lv5hcfNjiR6KHP+eYesmoCEpgfn7ZonVklD4gwnzCdKE+aVl5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL/CNUJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL/CNUJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793C7C433C7;
	Mon,  8 Apr 2024 13:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584138;
	bh=qYZkIg7CwvsOs5ML1cn9OGrnsM8MIkCqOZLEVQpGigU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WL/CNUJmVn83mjb4QUk2c+G3XoBBA8kAm9GWjh09VLOiWGzLqUpc/E6J8Msxtq+lc
	 CnrZC8XyZ5Q1pwRbYYjeXSEnxIvvCgI9SOgyirW/cjmgQCysqI3ngzLnQEAdA5HZMI
	 jWhbciAFzTXJXrWZeYwOFI3Kywi0nf6qUoMJYjVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 245/273] smb: client: refresh referral without acquiring refpath_lock
Date: Mon,  8 Apr 2024 14:58:40 +0200
Message-ID: <20240408125317.050430122@linuxfoundation.org>
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

commit 0a05ad21d77a188d06481c36d6016805a881bcc0 upstream.

Avoid refreshing DFS referral with refpath_lock acquired as the I/O
could block for a while due to a potentially disconnected or slow DFS
root server and then making other threads - that use same @server and
don't require a DFS root server - unable to make any progress.

Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs_cache.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1172,8 +1172,8 @@ static bool is_ses_good(struct cifs_ses
 	return ret;
 }
 
-/* Refresh dfs referral of tcon and mark it for reconnect if needed */
-static int __refresh_tcon(const char *path, struct cifs_ses *ses, bool force_refresh)
+/* Refresh dfs referral of @ses and mark it for reconnect if needed */
+static void __refresh_ses_referral(struct cifs_ses *ses, bool force_refresh)
 {
 	struct TCP_Server_Info *server = ses->server;
 	DFS_CACHE_TGT_LIST(old_tl);
@@ -1181,10 +1181,21 @@ static int __refresh_tcon(const char *pa
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
@@ -1218,19 +1229,17 @@ out:
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
@@ -1271,25 +1280,20 @@ int dfs_cache_remount_fs(struct cifs_sb_
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


