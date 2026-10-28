Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213988;
	b=Gu5d060ovBGeLSntaPDtVDbh414/2SrmTYPjV65/qn52d5Z0bWRJZSi8U5IZcJJiaj64
	 PGnVk3mMdDmnKk8MseYMY2vY0t+kUa4BprLxfxm2CKWIctEBEbTSHYINVxlnSfCZExSWU
	 eSU2dvNOXmHwch+GSHulv98fyHVeC2muGZns2IiiKwuiPEZj7RPJaFdyUo4lPR5S0nivB
	 cYZmwWZqDXNNoYYs3ij+K92KNKWjj9/WSiReHq2/uSNJ/ITpQHnP0hoPuI+j7znzvY7nF
	 PVmwCSL/+DUv2Fuj9u8WqIUkmGHIZTBQO/YcUzXlpxImeCHr+5cPTlTHobyCA9xSGiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kie44RUzLY6TmLZR9R9Zs7tGDSXKIwCfG9c3MryRaJg=;
	b=WcMQuEar0WbMsnvIk50wl7PietX7dCMG48G+pwfZPcPLs+LjTxlcShuhJ+a4rbIOWcRj
	 TvBMo8Xe1ronCl54rWbzVE6ny17noaOdeUtFgPizEIkiWOewRFSdNZZ6PrEjl1b0cp/AL
	 eJSIgNrCZhPV8Wt3beg/3F0MZqX2jk/S7h+bnQ8UOMEp7/oDf+uENbkWzRoQsI2Z/n/hn
	 KmhUg8m/dsbY4egbDp6aoGzvfvon0cuRkHeHcbQbL7bNmYGU9KZGVonQXsfJKompVhFee
	 cOzdFGHeps353SOjOBrSxjCJmdFHlX7VwPye+mP8Kn+V5ygTfC5cHRTkOuUjHo6wxzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HV1m4yhG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201E0606A327;
	Wed, 28 Oct 2026 18:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HV1m4yhG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721BD1F01825;
	Wed, 28 Oct 2026 18:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213988;
	bh=kie44RUzLY6TmLZR9R9Zs7tGDSXKIwCfG9c3MryRaJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HV1m4yhGZZzUJnXsEuv8A6hJX1+rEuIO2rPR8ktAh2Vyqh8v2q4K5ujswSI3GlTrv
	 Sns3hvHeh2BzYsTimVxamfD0QgeMEDHfzPJBxJg72Iso06mE5X8aOYPAS54vZq+2Ky
	 VXIN5K+tj5IrCrvaDoLa1cX5qv3s2xg758M31zZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0699/1887] smb: client: fix use-after-free of signing key
Date: Wed, 28 Oct 2026 17:46:35 +0100
Message-ID: <20261028170515.317509832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2897fb6f5397e..e166f49bdf696 100644
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
index e72c6933788e8..f709bc3424dd8 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -75,7 +75,7 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 
 
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
+	if (CIFS_SERVER_IS_CHAN(server))
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
 
@@ -582,7 +606,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
-	rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
+	rc = smb3_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
 	if (unlikely(rc)) {
 		cifs_server_dbg(VFS, "%s: Could not get signing key\n", __func__);
 		return rc;
-- 
2.53.0



