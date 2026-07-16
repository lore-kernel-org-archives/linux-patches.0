Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70B442589F;
	Thu, 16 Jul 2026 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209869; cv=none; b=kLd5sCCRiUT/S801PyONzs0iE7ox8pVY0uMAz3nVSIU0ZnbusncjQzHIsL2cl+l61WoD5nhwYeygGr5uCFraiIPaMXDsWfSFEgtq06aLWx0RqLJDv3OQv7p7jXVlw+knzLaP6Bpo0NwWmpYmikBbxbp4AhS0wehX/pxIu+lc6QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209869; c=relaxed/simple;
	bh=+iogh6/+6pkgYv5Ob3f1KCfyOqyupCIKJTz8vrXnlUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjgquVS/lI8dbgF92sufxEGS4OZW0WcoKjGNLTUEAMtJT0NgctWmmgi/wxE7Bc67eQ1myqbTarwF74GMSzLc7KoSnBDvFAxVITpc0sjL0oLQJIMR8q/X5BhVgtalggRlGP5chAknCiJNJ/Y8ja6bPwn81E76WO+SKulU76bAdO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwBCDwmw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwBCDwmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E701F000E9;
	Thu, 16 Jul 2026 13:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209867;
	bh=Gb7UQCBg9dK9xnxY78FwmY2527bJxBv7ioZG+KiqEts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwBCDwmwskjEtCZwGKxsQH8LeLhveb+ZENWCUMeywGF5fGk3DTyzVC2UB6d7zMXst
	 MfBmYnmwYerhasG0Wvr0F2oFncTK6O+dWiHJpdHN/eiBsmv/yh32BO9GjgTXFKzQKS
	 TYaosZJU3DaT0KlfnFzkVoPslzIiHTg9bYfx7Auk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 347/518] crypto: atmel-sha204a - fail on hwrng registration error in probe path
Date: Thu, 16 Jul 2026 15:30:15 +0200
Message-ID: <20260716133055.415001084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 49e05bb00f2e8168695f7af4d694c39e1423e8a2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -183,12 +183,14 @@ static int atmel_sha204a_probe(struct i2
 		i2c_priv->hwrng.quality = *quality;
 
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
-	if (ret)
-		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
+	if (ret) {
+		dev_err(&client->dev, "failed to register RNG (%d)\n", ret);
+		return ret;
+	}
 
 	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
 	if (ret) {
-		dev_err(&client->dev, "failed to register sysfs entry\n");
+		dev_err(&client->dev, "failed to create sysfs group (%d)\n", ret);
 		return ret;
 	}
 


