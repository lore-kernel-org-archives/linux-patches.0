Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA682D9494;
	Tue, 11 Nov 2025 01:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825250; cv=none; b=nUf8yuNSdyJNwb658JPqSC8gRn0IV7V6WznjqeDYmVTg3kg+3tYF284OOVDPErg9b++wJTv35Y3eB5SuCDKXsTyzeWgstWsrMUhN4A51EPQaRHVPhjch1AEHnwgCp+JCmzcJkGzZeFTd+xb+ZT1abdVIQeKJpRldVMOPJRSx2XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825250; c=relaxed/simple;
	bh=EOREWAUrDlo+CNOaZHXQ5TiKWLVQfPkW1zPXW/ydhFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvvpkuzQCJ69ZjiaCm403VOoNgtEHBGVAZE1ZjAPj9nEOr8lq3y1IwXr6ZlrdSrlepUtnWQglk2wLCJTAIujkGjZLvViMEqEnTt2C2Gf06XPLlvAlO5AEZPv5FMZdAcfhbxGXk51eSgPe9I6QY1BZwo6lp6GgRlAS/r0Y6nxXHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXf95IrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXf95IrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2BDC116D0;
	Tue, 11 Nov 2025 01:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825250;
	bh=EOREWAUrDlo+CNOaZHXQ5TiKWLVQfPkW1zPXW/ydhFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXf95IrIXCUdLE3MbxBv7kLPbQyl1DagHeIJA5ovtc5VwlGMAE9TtpPkVdOA76epX
	 g0OTxM6Wye3BGUV5N9NY4AQsls+3ujb1RCnTJuk+xPa3w6nJvaqPsADovD0TdcC/VL
	 e8UT4HZ53Ykr766nnFIE7kUn2IHa5RYUKmvQQRKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 725/849] rtc: zynqmp: Restore alarm functionality after kexec transition
Date: Tue, 11 Nov 2025 09:44:55 +0900
Message-ID: <20251111004553.962307117@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini T <harini.t@amd.com>

[ Upstream commit e22f4d1321e0055065f274e20bf6d1dbf4b500f5 ]

During kexec reboots, RTC alarms that are fired during the kernel
transition experience delayed execution. The new kernel would eventually
honor these alarms, but the interrupt handlers would only execute after
the driver probe is completed rather than at the intended alarm time.

This is because pending alarm interrupt status from the previous kernel
is not properly cleared during driver initialization, causing timing
discrepancies in alarm delivery.

To ensure precise alarm timing across kexec transitions, enhance the
probe function to:
1. Clear any pending alarm interrupt status from previous boot.
2. Detect existing valid alarms and preserve their state.
3. Re-enable alarm interrupts for future alarms.

Signed-off-by: Harini T <harini.t@amd.com>
Link: https://lore.kernel.org/r/20250730142110.2354507-1-harini.t@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-zynqmp.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/rtc/rtc-zynqmp.c b/drivers/rtc/rtc-zynqmp.c
index f39102b66eac2..3baa2b481d9f2 100644
--- a/drivers/rtc/rtc-zynqmp.c
+++ b/drivers/rtc/rtc-zynqmp.c
@@ -277,6 +277,10 @@ static irqreturn_t xlnx_rtc_interrupt(int irq, void *id)
 static int xlnx_rtc_probe(struct platform_device *pdev)
 {
 	struct xlnx_rtc_dev *xrtcdev;
+	bool is_alarm_set = false;
+	u32 pending_alrm_irq;
+	u32 current_time;
+	u32 alarm_time;
 	int ret;
 
 	xrtcdev = devm_kzalloc(&pdev->dev, sizeof(*xrtcdev), GFP_KERNEL);
@@ -296,6 +300,17 @@ static int xlnx_rtc_probe(struct platform_device *pdev)
 	if (IS_ERR(xrtcdev->reg_base))
 		return PTR_ERR(xrtcdev->reg_base);
 
+	/* Clear any pending alarm interrupts from previous kernel/boot */
+	pending_alrm_irq = readl(xrtcdev->reg_base + RTC_INT_STS) & RTC_INT_ALRM;
+	if (pending_alrm_irq)
+		writel(pending_alrm_irq, xrtcdev->reg_base + RTC_INT_STS);
+
+	/* Check if a valid alarm is already set from previous kernel/boot */
+	alarm_time = readl(xrtcdev->reg_base + RTC_ALRM);
+	current_time = readl(xrtcdev->reg_base + RTC_CUR_TM);
+	if (alarm_time > current_time && alarm_time != 0)
+		is_alarm_set = true;
+
 	xrtcdev->alarm_irq = platform_get_irq_byname(pdev, "alarm");
 	if (xrtcdev->alarm_irq < 0)
 		return xrtcdev->alarm_irq;
@@ -337,6 +352,10 @@ static int xlnx_rtc_probe(struct platform_device *pdev)
 
 	xlnx_init_rtc(xrtcdev);
 
+	/* Re-enable alarm interrupt if a valid alarm was found */
+	if (is_alarm_set)
+		writel(RTC_INT_ALRM, xrtcdev->reg_base + RTC_INT_EN);
+
 	device_init_wakeup(&pdev->dev, true);
 
 	return devm_rtc_register_device(xrtcdev->rtc);
-- 
2.51.0



