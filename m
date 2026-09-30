Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233D350B8B1;
	Wed, 30 Sep 2026 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782388; cv=none; b=cdKPJYI7I5RdEbJP9p3Ss8LO8aceyar3THOR9wtQypUd9hUrDgOEQFteYDls9Yv+7cEH0p5Wwr0udhrbMmgxA+EIUbKA9+rxx4QvlR50pEm0/bRCFP+eiA36BS8qRo2r7YtG7OXEo4+gMgf3O4eutn+hvJxMzFipxLoMlMsf7wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782388; c=relaxed/simple;
	bh=PPZGMGukImWcxH8kzXfAvmAQzBP/Qd9XDxEsUUejufU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0SYELTwzQl31gRsJI+JN7vVxvdKu19bSuRLsD2CCwYWxOd2Kl4cEQXM/YguhGE/F1WHZkwf+UmI/Zba31VV8vJKOTfSLQ9gXDwpyrV7Pj7prTdNZiq/nCNvMb1FE8P0K85ABncaMrbv2faCo6V9fS+rRsDzF9bw7e7SVb5QFdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sY3cFVPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sY3cFVPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12191F00893;
	Wed, 30 Sep 2026 15:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782380;
	bh=1TSxRJeJYYEdupc7Zuzjdv2uKIIQLc+BZZfriBWmOL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sY3cFVPsx3iSgY/ZSk7p0qtbYJr/066Em3IHwWha1fAnxtHlZCsk+rQaZCdKF4cHL
	 s0x0zslfkg0sOzeQ1gCe1zDI5BoIF16eqHHj8OJbFerlTpbg2IWoMnsaYdF0a12jer
	 VUu+a3S8BKGiYhrOmeFAw1zI692+Onm8JwK992mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/595] crypto: atmel-ecc - add support for atecc608b
Date: Wed, 30 Sep 2026 17:18:40 +0200
Message-ID: <20260930152348.311648843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



