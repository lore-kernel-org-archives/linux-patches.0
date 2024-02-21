Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D78169942;
	Wed, 21 Feb 2024 13:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523425; cv=none; b=SEB6Pjbfpghw3M1Sw0DD7phccVm1f/frrknmgSB5Mjyh2QI8WAUVgJGgoFoP28djodQBHOEEzlkO9e64HSDbFfEgpnd9vQBYrylCiuvyCbE+HqxZf9kr51gj+sGpITVzuBLXslkuloKDbrhaHYbNEjQEjMkEKkxXSH6rl+1/+hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523425; c=relaxed/simple;
	bh=VWA8FN3FxDxvIv43Bb+TZMASetBFy2ayGNgsm3O1gAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kBznJbsqpXwIx5vcD0amhiHFwpbH6ViwaeOTfH+57/pgOg7KZX497eu3LZydnWq5Stip1gSmJwhGsyPNHl8mY/ZLyYT/iJexsp1rLBa/uGj4O9WNGwjy46Akdf0SsTnNxH1DAYw2OLdiPtSzrVSRC1a7Z9KIt5BREn/ukMtOdxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfi/AmPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfi/AmPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF75DC433F1;
	Wed, 21 Feb 2024 13:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523425;
	bh=VWA8FN3FxDxvIv43Bb+TZMASetBFy2ayGNgsm3O1gAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfi/AmPBvdW4p9UToo50nUTemIQPz7PGc4lYTExUdf0DbGGbzGYbMo5PjnKF11e51
	 ONr/UF+vItQI0SZnuijv/SZLEGM9Nst8D/vD1ZhSjiPHZV3lA/tbKNi8YFArTZpAbV
	 LzugRYWhflyqOe3MVcn+remH0YD3rYwEITpss77Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 433/476] usb: dwc3: gadget: Wait for ep0 xfers to complete during dequeue
Date: Wed, 21 Feb 2024 14:08:04 +0100
Message-ID: <20240221130024.028870531@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit e4cf6580ac740f766dae26203bd6311d353dcd42 ]

If a Setup packet is received but yet to DMA out, the controller will
not process the End Transfer command of any endpoint. Polling of its
DEPCMD.CmdAct may block setting up TRB for Setup packet, causing a
command timeout.

This may occur if the driver doesn’t service the completion interrupt of
the control status stage yet due to system latency, then it won’t
prepare TRB and start the transfer for the next Setup Stage. To the host
side, the control transfer had completed, and the host can send a new
Setup packet at this point.

In the meanwhile, if the driver receives an async call to dequeue a
request (triggering End Transfer) to any endpoint, then the driver will
service that End transfer first, blocking the control status stage
completion handler. Since no TRB is available for the Setup stage, the
Setup packet can’t be DMA’ed out and the End Transfer gets hung.

The driver must not block setting up of the Setup stage. So track and
only issue the End Transfer command only when there’s Setup TRB prepared
so that the controller can DMA out the Setup packet. Delay the End
transfer command if there's no Setup TRB available. This is applicable to
all DWC_usb3x IPs.

Co-developed-by: Wesley Cheng <quic_wcheng@quicinc.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220309205402.4467-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 730e12fbec53 ("usb: dwc3: gadget: Handle EP0 request dequeuing properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.h   |  1 +
 drivers/usb/dwc3/ep0.c    | 14 ++++++++++++++
 drivers/usb/dwc3/gadget.c | 20 +++++++++++++++-----
 drivers/usb/dwc3/gadget.h |  1 +
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 3dcb5b744f7c..d64f7edc70c1 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -722,6 +722,7 @@ struct dwc3_ep {
 #define DWC3_EP_FIRST_STREAM_PRIMED	BIT(10)
 #define DWC3_EP_PENDING_CLEAR_STALL	BIT(11)
 #define DWC3_EP_TXFIFO_RESIZED		BIT(12)
+#define DWC3_EP_DELAY_STOP             BIT(13)
 
 	/* This last one is specific to EP0 */
 #define DWC3_EP0_DIR_IN		BIT(31)
diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 52f2bfae46bc..34cb8662e129 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -274,6 +274,7 @@ void dwc3_ep0_out_start(struct dwc3 *dwc)
 {
 	struct dwc3_ep			*dep;
 	int				ret;
+	int                             i;
 
 	complete(&dwc->ep0_in_setup);
 
@@ -282,6 +283,19 @@ void dwc3_ep0_out_start(struct dwc3 *dwc)
 			DWC3_TRBCTL_CONTROL_SETUP, false);
 	ret = dwc3_ep0_start_trans(dep);
 	WARN_ON(ret < 0);
+	for (i = 2; i < DWC3_ENDPOINTS_NUM; i++) {
+		struct dwc3_ep *dwc3_ep;
+
+		dwc3_ep = dwc->eps[i];
+		if (!dwc3_ep)
+			continue;
+
+		if (!(dwc3_ep->flags & DWC3_EP_DELAY_STOP))
+			continue;
+
+		dwc3_ep->flags &= ~DWC3_EP_DELAY_STOP;
+		dwc3_stop_active_transfer(dwc3_ep, true, true);
+	}
 }
 
 static struct dwc3_ep *dwc3_wIndex_to_dep(struct dwc3 *dwc, __le16 wIndex_le)
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 6188193e5ef4..3a663d71d791 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -641,9 +641,6 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep *dep, unsigned int action)
 	return dwc3_send_gadget_ep_cmd(dep, DWC3_DEPCMD_SETEPCONFIG, &params);
 }
 
-static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
-		bool interrupt);
-
 /**
  * dwc3_gadget_calc_tx_fifo_size - calculates the txfifo size value
  * @dwc: pointer to the DWC3 context
@@ -1891,6 +1888,7 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 	 */
 	if ((dep->flags & DWC3_EP_END_TRANSFER_PENDING) ||
 	    (dep->flags & DWC3_EP_WEDGE) ||
+	    (dep->flags & DWC3_EP_DELAY_STOP) ||
 	    (dep->flags & DWC3_EP_STALL)) {
 		dep->flags |= DWC3_EP_DELAY_START;
 		return 0;
@@ -2031,6 +2029,16 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 		if (r == req) {
 			struct dwc3_request *t;
 
+			/*
+			 * If a Setup packet is received but yet to DMA out, the controller will
+			 * not process the End Transfer command of any endpoint. Polling of its
+			 * DEPCMD.CmdAct may block setting up TRB for Setup packet, causing a
+			 * timeout. Delay issuing the End Transfer command until the Setup TRB is
+			 * prepared.
+			 */
+			if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status)
+				dep->flags |= DWC3_EP_DELAY_STOP;
+
 			/* wait until it is processed */
 			dwc3_stop_active_transfer(dep, true, true);
 
@@ -2114,7 +2122,8 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
 			dwc3_gadget_move_cancelled_request(req, DWC3_REQUEST_STATUS_STALLED);
 
-		if (dep->flags & DWC3_EP_END_TRANSFER_PENDING) {
+		if (dep->flags & DWC3_EP_END_TRANSFER_PENDING ||
+		    (dep->flags & DWC3_EP_DELAY_STOP)) {
 			dep->flags |= DWC3_EP_PENDING_CLEAR_STALL;
 			return 0;
 		}
@@ -3630,10 +3639,11 @@ static void dwc3_reset_gadget(struct dwc3 *dwc)
 	}
 }
 
-static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
+void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	bool interrupt)
 {
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
+	    (dep->flags & DWC3_EP_DELAY_STOP) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 		return;
 
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index 77df4b6d6c13..f763380e672e 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -116,6 +116,7 @@ int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 		gfp_t gfp_flags);
 int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol);
 void dwc3_ep0_send_delayed_status(struct dwc3 *dwc);
+void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt);
 
 /**
  * dwc3_gadget_ep_get_transfer_index - Gets transfer index from HW
-- 
2.43.0



