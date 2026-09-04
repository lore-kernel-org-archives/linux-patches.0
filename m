Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761F93EC6AE;
	Fri,  4 Sep 2026 05:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500282; cv=none; b=QU1S5BVhs4dZtCcZ9+xD/IPV2sCsY/kVGpM9Crqk0xr4+xJVHr7lyCRPavIx+MpPceMlxhsusvykEy/fszAOK3GQz3OwqRCY1uezptYhI2X+d3lpsbp69ex0HZ09WeHgC33GNbtwaX5YbTXtJ5kNuizspbK0XKPIo/XVzG3IbY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500282; c=relaxed/simple;
	bh=IBUA2ufv7Jyne98SoxrQitNra5VdktQ/7LHezgdg3ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5rSitu+2iTgT6b4brAI2jlR0eK8LM/otoGUXBH/9iiBBZPPrlUZMVvnzvFoz7xgNHe02Hyx3//Rrv8eXuN0N1Ts2kr1dJ5Y71v1P3HYID+CRp0PWTomLE4IK1TileK8PFjh+A3DDL761e0O06oN+BIgIb5VFgxTnASSKvaOP5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8K5b7Gk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8K5b7Gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20B61F00A3D;
	Fri,  4 Sep 2026 05:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500281;
	bh=VAPCmvmEWh2D2nOij0G2u5ZGJgSj2Jcuf7VDoOsWGoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8K5b7GklEqdtNXZswsmMLH1twduOHnpGg/ORsK3E6/lG0kJY5sT3JBREe2B0FHrt
	 NRHA9v0M+tnFvLdBOcN6x/+Ccm8smgsbRERSKrJ1ECHeH6Y+FUvf7lPVsP43ovlZNn
	 AdE3/FNcJ6mLljcWLroDKlKgg7rFazChmxF0sTmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 682/713] crypto: atmel-ecc - avoid stale fallback key after set_secret failure
Date: Fri,  4 Sep 2026 07:00:50 +0200
Message-ID: <20260904045819.126964712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit f07a0d251db7606e4792d2610788fbcc7b2c0d12 ]

Clear ->do_fallback before decoding a new ECDH secret and enable it only
after the software fallback accepts a caller-provided private key. This
avoids using a stale fallback key should crypto_kpp_set_secret() fail.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-ecc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -84,6 +84,7 @@ static int atmel_ecdh_set_secret(struct
 
 	kfree(ctx->public_key);
 	ctx->public_key = NULL;
+	ctx->do_fallback = false;
 
 	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
 		dev_err(&ctx->client->dev, "crypto_ecdh_decode_key failed\n");
@@ -91,8 +92,9 @@ static int atmel_ecdh_set_secret(struct
 	}
 
 	if (params.key_size) {
-		ctx->do_fallback = true;
-		return crypto_kpp_set_secret(ctx->fallback, buf, len);
+		ret = crypto_kpp_set_secret(ctx->fallback, buf, len);
+		ctx->do_fallback = !ret;
+		return ret;
 	}
 
 	cmd = kmalloc_obj(*cmd);
@@ -103,8 +105,6 @@ static int atmel_ecdh_set_secret(struct
 	if (!public_key)
 		goto free_cmd;
 
-	ctx->do_fallback = false;
-
 	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2);
 
 	ret = atmel_i2c_send_receive(ctx->client, cmd);


