Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D9B2DBF75;
	Tue, 21 Jul 2026 18:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659524; cv=none; b=NqLcMaVxbfIyon1XgnPD75f2xGBxuYs8gFdDuFv9Qmrp0L+NOQDbcSIOEF1u8gn1tUR5rf+t7KQaRmwmuCJQ635IFULla2PFdEmjoQkbkNB/Fs2Q47EN/nKICsa/eZxKTQbGKMrpmsECVKPWWtw9WTZ52jCdTc6F8c3qbAsjHyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659524; c=relaxed/simple;
	bh=KtvBYgba8MGeHLnAjWeC/drIaj60Mnt+aj5Z+G/p7yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnY+OH3dBpiM/k24GvVkm99eVB3Y6xMzJpphm9VXjr061WsHQY9nX10HNjMYs8SzZiQ5i0zvMq3+1OgxU6/pWm5wM8l6l3AOfq+C4xU4cW3MGbn/RCkeKtiHQQZDfm7BtOUyzEmYbAcwRJbSTHZcfOwuSohIkttI85t8ixQy6q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gcb4eev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gcb4eev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E11F000E9;
	Tue, 21 Jul 2026 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659523;
	bh=uLH+h9iMHDH/QWwTm0H/KXZtBXcCWqowQCRLYePnsSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Gcb4eevAigkFONFuqtvzazBGG6sDwWuDfVkKG5PkCS7Fh9iZPdSbhW7Sj3XTgaYF
	 1/WQqEPtrFuz8hoInLLdmJtgXE2frf6SGUGOGtl7C79HetSu6aAwDzPiSBB7fj/hI7
	 HWoRKpMaDbkebVvZkoQQVFe5PUZQsZwD/oB1mA1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1553/1611] ksmbd: Use SHA-512 library for SMB3.1.1 preauth hash
Date: Tue, 21 Jul 2026 17:27:49 +0200
Message-ID: <20260721152550.386471331@linuxfoundation.org>
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

[ Upstream commit e009cb1e3093977c5b96a1c6697a7dc9332222d5 ]

Convert ksmbd_gen_preauth_integrity_hash() to use the SHA-512 library
instead of a "sha512" crypto_shash.  This is simpler and faster.  With
the library there's no need to allocate memory, no need to handle
errors, and the SHA-512 code is accessed directly without inefficient
indirect calls and other unnecessary API overhead.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 954d196bebb2 ("ksmbd: validate NTLMv2 response before updating session key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/Kconfig      |    2 +-
 fs/smb/server/auth.c       |   41 +++++++----------------------------------
 fs/smb/server/crypto_ctx.c |    8 --------
 fs/smb/server/crypto_ctx.h |    4 ----
 fs/smb/server/server.c     |    1 -
 5 files changed, 8 insertions(+), 48 deletions(-)

--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -13,10 +13,10 @@ config SMB_SERVER
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
 	select CRYPTO_LIB_UTILS
 	select CRYPTO_SHA256
 	select CRYPTO_CMAC
-	select CRYPTO_SHA512
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -13,6 +13,7 @@
 #include <linux/xattr.h>
 #include <crypto/hash.h>
 #include <crypto/aead.h>
+#include <crypto/sha2.h>
 #include <crypto/utils.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
@@ -918,48 +919,20 @@ int ksmbd_gen_smb311_encryptionkey(struc
 int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 				     __u8 *pi_hash)
 {
-	int rc;
 	struct smb2_hdr *rcv_hdr = smb2_get_msg(buf);
 	char *all_bytes_msg = (char *)&rcv_hdr->ProtocolId;
 	int msg_size = get_rfc1002_len(buf);
-	struct ksmbd_crypto_ctx *ctx = NULL;
+	struct sha512_ctx sha_ctx;
 
 	if (conn->preauth_info->Preauth_HashId !=
 	    SMB2_PREAUTH_INTEGRITY_SHA512)
 		return -EINVAL;
 
-	ctx = ksmbd_crypto_ctx_find_sha512();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not alloc sha512\n");
-		return -ENOMEM;
-	}
-
-	rc = crypto_shash_init(CRYPTO_SHA512(ctx));
-	if (rc) {
-		ksmbd_debug(AUTH, "could not init shashn");
-		goto out;
-	}
-
-	rc = crypto_shash_update(CRYPTO_SHA512(ctx), pi_hash, 64);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with n\n");
-		goto out;
-	}
-
-	rc = crypto_shash_update(CRYPTO_SHA512(ctx), all_bytes_msg, msg_size);
-	if (rc) {
-		ksmbd_debug(AUTH, "could not update with n\n");
-		goto out;
-	}
-
-	rc = crypto_shash_final(CRYPTO_SHA512(ctx), pi_hash);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate hash err : %d\n", rc);
-		goto out;
-	}
-out:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
+	sha512_init(&sha_ctx);
+	sha512_update(&sha_ctx, pi_hash, 64);
+	sha512_update(&sha_ctx, all_bytes_msg, msg_size);
+	sha512_final(&sha_ctx, pi_hash);
+	return 0;
 }
 
 static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
--- a/fs/smb/server/crypto_ctx.c
+++ b/fs/smb/server/crypto_ctx.c
@@ -75,9 +75,6 @@ static struct shash_desc *alloc_shash_de
 	case CRYPTO_SHASH_CMACAES:
 		tfm = crypto_alloc_shash("cmac(aes)", 0, 0);
 		break;
-	case CRYPTO_SHASH_SHA512:
-		tfm = crypto_alloc_shash("sha512", 0, 0);
-		break;
 	default:
 		return NULL;
 	}
@@ -195,11 +192,6 @@ struct ksmbd_crypto_ctx *ksmbd_crypto_ct
 	return ____crypto_shash_ctx_find(CRYPTO_SHASH_CMACAES);
 }
 
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha512(void)
-{
-	return ____crypto_shash_ctx_find(CRYPTO_SHASH_SHA512);
-}
-
 static struct ksmbd_crypto_ctx *____crypto_aead_ctx_find(int id)
 {
 	struct ksmbd_crypto_ctx *ctx;
--- a/fs/smb/server/crypto_ctx.h
+++ b/fs/smb/server/crypto_ctx.h
@@ -13,7 +13,6 @@ enum {
 	CRYPTO_SHASH_HMACMD5	= 0,
 	CRYPTO_SHASH_HMACSHA256,
 	CRYPTO_SHASH_CMACAES,
-	CRYPTO_SHASH_SHA512,
 	CRYPTO_SHASH_MAX,
 };
 
@@ -38,13 +37,11 @@ struct ksmbd_crypto_ctx {
 #define CRYPTO_HMACMD5(c)	((c)->desc[CRYPTO_SHASH_HMACMD5])
 #define CRYPTO_HMACSHA256(c)	((c)->desc[CRYPTO_SHASH_HMACSHA256])
 #define CRYPTO_CMACAES(c)	((c)->desc[CRYPTO_SHASH_CMACAES])
-#define CRYPTO_SHA512(c)	((c)->desc[CRYPTO_SHASH_SHA512])
 
 #define CRYPTO_HMACMD5_TFM(c)	((c)->desc[CRYPTO_SHASH_HMACMD5]->tfm)
 #define CRYPTO_HMACSHA256_TFM(c)\
 				((c)->desc[CRYPTO_SHASH_HMACSHA256]->tfm)
 #define CRYPTO_CMACAES_TFM(c)	((c)->desc[CRYPTO_SHASH_CMACAES]->tfm)
-#define CRYPTO_SHA512_TFM(c)	((c)->desc[CRYPTO_SHASH_SHA512]->tfm)
 
 #define CRYPTO_GCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_GCM])
 #define CRYPTO_CCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_CCM])
@@ -53,7 +50,6 @@ void ksmbd_release_crypto_ctx(struct ksm
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacmd5(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_hmacsha256(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha512(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
 struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
 void ksmbd_crypto_destroy(void);
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -640,7 +640,6 @@ MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");
 MODULE_SOFTDEP("pre: cmac");
 MODULE_SOFTDEP("pre: sha256");
-MODULE_SOFTDEP("pre: sha512");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
 MODULE_SOFTDEP("pre: gcm");


