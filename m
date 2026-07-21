Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1E4315D53;
	Tue, 21 Jul 2026 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659527; cv=none; b=hOUcQV0GgfhZ1GFJYUgUSJyIijFMXhp+c2mTWtZql1KyIGv7dciEtTZTapf/GEKf6DHNFKs5Lh/QRxanhBJIBh7b4v3FXcSIEYpOfWgLsi2fpivnN71yWJ+2Nhe2ZSGqv1Zn6ZQowO/AGHcPsEhrU3uNL+wWS4rbf4ff+wWIDso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659527; c=relaxed/simple;
	bh=tF0JnX45xjgP7FVSnYOV7ZGQcT+SxgaSzweV04g++1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cm8URy52geIUFrsSZk/jgp0exlzaXLBhSD6IaawLf5ns66XwdFs7G7t+mzMnsu0bdDyO+Zf4SEaBTLUq8QUr7mKCnkax65PuCVphZxseQsmtCu/yR1Wdy2NZ8erLIFOqDOJGEa7dxCsYTp16Pd/OsoVgKGJ6jBjxOH5JU39BDCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSQ73Mrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSQ73Mrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EED91F000E9;
	Tue, 21 Jul 2026 18:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659526;
	bh=gvX7HjeMvB5XFnK2mlrRrIh8nOQEYfbV+HXV9U9slnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSQ73MrvDf1lwkhmAhxBZ4+l/QT6b+Oh+EMvXVQVDjJIBvnb3VVBsaVBMPWMELnz6
	 VY302ypzkzP1Co4lavsDk/4WlFcbBeMpnlXAaW9cFr+5/ayqm+lb3O4dw3M/ZYQtfw
	 0eBfwohZCbfQsVHFXncBSPONpq02Vd38Kwcs4rxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1554/1611] ksmbd: Use HMAC-SHA256 library for message signing and key generation
Date: Tue, 21 Jul 2026 17:27:50 +0200
Message-ID: <20260721152550.409327745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 924067ef183bd17f39d790752190f99982524598 ]

Convert ksmbd_sign_smb2_pdu() and generate_key() to use the HMAC-SHA256
library instead of a "hmac(sha256)" crypto_shash.  This is simpler and
faster.  With the library there's no need to allocate memory, no need to
handle errors, and the HMAC-SHA256 code is accessed directly without
inefficient indirect calls and other unnecessary API overhead.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 954d196bebb2 ("ksmbd: validate NTLMv2 response before updating session key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/Kconfig      |    1 
 fs/smb/server/auth.c       |  180 ++++++++++-----------------------------------
 fs/smb/server/auth.h       |   10 +-
 fs/smb/server/crypto_ctx.c |    8 --
 fs/smb/server/crypto_ctx.h |    5 -
 fs/smb/server/server.c     |    1 
 fs/smb/server/smb2pdu.c    |   25 +-----
 fs/smb/server/smb_common.h |    2 
 8 files changed, 54 insertions(+), 178 deletions(-)

--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -15,7 +15,6 @@ config SMB_SERVER
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select CRYPTO_LIB_UTILS
-	select CRYPTO_SHA256
 	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -592,46 +592,16 @@ int ksmbd_krb5_authenticate(struct ksmbd
  * @sig:	signature value generated for client request packet
  *
  */
-int ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
-			int n_vec, char *sig)
+void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
+			 int n_vec, char *sig)
 {
-	struct ksmbd_crypto_ctx *ctx;
-	int rc, i;
+	struct hmac_sha256_ctx ctx;
+	int i;
 
-	ctx = ksmbd_crypto_ctx_find_hmacsha256();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
-		return -ENOMEM;
-	}
-
-	rc = crypto_shash_setkey(CRYPTO_HMACSHA256_TFM(ctx),
-				 key,
-				 SMB2_NTLMV2_SESSKEY_SIZE);
-	if (rc)
-		goto out;
-
-	rc = crypto_shash_init(CRYPTO_HMACSHA256(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "hmacsha256 init error %d\n", rc);
-		goto out;
-	}
-
-	for (i = 0; i < n_vec; i++) {
-		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx),
-					 iov[i].iov_base,
-					 iov[i].iov_len);
-		if (rc) {
-			ksmbd_debug(AUTH, "hmacsha256 update error %d\n", rc);
-			goto out;
-		}
-	}
-
-	rc = crypto_shash_final(CRYPTO_HMACSHA256(ctx), sig);
-	if (rc)
-		ksmbd_debug(AUTH, "hmacsha256 generation error %d\n", rc);
-out:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
+	hmac_sha256_init_usingrawkey(&ctx, key, SMB2_NTLMV2_SESSKEY_SIZE);
+	for (i = 0; i < n_vec; i++)
+		hmac_sha256_update(&ctx, iov[i].iov_base, iov[i].iov_len);
+	hmac_sha256_final(&ctx, sig);
 }
 
 /**
@@ -691,98 +661,39 @@ struct derivation {
 	bool binding;
 };
 
-static int generate_key(struct ksmbd_conn *conn, struct ksmbd_session *sess,
-			struct kvec label, struct kvec context, __u8 *key,
-			unsigned int key_size)
+static void generate_key(struct ksmbd_conn *conn, struct ksmbd_session *sess,
+			 struct kvec label, struct kvec context, __u8 *key,
+			 unsigned int key_size)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
 	__u8 L128[4] = {0, 0, 0, 128};
 	__u8 L256[4] = {0, 0, 1, 0};
-	int rc;
 	unsigned char prfhash[SMB2_HMACSHA256_SIZE];
-	unsigned char *hashptr = prfhash;
-	struct ksmbd_crypto_ctx *ctx;
-
-	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
-	memset(key, 0x0, key_size);
-
-	ctx = ksmbd_crypto_ctx_find_hmacsha256();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
-		return -ENOMEM;
-	}
+	struct hmac_sha256_ctx ctx;
 
-	rc = crypto_shash_setkey(CRYPTO_HMACSHA256_TFM(ctx),
-				 sess->sess_key,
-				 SMB2_NTLMV2_SESSKEY_SIZE);
-	if (rc)
-		goto smb3signkey_ret;
-
-	rc = crypto_shash_init(CRYPTO_HMACSHA256(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "hmacsha256 init error %d\n", rc);
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), i, 4);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with n\n");
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx),
-				 label.iov_base,
-				 label.iov_len);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with label\n");
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), &zero, 1);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with zero\n");
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx),
-				 context.iov_base,
-				 context.iov_len);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with context\n");
-		goto smb3signkey_ret;
-	}
+	hmac_sha256_init_usingrawkey(&ctx, sess->sess_key,
+				     SMB2_NTLMV2_SESSKEY_SIZE);
+	hmac_sha256_update(&ctx, i, 4);
+	hmac_sha256_update(&ctx, label.iov_base, label.iov_len);
+	hmac_sha256_update(&ctx, &zero, 1);
+	hmac_sha256_update(&ctx, context.iov_base, context.iov_len);
 
 	if (key_size == SMB3_ENC_DEC_KEY_SIZE &&
 	    (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
 	     conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L256, 4);
+		hmac_sha256_update(&ctx, L256, 4);
 	else
-		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L128, 4);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with L\n");
-		goto smb3signkey_ret;
-	}
-
-	rc = crypto_shash_final(CRYPTO_HMACSHA256(ctx), hashptr);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate hmacmd5 hash error %d\n",
-			    rc);
-		goto smb3signkey_ret;
-	}
+		hmac_sha256_update(&ctx, L128, 4);
 
-	memcpy(key, hashptr, key_size);
-
-smb3signkey_ret:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
+	hmac_sha256_final(&ctx, prfhash);
+	memcpy(key, prfhash, key_size);
 }
 
 static int generate_smb3signingkey(struct ksmbd_session *sess,
 				   struct ksmbd_conn *conn,
 				   const struct derivation *signing)
 {
-	int rc;
 	struct channel *chann;
 	char *key;
 
@@ -795,10 +706,8 @@ static int generate_smb3signingkey(struc
 	else
 		key = sess->smb3signingkey;
 
-	rc = generate_key(conn, sess, signing->label, signing->context, key,
-			  SMB3_SIGN_KEY_SIZE);
-	if (rc)
-		return rc;
+	generate_key(conn, sess, signing->label, signing->context, key,
+		     SMB3_SIGN_KEY_SIZE);
 
 	if (!(conn->dialect >= SMB30_PROT_ID && signing->binding))
 		memcpy(chann->smb3signingkey, key, SMB3_SIGN_KEY_SIZE);
@@ -850,32 +759,25 @@ struct derivation_twin {
 	struct derivation decryption;
 };
 
-static int generate_smb3encryptionkey(struct ksmbd_conn *conn,
-				      struct ksmbd_session *sess,
-				      const struct derivation_twin *ptwin)
-{
-	int rc;
-
-	rc = generate_key(conn, sess, ptwin->encryption.label,
-			  ptwin->encryption.context, sess->smb3encryptionkey,
-			  SMB3_ENC_DEC_KEY_SIZE);
-	if (rc)
-		return rc;
-
-	rc = generate_key(conn, sess, ptwin->decryption.label,
-			  ptwin->decryption.context,
-			  sess->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
-	if (rc)
-		return rc;
+static void generate_smb3encryptionkey(struct ksmbd_conn *conn,
+				       struct ksmbd_session *sess,
+				       const struct derivation_twin *ptwin)
+{
+	generate_key(conn, sess, ptwin->encryption.label,
+		     ptwin->encryption.context, sess->smb3encryptionkey,
+		     SMB3_ENC_DEC_KEY_SIZE);
+
+	generate_key(conn, sess, ptwin->decryption.label,
+		     ptwin->decryption.context,
+		     sess->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
 
 	ksmbd_debug(AUTH, "generated SMB3 encryption/decryption keys\n");
 	ksmbd_debug(AUTH, "Cipher type   %d\n", conn->cipher_type);
 	ksmbd_debug(AUTH, "Session Id    %llu\n", sess->id);
-	return 0;
 }
 
-int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
-				  struct ksmbd_session *sess)
+void ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
+				   struct ksmbd_session *sess)
 {
 	struct derivation_twin twin;
 	struct derivation *d;
@@ -892,11 +794,11 @@ int ksmbd_gen_smb30_encryptionkey(struct
 	d->context.iov_base = "ServerIn ";
 	d->context.iov_len = 10;
 
-	return generate_smb3encryptionkey(conn, sess, &twin);
+	generate_smb3encryptionkey(conn, sess, &twin);
 }
 
-int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
-				   struct ksmbd_session *sess)
+void ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
+				    struct ksmbd_session *sess)
 {
 	struct derivation_twin twin;
 	struct derivation *d;
@@ -913,7 +815,7 @@ int ksmbd_gen_smb311_encryptionkey(struc
 	d->context.iov_base = sess->Preauth_HashValue;
 	d->context.iov_len = 64;
 
-	return generate_smb3encryptionkey(conn, sess, &twin);
+	generate_smb3encryptionkey(conn, sess, &twin);
 }
 
 int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
--- a/fs/smb/server/auth.h
+++ b/fs/smb/server/auth.h
@@ -52,18 +52,18 @@ ksmbd_build_ntlmssp_challenge_blob(struc
 				   struct ksmbd_conn *conn);
 int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 			    int in_len,	char *out_blob, int *out_len);
-int ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
-			int n_vec, char *sig);
+void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
+			 int n_vec, char *sig);
 int ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
 			int n_vec, char *sig);
 int ksmbd_gen_smb30_signingkey(struct ksmbd_session *sess,
 			       struct ksmbd_conn *conn);
 int ksmbd_gen_smb311_signingkey(struct ksmbd_session *sess,
 				struct ksmbd_conn *conn);
-int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
-				  struct ksmbd_session *sess);
-int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
+void ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
 				   struct ksmbd_session *sess);
+void ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
+				    struct ksmbd_session *sess);
 int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 				     __u8 *pi_hash);
 #endif
--- a/fs/smb/server/crypto_ctx.c
+++ b/fs/smb/server/crypto_ctx.c
@@ -69,9 +69,6 @@ static struct shash_desc *alloc_shash_de
 	case CRYPTO_SHASH_HMACMD5:
 		tfm = crypto_alloc_shash("hmac(md5)", 0, 0);
 		break;
-	case CRYPTO_SHASH_HMACSHA256:
-		tfm = crypto_alloc_shash("hmac(sha256)", 0, 0);
-		break;
 	case CRYPTO_SHASH_CMACAES:
 		tfm = crypto_alloc_shash("cmac(aes)", 0, 0);
 		break;
@@ -182,11 +179,6 @@ struct ksmbd_crypto_ctx *ksmbd_crypto_ct
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_HMACMD5);
 }
 
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacsha256(void)
-{
-	return ____crypto_shash_ctx_find(CRYPTO_SHASH_HMACSHA256);
-}
-
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void)
 {
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_CMACAES);
--- a/fs/smb/server/crypto_ctx.h
+++ b/fs/smb/server/crypto_ctx.h
@@ -11,7 +11,6 @@
 
 enum {
 	CRYPTO_SHASH_HMACMD5	= 0,
-	CRYPTO_SHASH_HMACSHA256,
 	CRYPTO_SHASH_CMACAES,
 	CRYPTO_SHASH_MAX,
 };
@@ -35,12 +34,9 @@ struct ksmbd_crypto_ctx {
 };
 
 #define CRYPTO_HMACMD5(c)	((c)->desc[CRYPTO_SHASH_HMACMD5])
-#define CRYPTO_HMACSHA256(c)	((c)->desc[CRYPTO_SHASH_HMACSHA256])
 #define CRYPTO_CMACAES(c)	((c)->desc[CRYPTO_SHASH_CMACAES])
 
 #define CRYPTO_HMACMD5_TFM(c)	((c)->desc[CRYPTO_SHASH_HMACMD5]->tfm)
-#define CRYPTO_HMACSHA256_TFM(c)\
-				((c)->desc[CRYPTO_SHASH_HMACSHA256]->tfm)
 #define CRYPTO_CMACAES_TFM(c)	((c)->desc[CRYPTO_SHASH_CMACAES]->tfm)
 
 #define CRYPTO_GCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_GCM])
@@ -48,7 +44,6 @@ struct ksmbd_crypto_ctx {
 
 void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacsha256(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -639,7 +639,6 @@ MODULE_SOFTDEP("pre: md5");
 MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");
 MODULE_SOFTDEP("pre: cmac");
-MODULE_SOFTDEP("pre: sha256");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
 MODULE_SOFTDEP("pre: gcm");
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1552,12 +1552,7 @@ static int ntlm_authenticate(struct ksmb
 
 	if (smb3_encryption_negotiated(conn) &&
 			!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
-		rc = conn->ops->generate_encryptionkey(conn, sess);
-		if (rc) {
-			ksmbd_debug(SMB,
-					"SMB3 encryption key generation failed\n");
-			return -EINVAL;
-		}
+		conn->ops->generate_encryptionkey(conn, sess);
 		sess->enc = true;
 		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
 			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
@@ -1656,12 +1651,7 @@ static int krb5_authenticate(struct ksmb
 
 	if (smb3_encryption_negotiated(conn) &&
 	    !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
-		retval = conn->ops->generate_encryptionkey(conn, sess);
-		if (retval) {
-			ksmbd_debug(SMB,
-				    "SMB3 encryption key generation failed\n");
-			return -EINVAL;
-		}
+		conn->ops->generate_encryptionkey(conn, sess);
 		sess->enc = true;
 		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
 			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
@@ -9077,9 +9067,8 @@ int smb2_check_sign_req(struct ksmbd_wor
 	iov[0].iov_base = (char *)&hdr->ProtocolId;
 	iov[0].iov_len = len;
 
-	if (ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
-				signature))
-		return 0;
+	ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
+			    signature);
 
 	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
@@ -9112,9 +9101,9 @@ void smb2_set_sign_rsp(struct ksmbd_work
 		iov = &work->iov[work->iov_idx];
 	}
 
-	if (!ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, n_vec,
-				 signature))
-		memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
+	ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, n_vec,
+			    signature);
+	memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
 }
 
 /**
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -373,7 +373,7 @@ struct smb_version_ops {
 	int (*check_sign_req)(struct ksmbd_work *work);
 	void (*set_sign_rsp)(struct ksmbd_work *work);
 	int (*generate_signingkey)(struct ksmbd_session *sess, struct ksmbd_conn *conn);
-	int (*generate_encryptionkey)(struct ksmbd_conn *conn, struct ksmbd_session *sess);
+	void (*generate_encryptionkey)(struct ksmbd_conn *conn, struct ksmbd_session *sess);
 	bool (*is_transform_hdr)(void *buf);
 	int (*decrypt_req)(struct ksmbd_work *work);
 	int (*encrypt_resp)(struct ksmbd_work *work);


