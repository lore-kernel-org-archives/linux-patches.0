Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724072210EA;
	Thu, 12 Dec 2024 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025223; cv=none; b=CJJu2PtOnk2bT8zxaKD3kM4HPae5qcSp+GykGIE/FkLuyA6Nckmw59tD54DWoBuZ8UU9YQqYFLaNv8CxZbJ7GjwrFnCjLQ7k6RYKwxKzqLqXckMHAVRYB82U/pMFPNTOTkWKHsDlcM9YrM36YpYhBk75VP5LziOKmJMHNJl6OFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025223; c=relaxed/simple;
	bh=4dalha8j7Drxw1k9oxu4dpuB9c+w252gElfVW1Lu1qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/Rz69qtehSLvlefBCdbHEB1a6ufVia+2YuhsPUhuG3Ey09SsI2l1JmhLZyWda9x8daeB4DRpl6aT73xj84dUk68Pibeta07MAp7yQ1Xbf8xeRd39CPRoKXn9zhf7PSGPw4LZfBTOt4Pt2k6vV4/f95rMrcvr+LwXjM/a5TDTBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKuBdrra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKuBdrra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE627C4CECE;
	Thu, 12 Dec 2024 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025223;
	bh=4dalha8j7Drxw1k9oxu4dpuB9c+w252gElfVW1Lu1qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKuBdrraXTVmgoPsH9EtxxWiZWHbbCG7mCu29zDri48obeUZW03Iw7nu+DZtZJ8FP
	 FNeTI3TtynI6LaD7y5vrOwIt3h5nczWGCv5U9Bbz9wU9pkD5CO09AfX9qf3kIIgQRC
	 QOWc6sn3oGrINvqPvicIf2CmdL+EZGYaLwEtc/kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/321] mfd: rt5033: Fix missing regmap_del_irq_chip()
Date: Thu, 12 Dec 2024 16:00:15 +0100
Message-ID: <20241212144233.822594696@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 302115dabff4b..9afb8d2b35476 100644
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



