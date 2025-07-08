Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0629A2DAFA3;
	Tue,  8 Jul 2025 16:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993161; cv=none; b=i+5Vl/W2DRW1+HNiX6Z6eQza4rLkYumi4kKJ8BUfG3w0H90GJi24MTZAkGWCq3O81Ewgl/BXPmEf9BPrKWuOwVDZQMKGmqw83myIvFX3XKccXCqu/UX3mE4W8n9grrtWC9w+KjY1JSu3kobngchG2SZ7CqsZspGC71oML3c4T/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993161; c=relaxed/simple;
	bh=Sj2s6Ijfe27O/khGGm0bW5r0F5AXmZcpvZ/I2mLXIbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erMF8TAbvmj4j16FP95i+hIPJN/Dz2aEtmOrkmsoKwSg+X5MC582N/hZrJIL0GqijoQgwsct2+E5zHXigCntLg64C1SeGeeJ4CTrG9mw2wCBP5ynqJb1N82FmrnvWxf8vxPxwzMfqaeUiRxpg3ED6/cN110uxnkTLmKewUPTlhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSkr8NqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSkr8NqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEB1C4CEF7;
	Tue,  8 Jul 2025 16:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993160;
	bh=Sj2s6Ijfe27O/khGGm0bW5r0F5AXmZcpvZ/I2mLXIbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSkr8NqWtBWibje0d0k9rMG+bMr1W19QNI79HuTaVmK3LxE722wx2tpK/aFZVjAvb
	 GL+jNA7ki++/J99Imcr5PoSzcBmYhsFgJRujeZ7E58cLuJwcM8H9w1L5cOUzdbMxvA
	 /43ixXPj4H1qwfjk9AXmiLGiqjgEsScqlVxg66/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.12 209/232] usb: dwc3: Abort suspend on soft disconnect failure
Date: Tue,  8 Jul 2025 18:23:25 +0200
Message-ID: <20250708162246.907835259@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

commit 630a1dec3b0eba2a695b9063f1c205d585cbfec9 upstream.

When dwc3_gadget_soft_disconnect() fails, dwc3_suspend_common() keeps
going with the suspend, resulting in a period where the power domain is
off, but the gadget driver remains connected.  Within this time frame,
invoking vbus_event_work() will cause an error as it attempts to access
DWC3 registers for endpoint disabling after the power domain has been
completely shut down.

Abort the suspend sequence when dwc3_gadget_suspend() cannot halt the
controller and proceeds with a soft connect.

Fixes: 9f8a67b65a49 ("usb: dwc3: gadget: fix gadget suspend/resume")
Cc: stable <stable@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://lore.kernel.org/r/20250528100315.2162699-1-khtsai@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c   |    9 +++++++--
 drivers/usb/dwc3/gadget.c |   22 +++++++++-------------
 2 files changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -2364,6 +2364,7 @@ static int dwc3_suspend_common(struct dw
 {
 	u32 reg;
 	int i;
+	int ret;
 
 	if (!pm_runtime_suspended(dwc->dev) && !PMSG_IS_AUTO(msg)) {
 		dwc->susphy_state = (dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0)) &
@@ -2382,7 +2383,9 @@ static int dwc3_suspend_common(struct dw
 	case DWC3_GCTL_PRTCAP_DEVICE:
 		if (pm_runtime_suspended(dwc->dev))
 			break;
-		dwc3_gadget_suspend(dwc);
+		ret = dwc3_gadget_suspend(dwc);
+		if (ret)
+			return ret;
 		synchronize_irq(dwc->irq_gadget);
 		dwc3_core_exit(dwc);
 		break;
@@ -2417,7 +2420,9 @@ static int dwc3_suspend_common(struct dw
 			break;
 
 		if (dwc->current_otg_role == DWC3_OTG_ROLE_DEVICE) {
-			dwc3_gadget_suspend(dwc);
+			ret = dwc3_gadget_suspend(dwc);
+			if (ret)
+				return ret;
 			synchronize_irq(dwc->irq_gadget);
 		}
 
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4788,26 +4788,22 @@ int dwc3_gadget_suspend(struct dwc3 *dwc
 	int ret;
 
 	ret = dwc3_gadget_soft_disconnect(dwc);
-	if (ret)
-		goto err;
-
-	spin_lock_irqsave(&dwc->lock, flags);
-	if (dwc->gadget_driver)
-		dwc3_disconnect_gadget(dwc);
-	spin_unlock_irqrestore(&dwc->lock, flags);
-
-	return 0;
-
-err:
 	/*
 	 * Attempt to reset the controller's state. Likely no
 	 * communication can be established until the host
 	 * performs a port reset.
 	 */
-	if (dwc->softconnect)
+	if (ret && dwc->softconnect) {
 		dwc3_gadget_soft_connect(dwc);
+		return -EAGAIN;
+	}
 
-	return ret;
+	spin_lock_irqsave(&dwc->lock, flags);
+	if (dwc->gadget_driver)
+		dwc3_disconnect_gadget(dwc);
+	spin_unlock_irqrestore(&dwc->lock, flags);
+
+	return 0;
 }
 
 int dwc3_gadget_resume(struct dwc3 *dwc)


