Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623218;
	b=u0KH8+SybJAHsFfl14KWKfRv64ELRSYRCj/QWlusOVCeHk+6yGioxuoaiAw0oWasQNwR
	 o7hs2nv4OjqixibGDn/prO6SdzGapD5traF8wklbH6o46Ukq029bRkBjccPBNgwxuDJO2
	 l84XLp5Fa12XiUeduqVf6CF43OKsGkJ6h2Dvm2Mff/e10Hl3gX101x1qp7i+3/IfA2OpU
	 IZ2V6s9P1pilfEfAEUCSi4qznYO4qm84cwp06rndLLOBqL7VSx7oi02sJdzihnlM5es6x
	 wE/dqMBG25juzpQud/UH92eI6hmKygBAqXSr/YHqcdT3ilqD8ISpFBfLceAhv7NgtLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7wbIO4pNXkfAlJYP/i+gEayjEEYI1QAimfuICIi+ZEA=;
	b=IwTU9os1XH2ZwD7WQok7Hl6keoWHhISMKopb+DsFOWxX7e9pcMiNKL9p1ua9pyHAeuae
	 q9I57l3YDbzk0ollPACqAtBm33Pz1ESNrkp7TKIDHYW9x8nHxwxW/AMr5p6JnKVR1c1iD
	 43BoJ7ZVbJaRX+hVGeCEdXFE10wFPotRQnov/ukzZDTvXvWA46SR3mOk+y7D3ijlpVVH4
	 oCDwBgrzwpAbhdwJ9UOOIlGmatwlHiRSRNjgz5r9MSzoSTE2BhE/ikcrl6Anpluei7QIv
	 I+AHVyGizFJtnnyZA+Cmxn9dd7Qzl2NLDfcny5ciAl0NSaiVc8TAcgDTCr2wNb/2coQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjY0OqAU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4958606A31E;
	Wed, 25 Nov 2026 16:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjY0OqAU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD071F000C6;
	Wed, 25 Nov 2026 16:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623217;
	bh=7wbIO4pNXkfAlJYP/i+gEayjEEYI1QAimfuICIi+ZEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjY0OqAU5Cvz1AOT+Izokoahg4OUBKK0TeZHh53iwcW3n0t6y3D7Sy4NKUIR8QVcL
	 Y5eUftNFAT6QVNHN5LaFlVveeH2wrWI2LpltCN6I31dH6VPESdW3fcmfhWdNcFNw0L
	 G16UQZX6lCvRj5Am58cojfH64C40T5WEDcA82/Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 743/990] crypto: essiv - fix use-after-free in AEAD path
Date: Wed, 25 Nov 2026 15:35:10 +0100
Message-ID: <20261125143839.467292093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


