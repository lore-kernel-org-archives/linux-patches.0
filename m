Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E71C223E61;
	Thu, 12 Dec 2024 16:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019551; cv=none; b=Au7gwxiyo1DqEC/DlcphTyBtBZFKyGmglKK1qAqdsQIrIxHTpZp8MFRQgJVKy9pLq8sHWrPLGMGytklMsMD06WBKR+sDuIlfD4QdDiVcIkH0sclEsfkPJsziL3NHTAht6Cz7BllFkI9OSQ8mi1ijkNtpUP/lOZBIWy9iY2bcFCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019551; c=relaxed/simple;
	bh=uwJrpOgYSJhJunlDhOIsRTPJYBlU798lAAF/dOmgF44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKZj0Zxmp/TLEPYXHEpFdDGaM9OFfrQ4szqRDVMoW+ZpOjq7CZ/VeTpXHgl+XZPYbqea6f5Ab6PRqYDXrX31OocUVPpcCWSoFMM4s9btBG/+OuCn+w3xUt2c83/JLWy6Yn0WBIC617XC93kuYHzBFHMfE6xxP2c9xKjKks/DXek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVdJmrX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVdJmrX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C85C4CECE;
	Thu, 12 Dec 2024 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019551;
	bh=uwJrpOgYSJhJunlDhOIsRTPJYBlU798lAAF/dOmgF44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVdJmrX3GLMTSbg7NX5Abh33mMa/D3xea8D5N0790ahsRP1xjbVrYrp4EDQcQjYV7
	 0qWjg5rejdFNvO8027B4k4pDtjUTWxNMQF5Xw3SH2Y3ARXx/eOry93zMbBjknDI42b
	 LZKw+6RfutV5w1f4tGIJW7w7p/PSrwnpMuaqEyR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/772] mfd: rt5033: Fix missing regmap_del_irq_chip()
Date: Thu, 12 Dec 2024 15:53:02 +0100
Message-ID: <20241212144359.703309350@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit d256d612f47529ed0b332298e2d5ea981a4dd5b8 ]

Fix missing call to regmap_del_irq_chip() in error handling path by
using devm_regmap_add_irq_chip().

Fixes: 0b271258544b ("mfd: rt5033: Add Richtek RT5033 driver core.")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1730302867-8391-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rt5033.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rt5033.c b/drivers/mfd/rt5033.c
index df095e91e2666..78bafeda5e470 100644
--- a/drivers/mfd/rt5033.c
+++ b/drivers/mfd/rt5033.c
@@ -82,8 +82,8 @@ static int rt5033_i2c_probe(struct i2c_client *i2c,
 	}
 	dev_info(&i2c->dev, "Device found Device ID: %04x\n", dev_id);
 
-	ret = regmap_add_irq_chip(rt5033->regmap, rt5033->irq,
-			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+	ret = devm_regmap_add_irq_chip(rt5033->dev, rt5033->regmap,
+			rt5033->irq, IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 			0, &rt5033_irq_chip, &rt5033->irq_data);
 	if (ret) {
 		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
-- 
2.43.0



