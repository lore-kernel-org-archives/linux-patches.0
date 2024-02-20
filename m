Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ECA151CE1;
	Tue, 20 Feb 2024 21:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464519; cv=none; b=pBFWmgnk+NVt181QykUTjo8ZdhHZN9CPx3czusuosHWhlBXOgQw3uSLxcSXNBZCJ6WxbO6PzzlfSI9GMLsxNIdC7plG/vfnd0SPtZuHaum/AmDtejW44WaU8FcVV6GWu+jgtzCIkgMT/+TW4/Y1csRUGxboNkqO6b71voO3OtV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464519; c=relaxed/simple;
	bh=jbLuwnkkQX2+3Po7WlUCDtomTvV1xGmQWASflhqmoDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNJX2rt53ZDIjkua0k549gNhOQlPCVzztFKiopjBxJxtUVy4vSSz0KQb6N/Em7p7acLok93vtj59ZQ0RFWVsqBJWVzXYsK0w3yRpvcBJoawgozbzanxDImigaBDIIw12gWupla2S1Vo5LnvJtqS8ZM7SZ+rkQb8Ny3MkJid2zEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoVabUBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoVabUBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BE0C433F1;
	Tue, 20 Feb 2024 21:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464519;
	bh=jbLuwnkkQX2+3Po7WlUCDtomTvV1xGmQWASflhqmoDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoVabUBIihN2kZGBhAw5sxoyDJe+RReON+LuSTEvxe5XC8TG7xYRA8yLNLIfiNFB+
	 KsTXbJOad+tNhzh8qreBPfX/CChR9FwcjSKC4P9vO60mRg7aE2QLziaicMnz+rWNqC
	 nTkZhPFrjtlIqAYROR3vRAEgYHypOGydv5+++SZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 050/309] net: tls: handle backlogging of crypto requests
Date: Tue, 20 Feb 2024 21:53:29 +0100
Message-ID: <20240220205634.758542829@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8590541473188741055d27b955db0777569438e3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9374a61cef00..63bef5666e36 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -196,6 +196,17 @@ static void tls_decrypt_done(void *data, int err)
 	struct sock *sk;
 	int aead_size;
 
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
 	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(aead);
 	aead_size = ALIGN(aead_size, __alignof__(*dctx));
 	dctx = (void *)((u8 *)aead_req + aead_size);
@@ -269,6 +280,10 @@ static int tls_do_decryption(struct sock *sk,
 	}
 
 	ret = crypto_aead_decrypt(aead_req);
+	if (ret == -EBUSY) {
+		ret = tls_decrypt_async_wait(ctx);
+		ret = ret ?: -EINPROGRESS;
+	}
 	if (ret == -EINPROGRESS) {
 		if (darg->async)
 			return 0;
@@ -449,6 +464,9 @@ static void tls_encrypt_done(void *data, int err)
 	struct sk_msg *msg_en;
 	struct sock *sk;
 
+	if (err == -EINPROGRESS) /* see the comment in tls_decrypt_done() */
+		return;
+
 	msg_en = &rec->msg_encrypted;
 
 	sk = rec->sk;
@@ -553,6 +571,10 @@ static int tls_do_encryption(struct sock *sk,
 	atomic_inc(&ctx->encrypt_pending);
 
 	rc = crypto_aead_encrypt(aead_req);
+	if (rc == -EBUSY) {
+		rc = tls_encrypt_async_wait(ctx);
+		rc = rc ?: -EINPROGRESS;
+	}
 	if (!rc || rc != -EINPROGRESS) {
 		atomic_dec(&ctx->encrypt_pending);
 		sge->offset -= prot->prepend_size;
-- 
2.43.0



