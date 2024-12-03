Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1FA1F893B;
	Tue,  3 Dec 2024 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242617; cv=none; b=QfKMFSHy66NDSUCK4NzUexn99ik3eIFyIeAgrHk5/BsljsvlmBQyVH21p3E3LOhIjwNaWkIfzeu2qYELNy4RYq519r5X1BfBZgPKFN/YAtGim3FDWHJdbgCAAHRFcekTZVy+PR9xWjUf7bA4dDyGR+AxaeNwO7ip89ZMP+b8Tj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242617; c=relaxed/simple;
	bh=DNjoKT/GT+PIa7BYqi5WSQDCNrqH5bSqa5zcJURqyS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/NFxWKK1MHpUblpAAWMy+cmJLa9NWHvjYhqnqqYHYuG9lyAVebsqxbki1yPcMcJmuy/2zzRGOFiif2zbk4zrPmq7sFZDXV3Q0EWBqsKRHYiEPF2LtIXtME8RQIWE4M5+b6l3WfyjjMPPeSEqgqnDQaG7fABPv8WymMM+JDgFG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRdzYulc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRdzYulc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9704C4CED6;
	Tue,  3 Dec 2024 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242617;
	bh=DNjoKT/GT+PIa7BYqi5WSQDCNrqH5bSqa5zcJURqyS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRdzYulcEc4Wm34dehh0wzfp1+bUkRhBF8FvC8/iX4nBUkJey4WOHVStpWn32Miq7
	 t/YHMti7tYUsgWRWh2wE2nVcofBxA/kaTHGz3I6lFgcTxrRy86WCFTrXC/mFcCf5R9
	 fcd7UiNsT/Hf3iYV3Ze1r8vuV0jB5BadfQEQ5Z+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 750/826] smb: client: fix use-after-free of signing key
Date: Tue,  3 Dec 2024 15:47:57 +0100
Message-ID: <20241203144813.020085739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 343d7fe6df9e247671440a932b6a73af4fa86d95 upstream.

Customers have reported use-after-free in @ses->auth_key.response with
SMB2.1 + sign mounts which occurs due to following race:

task A                         task B
cifs_mount()
 dfs_mount_share()
  get_session()
   cifs_mount_get_session()    cifs_send_recv()
    cifs_get_smb_ses()          compound_send_recv()
     cifs_setup_session()        smb2_setup_request()
      kfree_sensitive()           smb2_calc_signature()
                                   crypto_shash_setkey() *UAF*

Fix this by ensuring that we have a valid @ses->auth_key.response by
checking whether @ses->ses_status is SES_GOOD or SES_EXITING with
@ses->ses_lock held.  After commit 24a9799aa8ef ("smb: client: fix UAF
in smb2_reconnect_server()"), we made sure to call ->logoff() only
when @ses was known to be good (e.g. valid ->auth_key.response), so
it's safe to access signing key when @ses->ses_status == SES_EXITING.

Cc: stable@vger.kernel.org
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2proto.h     |    2 -
 fs/smb/client/smb2transport.c |   56 ++++++++++++++++++++++++++++++------------
 2 files changed, 40 insertions(+), 18 deletions(-)

--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -37,8 +37,6 @@ extern struct mid_q_entry *smb2_setup_re
 					      struct smb_rqst *rqst);
 extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
-extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
-					   __u64 ses_id);
 extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 						__u64 ses_id, __u32  tid);
 extern int smb2_calc_signature(struct smb_rqst *rqst,
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -74,7 +74,7 @@ err:
 
 
 static
-int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
+int smb3_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 {
 	struct cifs_chan *chan;
 	struct TCP_Server_Info *pserver;
@@ -168,16 +168,41 @@ smb2_find_smb_ses_unlocked(struct TCP_Se
 	return NULL;
 }
 
-struct cifs_ses *
-smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
+static int smb2_get_sign_key(struct TCP_Server_Info *server,
+			     __u64 ses_id, u8 *key)
 {
 	struct cifs_ses *ses;
+	int rc = -ENOENT;
+
+	if (SERVER_IS_CHAN(server))
+		server = server->primary_server;
 
 	spin_lock(&cifs_tcp_ses_lock);
-	ses = smb2_find_smb_ses_unlocked(server, ses_id);
-	spin_unlock(&cifs_tcp_ses_lock);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		if (ses->Suid != ses_id)
+			continue;
 
-	return ses;
+		rc = 0;
+		spin_lock(&ses->ses_lock);
+		switch (ses->ses_status) {
+		case SES_EXITING: /* SMB2_LOGOFF */
+		case SES_GOOD:
+			if (likely(ses->auth_key.response)) {
+				memcpy(key, ses->auth_key.response,
+				       SMB2_NTLMV2_SESSKEY_SIZE);
+			} else {
+				rc = -EIO;
+			}
+			break;
+		default:
+			rc = -EAGAIN;
+			break;
+		}
+		spin_unlock(&ses->ses_lock);
+		break;
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+	return rc;
 }
 
 static struct cifs_tcon *
@@ -236,14 +261,16 @@ smb2_calc_signature(struct smb_rqst *rqs
 	unsigned char *sigptr = smb2_signature;
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
-	struct cifs_ses *ses;
 	struct shash_desc *shash = NULL;
 	struct smb_rqst drqst;
+	__u64 sid = le64_to_cpu(shdr->SessionId);
+	u8 key[SMB2_NTLMV2_SESSKEY_SIZE];
 
-	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
-	if (unlikely(!ses)) {
-		cifs_server_dbg(FYI, "%s: Could not find session\n", __func__);
-		return -ENOENT;
+	rc = smb2_get_sign_key(server, sid, key);
+	if (unlikely(rc)) {
+		cifs_server_dbg(FYI, "%s: [sesid=0x%llx] couldn't find signing key: %d\n",
+				__func__, sid, rc);
+		return rc;
 	}
 
 	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
@@ -260,8 +287,7 @@ smb2_calc_signature(struct smb_rqst *rqs
 		shash = server->secmech.hmacsha256;
 	}
 
-	rc = crypto_shash_setkey(shash->tfm, ses->auth_key.response,
-			SMB2_NTLMV2_SESSKEY_SIZE);
+	rc = crypto_shash_setkey(shash->tfm, key, sizeof(key));
 	if (rc) {
 		cifs_server_dbg(VFS,
 				"%s: Could not update with response\n",
@@ -303,8 +329,6 @@ smb2_calc_signature(struct smb_rqst *rqs
 out:
 	if (allocate_crypto)
 		cifs_free_hash(&shash);
-	if (ses)
-		cifs_put_smb_ses(ses);
 	return rc;
 }
 
@@ -570,7 +594,7 @@ smb3_calc_signature(struct smb_rqst *rqs
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
-	rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
+	rc = smb3_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
 	if (unlikely(rc)) {
 		cifs_server_dbg(FYI, "%s: Could not get signing key\n", __func__);
 		return rc;


