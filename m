Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBC02F234A;
	Tue, 17 Jun 2025 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175950; cv=none; b=neKe+cpyLqda72MV4RDpc/GrE4p7ajYRtT+6Awmh38lXqZtRDCren1tV1xUpiVZsF+wruYEACkVIbrqZlitux/E7W38iZpCPZJetTn9weW5MmubsgdLu8dwWcGkOwB29uWujIjdMejCrng/qQVgxd0QBDC1Kg5TWLh8sRals0Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175950; c=relaxed/simple;
	bh=iuLKTn2pNvu+GE1gZEkoRSUbt+iYlh+9v0Bua80Kyiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q42iHoEZpOy3hOql7SjToB5f7WF2L4txDvG536rmZRoeO5Igs2c/w64/Gp/C89a9Av7Q/UOOS3Mb4Pe0aCXGqoQINWRh3JRobPRwA2OqpK/Yp5CtGANtYS504VnAsAZHvLPUYw4tWWi0wd8BJnnKpIu3otrLRMyIGBG8kOjTZUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWa+lxSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWa+lxSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A98C4CEE3;
	Tue, 17 Jun 2025 15:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175949;
	bh=iuLKTn2pNvu+GE1gZEkoRSUbt+iYlh+9v0Bua80Kyiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWa+lxSIHX2x+CERQOrrKrdtI/cPVsiTsv/xjFW+UbUY8OUjNlwJrY/M07RxaiuDF
	 D4NvE+7VUFKrgSubV4tyHUuFDVHKmIQy8K6pduOKn+4wE2Z8uKKMbIrj6BM1kOSGQt
	 PrRnrNPWSIvRvQ8iiIHLkvLV4dkqLE3NyOLZiBEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/356] rtc: loongson: Add missing alarm notifications for ACPI RTC events
Date: Tue, 17 Jun 2025 17:25:44 +0200
Message-ID: <20250617152347.415472495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Dalin <liudalin@kylinsec.com.cn>

[ Upstream commit 5af9f1fa576874b24627d4c05e3a84672204c200 ]

When an application sets and enables an alarm on Loongson RTC devices,
the alarm notification fails to propagate to userspace because the
ACPI event handler omits calling rtc_update_irq().

As a result, processes waiting via select() or poll() on RTC device
files fail to receive alarm notifications.

The ACPI interrupt is also triggered multiple times. In loongson_rtc_handler,
we need to clear TOY_MATCH0_REG to resolve this issue.

Fixes: 09471d8f5b39 ("rtc: loongson: clear TOY_MATCH0_REG in loongson_rtc_isr()")
Fixes: 1b733a9ebc3d ("rtc: Add rtc driver for the Loongson family chips")
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
Reviewed-by: Binbin Zhou <zhoubinbin@loongson.cn>
Link: https://lore.kernel.org/r/20250509084416.7979-1-liudalin@kylinsec.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-loongson.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/rtc/rtc-loongson.c b/drivers/rtc/rtc-loongson.c
index 90e9d97a86b48..c9d5b91a6544d 100644
--- a/drivers/rtc/rtc-loongson.c
+++ b/drivers/rtc/rtc-loongson.c
@@ -129,6 +129,14 @@ static u32 loongson_rtc_handler(void *id)
 {
 	struct loongson_rtc_priv *priv = (struct loongson_rtc_priv *)id;
 
+	rtc_update_irq(priv->rtcdev, 1, RTC_AF | RTC_IRQF);
+
+	/*
+	 * The TOY_MATCH0_REG should be cleared 0 here,
+	 * otherwise the interrupt cannot be cleared.
+	 */
+	regmap_write(priv->regmap, TOY_MATCH0_REG, 0);
+
 	spin_lock(&priv->lock);
 	/* Disable RTC alarm wakeup and interrupt */
 	writel(readl(priv->pm_base + PM1_EN_REG) & ~RTC_EN,
-- 
2.39.5



