Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87FE6774B;
	Tue, 23 Jan 2024 02:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975516; cv=none; b=mO2uBpFGR5XKp2hy6cOwscPHK4Ij8AE2p70qrzvgBWu2DUecRFivBblW4Lbsv38/5S4IMjX0L0AYvpKe1fc/hZvUGWGq78OF6mEDHH4mgyF0VIe9MKTXwfCy77y1gVSoybIjP3flbAyCu2cOs53v7mJY4vfiSBOKRsXw0Kk/eTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975516; c=relaxed/simple;
	bh=IQosZORJoZf1zMrVkVUeGUA3fBgPJ1CVpRlnMmCmA58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiRNWYTDU7NSUKKHhLOrmD/BQLgtnc2HbKdA2i0t3XYBFLy2jEWJCBTErTr4RV/sc2YkETOMEtxNmzDynTuUqXHFiHRD/8G3kGHOj1x8TfRqu+CZ620PGJsA/YngJxvWkpLaO8R+Ohe/oFvQ90YoC5YVcYwAYuHzxIAlpHrZlC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHuAM06R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHuAM06R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73669C433C7;
	Tue, 23 Jan 2024 02:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975516;
	bh=IQosZORJoZf1zMrVkVUeGUA3fBgPJ1CVpRlnMmCmA58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHuAM06Rzrbk/C3fhnW1r60LuzepeeOL3Z9vbHxQuqcqGfmbIANxY5RTLPp1j4l5d
	 gsq1Hmr8e/6Nv7hA1HpqvuCye+D8qfYmoahos258Y4o5sFcz5idcCjBZAnosMeb0BC
	 PumTibmt1vcAGaN0yAkvGYQn8FTBPOpGo5ioLlXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 443/583] mfd: tps6594: Add null pointer check to tps6594_device_init()
Date: Mon, 22 Jan 2024 15:58:14 -0800
Message-ID: <20240122235825.531372873@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 825906f2ebe83977d747d8bce61675dddd72485d ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: 325bec7157b3 ("mfd: tps6594: Add driver for TI TPS6594 PMIC")
Suggested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20231208033320.49345-1-chentao@kylinos.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps6594-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/tps6594-core.c b/drivers/mfd/tps6594-core.c
index 0fb9c5cf213a..783ee59901e8 100644
--- a/drivers/mfd/tps6594-core.c
+++ b/drivers/mfd/tps6594-core.c
@@ -433,6 +433,9 @@ int tps6594_device_init(struct tps6594 *tps, bool enable_crc)
 	tps6594_irq_chip.name = devm_kasprintf(dev, GFP_KERNEL, "%s-%ld-0x%02x",
 					       dev->driver->name, tps->chip_id, tps->reg);
 
+	if (!tps6594_irq_chip.name)
+		return -ENOMEM;
+
 	ret = devm_regmap_add_irq_chip(dev, tps->regmap, tps->irq, IRQF_SHARED | IRQF_ONESHOT,
 				       0, &tps6594_irq_chip, &tps->irq_data);
 	if (ret)
-- 
2.43.0



