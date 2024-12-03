Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FEB1F75BB;
	Tue,  3 Dec 2024 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238894; cv=none; b=qURHkS4pdd96SnTu8M1wDy1Nrd35tqgtzHyrT5vHk6B9auFGctI98FO/DEq6+BGr41lZ4mXyxznRPQ3RWG7wowfYlHeNABha7HbUywp+Gx1wQizQvBuwS4cI214fSexKITgZP5yrSqt3reBwhXf2YWAWfCeHXBdsx6na3ks7Lig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238894; c=relaxed/simple;
	bh=B+1fWB1N7MqadeQNU5haZe8EMdwzEnmgZX6vG7ejWdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqUuO4yACvFSgV94UzMn2hP3/b95MgZJ4jJd206DOh8LksOy4p8PL1c123AA09/R092lcBBDCavTwCNhgDw9x01yLVOSuIm+ej1Gdm/QBktnnkx36r6tDr653GEJxxtJu/VD47vGBzx0UEl9Nhk8HaanhlrqVAWNzOCfODei2iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtAk5gyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtAk5gyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE056C4CECF;
	Tue,  3 Dec 2024 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238894;
	bh=B+1fWB1N7MqadeQNU5haZe8EMdwzEnmgZX6vG7ejWdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtAk5gyXWUmINgnVE1wM2Z2iw0Kx0HgEsDYvc6aHuc7R7s5hZG7mAHziyZU2zq8ZL
	 5lfk0XrMziqXOai2zdmjq28A8NI48PrlFaKuGbvOtIIrSmSte6uw+0+x1V4157xV5y
	 REXaXHxjUWrDrcjosrls2DCWwam7UOLlIVG7iq6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 433/817] mfd: rt5033: Fix missing regmap_del_irq_chip()
Date: Tue,  3 Dec 2024 15:40:05 +0100
Message-ID: <20241203144012.784086942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



