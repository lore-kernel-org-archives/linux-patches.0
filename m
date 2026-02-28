Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234A1340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301054; cv=none; b=cbdPdLZatKjHHiaL5sEFSonEB6eWN2yywyWO+ymO3zZzBDGT+gL/dlghdtrcyRsfm3ULG++9Qpuc1uZeweZBrv7GN1R4VA5UA/QQprnHdabv2zSHdqtX/mTTWHWaGrr4AYiaNC7J8Ut8zHcpqX1jJjJPPKuq5QK4Z6mjDGzBJHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301054; c=relaxed/simple;
	bh=5MxffBDqvoHOB1DY7qSMtyUJ0WIXROTKZWFL/D1zncE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIII3LLK7rdNu4qrwXtnPk3XiPm9f23XBtTsy9GDD/ZwT9efCynNLGCxMrkCRtiEGVzw6jstaM7KE/j8kop9KvNwYxecF5PWuN3FKc29xBNotKc3jrWfe4YUWzucrVxfQwx8LDYZnj+2v3Z+26gxO+WzWLA7x5MmrFmPBcp5/Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VNL2MD36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VNL2MD36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8664DC19423;
	Sat, 28 Feb 2026 17:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301054;
	bh=5MxffBDqvoHOB1DY7qSMtyUJ0WIXROTKZWFL/D1zncE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNL2MD36a55KRTkM+L6OoJT3OTtqvy+x0zUnyQyR1OfEfaFAVOPReP7r6z6eWnUyd
	 JHpzHJFQd676ASCS3fO2UaXPfe81Z11RqFvRggFvceBNw2rMAzcdOc5p+S9xOYbdPc
	 ak3Xrjb6Aze9YgkcoOhbteK419VyKnkC+ejyAa9nWxFSn4soULvHAnSXe9top/HzlU
	 ANN9of3QFhA0TyEbOFTRbhfyDGNFXB437FjMVyIGltgCPdATkzqOfgShrD9SgROmV4
	 Ib1HvXEwjYi2WAzeWXRQZgAw+iM+uFxXnxeVODgsmkQ47KMZ49bpeN2aJMHFT2hqVc
	 aDe/3HGVTDGQw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 194/752] ASoC: codecs: max98390: Check return value of devm_gpiod_get_optional() in max98390_i2c_probe()
Date: Sat, 28 Feb 2026 12:38:25 -0500
Message-ID: <20260228174750.1542406-194-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a1d14d8364eac2611fe1391c73ff0e5b26064f0e ]

The devm_gpiod_get_optional() function may return an error pointer
(ERR_PTR) in case of a genuine failure during GPIO acquisition,
not just NULL which indicates the legitimate absence of an optional
GPIO.

Add an IS_ERR() check after the function call to catch such errors and
propagate them to the probe function, ensuring the driver fails to load
safely rather than proceeding with an invalid pointer.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260130091904.3426149-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98390.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/max98390.c b/sound/soc/codecs/max98390.c
index a8a282ff9fc5a..b132ef8c1d2c8 100644
--- a/sound/soc/codecs/max98390.c
+++ b/sound/soc/codecs/max98390.c
@@ -1073,6 +1073,9 @@ static int max98390_i2c_probe(struct i2c_client *i2c)
 
 	reset_gpio = devm_gpiod_get_optional(&i2c->dev,
 					     "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(reset_gpio))
+		return dev_err_probe(&i2c->dev, PTR_ERR(reset_gpio),
+				     "Failed to get reset gpio\n");
 
 	/* Power on device */
 	if (reset_gpio) {
-- 
2.51.0

