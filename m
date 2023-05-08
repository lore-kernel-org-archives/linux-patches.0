Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29070168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0828C433D2;
	Mon,  8 May 2023 09:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539485;
	bh=1GttUdO05eOqiqILDjILTE6gHNtRd1K7LBYF5cqMYSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUTYeyVssCPBTPUAcQ80I8CNTL3PY7beS6WYx8ocP6UOlaTCVoR5sSEhkKFGIL2p/
	 37EbwmwYqwNI+74ZWioTBBUx+ynE/kLR5yvKm05xubbim6fW00v+fvL2Y4etvmrSTH
	 FdVVOWzpDWCESEzgWOTF3KOaK+Fwvu/xEOUaCfs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>
Subject: [PATCH 6.1 032/611] usb: dwc3: gadget: Stall and restart EP0 if host is unresponsive
Date: Mon,  8 May 2023 11:37:54 +0200
Message-Id: <20230508094422.823114540@linuxfoundation.org>
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

From: Wesley Cheng <quic_wcheng@quicinc.com>

commit 02435a739b81ae24aff5d6e930efef9458e2af3c upstream.

It was observed that there are hosts that may complete pending SETUP
transactions before the stop active transfers and controller halt occurs,
leading to lingering endxfer commands on DEPs on subsequent pullup/gadget
start iterations.

  dwc3_gadget_ep_disable   name=ep8in flags=0x3009  direction=1
  dwc3_gadget_ep_disable   name=ep4in flags=1  direction=1
  dwc3_gadget_ep_disable   name=ep3out flags=1  direction=0
  usb_gadget_disconnect   deactivated=0  connected=0  ret=0

The sequence shows that the USB gadget disconnect (dwc3_gadget_pullup(0))
routine completed successfully, allowing for the USB gadget to proceed with
a USB gadget connect.  However, if this occurs the system runs into an
issue where:

  BUG: spinlock already unlocked on CPU
  spin_bug+0x0
  dwc3_remove_requests+0x278
  dwc3_ep0_out_start+0xb0
  __dwc3_gadget_start+0x25c

This is due to the pending endxfers, leading to gadget start (w/o lock
held) to execute the remove requests, which will unlock the dwc3
spinlock as part of giveback.

To mitigate this, resolve the pending endxfers on the pullup disable
path by re-locating the SETUP phase check after stop active transfers, since
that is where the DWC3_EP_DELAY_STOP is potentially set.  This also allows
for handling of a host that may be unresponsive by using the completion
timeout to trigger the stall and restart for EP0.

Fixes: c96683798e27 ("usb: dwc3: ep0: Don't prepare beyond Setup stage")
Cc: stable@vger.kernel.org
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20230413195742.11821-2-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   49 ++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2522,29 +2522,17 @@ static int __dwc3_gadget_start(struct dw
 static int dwc3_gadget_soft_disconnect(struct dwc3 *dwc)
 {
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(&dwc->lock, flags);
 	dwc->connected = false;
 
 	/*
-	 * Per databook, when we want to stop the gadget, if a control transfer
-	 * is still in process, complete it and get the core into setup phase.
+	 * Attempt to end pending SETUP status phase, and not wait for the
+	 * function to do so.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE) {
-		int ret;
-
-		if (dwc->delayed_status)
-			dwc3_ep0_send_delayed_status(dwc);
-
-		reinit_completion(&dwc->ep0_in_setup);
-
-		spin_unlock_irqrestore(&dwc->lock, flags);
-		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
-				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
-		spin_lock_irqsave(&dwc->lock, flags);
-		if (ret == 0)
-			dev_warn(dwc->dev, "timed out waiting for SETUP phase\n");
-	}
+	if (dwc->delayed_status)
+		dwc3_ep0_send_delayed_status(dwc);
 
 	/*
 	 * In the Synopsys DesignWare Cores USB3 Databook Rev. 3.30a
@@ -2558,6 +2546,33 @@ static int dwc3_gadget_soft_disconnect(s
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	/*
+	 * Per databook, when we want to stop the gadget, if a control transfer
+	 * is still in process, complete it and get the core into setup phase.
+	 * In case the host is unresponsive to a SETUP transaction, forcefully
+	 * stall the transfer, and move back to the SETUP phase, so that any
+	 * pending endxfers can be executed.
+	 */
+	if (dwc->ep0state != EP0_SETUP_PHASE) {
+		reinit_completion(&dwc->ep0_in_setup);
+
+		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
+				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
+		if (ret == 0) {
+			unsigned int    dir;
+
+			dev_warn(dwc->dev, "wait for SETUP phase timed out\n");
+			spin_lock_irqsave(&dwc->lock, flags);
+			dir = !!dwc->ep0_expect_in;
+			if (dwc->ep0state == EP0_DATA_PHASE)
+				dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
+			else
+				dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
+			dwc3_ep0_stall_and_restart(dwc);
+			spin_unlock_irqrestore(&dwc->lock, flags);
+		}
+	}
+
+	/*
 	 * Note: if the GEVNTCOUNT indicates events in the event buffer, the
 	 * driver needs to acknowledge them before the controller can halt.
 	 * Simply let the interrupt handler acknowledges and handle the


