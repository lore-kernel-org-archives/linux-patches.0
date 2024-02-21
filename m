Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E27E55E5E;
	Wed, 21 Feb 2024 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523455; cv=none; b=Dhmpgd6b1E4L5XkxZwmIohBUDybYtGFqdSUPqVlfEO2VfdqAyzymfam/QFH57T4DIk83ojXwk9uJt/uT2oA5/7WSugRfgSs7qJSIF/r3J9HaL3O16d/zqF5smqkVJldSGB+Q0LLYg3OMoZlPYMDoddOc74yfmM1ZlUbZ4qwGVAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523455; c=relaxed/simple;
	bh=LlP3jfWLWiEYoeAxH+TwvrOaNFg1JB5nHvtcoS3eSKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+1HfLFQA0A6s7Ahc7nwi4vXc6RML0Cq3ZiwFroF3bvrxkFmPBmVn+HdH2aCSgO+gJLW6iE1qACQwuF9XxZO3v3Lft0gMmaUJXYjAEoe5y91c/mynrlyndgUeF7FeuQzbMgqJg40iKCoL8uk+KZJNLDK36KAyNhiF3ruuY87Hzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2K3pWq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2K3pWq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936DFC433F1;
	Wed, 21 Feb 2024 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523455;
	bh=LlP3jfWLWiEYoeAxH+TwvrOaNFg1JB5nHvtcoS3eSKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2K3pWq8PNqcBH3kDWTUmbYdb3WGH0a7SuzZtb6ETB/bogA6YuJ9XBxVASr9SK5IA
	 C+7PHOLzVPkXETZ/DotaxDrzcHuFVekJLHD9vVR5M7i/IlpCzTczLhdVhpIeyl4k0F
	 5W4KDzpM155eAM16HNegSM+Cl2DWCk3z6xP6GYkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/476] usb: dwc3: gadget: Stall and restart EP0 if host is unresponsive
Date: Wed, 21 Feb 2024 14:08:11 +0100
Message-ID: <20240221130024.303993266@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 02435a739b81ae24aff5d6e930efef9458e2af3c ]

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
Stable-dep-of: 730e12fbec53 ("usb: dwc3: gadget: Handle EP0 request dequeuing properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 49 +++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index c61b6f49701a..a74ac44c6cd8 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2459,29 +2459,17 @@ static int __dwc3_gadget_start(struct dwc3 *dwc);
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
@@ -2494,6 +2482,33 @@ static int dwc3_gadget_soft_disconnect(struct dwc3 *dwc)
 	__dwc3_gadget_stop(dwc);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
+	/*
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
 	/*
 	 * Note: if the GEVNTCOUNT indicates events in the event buffer, the
 	 * driver needs to acknowledge them before the controller can halt.
-- 
2.43.0



