Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7653D3323;
	Wed, 30 Sep 2026 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790800; cv=none; b=UhLq4AY+Pqemq/vbUK9w0D3E8q5LM6+1SFOHFyDKFApb4Ct30a5LWVcgmkZZPyOgC6oy0yaL4dHImDs3OMjLMZX9/vnM0vEMg6Q1a5q+Z4Y30gSv1iHm3irYfpYlTNX1kYuEZL/rQA+q2GPOlKTgD9/JY+unwPjgEiEUHC7OPZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790800; c=relaxed/simple;
	bh=DPTdxLpq6KKc/R+q0iwx1Ot8a78cb8dFtTuTYrgMSww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMgEwO27oJy0ZdGEVJmqyT2BZJYlZbE3VGIeAxyaaFgPoq81G5o34fP9e2zwPY6nuWgK1vTxTNzE2UA0pMVfDld/ElNJ7ImNZNslcVXVyPG6wc+GZZIFH12/aq/kYZd9M85Ue12a2fxvjgnz4S28bOwzI5nZTh9gLtwN+7QpO94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=halzQ6nh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="halzQ6nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0821F000FF;
	Wed, 30 Sep 2026 17:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790798;
	bh=vu+fOm+aKPyqNlZw+ZTtBSn7039wJ9d8JBD9catn9IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=halzQ6nhFXaqO6V05V8zV/HsVvR0ESn7MA180rnwPGOWrkNc9cDyoyTSo5VKKrnsT
	 G8M0R5pYbuJICARKznZpnLfAnWcDRT+//fsJYnqAGeefoBj+pVaUqepCj0sd4qVMwW
	 GedPZUrRm8kHR3bzMpTKPNi+I8Yrh3Wn3GB2OiD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/752] crypto: atmel-ecc - add support for atecc608b
Date: Wed, 30 Sep 2026 17:18:23 +0200
Message-ID: <20260930152358.866844048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

[ Upstream commit b668edaf8dcc8d09f6f1e71797422b44d4bd22a3 ]

Tested on hardware with an ATECC608B at 0x60. The device binds
successfully, passes the driver's sanity check, and registers the
ecdh-nist-p256 KPP algorithm.

The hardware ECDH path was also exercised using a minimal KPP test
module, covering private key generation, public key derivation, and
shared secret computation.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 6fb1d02c2c30e..b7fa3ea7a3bef 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -360,6 +360,8 @@ static int atmel_ecc_remove(struct i2c_client *client)
 static const struct of_device_id atmel_ecc_dt_ids[] = {
 	{
 		.compatible = "atmel,atecc508a",
+	}, {
+		.compatible = "atmel,atecc608b",
 	}, {
 		/* sentinel */
 	}
@@ -369,6 +371,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
 
 static const struct i2c_device_id atmel_ecc_id[] = {
 	{ "atecc508a" },
+	{ "atecc608b" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
-- 
2.53.0



