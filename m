Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619762;
	b=WMy1KFMkz3YSXcGE1Ts+XaXefR8pJe5dQoPCg/KO/WlUlCeDu4s/sBNNAC/iS9sr6l85
	 wZGshSiNJV7mKf0gZ1iMH+u/mdUXTCGtnESVcMX9vRBCshLfwnFI7uBj7sHXB2gE5JjcM
	 AEfcRfYcdeFbcui40acpNysuzZTusYLk5LsrmDX7EJUZUMebff2A2+InrcK675Tp46A2w
	 zfFL3/m8TbQiLVY6b60sOHarMsqKmROruNifeuSrT6CXtFXgvA5qjDhven/QotNuhIOpd
	 WuctkBoiPOdbmvGQdSWFXkttDxIubCTXDt8PIGPMfWPqWp2/VE16C6vTqqkWFY/ACuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=G0tK/CQ8TlfeA28Pn182l46szUIHBmaDfm1Em10rQbs=;
	b=QwHA1wNhIP+rCDjk2VJ9dfq2fvFRY73+NdBhzXm0YXne6Ruw/oTmp9yTtrUYqaAAxfQA
	 famtUSHvvuWeHYZyfXsQbUtB52pIgUhqgCuanuUkH64e8dayCDevrnzgVLTAr3F+l4J5P
	 FZLHS+/w3h+79av9merFce9AKmu4XBKNxa3tLxGvQFWeRc5ZyNxnbf+6WxG0pZlY061GV
	 6zMH7Hx9vtpdvcGuJc3Pi+mWt9wv4A1uOjT3mH2XCTtVE8AAoZ/hjq0tNfQY7MHgbnhgu
	 tBphqjLknYUcd8di3v2CNLOHSNRd35CA+Vr5zERzgajNx7I1rL70dYyo497abFxycsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1ZGV6zQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5064606A329;
	Wed, 25 Nov 2026 15:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1ZGV6zQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1609D1F000C6;
	Wed, 25 Nov 2026 15:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619762;
	bh=G0tK/CQ8TlfeA28Pn182l46szUIHBmaDfm1Em10rQbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1ZGV6zQrshZahZMrgQZNx/c2jUwVxlPVAbY13hcOuAuMuNHEYpnFirlPKGMRsRii
	 9E94yHnpj6WexAiPmQPvpAx6Ae0XURu6DiFf+KS2sd+6AawcSHPhcnWl9whmxsseSM
	 b5pRc+Y2dbQOJpA8ZjeX5n2OEL/EZLSHuXWGmXuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.3 0693/1005] crypto: essiv - fix use-after-free in AEAD path
Date: Wed, 25 Nov 2026 15:33:51 +0100
Message-ID: <20261125143837.987729617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


