Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DE824DCF6;
	Mon, 13 Apr 2026 16:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096627; cv=none; b=KupaC70eWvnJPMelxgvg4SAPduC7i1RCogvA4sM7gg1WUc/wMZTRtCSfXYLkzmR7FdBfy7R+dEZH28GwKyWzsCO6Ch+nXTzSf6OLGvJpYMTfQwenHrh4c35QcZv7B/UkguJJh1s6S9Pr8LCEJSJ7dE54/eg27VRhHKfc1jFuS8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096627; c=relaxed/simple;
	bh=YY1Wi4wp7iMyReXOwungvEorTwXclSAX0Bwr3cVxMFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKCqtGtRyt0PJzmkqajuv5xsD1aymYnvorqCn/TXiFMI9+ICOjAJlTr+RP9RCNwX4XIZJ3QTd0yjcrUa8wjeJA8y26d5yz80Bhk7fosbNMzbBN5XjoPaOJwkq+m4z7pVWeQECidL+1vL/GaqW/DgR3alhCyQeMQt68R2YUHElyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJJXrd94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJJXrd94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BDEC2BCB7;
	Mon, 13 Apr 2026 16:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096627;
	bh=YY1Wi4wp7iMyReXOwungvEorTwXclSAX0Bwr3cVxMFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJJXrd945643tMXUHI8NEXKda1eykVbCEPXV5ENtXN9ioVHyZ0RtJaZze/wHSwcPY
	 rinpuHxEPF4juuhSXooHbND98M+wBN9I3ekwdnAm8SZ3IbhIY7q2PP06RPGYsUFwrY
	 B73mE/bMKvcBBLoXvkuGY1Sg71sGPK7BoZu2KO7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 77/83] rxrpc: Fix missing error checks for rxkad encryption/decryption failure
Date: Mon, 13 Apr 2026 18:00:45 +0200
Message-ID: <20260413155733.870452686@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

commit f93af41b9f5f798823d0d0fb8765c2a936d76270 upstream.

Add error checking for failure of crypto_skcipher_en/decrypt() to various
rxkad function as the crypto functions can fail with ENOMEM at least.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Closes: https://sashiko.dev/#/patchset/20260401105614.1696001-10-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-17-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxkad.c |   57 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 19 deletions(-)

--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -197,6 +197,7 @@ static int rxkad_prime_packet_security(s
 	struct rxrpc_crypt iv;
 	__be32 *tmpbuf;
 	size_t tmpsize = 4 * sizeof(__be32);
+	int ret;
 
 	_enter("");
 
@@ -225,13 +226,13 @@ static int rxkad_prime_packet_security(s
 	skcipher_request_set_sync_tfm(req, ci);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, tmpsize, iv.x);
-	crypto_skcipher_encrypt(req);
+	ret = crypto_skcipher_encrypt(req);
 	skcipher_request_free(req);
 
 	memcpy(&conn->rxkad.csum_iv, tmpbuf + 2, sizeof(conn->rxkad.csum_iv));
 	kfree(tmpbuf);
-	_leave(" = 0");
-	return 0;
+	_leave(" = %d", ret);
+	return ret;
 }
 
 /*
@@ -264,6 +265,7 @@ static int rxkad_secure_packet_auth(cons
 	struct scatterlist sg;
 	size_t pad;
 	u16 check;
+	int ret;
 
 	_enter("");
 
@@ -286,11 +288,11 @@ static int rxkad_secure_packet_auth(cons
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
-	crypto_skcipher_encrypt(req);
+	ret = crypto_skcipher_encrypt(req);
 	skcipher_request_zero(req);
 
-	_leave(" = 0");
-	return 0;
+	_leave(" = %d", ret);
+	return ret;
 }
 
 /*
@@ -345,7 +347,7 @@ static int rxkad_secure_packet(struct rx
 	union {
 		__be32 buf[2];
 	} crypto __aligned(8);
-	u32 x, y;
+	u32 x, y = 0;
 	int ret;
 
 	_enter("{%d{%x}},{#%u},%u,",
@@ -376,8 +378,10 @@ static int rxkad_secure_packet(struct rx
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
-	crypto_skcipher_encrypt(req);
+	ret = crypto_skcipher_encrypt(req);
 	skcipher_request_zero(req);
+	if (ret < 0)
+		goto out;
 
 	y = ntohl(crypto.buf[1]);
 	y = (y >> 16) & 0xffff;
@@ -413,6 +417,7 @@ static int rxkad_secure_packet(struct rx
 		memset(p + txb->pkt_len, 0, gap);
 	}
 
+out:
 	skcipher_request_free(req);
 	_leave(" = %d [set %x]", ret, y);
 	return ret;
@@ -453,8 +458,10 @@ static int rxkad_verify_packet_1(struct
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, 8, iv.x);
-	crypto_skcipher_decrypt(req);
+	ret = crypto_skcipher_decrypt(req);
 	skcipher_request_zero(req);
+	if (ret < 0)
+		return ret;
 
 	/* Extract the decrypted packet length */
 	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0)
@@ -531,10 +538,14 @@ static int rxkad_verify_packet_2(struct
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, sp->len, iv.x);
-	crypto_skcipher_decrypt(req);
+	ret = crypto_skcipher_decrypt(req);
 	skcipher_request_zero(req);
 	if (sg != _sg)
 		kfree(sg);
+	if (ret < 0) {
+		WARN_ON_ONCE(ret != -ENOMEM);
+		return ret;
+	}
 
 	/* Extract the decrypted packet length */
 	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0)
@@ -602,8 +613,10 @@ static int rxkad_verify_packet(struct rx
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
-	crypto_skcipher_encrypt(req);
+	ret = crypto_skcipher_encrypt(req);
 	skcipher_request_zero(req);
+	if (ret < 0)
+		goto out;
 
 	y = ntohl(crypto.buf[1]);
 	cksum = (y >> 16) & 0xffff;
@@ -1077,21 +1090,23 @@ static int rxkad_decrypt_ticket(struct r
 /*
  * decrypt the response packet
  */
-static void rxkad_decrypt_response(struct rxrpc_connection *conn,
-				   struct rxkad_response *resp,
-				   const struct rxrpc_crypt *session_key)
+static int rxkad_decrypt_response(struct rxrpc_connection *conn,
+				  struct rxkad_response *resp,
+				  const struct rxrpc_crypt *session_key)
 {
 	struct skcipher_request *req = rxkad_ci_req;
 	struct scatterlist sg[1];
 	struct rxrpc_crypt iv;
+	int ret;
 
 	_enter(",,%08x%08x",
 	       ntohl(session_key->n[0]), ntohl(session_key->n[1]));
 
 	mutex_lock(&rxkad_ci_mutex);
-	if (crypto_sync_skcipher_setkey(rxkad_ci, session_key->x,
-					sizeof(*session_key)) < 0)
-		BUG();
+	ret = crypto_sync_skcipher_setkey(rxkad_ci, session_key->x,
+					  sizeof(*session_key));
+	if (ret < 0)
+		goto unlock;
 
 	memcpy(&iv, session_key, sizeof(iv));
 
@@ -1100,12 +1115,14 @@ static void rxkad_decrypt_response(struc
 	skcipher_request_set_sync_tfm(req, rxkad_ci);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, sizeof(resp->encrypted), iv.x);
-	crypto_skcipher_decrypt(req);
+	ret = crypto_skcipher_decrypt(req);
 	skcipher_request_zero(req);
 
+unlock:
 	mutex_unlock(&rxkad_ci_mutex);
 
 	_leave("");
+	return ret;
 }
 
 /*
@@ -1198,7 +1215,9 @@ static int rxkad_verify_response(struct
 
 	/* use the session key from inside the ticket to decrypt the
 	 * response */
-	rxkad_decrypt_response(conn, response, &session_key);
+	ret = rxkad_decrypt_response(conn, response, &session_key);
+	if (ret < 0)
+		goto temporary_error_free_ticket;
 
 	if (ntohl(response->encrypted.epoch) != conn->proto.epoch ||
 	    ntohl(response->encrypted.cid) != conn->proto.cid ||


