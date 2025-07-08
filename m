Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA44A2F37;
	Tue,  8 Jul 2025 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993665; cv=none; b=OWgoYqdkGVmbbJfuhxxxB+nlHok6HQuj2gQSkhSS9LbjPLTWnX1MgLcSjh7RVkX3Kah+bhZ80NZeFljoDfVg36Y2txvW3wKzxEMi/C5f2SYI/8UBU8CgjAPSEqKj9EFyzB+gDmNZJ3dXg+aVVgyLtnGgW37it+MZUeTS0BCgD/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993665; c=relaxed/simple;
	bh=FH3gF+2F0FE6kPtZqlb9qT05ej73G94PvvRvMjHqbOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+65htCrN9kgK4M1W8hivBmm31lzZe6BF/Mz7HfVKNpyS+GpmTW6Ow+Pz2zjm5gYj5uwH+KqHdQggQzItQpIflnVFsNmEXv4zjlz8MFMd5T9GgD3H/3YAndj9Zjq6sK/cbpkCphrTwdPN3oUdpBtd9df5afOH5Bl13N6XMW5s0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9zhc2ax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9zhc2ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F8BC4CEED;
	Tue,  8 Jul 2025 16:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993664;
	bh=FH3gF+2F0FE6kPtZqlb9qT05ej73G94PvvRvMjHqbOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9zhc2axbO7YkP/WqD4HJ/xKS4YN41hTQfI26QSjqmO5HrJO22q02NnBrFtruwaV9
	 3/FscXCWbv2CGuVYvoyLvi2OuXEMUg1bJU3MhXqInEln5Nnv0gP6f9YletTwEP+ku1
	 APV6WH0plFC16dLA4VucYBd1XcJNGDXbYW4RX49I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.15 152/178] usb: dwc3: Abort suspend on soft disconnect failure
Date: Tue,  8 Jul 2025 18:23:09 +0200
Message-ID: <20250708162240.478983015@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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
@@ -2388,6 +2388,7 @@ static int dwc3_suspend_common(struct dw
 {
 	u32 reg;
 	int i;
+	int ret;
 
 	if (!pm_runtime_suspended(dwc->dev) && !PMSG_IS_AUTO(msg)) {
 		dwc->susphy_state = (dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0)) &
@@ -2406,7 +2407,9 @@ static int dwc3_suspend_common(struct dw
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
@@ -2441,7 +2444,9 @@ static int dwc3_suspend_common(struct dw
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
@@ -4821,26 +4821,22 @@ int dwc3_gadget_suspend(struct dwc3 *dwc
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


