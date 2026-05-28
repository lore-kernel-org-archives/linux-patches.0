Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0891432AAD6;
	Thu, 28 May 2026 20:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000328; cv=none; b=IPey6xD8B9g43R5rAjmBPeAiJQlgEfxdzKLyAzhUfgVPTcK91JsMi2zX25KsqKRymkjcMyUz5W6cJICaN1cTVtUbxhbGNRUUAErEgMAJXggl+YXpNU3d/8v2/gQTK5T5JKez7V/Z4n3FTMcvxRcTEpknTyJKmQwp37t58nq63oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000328; c=relaxed/simple;
	bh=B410Jkjs+G1CJ4MkutK17ankQVCVVIuZS3B73vjO94E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQMFIDvW5QwDnFW5+IgYUlxCCemldHoGfrECza92X2god+fhrZ4GSS5dUo9pfmaU/bDWQNTg0OnxsinUxu5G+mI5uQ5WCtM+C/RlPcrfr3gyAc3VVDiKXU1vLvYWEyrw3eDtcwg0qi99xep6LFVM83JZMQT6vF88S4A0+FH6CPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMYkD2uj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMYkD2uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8131F000E9;
	Thu, 28 May 2026 20:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000326;
	bh=dO9KO26gGX4qOwp5LM6jHA2GMsQsedKSyEFfJITmdco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMYkD2ujzKnKoeDxN60iSVSM79mf8BkREQa3HqEhNEC0AOtL1NmtXKUCAjBu52RnX
	 Hbrp9LZWgvd4UKSJ+9hrHaU971S1ak0Rmd41EZZfB0yoLJ85EHPaNc1b4yP94zTvsF
	 FJGF6DthSskb5DSNUWUXvV1fBQjg9Av1l9Mdtz6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Simon Horman <horms@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	linux-afs@lists.infradead.org,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 357/377] crypto/krb5, rxrpc: Fix lack of pre-decrypt/pre-verify length checks
Date: Thu, 28 May 2026 21:49:55 +0200
Message-ID: <20260528194648.767572577@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2b50aceafe6606ea52ed42aadd1b4d44a188aade ]

Change the krb5 crypto library to provide facilities to precheck the length
of the message about to be decrypted or verified.

Fix AF_RXRPC to make use of this to validate DATA packets secured with
RxGK.

Fixes: 9d1d2b59341f ("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)")
Closes: https://sashiko.dev/#/patchset/20260511160753.607296-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Simon Horman <horms@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: linux-afs@lists.infradead.org
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
Link: https://patch.msgid.link/20260515230516.2718212-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/crypto/krb5.rst | 17 ++++++++---
 crypto/krb5/krb5_api.c        | 54 +++++++++++++++++++++++++++++++----
 include/crypto/krb5.h         |  9 ++++--
 include/trace/events/rxrpc.h  |  1 +
 net/rxrpc/rxgk.c              | 15 ++++++++--
 5 files changed, 81 insertions(+), 15 deletions(-)

diff --git a/Documentation/crypto/krb5.rst b/Documentation/crypto/krb5.rst
index beffa0133446d..f62e07ac68114 100644
--- a/Documentation/crypto/krb5.rst
+++ b/Documentation/crypto/krb5.rst
@@ -158,13 +158,22 @@ returned.
 When a message has been received, the location and size of the data with the
 message can be determined by calling::
 
-	void crypto_krb5_where_is_the_data(const struct krb5_enctype *krb5,
-					   enum krb5_crypto_mode mode,
-					   size_t *_offset, size_t *_len);
+	int crypto_krb5_where_is_the_data(const struct krb5_enctype *krb5,
+					  enum krb5_crypto_mode mode,
+					  size_t *_offset, size_t *_len);
 
 The caller provides the offset and length of the message to the function, which
 then alters those values to indicate the region containing the data (plus any
-padding).  It is up to the caller to determine how much padding there is.
+padding).  It is up to the caller to determine how much padding there is.  The
+function returns an error if the length is too small or if the mode is
+unsupported.  An additional function::
+
+	int crypto_krb5_check_data_len(const struct krb5_enctype *krb5,
+				       enum krb5_crypto_mode mode,
+				       size_t len, size_t min_content);
+
+is provided to just do a basic check that the decrypted/verified message would
+have a sufficient minimum payload.
 
 Preparation Functions
 ---------------------
diff --git a/crypto/krb5/krb5_api.c b/crypto/krb5/krb5_api.c
index 23026d4206c82..c7ea40f900a77 100644
--- a/crypto/krb5/krb5_api.c
+++ b/crypto/krb5/krb5_api.c
@@ -134,27 +134,69 @@ EXPORT_SYMBOL(crypto_krb5_how_much_data);
  * Find the offset and size of the data in a secure message so that this
  * information can be used in the metadata buffer which will get added to the
  * digest by crypto_krb5_verify_mic().
+ *
+ * Return: 0 if successful, -EBADMSG if the message is too short or -EINVAL if
+ * the mode is unsupported.
  */
-void crypto_krb5_where_is_the_data(const struct krb5_enctype *krb5,
-				   enum krb5_crypto_mode mode,
-				   size_t *_offset, size_t *_len)
+int crypto_krb5_where_is_the_data(const struct krb5_enctype *krb5,
+				  enum krb5_crypto_mode mode,
+				  size_t *_offset, size_t *_len)
 {
 	switch (mode) {
 	case KRB5_CHECKSUM_MODE:
+		if (*_len < krb5->cksum_len)
+			return -EBADMSG;
 		*_offset += krb5->cksum_len;
 		*_len -= krb5->cksum_len;
-		return;
+		return 0;
 	case KRB5_ENCRYPT_MODE:
+		if (*_len < krb5->conf_len + krb5->cksum_len)
+			return -EBADMSG;
 		*_offset += krb5->conf_len;
 		*_len -= krb5->conf_len + krb5->cksum_len;
-		return;
+		return 0;
 	default:
 		WARN_ON_ONCE(1);
-		return;
+		return -EINVAL;
 	}
 }
 EXPORT_SYMBOL(crypto_krb5_where_is_the_data);
 
+/**
+ * crypto_krb5_check_data_len - Check a message is big enough
+ * @krb5: The encoding to use.
+ * @mode: Mode of operation.
+ * @len: The length of the secure blob.
+ * @min_content: Minimum length of the content inside the blob.
+ *
+ * Check that a message is large enough to hold whatever bits the encryption
+ * type wants to glue on (nonce, checksum) plus a minimum amount of content.
+ *
+ * Return: 0 if successful, -EBADMSG if the message is too short or -EINVAL if
+ * the mode is unsupported.
+ */
+int crypto_krb5_check_data_len(const struct krb5_enctype *krb5,
+			       enum krb5_crypto_mode mode,
+			       size_t len, size_t min_content)
+{
+	switch (mode) {
+	case KRB5_CHECKSUM_MODE:
+		if (len < krb5->cksum_len ||
+		    len - krb5->cksum_len < min_content)
+			return -EBADMSG;
+		return 0;
+	case KRB5_ENCRYPT_MODE:
+		if (len < krb5->conf_len + krb5->cksum_len ||
+		    len - (krb5->conf_len + krb5->cksum_len) < min_content)
+			return -EBADMSG;
+		return 0;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL(crypto_krb5_check_data_len);
+
 /*
  * Prepare the encryption with derived key data.
  */
diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
index 71dd38f59be1d..aac3ecf88467c 100644
--- a/include/crypto/krb5.h
+++ b/include/crypto/krb5.h
@@ -121,9 +121,12 @@ size_t crypto_krb5_how_much_buffer(const struct krb5_enctype *krb5,
 size_t crypto_krb5_how_much_data(const struct krb5_enctype *krb5,
 				 enum krb5_crypto_mode mode,
 				 size_t *_buffer_size, size_t *_offset);
-void crypto_krb5_where_is_the_data(const struct krb5_enctype *krb5,
-				   enum krb5_crypto_mode mode,
-				   size_t *_offset, size_t *_len);
+int crypto_krb5_where_is_the_data(const struct krb5_enctype *krb5,
+				  enum krb5_crypto_mode mode,
+				  size_t *_offset, size_t *_len);
+int crypto_krb5_check_data_len(const struct krb5_enctype *krb5,
+			       enum krb5_crypto_mode mode,
+			       size_t len, size_t min_content);
 struct crypto_aead *crypto_krb5_prepare_encryption(const struct krb5_enctype *krb5,
 						   const struct krb5_buffer *TK,
 						   u32 usage, gfp_t gfp);
diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 573f2df3a2c99..704a10de66700 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -71,6 +71,7 @@
 	EM(rxkad_abort_resp_unknown_tkt,	"rxkad-resp-unknown-tkt") \
 	EM(rxkad_abort_resp_version,		"rxkad-resp-version")	\
 	/* RxGK security errors */					\
+	EM(rxgk_abort_1_short_header,		"rxgk1-short-hdr")	\
 	EM(rxgk_abort_1_verify_mic_eproto,	"rxgk1-vfy-mic-eproto")	\
 	EM(rxgk_abort_2_decrypt_eproto,		"rxgk2-dec-eproto")	\
 	EM(rxgk_abort_2_short_data,		"rxgk2-short-data")	\
diff --git a/net/rxrpc/rxgk.c b/net/rxrpc/rxgk.c
index c39f5066d8e86..04a761c79548a 100644
--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -480,8 +480,12 @@ static int rxgk_verify_packet_integrity(struct rxrpc_call *call,
 
 	_enter("");
 
-	crypto_krb5_where_is_the_data(gk->krb5, KRB5_CHECKSUM_MODE,
-				      &data_offset, &data_len);
+	if (crypto_krb5_where_is_the_data(gk->krb5, KRB5_CHECKSUM_MODE,
+					  &data_offset, &data_len) < 0) {
+		ret = rxrpc_abort_eproto(call, skb, RXGK_PACKETSHORT,
+					 rxgk_abort_1_short_header);
+		goto put_gk;
+	}
 
 	hdr = kzalloc(sizeof(*hdr), GFP_NOFS);
 	if (!hdr)
@@ -529,6 +533,13 @@ static int rxgk_verify_packet_encrypted(struct rxrpc_call *call,
 
 	_enter("");
 
+	if (crypto_krb5_check_data_len(gk->krb5, KRB5_ENCRYPT_MODE,
+				       len, sizeof(hdr)) < 0) {
+		ret = rxrpc_abort_eproto(call, skb, RXGK_PACKETSHORT,
+					 rxgk_abort_2_short_header);
+		goto error;
+	}
+
 	ret = rxgk_decrypt_skb(gk->krb5, gk->rx_enc, skb, &offset, &len, &ac);
 	if (ret < 0) {
 		if (ret != -ENOMEM)
-- 
2.53.0



