Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704572;
	b=o8yI8r2AOcmGplcpFogKFOhDgzvgp6mNP+JGDFQpQ28SYHwB40SrwF8tEqp07GGrLDXF
	 LRZgRMh3St6tft/6hBIXnhU6L+AoU6ffFxpQsN1tsTtj08csu+hR5c7L2e4K1I83Xd5Mp
	 WrXQrAsA2kdwBTZFnMUVwuL4nMu6EiCXdI8N5SVvo3issTHxui4MTFj4v1UuqtiyHCiEi
	 1LF2BscCYDabWvOQSNJkXWPK9/yMXRIYewA1H9FutPGoJF+2EpbBQlqgAahS11lZ3x/Z0
	 MQOMkCJtRsUhQLZxUPq2wOZAmqNuEs+Qi0FD716cqu513Oz0WiIuVpsg/lbdI5J7/FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pHuIK+UHRjcgCJqfNu7baYxRf9XILCS2ln2CbAw3BUg=;
	b=akvGnv9NNINByQXEqtuLYKgiGKmz6guqD0L0d0nNmR8lnRxXkmj5C3qy7qeOTbnwbw/e
	 WcmmUjhDLZrtrP2H6o7ujVNzGZqIJ4fKMNVjHhJ94k04+/baxMSg1AbQNjLMiB+3imz28
	 h9rthwWCPitKEvC4LQnCBsU8qbpNdLyQeXjFojJ1AFviWPzATwbetHRHwyUVtcMIZjoFM
	 h1KciIj76Z5d0FSIYXQa43GBXyxxqVAMhgFVfZ52m23d/G2xcwugju0LfSz6zwX2AblFP
	 3SAEbHArL/JjBKR4ZW7PESXwK6jfKHfkE8RM7uLyNH37TXHppgNUMd+IaIRXBzQE2Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0LI2+xv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23ED606A31C;
	Thu, 26 Nov 2026 14:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0LI2+xv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F6C1F000D1;
	Thu, 26 Nov 2026 14:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704572;
	bh=pHuIK+UHRjcgCJqfNu7baYxRf9XILCS2ln2CbAw3BUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0LI2+xvZKcf+Nu5AXGMvIQ+NfQSbAd1VLVR4CU8sGvtx7Za7ihCQI3DMtnNIh4sv
	 0ER0uue037P0cyhy06G67OxpPh/sHXn7yfYtyTa+EDWwsUkWouiaWk4PR0SccxdG12
	 juO6FYlxikWOq3ED0IDVA2SbOTUZ3TK7KKmv9Vlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 170/265] crypto: essiv - fix use-after-free in AEAD path
Date: Thu, 26 Nov 2026 15:38:20 +0100
Message-ID: <20261126143617.058645577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit e9ce64dce975a14700e835003847415e29918474 upstream.

The request that ESSIV submits to its wrapped AEAD transform may
finish before crypto_aead_encrypt() or crypto_aead_decrypt() returns.
In case this happens, essiv_aead_done() calls aead_request_complete()
on the original ESSIV request, which can end up freeing the request
before essiv_aead_crypt() resumes, creating a UAF:

  BUG: KASAN: slab-use-after-free in essiv_aead_crypt+0x8e6/0x950
  Read of size 8 at addr ffff888102af1360 by task init/66

Check the return status before dereferencing rctx after submitting that
request. If the operation did not return -EINPROGRESS or -EBUSY, then
the request cannot have been freed yet.

Fixes: be1eb7f78aa8 ("crypto: essiv - create wrapper template for ESSIV generation")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/essiv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -249,7 +249,7 @@ static int essiv_aead_crypt(struct aead_
 	err = enc ? crypto_aead_encrypt(subreq) :
 		    crypto_aead_decrypt(subreq);
 
-	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
+	if (err != -EINPROGRESS && err != -EBUSY)
 		kfree(rctx->assoc);
 	return err;
 }


