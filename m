Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD7E208DB
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVtZ3msA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DCBC433D9;
	Tue, 31 Oct 2023 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774371;
	bh=ECCgwg/yYP7VnVUo9/EXuc2VRpJ1w0R37pWI2jhydow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVtZ3msAgY7nOUGciBwWvl2Gvvn299igulN7SVZlcy8CjdW0JHLZDf2PqVHg6l0Wz
	 QbnYAMyKOYSf7Xoi5iiYUfdnnaGuQOb18yD40ACD3b0dUEpzgkXfycnGWqEZoYJVih
	 5gs+bzszg9Lz4T3RikQVYQTtrtanokEL/2BKYIxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.5 005/112] smb3: do not start laundromat thread when dir leases  disabled
Date: Tue, 31 Oct 2023 18:00:06 +0100
Message-ID: <20231031165901.482031802@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

When no directory lease support, or for IPC shares where directories
can not be opened, do not start an unneeded laundromat thread for
that mount (it wastes resources).

Fixes: d14de8067e3f ("cifs: Add a laundromat thread for cached directories")
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
(cherry picked from commit 2da338ff752a2789470d733111a5241f30026675)
---
 fs/smb/client/cached_dir.c |  6 ++++++
 fs/smb/client/cifsglob.h   |  2 +-
 fs/smb/client/cifsproto.h  |  2 +-
 fs/smb/client/connect.c    |  8 ++++++--
 fs/smb/client/misc.c       | 14 +++++++++-----
 fs/smb/client/smb2pdu.c    |  2 +-
 6 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index b17f067e4ada0..e2be8aedb26e3 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -452,6 +452,9 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 	struct cached_fid *cfid, *q;
 	LIST_HEAD(entry);
 
+	if (cfids == NULL)
+		return;
+
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		list_move(&cfid->entry, &entry);
@@ -651,6 +654,9 @@ void free_cached_dirs(struct cached_fids *cfids)
 	struct cached_fid *cfid, *q;
 	LIST_HEAD(entry);
 
+	if (cfids == NULL)
+		return;
+
 	if (cfids->laundromat) {
 		kthread_stop(cfids->laundromat);
 		cfids->laundromat = NULL;
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index b4c1c4742f08a..ac68fed5ad28a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1914,7 +1914,7 @@ require use of the stronger protocol */
  * cifsInodeInfo->lock_sem	cifsInodeInfo->llist		cifs_init_once
  *				->can_cache_brlcks
  * cifsInodeInfo->deferred_lock	cifsInodeInfo->deferred_closes	cifsInodeInfo_alloc
- * cached_fid->fid_mutex		cifs_tcon->crfid		tconInfoAlloc
+ * cached_fid->fid_mutex		cifs_tcon->crfid		tcon_info_alloc
  * cifsFileInfo->fh_mutex		cifsFileInfo			cifs_new_fileinfo
  * cifsFileInfo->file_info_lock	cifsFileInfo->count		cifs_new_fileinfo
  *				->invalidHandle			initiate_cifs_search
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1d71d658e1679..bd0a1505719a4 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -513,7 +513,7 @@ extern int CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses);
 
 extern struct cifs_ses *sesInfoAlloc(void);
 extern void sesInfoFree(struct cifs_ses *);
-extern struct cifs_tcon *tconInfoAlloc(void);
+extern struct cifs_tcon *tcon_info_alloc(bool dir_leases_enabled);
 extern void tconInfoFree(struct cifs_tcon *);
 
 extern int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f00d02608ee46..e70203d07d5d1 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1882,7 +1882,8 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		}
 	}
 
-	tcon = tconInfoAlloc();
+	/* no need to setup directory caching on IPC share, so pass in false */
+	tcon = tcon_info_alloc(false);
 	if (tcon == NULL)
 		return -ENOMEM;
 
@@ -2492,7 +2493,10 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		goto out_fail;
 	}
 
-	tcon = tconInfoAlloc();
+	if (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING)
+		tcon = tcon_info_alloc(true);
+	else
+		tcon = tcon_info_alloc(false);
 	if (tcon == NULL) {
 		rc = -ENOMEM;
 		goto out_fail;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index d7e85d9a26553..249fac8be5a51 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -113,18 +113,22 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 }
 
 struct cifs_tcon *
-tconInfoAlloc(void)
+tcon_info_alloc(bool dir_leases_enabled)
 {
 	struct cifs_tcon *ret_buf;
 
 	ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
 	if (!ret_buf)
 		return NULL;
-	ret_buf->cfids = init_cached_dirs();
-	if (!ret_buf->cfids) {
-		kfree(ret_buf);
-		return NULL;
+
+	if (dir_leases_enabled == true) {
+		ret_buf->cfids = init_cached_dirs();
+		if (!ret_buf->cfids) {
+			kfree(ret_buf);
+			return NULL;
+		}
 	}
+	/* else ret_buf->cfids is already set to NULL above */
 
 	atomic_inc(&tconInfoAllocCount);
 	ret_buf->status = TID_NEW;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 9c7e46b7e7c7a..c22cc72223814 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3871,7 +3871,7 @@ void smb2_reconnect_server(struct work_struct *work)
 		goto done;
 
 	/* allocate a dummy tcon struct used for reconnect */
-	tcon = tconInfoAlloc();
+	tcon = tcon_info_alloc(false);
 	if (!tcon) {
 		resched = true;
 		list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
-- 
2.42.0



