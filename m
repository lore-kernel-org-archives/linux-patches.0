Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD201F76AA;
	Tue,  3 Dec 2024 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241529; cv=none; b=hFVe7DkYhRlXtX5X2VmcyCowdG3tJebj/ZptJggcyfW6J//NeiNvar87h9gsL2yGz2CbrszzEFlK0h8v48f49ylgA8ymPS+1rrWRaHn8Q7SYIm8iCWFDsltEnKPrSzbNFRjAGZkv7ntDBbma2cv7K+TvSNP+rgB3nyEywXiv/KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241529; c=relaxed/simple;
	bh=sZopB5Cd4U4lWEh74mxgJrhmBlszxgmZzJy0xNjHzco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q97QqrsIAuB3nb7EwczpFS79c7+bD3fChcKb2sZ60LcxiSMWk/jldZP+VhB+KE/xWOcqRZ/JZCK8dBla7fphIoBf/dR9tX97Yx4JFjr8ussIfztcpZW4sruPEE1SbT/ZmvhO1W/rifr85cEbkLkSnmbYhT1UZf77uG7aG51js/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1H2PlaZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1H2PlaZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79412C4CED8;
	Tue,  3 Dec 2024 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241529;
	bh=sZopB5Cd4U4lWEh74mxgJrhmBlszxgmZzJy0xNjHzco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1H2PlaZrucG8p4Wu+aFf193bdAvB/zr93TXH1xFNdublIxAmonjR4666ps44CFBPM
	 R4rJIfiWwPgXfiOuG5D/43WFgHY1l4A3lyaDXmy8L/6HtWdzwyXq3KnrcV1sKsxeAH
	 6qbIzm0v5Fn/STfcUYD6ioo2HVDNyZtyGwAbp7uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 413/826] mfd: rt5033: Fix missing regmap_del_irq_chip()
Date: Tue,  3 Dec 2024 15:42:20 +0100
Message-ID: <20241203144759.871002930@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



