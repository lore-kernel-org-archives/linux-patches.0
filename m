Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031B9168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79848C433D2;
	Mon,  8 May 2023 10:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540539;
	bh=e9Hy3WyXCvO+inDwzw0IUhXfCZEF145FMdZ9nPigEKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ey/r1fKW8BY1pzy9VWB/n949Gz0BCkZ1699sGjZ4wdwnA1tg6qo/hLKnloOarRUXA
	 xGKq0eMtsUnw/EOQTzc+6P2i1zI4W3f9PP43b/QeWbWh38kkBU82wAXF0uTz0oqECq
	 UJkvluz+1ka58da6QYq+zfc67yVCXvT4eidLjbQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 403/611] usb: dwc3: gadget: Change condition for processing suspend event
Date: Mon,  8 May 2023 11:44:05 +0200
Message-Id: <20230508094435.369573114@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prashanth K <quic_prashk@quicinc.com>

[ Upstream commit 4decf4060ecfee1f7a710999fcd421645ac0c419 ]

Currently we process the suspend interrupt event only if the
device is in configured state. Consider a case where device
is not configured and got suspend interrupt, in that case our
gadget will still use 100mA as composite_suspend didn't happen.
But battery charging specification (BC1.2) expects a downstream
device to draw less than 2.5mA when unconnected OR suspended.

Fix this by removing the condition for processing suspend event,
and thus composite_resume would set vbus draw to 2.

Fixes: 72704f876f50 ("dwc3: gadget: Implement the suspend entry event handler")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/1677217619-10261-2-git-send-email-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 79627ee761c25..d2622378ce040 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4252,15 +4252,8 @@ static void dwc3_gadget_interrupt(struct dwc3 *dwc,
 		break;
 	case DWC3_DEVICE_EVENT_SUSPEND:
 		/* It changed to be suspend event for version 2.30a and above */
-		if (!DWC3_VER_IS_PRIOR(DWC3, 230A)) {
-			/*
-			 * Ignore suspend event until the gadget enters into
-			 * USB_STATE_CONFIGURED state.
-			 */
-			if (dwc->gadget->state >= USB_STATE_CONFIGURED)
-				dwc3_gadget_suspend_interrupt(dwc,
-						event->event_info);
-		}
+		if (!DWC3_VER_IS_PRIOR(DWC3, 230A))
+			dwc3_gadget_suspend_interrupt(dwc, event->event_info);
 		break;
 	case DWC3_DEVICE_EVENT_SOF:
 	case DWC3_DEVICE_EVENT_ERRATIC_ERROR:
-- 
2.39.2



