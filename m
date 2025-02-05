Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC9F15854F;
	Wed,  5 Feb 2025 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768117; cv=none; b=gPW4JBRGfim1PICMf4MCKe55NlWN9Wp8UzDxQKGKUiUx33Bo8QDnVONECj6EQCMkrrse/GXO5R2rLt0lsW1uyLXIdiR4VEV4rDGWn5WzN5MDknk/1hvs+F84SYukZFAj4e6x2dzPeSDzmKyoT/mbm6hXCZNrPDpmhyhqdTLGGjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768117; c=relaxed/simple;
	bh=zJF/HRc2fHNyoZ1+nWx1sJa1k/RtmdnOXBo4pjdku8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3FaA5t/eHI+xsyeK46i1nwTGAOc2i5eByB8q3f7KZdHQ+OK6nwD/vUd1rUtOKxS3v+VVHIG7nm6WlFIFV5HVRyYappLnZNbxSX4Q1/Sk3ch0GAAJJa5lg8hVh+muXQV/rNrIOzf0qqLmJ5VbLfQplmOwQljByMpVxgru5PzeK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfWL49nC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfWL49nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C7EC4CED1;
	Wed,  5 Feb 2025 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768116;
	bh=zJF/HRc2fHNyoZ1+nWx1sJa1k/RtmdnOXBo4pjdku8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfWL49nCW2x16Npw46vqghaoIvBusind6gkOG2bQ/0FjbmBjeeQDaD3qR1A8T1MNn
	 cusSEUZzkBEmHzycw/7K6kMt+7at+iUyEavsRq05CgCQPxH4oYggCZywX8Y0fz0OWY
	 Q0Vw5d79Nvu9nFmMlRWzwUlvq5Lx/9H25ZADv6aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Wang <wangming01@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Keguang Zhang <keguang.zhang@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 500/623] rtc: loongson: clear TOY_MATCH0_REG in loongson_rtc_isr()
Date: Wed,  5 Feb 2025 14:44:02 +0100
Message-ID: <20250205134515.347110010@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Wang <wangming01@loongson.cn>

[ Upstream commit 09471d8f5b390883eaf21b917c4bf3ced1b8a1df ]

The TOY_MATCH0_REG should be cleared to 0 in the RTC interrupt handler,
otherwise the interrupt cannot be cleared, which will cause the
loongson_rtc_isr() to be triggered multiple times.

The previous code cleared TOY_MATCH0_REG in the loongson_rtc_handler(),
which is an ACPI interrupt. This did not prevent loongson_rtc_isr()
from being triggered multiple times.

This commit moves the clearing of TOY_MATCH0_REG to the
loongson_rtc_isr() to ensure that the interrupt is properly cleared.

Fixes: 1b733a9ebc3d ("rtc: Add rtc driver for the Loongson family chips")
Signed-off-by: Ming Wang <wangming01@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Keguang Zhang <keguang.zhang@gmail.com> # on LS1B
Tested-by: Keguang Zhang <keguang.zhang@gmail.com>
Link: https://lore.kernel.org/r/20241205114307.1891418-1-wangming01@loongson.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-loongson.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-loongson.c b/drivers/rtc/rtc-loongson.c
index 8d713e563d7c0..a0f7974e6a570 100644
--- a/drivers/rtc/rtc-loongson.c
+++ b/drivers/rtc/rtc-loongson.c
@@ -114,6 +114,13 @@ static irqreturn_t loongson_rtc_isr(int irq, void *id)
 	struct loongson_rtc_priv *priv = (struct loongson_rtc_priv *)id;
 
 	rtc_update_irq(priv->rtcdev, 1, RTC_AF | RTC_IRQF);
+
+	/*
+	 * The TOY_MATCH0_REG should be cleared 0 here,
+	 * otherwise the interrupt cannot be cleared.
+	 */
+	regmap_write(priv->regmap, TOY_MATCH0_REG, 0);
+
 	return IRQ_HANDLED;
 }
 
@@ -131,11 +138,7 @@ static u32 loongson_rtc_handler(void *id)
 	writel(RTC_STS, priv->pm_base + PM1_STS_REG);
 	spin_unlock(&priv->lock);
 
-	/*
-	 * The TOY_MATCH0_REG should be cleared 0 here,
-	 * otherwise the interrupt cannot be cleared.
-	 */
-	return regmap_write(priv->regmap, TOY_MATCH0_REG, 0);
+	return ACPI_INTERRUPT_HANDLED;
 }
 
 static int loongson_rtc_set_enabled(struct device *dev)
-- 
2.39.5



