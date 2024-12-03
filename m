Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44321F4279;
	Tue,  3 Dec 2024 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236653; cv=none; b=OpYiRcU3bgr8XW+OjXDs0BJTecwALSnNtMaHzvnoiPT50paueFWZn2k25Dw3PQjRbxxiH114ZrFDjhqIOUQG2C69oOS+cq0ubHCc/D0xm7H+fH6Wc9tKHZpJ2TPOL47mzX9OyS8UmRvdPzXviTfgmCX3eKuIbiQEYDKUtJZxn1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236653; c=relaxed/simple;
	bh=Q01+UBs3Qa3zOkNdv/NF6Ok8ez8TzZJs7PbVRzJPXHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d04UIZcVAjw0PW5cN0buY1e59vUygB+0JpYrDpW1d+qotUClj0E6nbZViGrN+9ktjbjT7Tjcko8pUKE5wyem5gQouFYPFJp533zsMHRmKy+DOaiHVA1y/545UACSgrHp/6lvHQKZ3AyH0qFr/piw/9tPEHgYe6ZSXaL0X5SIawg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDO3QjRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDO3QjRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B4AC4CECF;
	Tue,  3 Dec 2024 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236653;
	bh=Q01+UBs3Qa3zOkNdv/NF6Ok8ez8TzZJs7PbVRzJPXHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDO3QjRWO0Ki44tDPJl/lWnsv2B7RzN/bZY8jDZUMRjIalf3LqlBf9M2pJJTFsJYR
	 cHFLcWv6TXxEbCMoaZ3WSfvy3F4M+5XGyL5g3y2mbao17onShh9B9NvWIVN9C31+34
	 vjkmLP3jBDvGyDwL3qNp74qqeoGtqA93RE+rpNxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/138] mfd: rt5033: Fix missing regmap_del_irq_chip()
Date: Tue,  3 Dec 2024 15:31:33 +0100
Message-ID: <20241203141926.008501253@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 94cdad91c0657..71f35bfac3f28 100644
--- a/drivers/mfd/rt5033.c
+++ b/drivers/mfd/rt5033.c
@@ -85,8 +85,8 @@ static int rt5033_i2c_probe(struct i2c_client *i2c,
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



