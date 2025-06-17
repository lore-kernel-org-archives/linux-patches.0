Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F313E2FA642;
	Tue, 17 Jun 2025 16:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178748; cv=none; b=CeblffueLMHDwcO1tPqa21WQSFqwkNljnbn1SrDHCjRHdESEufNFqZNifwUqhL2npQPiyA/NPlVg3M8pHwymQb47BQQeLIipa8KycbubY8MYnIuXXAsaeyQRjH7M50w0x12Nzb4nm9vHRCaX5T5KhNt4chQWh7uCcq/U/iPMU8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178748; c=relaxed/simple;
	bh=Qewyp0retrK4Q+fGQd9EyLVA8y9lKGLIypLtMVNrwBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwBMvFS7oWOq8J2MM53QF8lF7c9usB5HmYY/abON1gh2bIGqkkkYsL+WyIn1l1Tbk0I9J4sSRGUKfprlwZpzcFAg0f4iXkwp4SJv6YDoyeT7U8g+GzTl0zKwtbW2i2bjaKWH8B/Rb3oRwcVuLBdybxdsH0tYfw7IJsw1hshkBu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXVDpubx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXVDpubx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C15DC4CEE3;
	Tue, 17 Jun 2025 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178747;
	bh=Qewyp0retrK4Q+fGQd9EyLVA8y9lKGLIypLtMVNrwBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXVDpubx0SdWkE0GnIGhMaHvKnmc5QVcVmL4Q2vBUK6rPQxKu116x7swQjs4IKZh3
	 gJx2qDxMbDtR1TekyrbBSNWu3Fxc8drVmsYnuWEIvDqRhZ+Si1XycJVq1y2/Qe4RVD
	 sYKygglA1gjYBFBi9/8evnbT78zZoYrhWgSW+MlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 511/780] rtc: loongson: Add missing alarm notifications for ACPI RTC events
Date: Tue, 17 Jun 2025 17:23:39 +0200
Message-ID: <20250617152512.325131268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 97e5625c064ce..2ca7ffd5d7a92 100644
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



