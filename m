Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A2D78B70;
	Wed, 21 Feb 2024 13:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523441; cv=none; b=gAYzr+N+shO2YmkwHeOba0Y9spKOp/vTrvM/36y1ez8BCsMzJuzqh8kiUV1bMw8DxZY3TxnmwGeVK8oTOoSundy5UxZ1fjRO8gnPG08ozxG01mR29dLV8TQBlH5DQn9+u6zutJqanqcRU6gq3Vg1taw+kwkvmTBOkRXksisJNQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523441; c=relaxed/simple;
	bh=dJxDYqWIePra83pIldEGEc39cK5ewTTNJWYMaQ35dok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGqLONQl8BW6Ast1EiUf7oMUrxQNl9WmoJLMyVYlKL5OLx3mCNyYYB/EuHnE6esaO9c/K2X4gkqiiPhtazpdZvO0kQaVdVppCYHRZmQCCaUmeVtvYJJC1cQ4ZThUFlo9+2J+va05At5fA45PJEjb57yrdUM9Wp72uex21e71tJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=US0UcFYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="US0UcFYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447BDC433C7;
	Wed, 21 Feb 2024 13:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523440;
	bh=dJxDYqWIePra83pIldEGEc39cK5ewTTNJWYMaQ35dok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=US0UcFYcUSlAVhSeK9OtmZf5LbOwNqPlJAdyZhmzu+U3Sde0J98veN1poZl19qp9K
	 Yw/+XlymcoaX6l/gcqzgnQIscYNsrvhV+wW9yRfrDp5FfcVVrcag+TuK39jtQ+NPsf
	 g22Z2z93FyJfs0vRQXPtHpw/3hfAjE7bDEDzRoaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mayank Rana <quic_mrana@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/476] usb: dwc3: Fix ep0 handling when getting reset while doing control transfer
Date: Wed, 21 Feb 2024 14:08:08 +0100
Message-ID: <20240221130024.188309947@linuxfoundation.org>
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

From: Mayank Rana <quic_mrana@quicinc.com>

[ Upstream commit 9d778f0c5f95ca5aa2ff628ea281978697e8d89b ]

According to the databook ep0 should be in setup phase during reset.
If host issues reset between control transfers, ep0 will be  in an
invalid state. Fix this by issuing stall and restart on ep0 if it
is not in setup phase.

Also SW needs to complete pending control transfer and setup core for
next setup stage as per data book. Hence check ep0 state during reset
interrupt handling and make sure active transfers on ep0 out/in
endpoint are stopped by queuing ENDXFER command for that endpoint and
restart ep0 out again to receive next setup packet.

Signed-off-by: Mayank Rana <quic_mrana@quicinc.com>
Link: https://lore.kernel.org/r/1651693001-29891-1-git-send-email-quic_mrana@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 730e12fbec53 ("usb: dwc3: gadget: Handle EP0 request dequeuing properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/ep0.c    | 11 ++++++++---
 drivers/usb/dwc3/gadget.c | 27 +++++++++++++++++++++++++--
 drivers/usb/dwc3/gadget.h |  2 ++
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 624de23782b5..f402c66039af 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -218,7 +218,7 @@ int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 	return ret;
 }
 
-static void dwc3_ep0_stall_and_restart(struct dwc3 *dwc)
+void dwc3_ep0_stall_and_restart(struct dwc3 *dwc)
 {
 	struct dwc3_ep		*dep;
 
@@ -1090,13 +1090,18 @@ void dwc3_ep0_send_delayed_status(struct dwc3 *dwc)
 	__dwc3_ep0_do_control_status(dwc, dwc->eps[direction]);
 }
 
-static void dwc3_ep0_end_control_data(struct dwc3 *dwc, struct dwc3_ep *dep)
+void dwc3_ep0_end_control_data(struct dwc3 *dwc, struct dwc3_ep *dep)
 {
 	struct dwc3_gadget_ep_cmd_params params;
 	u32			cmd;
 	int			ret;
 
-	if (!dep->resource_index)
+	/*
+	 * For status/DATA OUT stage, TRB will be queued on ep0 out
+	 * endpoint for which resource index is zero. Hence allow
+	 * queuing ENDXFER command for ep0 out endpoint.
+	 */
+	if (!dep->resource_index && dep->number)
 		return;
 
 	cmd = DWC3_DEPCMD_ENDTRANSFER;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5cf2fb165a56..b978e42ace75 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -869,12 +869,13 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
 		reg |= DWC3_DALEPENA_EP(dep->number);
 		dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
+		dep->trb_dequeue = 0;
+		dep->trb_enqueue = 0;
+
 		if (usb_endpoint_xfer_control(desc))
 			goto out;
 
 		/* Initialize the TRB ring */
-		dep->trb_dequeue = 0;
-		dep->trb_enqueue = 0;
 		memset(dep->trb_pool, 0,
 		       sizeof(struct dwc3_trb) * DWC3_TRB_NUM);
 
@@ -2702,6 +2703,7 @@ static int __dwc3_gadget_start(struct dwc3 *dwc)
 
 	/* begin to receive SETUP packets */
 	dwc->ep0state = EP0_SETUP_PHASE;
+	dwc->ep0_bounced = false;
 	dwc->link_state = DWC3_LINK_STATE_SS_DIS;
 	dwc->delayed_status = false;
 	dwc3_ep0_out_start(dwc);
@@ -3790,6 +3792,27 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 	}
 
 	dwc3_reset_gadget(dwc);
+
+	/*
+	 * From SNPS databook section 8.1.2, the EP0 should be in setup
+	 * phase. So ensure that EP0 is in setup phase by issuing a stall
+	 * and restart if EP0 is not in setup phase.
+	 */
+	if (dwc->ep0state != EP0_SETUP_PHASE) {
+		unsigned int	dir;
+
+		dir = !!dwc->ep0_expect_in;
+		if (dwc->ep0state == EP0_DATA_PHASE)
+			dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
+		else
+			dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
+
+		dwc->eps[0]->trb_enqueue = 0;
+		dwc->eps[1]->trb_enqueue = 0;
+
+		dwc3_ep0_stall_and_restart(dwc);
+	}
+
 	/*
 	 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
 	 * Section 4.1.2 Table 4-2, it states that during a USB reset, the SW
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index f763380e672e..55a56cf67d73 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -110,6 +110,8 @@ void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 void dwc3_ep0_interrupt(struct dwc3 *dwc,
 		const struct dwc3_event_depevt *event);
 void dwc3_ep0_out_start(struct dwc3 *dwc);
+void dwc3_ep0_end_control_data(struct dwc3 *dwc, struct dwc3_ep *dep);
+void dwc3_ep0_stall_and_restart(struct dwc3 *dwc);
 int __dwc3_gadget_ep0_set_halt(struct usb_ep *ep, int value);
 int dwc3_gadget_ep0_set_halt(struct usb_ep *ep, int value);
 int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
-- 
2.43.0



