Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4906C3A961B;
	Fri, 15 May 2026 16:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860898; cv=none; b=hMnC6FvHK9y6JGpV2has/0WpdD5ZUuO3iIrRvuwwInarrF+mPBGlWOoefPjH946ptYyp6EFlL2txRKyPHf+IPqO1671PT/6EkFTbw/Rp1vc/17QkP+tQoP1uIeoA9CQU/HcSgImq1/sZ8UBYJrrV9QqGvo5qSB3IJXfW7uRZDlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860898; c=relaxed/simple;
	bh=0BnkGp5QX1XfhVk5YNfYO4ezroS6MoyfF2+mEXM9E1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaqLEBrrT2N3rihreS6Dcgux0/zn701kYEdQTGNCVamBBqldPfhYQjhFFhBNZa67uQrLUsvfd2e34vIm81pI0jRL3KQRh2xHG5aC237ZH4baY3rVGGJl4xKgaB+wKiSv9tJ40gahWcue3HLspBRjburUkXsZ4IFAT7Wugcu3x+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riyqAPQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riyqAPQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07634C2BCB0;
	Fri, 15 May 2026 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860898;
	bh=0BnkGp5QX1XfhVk5YNfYO4ezroS6MoyfF2+mEXM9E1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=riyqAPQ3PPHJ1jbgtHGQkPhaah1aMXvPkyI+x5bfb58ZNfyyGxDKH9WQ5qO/nyJXc
	 DsLORpHze+ZNIWiw7AJQSM6yX+Ep15oiRZK+1tF6zl5t0ddZECcjJYFzrq92YtLLKk
	 15fEDHsptoOX50ZojcjyeBStH8BDspIfUrkz84F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 122/474] crypto: atmel-ecc - Release client on allocation failure
Date: Fri, 15 May 2026 17:43:51 +0200
Message-ID: <20260515154717.676175812@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 095d50008d55d13f8fcf1bbeb7c6eba51779bc85 upstream.

Call atmel_ecc_i2c_client_free() to release the I2C client reserved by
atmel_ecc_i2c_client_alloc() when crypto_alloc_kpp() fails. Otherwise
->tfm_count will be out of sync.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-ecc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -261,6 +261,7 @@ static int atmel_ecdh_init_tfm(struct cr
 	if (IS_ERR(fallback)) {
 		dev_err(&ctx->client->dev, "Failed to allocate transformation for '%s': %ld\n",
 			alg, PTR_ERR(fallback));
+		atmel_ecc_i2c_client_free(ctx->client);
 		return PTR_ERR(fallback);
 	}
 


