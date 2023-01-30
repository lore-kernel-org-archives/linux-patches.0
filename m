Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6435828EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC714C433D2;
	Mon, 30 Jan 2023 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087166;
	bh=8H7ZNeu2+wFrG7LiSUBZ4Zw+JrLC/bh20XeelFMAUSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBJhigdaeN3vQizr636KDFc6ubQKyD09zqmZhA2ysUh2hIxcOSI6cBJr6pNvawwGj
	 EQgsdx3xe5LNPfQiFFIWyCw0cPjVvHa8ooEbbJFswfPrMRMi4If2Ymt0gK16rU8ly5
	 suE5ROwsYWBQjvhziGeIW5GN7FIjzGZzD2b4iF6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aurelien.aptel@gmail.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/313] cifs: fix potential deadlock in cache_refresh_path()
Date: Mon, 30 Jan 2023 14:49:14 +0100
Message-Id: <20230130134342.201324578@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 9fb0db40513e27537fde63287aea920b60557a69 ]

Avoid getting DFS referral from an exclusive lock in
cache_refresh_path() because the tcon IPC used for getting the
referral could be disconnected and thus causing a deadlock as shown
below:

task A                       task B
======                       ======
cifs_demultiplex_thread()    dfs_cache_find()
 cifs_handle_standard()       cache_refresh_path()
  reconnect_dfs_server()       down_write()
   dfs_cache_noreq_find()       get_dfs_referral()
    down_read() <- deadlock      smb2_get_dfs_refer()
                                  SMB2_ioctl()
				   cifs_send_recv()
				    compound_send_recv()
				     wait_for_response()

where task A cannot wake up task B because it is blocked on
down_read() due to the exclusive lock held in cache_refresh_path() and
therefore not being able to make progress.

Fixes: c9f711039905 ("cifs: keep referral server sessions alive")
Reviewed-by: Aurélien Aptel <aurelien.aptel@gmail.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dfs_cache.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index e70915ad7541..4302dc75843c 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -792,26 +792,27 @@ static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses, const
  */
 static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, const char *path)
 {
-	int rc;
-	struct cache_entry *ce;
 	struct dfs_info3_param *refs = NULL;
+	struct cache_entry *ce;
 	int numrefs = 0;
-	bool newent = false;
+	int rc;
 
 	cifs_dbg(FYI, "%s: search path: %s\n", __func__, path);
 
-	down_write(&htable_rw_lock);
+	down_read(&htable_rw_lock);
 
 	ce = lookup_cache_entry(path);
-	if (!IS_ERR(ce)) {
-		if (!cache_entry_expired(ce)) {
-			dump_ce(ce);
-			up_write(&htable_rw_lock);
-			return 0;
-		}
-	} else {
-		newent = true;
+	if (!IS_ERR(ce) && !cache_entry_expired(ce)) {
+		up_read(&htable_rw_lock);
+		return 0;
 	}
+	/*
+	 * Unlock shared access as we don't want to hold any locks while getting
+	 * a new referral.  The @ses used for performing the I/O could be
+	 * reconnecting and it acquires @htable_rw_lock to look up the dfs cache
+	 * in order to failover -- if necessary.
+	 */
+	up_read(&htable_rw_lock);
 
 	/*
 	 * Either the entry was not found, or it is expired.
@@ -819,19 +820,22 @@ static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, cons
 	 */
 	rc = get_dfs_referral(xid, ses, path, &refs, &numrefs);
 	if (rc)
-		goto out_unlock;
+		goto out;
 
 	dump_refs(refs, numrefs);
 
-	if (!newent) {
-		rc = update_cache_entry_locked(ce, refs, numrefs);
-		goto out_unlock;
+	down_write(&htable_rw_lock);
+	/* Re-check as another task might have it added or refreshed already */
+	ce = lookup_cache_entry(path);
+	if (!IS_ERR(ce)) {
+		if (cache_entry_expired(ce))
+			rc = update_cache_entry_locked(ce, refs, numrefs);
+	} else {
+		rc = add_cache_entry_locked(refs, numrefs);
 	}
 
-	rc = add_cache_entry_locked(refs, numrefs);
-
-out_unlock:
 	up_write(&htable_rw_lock);
+out:
 	free_dfs_info_array(refs, numrefs);
 	return rc;
 }
-- 
2.39.0



