Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625876;
	b=1jydHQADHWgAuk6UJuF3t1wBn6gb+iOU/b3Oho+KWvYfo5cKI+yxneRUSh1ouQUfVspx
	 e+HpW6wx6VNHLNKnaiUb5bom5slRS9nhW0a1pJAeYIm/amP4yVkC19/wBNgUXuGGClXGs
	 3c//mXcr587+l6SKDaR7YhwlfIAEZgzU9y1dlo7ip/NSRRoLQkVO0sOxR2EjE95tmKl67
	 fpMYPXQ/NfbJR1IQrdVHNXUEnhmNtxG+rnNuN1QpYzhX06R62p2wKFz4A3bF1yOZ0eNwO
	 795LvlI8DL8wNxwthwoRtLsTPR8mODtygNjbX/UTlZcA1JPeKdUb+WbndT/0ZFM4Nfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=G+V/1yFjdxCYGDzj+fXepe4xoIXz+PPCxf+J0YckPtM=;
	b=Ug41xYfZc+X8ekRPQYc4T0hjmBSN9P8w+2QI/KW+RJQ7evHhn0SOAc6r+PdyCxejDqON
	 Iz/olCEJPApmD9PCpaZloWPizk9Asx8zKXcYdL1HsLN7F+bE2TO8mEf4Z19RXrblMuGOx
	 Bt0wHknPKr8sFZhLh6hec2uGSFq6nYzBfG1ah+d25+n/zbL5bM4bi8JCtbEdH/TOpx03G
	 FhDa66eO4bpiwrbb03hrSR/V5+LkbK3ZK5/TShOhOlTKg5Ealrf0J/a3kDmv3DXmfJi8Z
	 Hz3k9pw6ZF01tf9UkLB2LQGEZbfapvBOoXYx8JWa620EXM40dpQV1IL6VSPATlGXMlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0b0x2+Jo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81BB606A31E;
	Wed, 25 Nov 2026 16:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0b0x2+Jo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81361F000C0;
	Wed, 25 Nov 2026 16:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625876;
	bh=G+V/1yFjdxCYGDzj+fXepe4xoIXz+PPCxf+J0YckPtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0b0x2+Jo5yhumYBx3ky2zjeuRHxJt6xoDVyh+SDxR3ZYAFRQIPz/w5TPb4N6mqq0E
	 Xj1/kf8xqEn9XHywEcX/6w5kmECesysQPDOa/1E/CwCxfX7IwEvGzhFTbMMlbNCcbT
	 LIRE6IjqjyVesryKhcNyQA4KMK7WgBVJfcYbisyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 614/816] crypto: essiv - fix use-after-free in AEAD path
Date: Wed, 25 Nov 2026 15:36:02 +0100
Message-ID: <20261125143903.392304851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -250,7 +250,7 @@ static int essiv_aead_crypt(struct aead_
 	err = enc ? crypto_aead_encrypt(subreq) :
 		    crypto_aead_decrypt(subreq);
 
-	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
+	if (err != -EINPROGRESS && err != -EBUSY)
 		kfree(rctx->assoc);
 	return err;
 }


