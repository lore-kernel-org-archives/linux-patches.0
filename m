Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3917F21766D;
	Thu, 12 Dec 2024 17:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024070; cv=none; b=o1aQ/j6VGJHwmscEiNFwARaqEUMPjdGLiMi7V8zneQ8JFXicm2HuC95ZFiWwAvI8Sxn8ByEwLGzzECX9Hp06vYGfNrb8LfNbbLO8TRVqFq85yXfyc+7RlqPAn9Di+50p0F/oDIGBI2UUiGyuv7RH21e8taRKfTKZSQ39IgzeMpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024070; c=relaxed/simple;
	bh=EunpLDT9XIfP6LLR5dxwMWYH9/xjO78NTqbvCZbgVyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPqN3ico336eso0vuigN4l3I974KYfTcI5IrrZ9Bd72vc163SJ0ld/8hwHa83YDfZiK7hKKU47o8mXYqBPCI6cQCUETRh4b4PZNpIpTFG7IssWxt1OumkuuUEwtgl2zGvqdPsEy2qhCryqRxnWwavuoRYNDoRs/QwGkxG95qQAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOnjj16C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOnjj16C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B5DC4CECE;
	Thu, 12 Dec 2024 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024069;
	bh=EunpLDT9XIfP6LLR5dxwMWYH9/xjO78NTqbvCZbgVyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOnjj16Cq8Cku48OTKD95jF54Apt8pzpOTBM/mxaTRDfdgY6T+4Nc5DVBzCQrTLtU
	 zQAG+qOj4xmv5vp5KUB82xepo2uDIIOgSaoj3H1FAgRJv0tU5LOBvfOkMjWZLR2/wE
	 QTIVtMnG6HJzYIaCUuuqhbcCLuSFEDiazh0QASfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/459] mfd: rt5033: Fix missing regmap_del_irq_chip()
Date: Thu, 12 Dec 2024 15:58:33 +0100
Message-ID: <20241212144300.438174212@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



