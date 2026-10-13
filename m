Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07F74F4D1B;
	Tue, 13 Oct 2026 12:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893895; cv=none; b=aDpJPGcdxi+I8+DbakSEFlYmID1a8COzXboTicKeRAyUJ50Pr0ZKV7a9f3gnqy+JEOtaioi6hapRZk1PhyoGfsW9CwdoPR82hlPXx2fitYYq5O9w04pbMdHiUEhfPXTSEEp6pM0AAX5ZEe0esaIwJsMbxheYd1G2dzD+NfGjTbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893895; c=relaxed/simple;
	bh=ITmv8Jg1ZoGEzHos+UaiNjxIYGEC63PRt1ARuGcrs8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Clha/qWs1m7ReNj5E4tWxwPkMYFqsbAx4TfI2l5oZY7SNOdXzaAocpUtMtTaEEoWrsZ2ne3MTEMGqo7/gQLRMqcZh/GewQ2JIeduATtoIELcIbaBLfE71AC7GGjSpwsJlNR8V2YJcwHcfiuuhEWo/V0J5y7SW1Zi7zJFy7hBE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waD3xShT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waD3xShT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540D11F000FF;
	Tue, 13 Oct 2026 12:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893893;
	bh=qYOzhfovPMLUSazGWPETPFmsmATtbSqL1id0eyQ9kbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=waD3xShTL8dXTEDa+ufxoub+7zjoSPXR84xYjA7mkChab/X4GBNAUnzyzNvoguULF
	 tPpC7V2pGkePRuD5N/LnqqogIWrLUcc43Yg+wIWSCdP5+hLV+c26gcMoa6RpP5VNww
	 sngEw1gJ3EKhNl1Sa+7GaK4PA0N+i24GLxyuf9lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 377/621] SUNRPC: Switch wrap token encryption to crypto/krb5
Date: Tue, 13 Oct 2026 13:36:12 +0200
Message-ID: <20261013112929.793177775@linuxfoundation.org>
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

[ Upstream commit f1965a3bcb1dc9b3491f750abc0f30a595c3de9f ]

Replace the per-enctype .encrypt callbacks (gss_krb5_aes_encrypt and
krb5_etm_encrypt) with a single gss_krb5_aead_encrypt() wrapper that
delegates to crypto_krb5_encrypt().

The xdr_buf setup -- GSS header insertion, confounder space
allocation, and token header copy -- remains unchanged. The
difference is that the CBC-CTS encryption and HMAC computation are
now a single AEAD operation through the crypto/krb5 library. Both
the MtE construction (RFC 3962) and the EtM construction (RFC 8009)
are handled transparently by the AEAD transform.

The plaintext page data must be copied from the page cache pages to
the scratch output pages before building the scatterlist, since the
AEAD operates in-place rather than using separate input and output
scatterlists.

Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: b94f6719dcd9 ("SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_crypto.c   | 97 +++++++++++++++++++++++++
 net/sunrpc/auth_gss/gss_krb5_internal.h |  5 ++
 net/sunrpc/auth_gss/gss_krb5_mech.c     | 12 +--
 3 files changed, 108 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index 16dcf115de1ed..85425d4a28c23 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -953,3 +953,100 @@ krb5_etm_decrypt(struct krb5_ctx *kctx, u32 offset, u32 len,
 		ret = GSS_S_FAILURE;
 	return ret;
 }
+
+/**
+ * gss_krb5_aead_encrypt - Encrypt a wrap token using crypto/krb5
+ * @kctx: Kerberos context
+ * @offset: byte offset of the GSS token header in @buf
+ * @buf: OUT: send buffer
+ * @pages: plaintext payload pages (page cache data)
+ *
+ * The xdr_buf setup mirrors the original per-enctype encrypt
+ * functions, but the CBC-CTS encryption and HMAC are replaced
+ * by a single AEAD operation through the crypto/krb5 library.
+ *
+ * Return values:
+ *   %GSS_S_COMPLETE: Encryption successful
+ *   %GSS_S_FAILURE: Encryption failed
+ */
+u32
+gss_krb5_aead_encrypt(struct krb5_ctx *kctx, u32 offset,
+		      struct xdr_buf *buf, struct page **pages)
+{
+	const struct krb5_enctype *krb5 = kctx->krb5e;
+	struct crypto_aead *aead = kctx->initiate ?
+		kctx->initiator_enc_aead : kctx->acceptor_enc_aead;
+	unsigned int conflen = krb5->conf_len;
+	unsigned int cksum_len = krb5->cksum_len;
+	unsigned int sec_offset, sec_len, data_len;
+	struct scatterlist sg[XDR_BUF_TO_SG_NENTS];
+	struct scatterlist *sg_overflow = NULL;
+	ssize_t ret;
+	int nsg;
+
+	/* Insert space for the confounder */
+	if (xdr_extend_head(buf, offset + GSS_KRB5_TOK_HDR_LEN, conflen))
+		return GSS_S_FAILURE;
+
+	/* Ensure a tail segment exists */
+	if (buf->tail[0].iov_base == NULL) {
+		buf->tail[0].iov_base = buf->head[0].iov_base
+						+ buf->head[0].iov_len;
+		buf->tail[0].iov_len = 0;
+	}
+
+	/* Append a copy of the plaintext GSS token header (RFC 4121 Sec 4.2.4) */
+	memcpy(buf->tail[0].iov_base + buf->tail[0].iov_len,
+	       buf->head[0].iov_base + offset, GSS_KRB5_TOK_HDR_LEN);
+	buf->tail[0].iov_len += GSS_KRB5_TOK_HDR_LEN;
+	buf->len += GSS_KRB5_TOK_HDR_LEN;
+
+	/* Reserve space for the integrity checksum */
+	buf->tail[0].iov_len += cksum_len;
+	buf->len += cksum_len;
+
+	/*
+	 * The AEAD operates in-place, but on the client send path the
+	 * plaintext payload lives in page cache pages that must not be
+	 * modified.  Copy the payload into the scratch output pages
+	 * first.  On the server send path @pages and buf->pages are
+	 * the same array, and no copy is needed.
+	 *
+	 * Both arrays share buf->page_base, so the same index and
+	 * intra-page offset address corresponding data in each.
+	 */
+	if (pages != buf->pages) {
+		unsigned int poff = buf->page_base;
+		unsigned int plen = buf->page_len;
+		unsigned int i = poff >> PAGE_SHIFT;
+		unsigned int off = offset_in_page(poff);
+
+		while (plen) {
+			unsigned int n = min_t(unsigned int, plen,
+					       PAGE_SIZE - off);
+			memcpy_page(buf->pages[i], off, pages[i], off, n);
+			plen -= n;
+			i++;
+			off = 0;
+		}
+	}
+
+	/* Build scatterlist covering the secured region */
+	sec_offset = offset + GSS_KRB5_TOK_HDR_LEN;
+	sec_len = buf->len - sec_offset;
+	data_len = sec_len - conflen - cksum_len;
+
+	nsg = xdr_buf_to_sg_alloc(buf, sec_offset, sec_len,
+				  sg, ARRAY_SIZE(sg),
+				  &sg_overflow, GFP_NOFS);
+	if (nsg < 0)
+		return GSS_S_FAILURE;
+
+	ret = crypto_krb5_encrypt(krb5, aead, sg, nsg, sec_len,
+				  conflen, data_len, false);
+	kfree(sg_overflow);
+	if (ret < 0)
+		return GSS_S_FAILURE;
+
+	return GSS_S_COMPLETE;
+}
diff --git a/net/sunrpc/auth_gss/gss_krb5_internal.h b/net/sunrpc/auth_gss/gss_krb5_internal.h
index 33d41d972bd18..ce43e1be75779 100644
--- a/net/sunrpc/auth_gss/gss_krb5_internal.h
+++ b/net/sunrpc/auth_gss/gss_krb5_internal.h
@@ -186,6 +186,11 @@ u32 krb5_etm_decrypt(struct krb5_ctx *kctx, u32 offset, u32 len,
 
 u32 gss_krb5_errno_to_status(int err);
 
+u32 gss_krb5_aead_encrypt(struct krb5_ctx *kctx, u32 offset,
+			  struct xdr_buf *buf, struct page **pages);
+u32 gss_krb5_aead_decrypt(struct krb5_ctx *kctx, u32 offset, u32 len,
+			  struct xdr_buf *buf, u32 *headskip, u32 *tailskip);
+
 #if IS_ENABLED(CONFIG_KUNIT)
 void krb5_nfold(u32 inbits, const u8 *in, u32 outbits, u8 *out);
 const struct gss_krb5_enctype *gss_krb5_lookup_enctype(u32 etype);
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index cc75f7b193428..cdc710962e629 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -43,7 +43,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 	  .aux_cipher = "cbc(aes)",
 	  .cksum_name = "hmac(sha1)",
 	  .derive_key = krb5_derive_key_v2,
-	  .encrypt = gss_krb5_aes_encrypt,
+	  .encrypt = gss_krb5_aead_encrypt,
 	  .decrypt = gss_krb5_aes_decrypt,
 
 	  .get_mic = gss_krb5_get_mic_v2,
@@ -72,7 +72,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 	  .aux_cipher = "cbc(aes)",
 	  .cksum_name = "hmac(sha1)",
 	  .derive_key = krb5_derive_key_v2,
-	  .encrypt = gss_krb5_aes_encrypt,
+	  .encrypt = gss_krb5_aead_encrypt,
 	  .decrypt = gss_krb5_aes_decrypt,
 
 	  .get_mic = gss_krb5_get_mic_v2,
@@ -111,7 +111,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 		.Ki_length	= BITS2OCTETS(128),
 
 		.derive_key	= krb5_kdf_feedback_cmac,
-		.encrypt	= gss_krb5_aes_encrypt,
+		.encrypt	= gss_krb5_aead_encrypt,
 		.decrypt	= gss_krb5_aes_decrypt,
 
 		.get_mic	= gss_krb5_get_mic_v2,
@@ -137,7 +137,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 		.Ki_length	= BITS2OCTETS(256),
 
 		.derive_key	= krb5_kdf_feedback_cmac,
-		.encrypt	= gss_krb5_aes_encrypt,
+		.encrypt	= gss_krb5_aead_encrypt,
 		.decrypt	= gss_krb5_aes_decrypt,
 
 		.get_mic	= gss_krb5_get_mic_v2,
@@ -166,7 +166,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 		.Ki_length	= BITS2OCTETS(128),
 
 		.derive_key	= krb5_kdf_hmac_sha2,
-		.encrypt	= krb5_etm_encrypt,
+		.encrypt	= gss_krb5_aead_encrypt,
 		.decrypt	= krb5_etm_decrypt,
 
 		.get_mic	= gss_krb5_get_mic_v2,
@@ -192,7 +192,7 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 		.Ki_length	= BITS2OCTETS(192),
 
 		.derive_key	= krb5_kdf_hmac_sha2,
-		.encrypt	= krb5_etm_encrypt,
+		.encrypt	= gss_krb5_aead_encrypt,
 		.decrypt	= krb5_etm_decrypt,
 
 		.get_mic	= gss_krb5_get_mic_v2,
-- 
2.53.0



