Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F528285073;
	Tue, 17 Jun 2025 16:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177425; cv=none; b=NMAUAltmWptvErwJezF6SK3DlrQ9M3XpFqm35OaB9Nll8JcknAQVvbeM1Tqgfq3jsdyxnaX9dFCYrkGKjX7X6CeYi6fZn4gbbw7kP+Jpn1XaCIGe+0NrynqtTJuN38lGWQUDXKhFN2tXM7b18nT0vZolHegVJeHElkCYU9+zufk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177425; c=relaxed/simple;
	bh=MDzI1X5z5YOiz1vDhd+VabwpfWeAQmdGPtz8Jrc1I7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJMTSl3vJBpSQXsFsSmGbHgD5GibBtITFHx9c6C5cH74iuXHNvp5o1bjlsv98f5vDDpusB6RHUCnVEOxRom8NjWmTeOcTDfyInWpA5DW0IfzkpHDXh2dEaCbZviLLeha130wCvfNgiegLgUfLJcmTaLUAosVDJMvO+o5I81Ues0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GS8zMiQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GS8zMiQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DA4C4CEE3;
	Tue, 17 Jun 2025 16:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177425;
	bh=MDzI1X5z5YOiz1vDhd+VabwpfWeAQmdGPtz8Jrc1I7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GS8zMiQc9LOhOrx35v/g+PxIcJN2iwQAavc+yzJu+jpobXoJzjdhTQWQa0+u6JCLu
	 QKxIY/hoFOlYBP+UiRWUd7xBo/AVHlqcSbuwVCLUGMh0RYE4/Kd/gg8e2v5I6H1P0H
	 QQjFsSTUWxQMQhYhTRgO5TNJz4tBDXKjO2EhURCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/512] rtc: loongson: Add missing alarm notifications for ACPI RTC events
Date: Tue, 17 Jun 2025 17:24:45 +0200
Message-ID: <20250617152432.538196389@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



