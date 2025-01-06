Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E422149C7B;
	Mon,  6 Jan 2025 15:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176978; cv=none; b=EeLPVWEOjCPQ5D9f2d2dgv22mPloxAhAz9yv39gYQworjRwrda27jZLG/0Oxfb8kT5mc6GKsmKOg3S0Tit6e/u/OllMse/gNUeP63e4l6LQF+5LhqidoMT1EA2UYgpBnFc+e31NkAw314xwZcahMr3kP3AIB226ycsRR99Ir7zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176978; c=relaxed/simple;
	bh=MDi2HGZeZInSMxlUZS8Q90h5Kntr+f1r7/82KC9iPrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQKlciOAoJ77fsps7HEdq9DaqLqr4XyoYig+xFB3ak1PmtkHNEIsih9BisJsC8R07RN2S1nvkTvb85XXe0qRET5syw1JpUH4mmJK+XC5D6h15wqkz45sHQEXwfWWk1knVEF821qgyABz0Zp9mK3fDA8sHIwcY7u278JVLTEjx3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4Idqsc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4Idqsc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E330C4CED2;
	Mon,  6 Jan 2025 15:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176977;
	bh=MDi2HGZeZInSMxlUZS8Q90h5Kntr+f1r7/82KC9iPrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4Idqsc2k96fHhUn/anf2FYQfWWxyZcn/4ge0dgBMjMSVcNQ7IXyYLKZbbxGGOBbw
	 lNRU9f3hGuZlNtNeahGVs77kn7Fua6KPpdCiztD7RlY/mN4stthbLqIiWIE7zz9QIB
	 4IGk/qO3ZPwJdphcO0TPdvFvLxbccq3+0jOV1Soc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/222] smb: client: fix use-after-free of signing key
Date: Mon,  6 Jan 2025 16:13:35 +0100
Message-ID: <20250106151151.026227213@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

[ Upstream commit 343d7fe6df9e247671440a932b6a73af4fa86d95 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2proto.h     |  2 --
 fs/smb/client/smb2transport.c | 56 +++++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index fd90d8e5a1d1..750e4e397b13 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -37,8 +37,6 @@ extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
 					      struct smb_rqst *rqst);
 extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
-extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
-					   __u64 ses_id);
 extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 						__u64 ses_id, __u32  tid);
 extern int smb2_calc_signature(struct smb_rqst *rqst,
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 73eae1b16034..4a43802375b3 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -74,7 +74,7 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 
 
 static
-int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
+int smb3_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 {
 	struct cifs_chan *chan;
 	struct TCP_Server_Info *pserver;
@@ -168,16 +168,41 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
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
@@ -236,14 +261,16 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
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
@@ -260,8 +287,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 		shash = server->secmech.hmacsha256;
 	}
 
-	rc = crypto_shash_setkey(shash->tfm, ses->auth_key.response,
-			SMB2_NTLMV2_SESSKEY_SIZE);
+	rc = crypto_shash_setkey(shash->tfm, key, sizeof(key));
 	if (rc) {
 		cifs_server_dbg(VFS,
 				"%s: Could not update with response\n",
@@ -303,8 +329,6 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 out:
 	if (allocate_crypto)
 		cifs_free_hash(&shash);
-	if (ses)
-		cifs_put_smb_ses(ses);
 	return rc;
 }
 
@@ -570,7 +594,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
-	rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
+	rc = smb3_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
 	if (unlikely(rc)) {
 		cifs_server_dbg(FYI, "%s: Could not get signing key\n", __func__);
 		return rc;
-- 
2.39.5



