Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EAF3A75B6;
	Mon,  4 May 2026 14:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903506; cv=none; b=ZUuMTwEtNFIpNUUmaO0Q4a0f/DY6y59gVJG4K66p91t7nyBk3nj6OBSMME64lGodakUbkLk1RwoCViLeEiwUpJQ7rrOaPgSrKrlOcxaJs6Mo/5niZ7+D2YYjvsMCawS4gD8JIVyyjirhIq8tKJUKkJOlwwZ+we4NS40WW4Epoos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903506; c=relaxed/simple;
	bh=mmfl0kD6PNuaHv8JvUzKQfO256/CIGeycX6iSm7iBdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnhnPGbLlsbkePrmPSQTT1/s99xymR9DOt2yhQcRWs8A/j5+52lnIe5tzUvr5cMuN4ZJ/ka3/bLjuTaZm34EDObBTXi4gRanmU4yd4AniXy5iUvGAYKoRWZu3al6y56LstLKDO9e/P4GtGJLS6Oz8nHCyxc3syuOe7a51Hzbpl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UI9v+gzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UI9v+gzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11F3C2BCF5;
	Mon,  4 May 2026 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903506;
	bh=mmfl0kD6PNuaHv8JvUzKQfO256/CIGeycX6iSm7iBdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UI9v+gzAhmsZzy4EddR+2WNSpNgkcLzgMa8sTS8EDSM4vMUz/gMs9+XhKbizVXWcT
	 YbVqGsH/GexkqlPjdW6l9S5TyjT3kj0BorFsw0qQMb3E3GGUIrQLajaYOY3nYPEouo
	 ikZQ/sowjzZtii8fsTbXfi+EZsxr1e56GcxSTuIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.0 260/307] crypto: atmel-ecc - Release client on allocation failure
Date: Mon,  4 May 2026 15:52:25 +0200
Message-ID: <20260504135152.598277639@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


