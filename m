Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E73A1DED68;
	Wed, 19 Feb 2025 08:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955031; cv=none; b=oBrOecy6OOwGHqGGc/9wq5BQ76/a5vAWmCp0g2noX43O0cOXk29HaZMUU7cTfDHmmPu8DgWft4iH74I5JS3dLkUaGaz4/F10GomhoG7JMJKH3Zt8lyDSRtIQ4HLo+OtpX8oEagOAPc7f1pRI7nOfM7UsBWE7avbEv9qStNGsa3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955031; c=relaxed/simple;
	bh=XCE9mRWbZCxCV+lpCk3zYGa5QbfbR1Nzb5FNViqkdZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jh9pt46/bS/Wc/BgdRRyNVJ/UUAHAevMSfVSc8RyeCG6k8mQS34J3PHlh2hAwn5wHBPT4VcO2smVEQ0o16PfUXlt8DgnOE5KIncyiMYKDaCa/n/xa4hpxN59gnpRiM5etTB6wKPpztQBQjTmvXWspEm+b/ZoyVzhCKM6FHmrZpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEA1Uc3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEA1Uc3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DB6C4CEE7;
	Wed, 19 Feb 2025 08:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955031;
	bh=XCE9mRWbZCxCV+lpCk3zYGa5QbfbR1Nzb5FNViqkdZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEA1Uc3MH5zI/vXsI+GyTVWUPV2dCGwIftdIyxK9zsH4GPl2dT20TixjXmSzi98o8
	 kpBasyqWe8Lm/+2XMONEuo0B8Y4N/5JPBGJWQqDf9I01l/yl7IxytAwBQD/WOpMOlX
	 N+EuxJkV6lIxHvTw6oUGHJbu76WObBQQoLSi0Mv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 110/230] usb: dwc3: Fix timeout issue during controller enter/exit from halt state
Date: Wed, 19 Feb 2025 09:27:07 +0100
Message-ID: <20250219082605.993279069@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

commit d3a8c28426fc1fb3252753a9f1db0d691ffc21b0 upstream.

There is a frequent timeout during controller enter/exit from halt state
after toggling the run_stop bit by SW. This timeout occurs when
performing frequent role switches between host and device, causing
device enumeration issues due to the timeout. This issue was not present
when USB2 suspend PHY was disabled by passing the SNPS quirks
(snps,dis_u2_susphy_quirk and snps,dis_enblslpm_quirk) from the DTS.
However, there is a requirement to enable USB2 suspend PHY by setting of
GUSB2PHYCFG.ENBLSLPM and GUSB2PHYCFG.SUSPHY bits when controller starts
in gadget or host mode results in the timeout issue.

This commit addresses this timeout issue by ensuring that the bits
GUSB2PHYCFG.ENBLSLPM and GUSB2PHYCFG.SUSPHY are cleared before starting
the dwc3_gadget_run_stop sequence and restoring them after the
dwc3_gadget_run_stop sequence is completed.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250201163903.459-1-selvarasu.g@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2618,10 +2618,38 @@ static int dwc3_gadget_run_stop(struct d
 {
 	u32			reg;
 	u32			timeout = 2000;
+	u32			saved_config = 0;
 
 	if (pm_runtime_suspended(dwc->dev))
 		return 0;
 
+	/*
+	 * When operating in USB 2.0 speeds (HS/FS), ensure that
+	 * GUSB2PHYCFG.ENBLSLPM and GUSB2PHYCFG.SUSPHY are cleared before starting
+	 * or stopping the controller. This resolves timeout issues that occur
+	 * during frequent role switches between host and device modes.
+	 *
+	 * Save and clear these settings, then restore them after completing the
+	 * controller start or stop sequence.
+	 *
+	 * This solution was discovered through experimentation as it is not
+	 * mentioned in the dwc3 programming guide. It has been tested on an
+	 * Exynos platforms.
+	 */
+	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
+	if (reg & DWC3_GUSB2PHYCFG_SUSPHY) {
+		saved_config |= DWC3_GUSB2PHYCFG_SUSPHY;
+		reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
+	}
+
+	if (reg & DWC3_GUSB2PHYCFG_ENBLSLPM) {
+		saved_config |= DWC3_GUSB2PHYCFG_ENBLSLPM;
+		reg &= ~DWC3_GUSB2PHYCFG_ENBLSLPM;
+	}
+
+	if (saved_config)
+		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
+
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	if (is_on) {
 		if (DWC3_VER_IS_WITHIN(DWC3, ANY, 187A)) {
@@ -2649,6 +2677,12 @@ static int dwc3_gadget_run_stop(struct d
 		reg &= DWC3_DSTS_DEVCTRLHLT;
 	} while (--timeout && !(!is_on ^ !reg));
 
+	if (saved_config) {
+		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
+		reg |= saved_config;
+		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
+	}
+
 	if (!timeout)
 		return -ETIMEDOUT;
 


