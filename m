Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0A74D98E6;
	Tue, 13 Oct 2026 12:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893898; cv=none; b=TXyX2z/NUjyLPEGgmKxU+HbZ1C6HlXwjlzscRNpY2O80gDiBVUEqeP3/ylDiAmAEnjX2kJa+ZPulABP70XtwbqnEdyA23QzOTDDjUfPVEzNyhhhI/Q0AqNABfPe5VDbS1Tyul0vbwx4i/WxTjSnJk0jOdG66Sgktd/pcKn/Fy18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893898; c=relaxed/simple;
	bh=+67nfNZOZ39SS3L1vU89M0L7pLJudb4ZfA0mGEZfRWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0zWgIbJywkBQjhmGQBfT6iposM8dECQkXLqCNlgttolKnzjIPMetaSPOPFgyaJmJkhamXYMgBUjxjw+UELlUiECsz88JgLwb2rvI+smcZdrZGm8ZfTij/cyC0DbZmwdHIRd9IXkuqpnfq1WJMjdsKM47pQEreC9ZdfrJHVFzk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1v1cXEkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1v1cXEkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683D81F000FF;
	Tue, 13 Oct 2026 12:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893897;
	bh=yzGXiEWep6gr4vDv8TyMUgTZaIuXf64hj4yMw6O3yoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1v1cXEkDmTdH+dlnuGrHHZ0LY2lkJMtwdPi2/H8Xr6Js7lQ6Xmy5xoAqq66Wq8VZD
	 UhHPCK9MtUoT5kutubGqW1qitVHG0UpZyQxvt9NMoN3MlJ8aCqXgTlKmYtr4PNry8b
	 7dXZUeHERrSB/lL8xbCGOP7LXlG+4bks64g92y78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 378/621] SUNRPC: Switch wrap token decryption to crypto/krb5
Date: Tue, 13 Oct 2026 13:36:13 +0200
Message-ID: <20261013112929.816601230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 598de25deaffb80758ad8bdce5b4bacbbea59582 ]

Replace the per-enctype .decrypt callbacks (gss_krb5_aes_decrypt
and krb5_etm_decrypt) with a single gss_krb5_aead_decrypt()
wrapper that delegates to crypto_krb5_decrypt().

The new wrapper builds a scatterlist covering the secured
region (confounder through checksum), passes it to the AEAD
decrypt operation, and derives the confounder and checksum
lengths from the data offset and length that
crypto_krb5_decrypt() reports. The caller's token header
verification and buffer adjustment logic is unchanged.

Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: b94f6719dcd9 ("SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_crypto.c | 53 +++++++++++++++++++++++++++
 net/sunrpc/auth_gss/gss_krb5_mech.c   |  8 ++--
 2 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index 85425d4a28c23..31c2c86b873fc 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -1050,3 +1050,56 @@ gss_krb5_aead_encrypt(struct krb5_ctx *kctx, u32 offset,
 
 	return GSS_S_COMPLETE;
 }
+
+/**
+ * gss_krb5_aead_decrypt - Decrypt a wrap token using crypto/krb5
+ * @kctx: Kerberos context
+ * @offset: byte offset of the GSS token header in @buf
+ * @len: total length of the GSS token
+ * @buf: ciphertext buffer, decrypted in-place
+ * @headskip: OUT: confounder length, in octets
+ * @tailskip: OUT: checksum length, in octets
+ *
+ * Return values:
+ *   %GSS_S_COMPLETE: Decryption and integrity verification succeeded
+ *   %GSS_S_BAD_SIG: Integrity checksum did not match
+ *   %GSS_S_DEFECTIVE_TOKEN: Token is malformed or truncated
+ *   %GSS_S_FAILURE: Decryption failed
+ */
+u32
+gss_krb5_aead_decrypt(struct krb5_ctx *kctx, u32 offset, u32 len,
+		      struct xdr_buf *buf, u32 *headskip, u32 *tailskip)
+{
+	const struct krb5_enctype *krb5 = kctx->krb5e;
+	struct crypto_aead *aead = kctx->initiate ?
+		kctx->acceptor_enc_aead : kctx->initiator_enc_aead;
+	unsigned int sec_offset, sec_len;
+	size_t data_offset, data_len;
+	struct scatterlist sg[XDR_BUF_TO_SG_NENTS];
+	struct scatterlist *sg_overflow = NULL;
+	int nsg, ret;
+
+	/* Secured region starts after the GSS token header */
+	sec_offset = offset + GSS_KRB5_TOK_HDR_LEN;
+	if (len < sec_offset)
+		return GSS_S_DEFECTIVE_TOKEN;
+	sec_len = len - sec_offset;
+
+	nsg = xdr_buf_to_sg_alloc(buf, sec_offset, sec_len,
+				  sg, ARRAY_SIZE(sg),
+				  &sg_overflow, GFP_NOFS);
+	if (nsg < 0)
+		return GSS_S_FAILURE;
+
+	data_offset = 0;
+	data_len = sec_len;
+	ret = crypto_krb5_decrypt(krb5, aead, sg, nsg,
+				  &data_offset, &data_len);
+	kfree(sg_overflow);
+	if (ret < 0)
+		return gss_krb5_errno_to_status(ret);
+
+	*headskip = data_offset;
+	*tailskip = sec_len - data_offset - data_len;
+	return GSS_S_COMPLETE;
+}
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index cdc710962e629..8e61be0e8ec5b 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -44,7 +44,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 	  .cksum_name = "hmac(sha1)",
 	  .derive_key = krb5_derive_key_v2,
 	  .encrypt = gss_krb5_aead_encrypt,
-	  .decrypt = gss_krb5_aes_decrypt,
+	  .decrypt = gss_krb5_aead_decrypt,
 
 	  .get_mic = gss_krb5_get_mic_v2,
 	  .verify_mic = gss_krb5_verify_mic_v2,
@@ -73,7 +73,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 	  .cksum_name = "hmac(sha1)",
 	  .derive_key = krb5_derive_key_v2,
 	  .encrypt = gss_krb5_aead_encrypt,
-	  .decrypt = gss_krb5_aes_decrypt,
+	  .decrypt = gss_krb5_aead_decrypt,
 
 	  .get_mic = gss_krb5_get_mic_v2,
 	  .verify_mic = gss_krb5_verify_mic_v2,
@@ -167,7 +167,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 
 		.derive_key	= krb5_kdf_hmac_sha2,
 		.encrypt	= gss_krb5_aead_encrypt,
-		.decrypt	= krb5_etm_decrypt,
+		.decrypt	= gss_krb5_aead_decrypt,
 
 		.get_mic	= gss_krb5_get_mic_v2,
 		.verify_mic	= gss_krb5_verify_mic_v2,
@@ -193,7 +193,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 
 		.derive_key	= krb5_kdf_hmac_sha2,
 		.encrypt	= gss_krb5_aead_encrypt,
-		.decrypt	= krb5_etm_decrypt,
+		.decrypt	= gss_krb5_aead_decrypt,
 
 		.get_mic	= gss_krb5_get_mic_v2,
 		.verify_mic	= gss_krb5_verify_mic_v2,
-- 
2.53.0



