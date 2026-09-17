Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0D53B7771;
	Thu, 17 Sep 2026 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667572; cv=none; b=CQ57tV3eIqW1jzVELflWKaDURy0FPC8Td0d5iZ+eOtlZHrpdxaNjQZNsyDkJoPnL1B3V8K10nuNnIV/E9OxubrbRZPXvk6ab5Twsix11S29Lr6S5e6Ck+XLJ1qt1zKVgA0818mUgPKziIg+dAUeIQagX69Zd4umS7J5pg3JJlFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667572; c=relaxed/simple;
	bh=6ne51POljKskD5PiJtVeJ9+LO3eC1tv/oK7+GllJp78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERSVN6JQl9nyGiOT50lZMC2S9uwE3IGduIArXWrygLB4HjuII2uaW8wH0IB8jm39MKnSgfeNZLs1m8xQa6ArJ7VdTbGhqxyt0Zx0wI20gILIBeT4Ti2JPzsofjme69b7oZlRHJOEwmYlZfKGfGFm5GljCKWWnoXXyn8/ZflyPL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoyLFQIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoyLFQIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13401F000FF;
	Thu, 17 Sep 2026 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667571;
	bh=NczXCzLNTaZn893+qaUD9+D8z/TRPHHyV62FxdsGnU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YoyLFQIkKaeVz4SjIlIa6IlkinEM8Txur2tjeghV5EQqsKOB5p5p0uDnaIAqaK9zF
	 nBwwISv1WTWseWS8zyY8lE830INWYP3kiD12uLy/0/AlxaSH7SMxAvpuuUGR0QvReU
	 jVVhXr9MlPSfEUO9bqC2vhm3pw+eY/WG6umiwkXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0138/1102] crypto: atmel-sha204a - remove sysfs group before hwrng
Date: Thu, 17 Sep 2026 16:01:21 +0100
Message-ID: <20260917151542.986687870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit d58b4a09d7f06750a706b70d068f5a678dad8233 ]

atmel_sha204a_probe() registers the hwrng before creating the sysfs
group. Mirror this order in atmel_sha204a_remove() by removing the sysfs
group before unregistering the hwrng.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-sha204a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index d2031abbd8efa..3e52e604ded39 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -209,11 +209,10 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
+	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 	atmel_i2c_flush_queue();
 
-	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
-
 	kfree((void *)i2c_priv->hwrng.priv);
 }
 
-- 
2.53.0



