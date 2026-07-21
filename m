Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F6246EF77;
	Tue, 21 Jul 2026 18:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659607; cv=none; b=t0YdeU1d37NlmxU3/uHdqdJ1D0vniFEdcmDWnRRfjR/F6Se9jM6vWVDJ6USI7oKPdiGhx32UETUrOWpvokN0/Q1PA5DvPeNRwYoOTQ0yvBvYz5LqrumGOjUAFN/7wawjUhYZh+0I0LaLLkrdxFCYCC+eVmZ3RTSB+lmyyC47yOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659607; c=relaxed/simple;
	bh=yBTXJjvL+fP9Ztx30TeBzSbTKOeVx9U5AKodSEYn8VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llsTe/E0VopZgXS50gCrUaUJPO8dMQqYHm2wPzoqdKo9pVunyzF3l2NLRTVY979TCBPrlG+h9yKwf82sFzNwhCrZP7oxrFPq/CzwsAskMzBHlRZCKki7FpGC88HffMjEntYyaOaoIUDmbVA41EV8pVx1zreTVcVfb6/o8dM9bcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xO/qIr5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xO/qIr5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C571F000E9;
	Tue, 21 Jul 2026 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659605;
	bh=87296R8MqdBcalJyVJFub0Ab2AFaAlML57tfwXWKa8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xO/qIr5CpBwColaguBXon4JPIjcZjzbmCUt1f7Ftor/b5tWsHihBxmvAQXyBaJ0ou
	 pBgFDiMIdbx2Q46D3Ory8Lkd7WTf390iFWaKrcwHTv/ytdaHWlTDa16xAHSsxSQlqg
	 s4u4XOw1FrMfq4WocA2BjRzpx03M030iZf9QsVOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1585/1611] crypto: atmel-sha204a - fail on hwrng registration error in probe path
Date: Tue, 21 Jul 2026 17:28:21 +0200
Message-ID: <20260721152551.123926915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 49e05bb00f2e8168695f7af4d694c39e1423e8a2 ]

Commit 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
overwrote the hwrng registration return value when creating the sysfs
group, which allowed atmel_sha204a_probe() to succeed even if
devm_hwrng_register() failed.

Return immediately when devm_hwrng_register() fails, and report both
hwrng and sysfs registration errors with dev_err(). Adjust the sysfs
error log message for consistency.

Fixes: 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -183,8 +183,10 @@ static int atmel_sha204a_probe(struct i2
 		i2c_priv->hwrng.quality = *quality;
 
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
-	if (ret)
-		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
+	if (ret) {
+		dev_err(&client->dev, "failed to register RNG (%d)\n", ret);
+		return ret;
+	}
 
 	/* otp read out */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
@@ -192,7 +194,7 @@ static int atmel_sha204a_probe(struct i2
 
 	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
 	if (ret) {
-		dev_err(&client->dev, "failed to register sysfs entry\n");
+		dev_err(&client->dev, "failed to create sysfs group (%d)\n", ret);
 		return ret;
 	}
 


