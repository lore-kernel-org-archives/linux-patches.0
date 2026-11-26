Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705461;
	b=4ef5++H35eexDGGylUqMMUqKKF2SMXPLLYdV4zgGUTXt4pPG5bMWPV2Ro0j2sOEO8TFZ
	 LdPK5c84bTHFxZxKHCxEGFiER5cJYtVPQDlxcLLwV2WziJjfRhpOW8UbzqHaCy9/+jwiW
	 Z7l2Ag2lUCroG3Yq7Facf7hD37/77GNMUe/XY14asbiVqR0mPDP5cnjun1Ci6lUZOJm3o
	 6bThVSXzdnOBkIiCUkmJ1xaR5DDBH8xRmlF0Z7zj3nrjEwjzjmD8Utx4tNKhrDnykyBv3
	 20ylgp7jJ6qWkAriGhwVR7QLpCUTyswU1I9QYe6gaP4bapnUCT9TXp5i8sgwVzU1QkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=buTkBI0BsQgyU2kXHSIhlHleEEW0p2bsVP27cgWdjbU=;
	b=DVXJ6KsrasbJa8O9ap6mlw4wQ6AsN2ckN2/XEnXDiaHl21HvJTEVmuXexXAfYE1nGbH0
	 a/ZpZbQG3se6GolQnAjkRAncHnYsjmJfuRdE3cfcaoGosujYV5pT0K38Pwldua01WhrEu
	 Dx7I2MYljFr9nHgIS2CghJIMevyXIhvHWMdbC3Shf32SZqTBKfcj1Xsp9KDyp1OZ7fRCW
	 5qxrruZVb/abPl4eZiXB0YyYFEj4trilBTHE32+A/Bcwg7u8DHft5YMjskAS29u0JrxMv
	 QdzpoZQz08W31OD41u72FMSl++g6aaJ0+ORwmlYJsgbyMyxKJ/WbGlLP0+vzpgR2FyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DZ/NmND0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9181A606A31E;
	Thu, 26 Nov 2026 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZ/NmND0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFF01F000C6;
	Thu, 26 Nov 2026 15:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705461;
	bh=buTkBI0BsQgyU2kXHSIhlHleEEW0p2bsVP27cgWdjbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZ/NmND05zFAIX9CGDRmmig4OcjYGor4bcWk7+kDF8pYKIFwspJ9lo56dXpizE59G
	 au6FDngbDCDzmAvT5IoHyjUTa8dbKvNWNxWr8MGzY9C2j5UEcNuoFx5Nk5hj2HFuHV
	 Y120Z6CZErCIUUwMn0xtLAAK2CAIg9VZ8jfJotJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 205/319] crypto: essiv - fix use-after-free in AEAD path
Date: Thu, 26 Nov 2026 15:39:33 +0100
Message-ID: <20261126144011.372352418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


