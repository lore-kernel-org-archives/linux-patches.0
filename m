Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BE82AE94;
	Thu, 23 May 2024 13:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470297; cv=none; b=Lx4Cs6VJWRn7FuEd6dA6DNFVkoLESYfY3Oi1k19rMemBGWv/qgrDWsWq/wIFulbh0HYy+M2W3fNxKfc6dPakawRLwPxJUCxwid3DNnW7lLzcafVsedJFV0yDcji6jFgBLvO2KMO4NTBSQhUMvjw9AizsUKAPKsONb2l26VjHAfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470297; c=relaxed/simple;
	bh=9Wewl6hkz2i23EI/shFjVXCt+PeBPa/8rOD7usPn1yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxwrF2IQGBFXNSJdPdkMKuxdeGQ6dQFQyl/b1wOBO1Kp1pMGcN72IJ3BFdABuhy6SU8q6tODCGIIBxPNsbExk8WnoonMrnnDc1Vqg+dUoqkhEJcBsACTSHbcg99dOFf0iSXLGSwa8sN1Igm4ksu2Nk/aMoEQ4W4tI7Shab8I85o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZatVEcGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZatVEcGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0CCC32781;
	Thu, 23 May 2024 13:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470297;
	bh=9Wewl6hkz2i23EI/shFjVXCt+PeBPa/8rOD7usPn1yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZatVEcGu7zxxN5lQTht8hDUXv3nyNCLlt+rU8d0VO0ujJVYZvmbW2t4LFZxByDNp7
	 BUqzZS+3mr2ovQgDm0Br+GGl8bY7MmshDwqjz1wRfnCnE4MXAJEa8ptGd0WZOPZq6W
	 G/dHXHdeG0pcs+7xQi64iG8ZvICacUPvu3zV+vAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH 5.15 12/23] net: tls: handle backlogging of crypto requests
Date: Thu, 23 May 2024 15:13:08 +0200
Message-ID: <20240523130328.418565055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit 8590541473188741055d27b955db0777569438e3 upstream.

Since we're setting the CRYPTO_TFM_REQ_MAY_BACKLOG flag on our
requests to the crypto API, crypto_aead_{encrypt,decrypt} can return
 -EBUSY instead of -EINPROGRESS in valid situations. For example, when
the cryptd queue for AESNI is full (easy to trigger with an
artificially low cryptd.cryptd_max_cpu_qlen), requests will be enqueued
to the backlog but still processed. In that case, the async callback
will also be called twice: first with err == -EINPROGRESS, which it
seems we can just ignore, then with err == 0.

Compared to Sabrina's original patch this version uses the new
tls_*crypt_async_wait() helpers and converts the EBUSY to
EINPROGRESS to avoid having to modify all the error handling
paths. The handling is identical.

Fixes: a54667f6728c ("tls: Add support for encryption using async offload accelerator")
Fixes: 94524d8fc965 ("net/tls: Add support for async decryption of tls records")
Co-developed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/netdev/9681d1febfec295449a62300938ed2ae66983f28.1694018970.git.sd@queasysnail.net/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[v5.15: fixed contextual merge-conflicts in tls_decrypt_done and tls_encrypt_done]
Cc: <stable@vger.kernel.org> # 5.15
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -175,6 +175,17 @@ static void tls_decrypt_done(struct cryp
 	struct sk_buff *skb;
 	unsigned int pages;
 
+	/* If requests get too backlogged crypto API returns -EBUSY and calls
+	 * ->complete(-EINPROGRESS) immediately followed by ->complete(0)
+	 * to make waiting for backlog to flush with crypto_wait_req() easier.
+	 * First wait converts -EBUSY -> -EINPROGRESS, and the second one
+	 * -EINPROGRESS -> 0.
+	 * We have a single struct crypto_async_request per direction, this
+	 * scheme doesn't help us, so just ignore the first ->complete().
+	 */
+	if (err == -EINPROGRESS)
+		return;
+
 	skb = (struct sk_buff *)req->data;
 	tls_ctx = tls_get_ctx(skb->sk);
 	ctx = tls_sw_ctx_rx(tls_ctx);
@@ -273,6 +284,10 @@ static int tls_do_decryption(struct sock
 	}
 
 	ret = crypto_aead_decrypt(aead_req);
+	if (ret == -EBUSY) {
+		ret = tls_decrypt_async_wait(ctx);
+		ret = ret ?: -EINPROGRESS;
+	}
 	if (ret == -EINPROGRESS) {
 		if (darg->async)
 			return 0;
@@ -455,6 +470,9 @@ static void tls_encrypt_done(struct cryp
 	struct tls_rec *rec;
 	bool ready = false;
 
+	if (err == -EINPROGRESS) /* see the comment in tls_decrypt_done() */
+		return;
+
 	rec = container_of(aead_req, struct tls_rec, aead_req);
 	msg_en = &rec->msg_encrypted;
 
@@ -551,6 +569,10 @@ static int tls_do_encryption(struct sock
 	atomic_inc(&ctx->encrypt_pending);
 
 	rc = crypto_aead_encrypt(aead_req);
+	if (rc == -EBUSY) {
+		rc = tls_encrypt_async_wait(ctx);
+		rc = rc ?: -EINPROGRESS;
+	}
 	if (!rc || rc != -EINPROGRESS) {
 		atomic_dec(&ctx->encrypt_pending);
 		sge->offset -= prot->prepend_size;


