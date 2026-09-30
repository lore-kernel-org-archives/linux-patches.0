Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A347E44F57F;
	Wed, 30 Sep 2026 19:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797248; cv=none; b=h/zeHD3OXLKbGFS94yk3RCPA+RrxLy4RcKyr05aZZI93mfV+u6IfrhH1Q7n//ZlZeVU+WTWZa17D5qLiVFxKwOqPN7Ke55mDkFkhS4omUoySeKLIiMZhnoTkf5ZNqVYOwKJNLiI6qJyfgTn8oBpY3vTENN/HgL9PLPTPqKujcZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797248; c=relaxed/simple;
	bh=qYVH6CkLQSqYVYPkGYMZXQXPFJ/OLpd7zPJW8Owv8Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu9xDWb5Wnl0YYda0+dx60I3U056wCIG6VZgDlCQdzCV0o8lNmULsD+e8nEEfAIbhMHi4T22TrZPvpCeOYZgjREPXCUZ6TF1GQZbxys1XU3htJUKz0dKLYHl6jKh1FOvew7nUAUilAFUX3dI9eQRblpb6o3CiT7oTAKTyRICfdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n84cJU4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n84cJU4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037E71F000FF;
	Wed, 30 Sep 2026 19:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797247;
	bh=hfQrMJP3Tr+8OtMu0+jNR5pNio+aHN8RGGjplJdxo9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n84cJU4Mh9nx8hAh6m4VvgZUJ1KDrvGBK06wkfAZYlwjiEDo+zBVj8oB2qMzGrZew
	 pVE9wIDY/QL4HitulTV5ENABjjZhMubslKNu+fbjFTVCpgZdl3S6CNdFius18H9XXT
	 EJD656GzU1z2cL0wC+i4RXg/lLtkdKgusUEAamXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1192/1193] crypto: atmel-ecc - avoid stale fallback key after set_secret failure
Date: Wed, 30 Sep 2026 17:31:16 +0200
Message-ID: <20260930152500.730465224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
 
 	cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
@@ -103,8 +105,6 @@ static int atmel_ecdh_set_secret(struct
 	if (!public_key)
 		goto free_cmd;
 
-	ctx->do_fallback = false;
-
 	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2);
 
 	ret = atmel_i2c_send_receive(ctx->client, cmd);


