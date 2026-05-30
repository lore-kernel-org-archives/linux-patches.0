Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC363349CCF;
	Sat, 30 May 2026 17:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163419; cv=none; b=D4ZaElD1Lzq36Xh2tW2OqVMCcE5k246r/w/HKLorYK81IyCSxl5X1FBHR9goeLgByk7NF8FzVB6+giDR2X/sjB2lNMFJTd4SpK/qAqQWFhoPdlbF1n1ocU5EoL+laNfe6Zo4oor4Huvpq9yxZHPOue8rX1pQ4G23WyzP4YUW2eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163419; c=relaxed/simple;
	bh=pcb9iLU7gXPAx/LY9FJDMSeMl1P56zCuOJioGmIx96I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qH5T1nmd9uak2S4NkvroPgo0YxJlaQLv83KWtshgMQUPa1yAKZ7qtKfbuP7qBDbyR1qfly2ViWhSfkoB/nhllWU4yA8w49MKETbsPJ3vuOHQiHnabAx0anvC9GjyYB1nWl6BDDJhmsD5RcD2oKfubmz+axl0uSTGyoFhhBZpULQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnOWx7mp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnOWx7mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBB41F00893;
	Sat, 30 May 2026 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163418;
	bh=s4hl4liI36J1mN6jk6/Pr62FeOx92aTXSZ2gvMg05R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnOWx7mpVz25kb7xfA5sdG9p/aBz/fHJeXsbV872DvtrwS7rhmbjXZ+ufbsgTtYG+
	 FnTGp6dEXWGBBe049i4PWie+GnZfA42L4cbjUsGQ06H+HJSVbjC5NzAhmyJ70Evlv3
	 SRHs3bgzqddD3OBzAk6eyESQUN58RuUzp9I4kzW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 252/776] crypto: atmel-ecc - Release client on allocation failure
Date: Sat, 30 May 2026 17:59:26 +0200
Message-ID: <20260530160247.046709942@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


