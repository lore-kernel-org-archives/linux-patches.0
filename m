Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D4E28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCB1C433D2;
	Mon, 12 Dec 2022 13:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850871;
	bh=RkGcC+L/o3C3T8U79kn4EvSY71fjlysQ/JfKQcONjdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCJal5h0UZcuL2asCWoeEaNTudh/0ASMc2PHnQjy+JAerriiFPdfT+hMZTtyvRZUb
	 Rc5VQKi1w6+8VtCQFjNH1lVweIZ2Lmv92vWa8taWx4trSxuR+79QfPxeRG+YRKQmBs
	 I0sJ5uJQ1nQ4pjBeFO46dVzlez09Y5yCWtK/wKAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/106] usb: dwc3: gadget: Disable GUSB2PHYCFG.SUSPHY for End Transfer
Date: Mon, 12 Dec 2022 14:09:27 +0100
Message-Id: <20221212130925.912373943@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 3aa07f72894d209fcf922ad686cbb28cf005aaad ]

If there's a disconnection while operating in eSS, there may be a delay
in VBUS drop response from the connector. In that case, the internal
link state may drop to operate in usb2 speed while the controller thinks
the VBUS is still high. The driver must make sure to disable
GUSB2PHYCFG.SUSPHY when sending endpoint command while in usb2 speed.
The End Transfer command may be called, and only that command needs to
go through at this point. Let's keep it simple and unconditionally
disable GUSB2PHYCFG.SUSPHY whenever we issue the command.

This scenario is not seen in real hardware. In a rare case, our
prototype type-c controller/interface may have a slow response
triggerring this issue.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/5651117207803c26e2f22ddf4e5ce9e865dcf7c7.1668045468.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index a9a43d649478..28a1194f849f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -291,7 +291,8 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned int cmd,
 	 *
 	 * DWC_usb3 3.30a and DWC_usb31 1.90a programming guide section 3.2.2
 	 */
-	if (dwc->gadget->speed <= USB_SPEED_HIGH) {
+	if (dwc->gadget->speed <= USB_SPEED_HIGH ||
+	    DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_ENDTRANSFER) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
 		if (unlikely(reg & DWC3_GUSB2PHYCFG_SUSPHY)) {
 			saved_config |= DWC3_GUSB2PHYCFG_SUSPHY;
-- 
2.35.1



