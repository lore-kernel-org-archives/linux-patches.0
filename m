Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6B153A7;
	Fri,  6 Dec 2024 15:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497463; cv=none; b=MKf/WvhBCFfisfJRDE1Cm3bB9MVFVj6QRmdSRAMxcNEsQsctlUkqPXh1Ztpzrotcg1H7cb0vQvPkh8B2lZBWdKJ690XPJG6ccJ9zqEMpNDDv3KC83imhjRtLhuMc/Iz4dJuOIOfX4IrV2JY3CA8DABFvRV6FP9tGf0BBotB2WQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497463; c=relaxed/simple;
	bh=YjapVWjQvdgXeUDi+ST7ABexKVdEW3cGz7LO2qY2OXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOMj709kssDo77stdT9RXRGP+PDNn4Ue3+neZKCjRPxNS81ja9cCUaqnbJEOems10iHsFhEWEpOpNNvP/aUixWX5VMwBF/CsNMePAUzbNP0GV3urM/ekTxTZd4E4vGwv3ImCQlZI2/nqsW5yCN9zO8Q1i53aRDD22iCZcaHAhzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07ousGLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07ousGLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C960C4CED1;
	Fri,  6 Dec 2024 15:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497462;
	bh=YjapVWjQvdgXeUDi+ST7ABexKVdEW3cGz7LO2qY2OXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07ousGLB7owNIEXTf3Ax++u3RI5gs8CAgJ5eriKNO3F4ntA7WzR/fSXHbaLyHk6Ac
	 6HxiJGqrC0IbIwHmfbSKGKU0NWkmYzY/afMbdVrKGGdHZBnpKBgh9YSK/krhlJLQb0
	 yubOb9+VKCtFsDpnA7eqxQXdqUBTvj/f2DmcnHvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/676] mfd: rt5033: Fix missing regmap_del_irq_chip()
Date: Fri,  6 Dec 2024 15:31:58 +0100
Message-ID: <20241206143705.022745439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 7e23ab3d5842c..84ebc96f58e48 100644
--- a/drivers/mfd/rt5033.c
+++ b/drivers/mfd/rt5033.c
@@ -81,8 +81,8 @@ static int rt5033_i2c_probe(struct i2c_client *i2c)
 	chip_rev = dev_id & RT5033_CHIP_REV_MASK;
 	dev_info(&i2c->dev, "Device found (rev. %d)\n", chip_rev);
 
-	ret = regmap_add_irq_chip(rt5033->regmap, rt5033->irq,
-			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+	ret = devm_regmap_add_irq_chip(rt5033->dev, rt5033->regmap,
+			rt5033->irq, IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 			0, &rt5033_irq_chip, &rt5033->irq_data);
 	if (ret) {
 		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
-- 
2.43.0



