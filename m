Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163122DBF75;
	Tue, 21 Jul 2026 18:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659530; cv=none; b=m/4qG5bOVwFAl4lcNJDiaGyQZRUO+jVTWwCx0ZHQRVVbDfTGL7xCEDmQXqukEdyZ43W3v721/oqWN4JtN8xmkuS1/uzi8H7UJEG9bYWjBHKRTH2NQ8fx+6xEmYh3VA6IiNdr1zoLBo6WXG887nUFgA6y3i1JcwduJkPW0ZBNls4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659530; c=relaxed/simple;
	bh=FW3/JinQkzVoEGbJOb0f9Jo/8fpyqvexC3upK5iBnYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOU73cFqh5QTtvk9sVkrpU+bQWyLS5Vq+c0D6uFijkirMdPGObERl/FfImZfBqmvhqSoCAo5dqf9za6fnLxxWr/dOCR7w5CStPqHzk6pF/1AX9Vu5DnUKA73mhM5Lo78TDN9ppvI3csANuTXV3e+Q0ImGPG097v+rYagR3Tf5UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEBhmqje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEBhmqje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370321F000E9;
	Tue, 21 Jul 2026 18:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659528;
	bh=GfQPuFEUvxdJf7Jdii9KYUn+FulbLdPcNd8ZB+msDb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEBhmqjedOMN/MHyNIiSQ42YTg/Lk87KEbMaYqMpATWO2ELNjZif+53myDZIcfRLR
	 hUoSoEB9oQzCF47BW2IffOaFN+ILCzdUkqIP14FAOs3FbvQY7sC6QONpP5eMbB+tYL
	 oWIkB8LlBest5BmPU1hcP/qggUCv64jcPg8TOOaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1555/1611] ksmbd: Use HMAC-MD5 library for NTLMv2
Date: Tue, 21 Jul 2026 17:27:51 +0200
Message-ID: <20260721152550.432887233@linuxfoundation.org>
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

[ Upstream commit 3a597e6e9701eb7af04864ffdc0a6a91bc8c6496 ]

For the HMAC-MD5 computations in NTLMv2, use the HMAC-MD5 library
instead of a "hmac(md5)" crypto_shash.  This is simpler and faster.
With the library there's no need to allocate memory, no need to handle
errors, and the HMAC-MD5 code is accessed directly without inefficient
indirect calls and other unnecessary API overhead.

To preserve the existing behavior of NTLMv2 support being disabled when
the kernel is booted with "fips=1", make ksmbd_auth_ntlmv2() check
fips_enabled itself.  Previously it relied on the error from
crypto_alloc_shash("hmac(md5)") being bubbled up.  I don't know for sure
that this is actually needed, but this preserves the existing behavior.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 954d196bebb2 ("ksmbd: validate NTLMv2 response before updating session key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/Kconfig      |    3 
 fs/smb/server/auth.c       |  175 ++++++---------------------------------------
 fs/smb/server/crypto_ctx.c |    8 --
 fs/smb/server/crypto_ctx.h |    6 -
 fs/smb/server/server.c     |    2 
 5 files changed, 28 insertions(+), 166 deletions(-)

--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -7,11 +7,10 @@ config SMB_SERVER
 	select NLS_UTF8
 	select NLS_UCS2_UTILS
 	select CRYPTO
-	select CRYPTO_MD5
-	select CRYPTO_HMAC
 	select CRYPTO_ECB
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
+	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select CRYPTO_LIB_UTILS
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -13,6 +13,7 @@
 #include <linux/xattr.h>
 #include <crypto/hash.h>
 #include <crypto/aead.h>
+#include <crypto/md5.h>
 #include <crypto/sha2.h>
 #include <crypto/utils.h>
 #include <linux/random.h>
@@ -71,85 +72,16 @@ void ksmbd_copy_gss_neg_header(void *buf
 	memcpy(buf, NEGOTIATE_GSS_HEADER, AUTH_GSS_LENGTH);
 }
 
-/**
- * ksmbd_gen_sess_key() - function to generate session key
- * @sess:	session of connection
- * @hash:	source hash value to be used for find session key
- * @hmac:	source hmac value to be used for finding session key
- *
- */
-static int ksmbd_gen_sess_key(struct ksmbd_session *sess, char *hash,
-			      char *hmac)
-{
-	struct ksmbd_crypto_ctx *ctx;
-	int rc;
-
-	ctx = ksmbd_crypto_ctx_find_hmacmd5();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
-		return -ENOMEM;
-	}
-
-	rc = crypto_shash_setkey(CRYPTO_HMACMD5_TFM(ctx),
-				 hash,
-				 CIFS_HMAC_MD5_HASH_SIZE);
-	if (rc) {
-		ksmbd_debug(AUTH, "hmacmd5 set key fail error %d\n", rc);
-		goto out;
-	}
-
-	rc = crypto_shash_init(CRYPTO_HMACMD5(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "could not init hmacmd5 error %d\n", rc);
-		goto out;
-	}
-
-	rc = crypto_shash_update(CRYPTO_HMACMD5(ctx),
-				 hmac,
-				 SMB2_NTLMV2_SESSKEY_SIZE);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not update with response error %d\n", rc);
-		goto out;
-	}
-
-	rc = crypto_shash_final(CRYPTO_HMACMD5(ctx), sess->sess_key);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate hmacmd5 hash error %d\n", rc);
-		goto out;
-	}
-
-out:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
-}
-
 static int calc_ntlmv2_hash(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 			    char *ntlmv2_hash, char *dname)
 {
 	int ret, len, conv_len;
 	wchar_t *domain = NULL;
 	__le16 *uniname = NULL;
-	struct ksmbd_crypto_ctx *ctx;
+	struct hmac_md5_ctx ctx;
 
-	ctx = ksmbd_crypto_ctx_find_hmacmd5();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "can't generate ntlmv2 hash\n");
-		return -ENOMEM;
-	}
-
-	ret = crypto_shash_setkey(CRYPTO_HMACMD5_TFM(ctx),
-				  user_passkey(sess->user),
+	hmac_md5_init_usingrawkey(&ctx, user_passkey(sess->user),
 				  CIFS_ENCPWD_SIZE);
-	if (ret) {
-		ksmbd_debug(AUTH, "Could not set NT Hash as a key\n");
-		goto out;
-	}
-
-	ret = crypto_shash_init(CRYPTO_HMACMD5(ctx));
-	if (ret) {
-		ksmbd_debug(AUTH, "could not init hmacmd5\n");
-		goto out;
-	}
 
 	/* convert user_name to unicode */
 	len = strlen(user_name(sess->user));
@@ -167,13 +99,7 @@ static int calc_ntlmv2_hash(struct ksmbd
 	}
 	UniStrupr(uniname);
 
-	ret = crypto_shash_update(CRYPTO_HMACMD5(ctx),
-				  (char *)uniname,
-				  UNICODE_LEN(conv_len));
-	if (ret) {
-		ksmbd_debug(AUTH, "Could not update with user\n");
-		goto out;
-	}
+	hmac_md5_update(&ctx, (const u8 *)uniname, UNICODE_LEN(conv_len));
 
 	/* Convert domain name or conn name to unicode and uppercase */
 	len = strlen(dname);
@@ -190,21 +116,12 @@ static int calc_ntlmv2_hash(struct ksmbd
 		goto out;
 	}
 
-	ret = crypto_shash_update(CRYPTO_HMACMD5(ctx),
-				  (char *)domain,
-				  UNICODE_LEN(conv_len));
-	if (ret) {
-		ksmbd_debug(AUTH, "Could not update with domain\n");
-		goto out;
-	}
-
-	ret = crypto_shash_final(CRYPTO_HMACMD5(ctx), ntlmv2_hash);
-	if (ret)
-		ksmbd_debug(AUTH, "Could not generate md5 hash\n");
+	hmac_md5_update(&ctx, (const u8 *)domain, UNICODE_LEN(conv_len));
+	hmac_md5_final(&ctx, ntlmv2_hash);
+	ret = 0;
 out:
 	kfree(uniname);
 	kfree(domain);
-	ksmbd_release_crypto_ctx(ctx);
 	return ret;
 }
 
@@ -225,74 +142,34 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn
 {
 	char ntlmv2_hash[CIFS_ENCPWD_SIZE];
 	char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
-	struct ksmbd_crypto_ctx *ctx = NULL;
-	char *construct = NULL;
-	int rc, len;
-
-	rc = calc_ntlmv2_hash(conn, sess, ntlmv2_hash, domain_name);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not get v2 hash rc %d\n", rc);
-		goto out;
-	}
-
-	ctx = ksmbd_crypto_ctx_find_hmacmd5();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
-		return -ENOMEM;
-	}
-
-	rc = crypto_shash_setkey(CRYPTO_HMACMD5_TFM(ctx),
-				 ntlmv2_hash,
-				 CIFS_HMAC_MD5_HASH_SIZE);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not set NTLMV2 Hash as a key\n");
-		goto out;
-	}
-
-	rc = crypto_shash_init(CRYPTO_HMACMD5(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not init hmacmd5\n");
-		goto out;
-	}
+	struct hmac_md5_ctx ctx;
+	int rc;
 
-	len = CIFS_CRYPTO_KEY_SIZE + blen;
-	construct = kzalloc(len, KSMBD_DEFAULT_GFP);
-	if (!construct) {
-		rc = -ENOMEM;
-		goto out;
+	if (fips_enabled) {
+		ksmbd_debug(AUTH, "NTLMv2 support is disabled due to FIPS\n");
+		return -EOPNOTSUPP;
 	}
 
-	memcpy(construct, cryptkey, CIFS_CRYPTO_KEY_SIZE);
-	memcpy(construct + CIFS_CRYPTO_KEY_SIZE, &ntlmv2->blob_signature, blen);
-
-	rc = crypto_shash_update(CRYPTO_HMACMD5(ctx), construct, len);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not update with response\n");
-		goto out;
-	}
-
-	rc = crypto_shash_final(CRYPTO_HMACMD5(ctx), ntlmv2_rsp);
+	rc = calc_ntlmv2_hash(conn, sess, ntlmv2_hash, domain_name);
 	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate md5 hash\n");
-		goto out;
+		ksmbd_debug(AUTH, "could not get v2 hash rc %d\n", rc);
+		return rc;
 	}
-	ksmbd_release_crypto_ctx(ctx);
-	ctx = NULL;
 
-	rc = ksmbd_gen_sess_key(sess, ntlmv2_hash, ntlmv2_rsp);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate sess key\n");
-		goto out;
-	}
+	hmac_md5_init_usingrawkey(&ctx, ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+	hmac_md5_update(&ctx, cryptkey, CIFS_CRYPTO_KEY_SIZE);
+	hmac_md5_update(&ctx, (const u8 *)&ntlmv2->blob_signature, blen);
+	hmac_md5_final(&ctx, ntlmv2_rsp);
+
+	/* Generate the session key */
+	hmac_md5_usingrawkey(ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE,
+			     ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE,
+			     sess->sess_key);
 
 	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
 			  CIFS_HMAC_MD5_HASH_SIZE))
-		rc = -EINVAL;
-out:
-	if (ctx)
-		ksmbd_release_crypto_ctx(ctx);
-	kfree(construct);
-	return rc;
+		return -EINVAL;
+	return 0;
 }
 
 /**
--- a/fs/smb/server/crypto_ctx.c
+++ b/fs/smb/server/crypto_ctx.c
@@ -66,9 +66,6 @@ static struct shash_desc *alloc_shash_de
 	struct shash_desc *shash;
 
 	switch (id) {
-	case CRYPTO_SHASH_HMACMD5:
-		tfm = crypto_alloc_shash("hmac(md5)", 0, 0);
-		break;
 	case CRYPTO_SHASH_CMACAES:
 		tfm = crypto_alloc_shash("cmac(aes)", 0, 0);
 		break;
@@ -174,11 +171,6 @@ static struct ksmbd_crypto_ctx *____cryp
 	return NULL;
 }
 
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void)
-{
-	return ____crypto_shash_ctx_find(CRYPTO_SHASH_HMACMD5);
-}
-
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void)
 {
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_CMACAES);
--- a/fs/smb/server/crypto_ctx.h
+++ b/fs/smb/server/crypto_ctx.h
@@ -10,8 +10,7 @@
 #include <crypto/aead.h>
 
 enum {
-	CRYPTO_SHASH_HMACMD5	= 0,
-	CRYPTO_SHASH_CMACAES,
+	CRYPTO_SHASH_CMACAES	= 0,
 	CRYPTO_SHASH_MAX,
 };
 
@@ -33,17 +32,14 @@ struct ksmbd_crypto_ctx {
 	struct crypto_aead		*ccmaes[CRYPTO_AEAD_MAX];
 };
 
-#define CRYPTO_HMACMD5(c)	((c)->desc[CRYPTO_SHASH_HMACMD5])
 #define CRYPTO_CMACAES(c)	((c)->desc[CRYPTO_SHASH_CMACAES])
 
-#define CRYPTO_HMACMD5_TFM(c)	((c)->desc[CRYPTO_SHASH_HMACMD5]->tfm)
 #define CRYPTO_CMACAES_TFM(c)	((c)->desc[CRYPTO_SHASH_CMACAES]->tfm)
 
 #define CRYPTO_GCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_GCM])
 #define CRYPTO_CCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_CCM])
 
 void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -634,8 +634,6 @@ MODULE_AUTHOR("Namjae Jeon <linkinjeon@k
 MODULE_DESCRIPTION("Linux kernel CIFS/SMB SERVER");
 MODULE_LICENSE("GPL");
 MODULE_SOFTDEP("pre: ecb");
-MODULE_SOFTDEP("pre: hmac");
-MODULE_SOFTDEP("pre: md5");
 MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");
 MODULE_SOFTDEP("pre: cmac");


