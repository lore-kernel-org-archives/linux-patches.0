Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC55021767F;
	Tue, 12 Nov 2024 10:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408422; cv=none; b=c4qJAnc37OYqOpcIxuGxCkAAp5ih5wVSpSVNGdalMiHQaY/+JZB2qJhWNtFZbNfEPYQ40/PxBisNnB5dF/YBJHMQURpvulK8qYgZbvHha1oRFUDi5O0DLVsoUSTnr51855DifY7TP596yoYR1fnNpPJGDUuQTTeMQhhLlvOztJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408422; c=relaxed/simple;
	bh=wkP9abSYW8w3DbceFJbYZHzmeATDlCB4PDaOMCMtqoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFcV1OV90f1BiCq+NCM9EIWy1lK16HZBoSweg6BLsYzkstrNiNU21NfLDdVEzNsITsOznPA3FFCRffzzrWXuJ3kbGzN86OYl3VhLdyP605WNqKHORTrO86ymyFoyR08r4qnocLZ+C0f8QtwshozFuraOzEwhHHcImsGhTQbUbjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kkot+pTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kkot+pTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45166C4CECD;
	Tue, 12 Nov 2024 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408422;
	bh=wkP9abSYW8w3DbceFJbYZHzmeATDlCB4PDaOMCMtqoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kkot+pTBqsaBE0r7AoYKnghQ0D6/Bd/5y9FneLInX8okEqHzrDLSGTL8VdIJGB95H
	 XWKk+Qk5oaERib3oR7kKLLTOuRBKQS4hdm3IZYUAU8eZN90FC/zBmHBE3RrUg91YUS
	 ggskMKcEHX5HEQatFYt+GaEN/36582JusFD7I17s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William McVicker <willmcvicker@google.com>,
	Roger Quadros <rogerq@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.11 157/184] usb: dwc3: fix fault at system suspend if device was already runtime suspended
Date: Tue, 12 Nov 2024 11:21:55 +0100
Message-ID: <20241112101906.896999460@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@kernel.org>

commit 9cfb31e4c89d200d8ab7cb1e0bb9e6e8d621ca0b upstream.

If the device was already runtime suspended then during system suspend
we cannot access the device registers else it will crash.

Also we cannot access any registers after dwc3_core_exit() on some
platforms so move the dwc3_enable_susphy() call to the top.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: William McVicker <willmcvicker@google.com>
Closes: https://lore.kernel.org/all/ZyVfcUuPq56R2m1Y@google.com
Fixes: 705e3ce37bcc ("usb: dwc3: core: Fix system suspend on TI AM62 platforms")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Tested-by: Will McVicker <willmcvicker@google.com>
Link: https://lore.kernel.org/r/20241104-am62-lpm-usb-fix-v1-1-e93df73a4f0d@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -2342,10 +2342,18 @@ static int dwc3_suspend_common(struct dw
 	u32 reg;
 	int i;
 
-	dwc->susphy_state = (dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0)) &
-			    DWC3_GUSB2PHYCFG_SUSPHY) ||
-			    (dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0)) &
-			    DWC3_GUSB3PIPECTL_SUSPHY);
+	if (!pm_runtime_suspended(dwc->dev) && !PMSG_IS_AUTO(msg)) {
+		dwc->susphy_state = (dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0)) &
+				    DWC3_GUSB2PHYCFG_SUSPHY) ||
+				    (dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0)) &
+				    DWC3_GUSB3PIPECTL_SUSPHY);
+		/*
+		 * TI AM62 platform requires SUSPHY to be
+		 * enabled for system suspend to work.
+		 */
+		if (!dwc->susphy_state)
+			dwc3_enable_susphy(dwc, true);
+	}
 
 	switch (dwc->current_dr_role) {
 	case DWC3_GCTL_PRTCAP_DEVICE:
@@ -2398,15 +2406,6 @@ static int dwc3_suspend_common(struct dw
 		break;
 	}
 
-	if (!PMSG_IS_AUTO(msg)) {
-		/*
-		 * TI AM62 platform requires SUSPHY to be
-		 * enabled for system suspend to work.
-		 */
-		if (!dwc->susphy_state)
-			dwc3_enable_susphy(dwc, true);
-	}
-
 	return 0;
 }
 


