Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF0280620;
	Mon,  8 Apr 2024 13:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582681; cv=none; b=iVlsV7XwUWldJ+gTcpKcGjEhsVFR3e1Ns/pMY0Dw+lzqDwPlkF19z0WAjnxEpgoTLHpDIMdeKkwe2ATiC7a55R7SweTV7DxaMKSmAmlfW8kjfxET2UHAERxqtjuvBdZxAZyNxzGYeI2ABf3qDrR8J6cH+CmEoWk5nGFPLywKkXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582681; c=relaxed/simple;
	bh=jkipIlhYxbrcp38TUw0JgOZN21Z2nPRRpg0hUnhoyAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAvDWNfJqZYlb8yN9Tz7fxVj0v056SJ+/hNoA7p50e3X2WiMxivnAkRIV957HFI1Q9FGj3uyB7VqpCc7breOFAzNmU8PNhEtJU1HI7XZ2mEpPlUaVA1L7Ea8sRADSD+sJYYneT+n4Z063T6mTtEtse0Z/FxHoWfAt/u+JL7naa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3+pedeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3+pedeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A20C433C7;
	Mon,  8 Apr 2024 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582681;
	bh=jkipIlhYxbrcp38TUw0JgOZN21Z2nPRRpg0hUnhoyAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3+pedeRkglnseb6CAAHliCAqaPp2wwf5aJyXCDZbNaDmlmunP6d/3np3eXWJ+LJX
	 wASlxdbs+21HkUFmiSqaOj+pWsw2TQZR+iauj1WuxkFrAoAewKHD19vP3aw3Bg0nkU
	 ut/0i4LfEhAkGEgcBJcmL2fvoLEGGyUBsyHl1IJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritvik Budhiraja <rbudhiraja@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 125/138] smb3: retrying on failed server close
Date: Mon,  8 Apr 2024 14:58:59 +0200
Message-ID: <20240408125300.120199651@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritvik Budhiraja <rbudhiraja@microsoft.com>

commit 173217bd73365867378b5e75a86f0049e1069ee8 upstream.

In the current implementation, CIFS close sends a close to the
server and does not check for the success of the server close.
This patch adds functionality to check for server close return
status and retries in case of an EBUSY or EAGAIN error.

This can help avoid handle leaks

Cc: stable@vger.kernel.org
Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |    6 ++--
 fs/smb/client/cifsfs.c     |   11 +++++++
 fs/smb/client/cifsglob.h   |    7 +++--
 fs/smb/client/file.c       |   63 ++++++++++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb1ops.c    |    4 +-
 fs/smb/client/smb2ops.c    |    9 +++---
 fs/smb/client/smb2pdu.c    |    2 -
 7 files changed, 85 insertions(+), 17 deletions(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -370,6 +370,7 @@ smb2_close_cached_fid(struct kref *ref)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
+	int rc;
 
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->on_list) {
@@ -383,9 +384,10 @@ smb2_close_cached_fid(struct kref *ref)
 	cfid->dentry = NULL;
 
 	if (cfid->is_open) {
-		SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
+		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
 			   cfid->fid.volatile_fid);
-		atomic_dec(&cfid->tcon->num_remote_opens);
+		if (rc != -EBUSY && rc != -EAGAIN)
+			atomic_dec(&cfid->tcon->num_remote_opens);
 	}
 
 	free_cached_dir(cfid);
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -154,6 +154,7 @@ struct workqueue_struct	*decrypt_wq;
 struct workqueue_struct	*fileinfo_put_wq;
 struct workqueue_struct	*cifsoplockd_wq;
 struct workqueue_struct	*deferredclose_wq;
+struct workqueue_struct	*serverclose_wq;
 __u32 cifs_lock_secret;
 
 /*
@@ -1866,6 +1867,13 @@ init_cifs(void)
 		goto out_destroy_cifsoplockd_wq;
 	}
 
+	serverclose_wq = alloc_workqueue("serverclose",
+					   WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
+	if (!serverclose_wq) {
+		rc = -ENOMEM;
+		goto out_destroy_serverclose_wq;
+	}
+
 	rc = cifs_init_inodecache();
 	if (rc)
 		goto out_destroy_deferredclose_wq;
@@ -1940,6 +1948,8 @@ out_destroy_decrypt_wq:
 	destroy_workqueue(decrypt_wq);
 out_destroy_cifsiod_wq:
 	destroy_workqueue(cifsiod_wq);
+out_destroy_serverclose_wq:
+	destroy_workqueue(serverclose_wq);
 out_clean_proc:
 	cifs_proc_clean();
 	return rc;
@@ -1969,6 +1979,7 @@ exit_cifs(void)
 	destroy_workqueue(cifsoplockd_wq);
 	destroy_workqueue(decrypt_wq);
 	destroy_workqueue(fileinfo_put_wq);
+	destroy_workqueue(serverclose_wq);
 	destroy_workqueue(cifsiod_wq);
 	cifs_proc_clean();
 }
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -389,10 +389,10 @@ struct smb_version_operations {
 	/* set fid protocol-specific info */
 	void (*set_fid)(struct cifsFileInfo *, struct cifs_fid *, __u32);
 	/* close a file */
-	void (*close)(const unsigned int, struct cifs_tcon *,
+	int (*close)(const unsigned int, struct cifs_tcon *,
 		      struct cifs_fid *);
 	/* close a file, returning file attributes and timestamps */
-	void (*close_getattr)(const unsigned int xid, struct cifs_tcon *tcon,
+	int (*close_getattr)(const unsigned int xid, struct cifs_tcon *tcon,
 		      struct cifsFileInfo *pfile_info);
 	/* send a flush request to the server */
 	int (*flush)(const unsigned int, struct cifs_tcon *, struct cifs_fid *);
@@ -1359,6 +1359,7 @@ struct cifsFileInfo {
 	bool invalidHandle:1;	/* file closed via session abend */
 	bool swapfile:1;
 	bool oplock_break_cancelled:1;
+	bool offload:1; /* offload final part of _put to a wq */
 	unsigned int oplock_epoch; /* epoch from the lease break */
 	__u32 oplock_level; /* oplock/lease level from the lease break */
 	int count;
@@ -1367,6 +1368,7 @@ struct cifsFileInfo {
 	struct cifs_search_info srch_inf;
 	struct work_struct oplock_break; /* work for oplock breaks */
 	struct work_struct put; /* work for the final part of _put */
+	struct work_struct serverclose; /* work for serverclose */
 	struct delayed_work deferred;
 	bool deferred_close_scheduled; /* Flag to indicate close is scheduled */
 	char *symlink_target;
@@ -2005,6 +2007,7 @@ extern struct workqueue_struct *decrypt_
 extern struct workqueue_struct *fileinfo_put_wq;
 extern struct workqueue_struct *cifsoplockd_wq;
 extern struct workqueue_struct *deferredclose_wq;
+extern struct workqueue_struct *serverclose_wq;
 extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_mid_poolp;
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -330,6 +330,7 @@ cifs_down_write(struct rw_semaphore *sem
 }
 
 static void cifsFileInfo_put_work(struct work_struct *work);
+void serverclose_work(struct work_struct *work);
 
 struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 				       struct tcon_link *tlink, __u32 oplock,
@@ -376,6 +377,7 @@ struct cifsFileInfo *cifs_new_fileinfo(s
 	cfile->tlink = cifs_get_tlink(tlink);
 	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
 	INIT_WORK(&cfile->put, cifsFileInfo_put_work);
+	INIT_WORK(&cfile->serverclose, serverclose_work);
 	INIT_DELAYED_WORK(&cfile->deferred, smb2_deferred_work_close);
 	mutex_init(&cfile->fh_mutex);
 	spin_lock_init(&cfile->file_info_lock);
@@ -467,6 +469,40 @@ static void cifsFileInfo_put_work(struct
 	cifsFileInfo_put_final(cifs_file);
 }
 
+void serverclose_work(struct work_struct *work)
+{
+	struct cifsFileInfo *cifs_file = container_of(work,
+			struct cifsFileInfo, serverclose);
+
+	struct cifs_tcon *tcon = tlink_tcon(cifs_file->tlink);
+
+	struct TCP_Server_Info *server = tcon->ses->server;
+	int rc = 0;
+	int retries = 0;
+	int MAX_RETRIES = 4;
+
+	do {
+		if (server->ops->close_getattr)
+			rc = server->ops->close_getattr(0, tcon, cifs_file);
+		else if (server->ops->close)
+			rc = server->ops->close(0, tcon, &cifs_file->fid);
+
+		if (rc == -EBUSY || rc == -EAGAIN) {
+			retries++;
+			msleep(250);
+		}
+	} while ((rc == -EBUSY || rc == -EAGAIN) && (retries < MAX_RETRIES)
+	);
+
+	if (retries == MAX_RETRIES)
+		pr_warn("Serverclose failed %d times, giving up\n", MAX_RETRIES);
+
+	if (cifs_file->offload)
+		queue_work(fileinfo_put_wq, &cifs_file->put);
+	else
+		cifsFileInfo_put_final(cifs_file);
+}
+
 /**
  * cifsFileInfo_put - release a reference of file priv data
  *
@@ -507,10 +543,13 @@ void _cifsFileInfo_put(struct cifsFileIn
 	struct cifs_fid fid = {};
 	struct cifs_pending_open open;
 	bool oplock_break_cancelled;
+	bool serverclose_offloaded = false;
 
 	spin_lock(&tcon->open_file_lock);
 	spin_lock(&cifsi->open_file_lock);
 	spin_lock(&cifs_file->file_info_lock);
+
+	cifs_file->offload = offload;
 	if (--cifs_file->count > 0) {
 		spin_unlock(&cifs_file->file_info_lock);
 		spin_unlock(&cifsi->open_file_lock);
@@ -552,13 +591,20 @@ void _cifsFileInfo_put(struct cifsFileIn
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
 		struct TCP_Server_Info *server = tcon->ses->server;
 		unsigned int xid;
+		int rc = 0;
 
 		xid = get_xid();
 		if (server->ops->close_getattr)
-			server->ops->close_getattr(xid, tcon, cifs_file);
+			rc = server->ops->close_getattr(xid, tcon, cifs_file);
 		else if (server->ops->close)
-			server->ops->close(xid, tcon, &cifs_file->fid);
+			rc = server->ops->close(xid, tcon, &cifs_file->fid);
 		_free_xid(xid);
+
+		if (rc == -EBUSY || rc == -EAGAIN) {
+			// Server close failed, hence offloading it as an async op
+			queue_work(serverclose_wq, &cifs_file->serverclose);
+			serverclose_offloaded = true;
+		}
 	}
 
 	if (oplock_break_cancelled)
@@ -566,10 +612,15 @@ void _cifsFileInfo_put(struct cifsFileIn
 
 	cifs_del_pending_open(&open);
 
-	if (offload)
-		queue_work(fileinfo_put_wq, &cifs_file->put);
-	else
-		cifsFileInfo_put_final(cifs_file);
+	// if serverclose has been offloaded to wq (on failure), it will
+	// handle offloading put as well. If serverclose not offloaded,
+	// we need to handle offloading put here.
+	if (!serverclose_offloaded) {
+		if (offload)
+			queue_work(fileinfo_put_wq, &cifs_file->put);
+		else
+			cifsFileInfo_put_final(cifs_file);
+	}
 }
 
 int cifs_open(struct inode *inode, struct file *file)
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -750,11 +750,11 @@ cifs_set_fid(struct cifsFileInfo *cfile,
 	cinode->can_cache_brlcks = CIFS_CACHE_WRITE(cinode);
 }
 
-static void
+static int
 cifs_close_file(const unsigned int xid, struct cifs_tcon *tcon,
 		struct cifs_fid *fid)
 {
-	CIFSSMBClose(xid, tcon, fid->netfid);
+	return CIFSSMBClose(xid, tcon, fid->netfid);
 }
 
 static int
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1392,14 +1392,14 @@ smb2_set_fid(struct cifsFileInfo *cfile,
 	memcpy(cfile->fid.create_guid, fid->create_guid, 16);
 }
 
-static void
+static int
 smb2_close_file(const unsigned int xid, struct cifs_tcon *tcon,
 		struct cifs_fid *fid)
 {
-	SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
+	return SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
 }
 
-static void
+static int
 smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifsFileInfo *cfile)
 {
@@ -1410,7 +1410,7 @@ smb2_close_getattr(const unsigned int xi
 	rc = __SMB2_close(xid, tcon, cfile->fid.persistent_fid,
 		   cfile->fid.volatile_fid, &file_inf);
 	if (rc)
-		return;
+		return rc;
 
 	inode = d_inode(cfile->dentry);
 
@@ -1436,6 +1436,7 @@ smb2_close_getattr(const unsigned int xi
 
 	/* End of file and Attributes should not have to be updated on close */
 	spin_unlock(&inode->i_lock);
+	return rc;
 }
 
 static int
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3452,9 +3452,9 @@ __SMB2_close(const unsigned int xid, str
 			memcpy(&pbuf->network_open_info,
 			       &rsp->network_open_info,
 			       sizeof(pbuf->network_open_info));
+		atomic_dec(&tcon->num_remote_opens);
 	}
 
-	atomic_dec(&tcon->num_remote_opens);
 close_exit:
 	SMB2_close_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);


