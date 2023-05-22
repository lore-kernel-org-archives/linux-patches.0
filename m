Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E50171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8090C433EF;
	Mon, 22 May 2023 19:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783316;
	bh=k6J6iAUpU2deFynylwaVIDw2PsSppJ6IGFYbpWYYLwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TP6/2xo8ocz0UbJTDLp9Aebn20n5r2U6L0hPBLrz+/FkGWK9V4vcskH95EM8OEKoz
	 nvHsKebOFOrq9jayEtYF9A5aVVAeY7YyE3Tf1K31fHBsMvaUAO+VIsKmt4lIN+Ziyv
	 UDvJ6COSJJpK0Qjk78EyAUh+vD5lGIlMyE62X6l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 184/203] SMB3: drop reference to cfile before sending oplock break
Date: Mon, 22 May 2023 20:10:08 +0100
Message-Id: <20230522190400.104108344@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bharath SM <bharathsm@microsoft.com>

commit 59a556aebc43dded08535fe97d94ca3f657915e4 upstream.

In cifs_oplock_break function we drop reference to a cfile at
the end of function, due to which close command goes on wire
after lease break acknowledgment even if file is already closed
by application but we had deferred the handle close.
If other client with limited file shareaccess waiting on lease
break ack proceeds operation on that file as soon as first client
sends ack, then we may encounter status sharing violation error
because of open handle.
Solution is to put reference to cfile(send close on wire if last ref)
and then send oplock acknowledgment to server.

Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferred close handles for the same file.")
Cc: stable@kernel.org
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsglob.h |    4 ++--
 fs/cifs/file.c     |   17 ++++++++++++-----
 fs/cifs/smb1ops.c  |    9 ++++-----
 fs/cifs/smb2ops.c  |    7 +++----
 4 files changed, 21 insertions(+), 16 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -394,8 +394,8 @@ struct smb_version_operations {
 	/* check for STATUS_NETWORK_SESSION_EXPIRED */
 	bool (*is_session_expired)(char *);
 	/* send oplock break response */
-	int (*oplock_response)(struct cifs_tcon *, struct cifs_fid *,
-			       struct cifsInodeInfo *);
+	int (*oplock_response)(struct cifs_tcon *tcon, __u64 persistent_fid, __u64 volatile_fid,
+			__u16 net_fid, struct cifsInodeInfo *cifs_inode);
 	/* query remote filesystem */
 	int (*queryfs)(const unsigned int, struct cifs_tcon *,
 		       struct cifs_sb_info *, struct kstatfs *);
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4869,7 +4869,9 @@ void cifs_oplock_break(struct work_struc
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
-	bool purge_cache = false;
+	bool purge_cache = false, oplock_break_cancelled;
+	__u64 persistent_fid, volatile_fid;
+	__u16 net_fid;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -4914,19 +4916,24 @@ oplock_break_ack:
 	if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred_closes))
 		cifs_close_deferred_file(cinode);
 
+	persistent_fid = cfile->fid.persistent_fid;
+	volatile_fid = cfile->fid.volatile_fid;
+	net_fid = cfile->fid.netfid;
+	oplock_break_cancelled = cfile->oplock_break_cancelled;
+
+	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
 	 * a now incorrect file handle is not a data integrity issue but do
 	 * not bother sending an oplock release if session to server still is
 	 * disconnected since oplock already released by the server
 	 */
-	if (!cfile->oplock_break_cancelled) {
-		rc = tcon->ses->server->ops->oplock_response(tcon, &cfile->fid,
-							     cinode);
+	if (!oplock_break_cancelled) {
+		rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
+				volatile_fid, net_fid, cinode);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	}
 
-	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	cifs_done_oplock_break(cinode);
 }
 
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -864,12 +864,11 @@ cifs_close_dir(const unsigned int xid, s
 }
 
 static int
-cifs_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
-		     struct cifsInodeInfo *cinode)
+cifs_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
+		__u64 volatile_fid, __u16 net_fid, struct cifsInodeInfo *cinode)
 {
-	return CIFSSMBLock(0, tcon, fid->netfid, current->tgid, 0, 0, 0, 0,
-			   LOCKING_ANDX_OPLOCK_RELEASE, false,
-			   CIFS_CACHE_READ(cinode) ? 1 : 0);
+	return CIFSSMBLock(0, tcon, net_fid, current->tgid, 0, 0, 0, 0,
+			   LOCKING_ANDX_OPLOCK_RELEASE, false, CIFS_CACHE_READ(cinode) ? 1 : 0);
 }
 
 static int
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2570,15 +2570,14 @@ smb2_is_network_name_deleted(char *buf,
 }
 
 static int
-smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
-		     struct cifsInodeInfo *cinode)
+smb2_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
+		__u64 volatile_fid, __u16 net_fid, struct cifsInodeInfo *cinode)
 {
 	if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
 		return SMB2_lease_break(0, tcon, cinode->lease_key,
 					smb2_get_lease_state(cinode));
 
-	return SMB2_oplock_break(0, tcon, fid->persistent_fid,
-				 fid->volatile_fid,
+	return SMB2_oplock_break(0, tcon, persistent_fid, volatile_fid,
 				 CIFS_CACHE_READ(cinode) ? 1 : 0);
 }
 


