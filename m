Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3634F218;
	Thu, 12 Dec 2024 15:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017679; cv=none; b=e0qCy1GCLURYR3vxFMZT1CM0t2Yv8oWShjTvM9GICplJq7xNrhKY8SYRdU/A2pEedGPs9CMSnlXMCLzZNyHw2Gu3gwy36HGby31tBMl6nG0BUWsfJ245Fq/BBEVSRCenAX/2kJ84cPmWFCd8wa3r+KW+ssuGQ9r4+TEZFVp8nPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017679; c=relaxed/simple;
	bh=p3BPJek5hK2ZiUDA9vlndKQeGEQYOY+FsMzK9decrnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ8C3WNDtqeTIZSEqJ32ArZeLP0zwRPoHfOX5/GDZC3ovHF/GqeAfDS65H4L3HkR5y0pd4daYL8POQZI8zefBUw/JweXsYPB2wHw3JmjKhvdgrqJ3Fd7jeH5LoYoGZXBw0eZZHgUqBZAJbcij9l/TRmplhzZviQyxujE5TDynJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzLFcECT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzLFcECT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB17C4CECE;
	Thu, 12 Dec 2024 15:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017679;
	bh=p3BPJek5hK2ZiUDA9vlndKQeGEQYOY+FsMzK9decrnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzLFcECTbYED402Jdck7lO/vmiZxbVI4KrqCTCQsndb5M+vJlEQccQ93sGUBd3/O+
	 eORDI0wiFaz+P07f+73xt15j5CoCBWKYolsGwGogA+rEbKc0qz1QOQcWAWBbwoiAcR
	 P/o/52Em23SKdBfpFqlbKzo6hOa6wUCrJ2/DlHys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/356] usb: dwc3: gadget: Rewrite endpoint allocation flow
Date: Thu, 12 Dec 2024 15:56:39 +0100
Message-ID: <20241212144247.784191989@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit b311048c174da893f47fc09439bc1f6fa2a29589 ]

The driver dwc3 deviates from the programming guide in regard to
endpoint configuration. It does this command sequence:

DEPSTARTCFG -> DEPXFERCFG -> DEPCFG

Instead of the suggested flow:

DEPSTARTCFG -> DEPCFG -> DEPXFERCFG

The reasons for this deviation were as follow, quoted:

	1) The databook says to do %DWC3_DEPCMD_DEPSTARTCFG for every
	   %USB_REQ_SET_CONFIGURATION and %USB_REQ_SET_INTERFACE
	   (8.1.5). This is incorrect in the scenario of multiple
	   interfaces.

	2) The databook does not mention doing more
	   %DWC3_DEPCMD_DEPXFERCFG for new endpoint on alt setting
	   (8.1.6).

Regarding 1), DEPSTARTCFG resets the endpoints' resource and can be a
problem if used with SET_INTERFACE request of a multiple interface
configuration. But we can still satisfy the programming guide
requirement by assigning the endpoint resource as part of
usb_ep_enable(). We will only reset endpoint resources on controller
initialization and SET_CONFIGURATION request.

Regarding 2), the later versions of the programming guide were updated
to clarify this flow (see "Alternate Initialization on SetInterface
Request" of the programming guide). As long as the platform has enough
physical endpoints, we can assign resource to a new endpoint.

The order of the command sequence will not be a problem to most
platforms for the current implementation of the dwc3 driver. However,
this order is required in different scenarios (such as initialization
during controller's hibernation restore). Let's keep the flow consistent
and follow the programming guide.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/c143583a5afb087deb8c3aa5eb227ee23515f272.1706754219.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 5d2fb074dea2 ("usb: dwc3: ep0: Don't clear ep0 DWC3_EP_TRANSFER_STARTED")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.h   |  1 +
 drivers/usb/dwc3/ep0.c    |  1 +
 drivers/usb/dwc3/gadget.c | 89 +++++++++++++++++----------------------
 drivers/usb/dwc3/gadget.h |  1 +
 4 files changed, 41 insertions(+), 51 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 3325796f3cb45..b118f4aab1898 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -751,6 +751,7 @@ struct dwc3_ep {
 #define DWC3_EP_PENDING_CLEAR_STALL	BIT(11)
 #define DWC3_EP_TXFIFO_RESIZED		BIT(12)
 #define DWC3_EP_DELAY_STOP             BIT(13)
+#define DWC3_EP_RESOURCE_ALLOCATED	BIT(14)
 
 	/* This last one is specific to EP0 */
 #define DWC3_EP0_DIR_IN			BIT(31)
diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 6ae8a36f21cf6..72bb722da2f25 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -646,6 +646,7 @@ static int dwc3_ep0_set_config(struct dwc3 *dwc, struct usb_ctrlrequest *ctrl)
 		return -EINVAL;
 
 	case USB_STATE_ADDRESS:
+		dwc3_gadget_start_config(dwc, 2);
 		dwc3_gadget_clear_tx_fifos(dwc);
 
 		ret = dwc3_ep0_delegate_req(dwc, ctrl);
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 9971076c31de6..b560996bd4218 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -516,77 +516,56 @@ static void dwc3_free_trb_pool(struct dwc3_ep *dep)
 static int dwc3_gadget_set_xfer_resource(struct dwc3_ep *dep)
 {
 	struct dwc3_gadget_ep_cmd_params params;
+	int ret;
+
+	if (dep->flags & DWC3_EP_RESOURCE_ALLOCATED)
+		return 0;
 
 	memset(&params, 0x00, sizeof(params));
 
 	params.param0 = DWC3_DEPXFERCFG_NUM_XFER_RES(1);
 
-	return dwc3_send_gadget_ep_cmd(dep, DWC3_DEPCMD_SETTRANSFRESOURCE,
+	ret = dwc3_send_gadget_ep_cmd(dep, DWC3_DEPCMD_SETTRANSFRESOURCE,
 			&params);
+	if (ret)
+		return ret;
+
+	dep->flags |= DWC3_EP_RESOURCE_ALLOCATED;
+	return 0;
 }
 
 /**
- * dwc3_gadget_start_config - configure ep resources
- * @dep: endpoint that is being enabled
- *
- * Issue a %DWC3_DEPCMD_DEPSTARTCFG command to @dep. After the command's
- * completion, it will set Transfer Resource for all available endpoints.
- *
- * The assignment of transfer resources cannot perfectly follow the data book
- * due to the fact that the controller driver does not have all knowledge of the
- * configuration in advance. It is given this information piecemeal by the
- * composite gadget framework after every SET_CONFIGURATION and
- * SET_INTERFACE. Trying to follow the databook programming model in this
- * scenario can cause errors. For two reasons:
- *
- * 1) The databook says to do %DWC3_DEPCMD_DEPSTARTCFG for every
- * %USB_REQ_SET_CONFIGURATION and %USB_REQ_SET_INTERFACE (8.1.5). This is
- * incorrect in the scenario of multiple interfaces.
- *
- * 2) The databook does not mention doing more %DWC3_DEPCMD_DEPXFERCFG for new
- * endpoint on alt setting (8.1.6).
- *
- * The following simplified method is used instead:
+ * dwc3_gadget_start_config - reset endpoint resources
+ * @dwc: pointer to the DWC3 context
+ * @resource_index: DEPSTARTCFG.XferRscIdx value (must be 0 or 2)
  *
- * All hardware endpoints can be assigned a transfer resource and this setting
- * will stay persistent until either a core reset or hibernation. So whenever we
- * do a %DWC3_DEPCMD_DEPSTARTCFG(0) we can go ahead and do
- * %DWC3_DEPCMD_DEPXFERCFG for every hardware endpoint as well. We are
- * guaranteed that there are as many transfer resources as endpoints.
+ * Set resource_index=0 to reset all endpoints' resources allocation. Do this as
+ * part of the power-on/soft-reset initialization.
  *
- * This function is called for each endpoint when it is being enabled but is
- * triggered only when called for EP0-out, which always happens first, and which
- * should only happen in one of the above conditions.
+ * Set resource_index=2 to reset only non-control endpoints' resources. Do this
+ * on receiving the SET_CONFIGURATION request or hibernation resume.
  */
-static int dwc3_gadget_start_config(struct dwc3_ep *dep)
+int dwc3_gadget_start_config(struct dwc3 *dwc, unsigned int resource_index)
 {
 	struct dwc3_gadget_ep_cmd_params params;
-	struct dwc3		*dwc;
 	u32			cmd;
 	int			i;
 	int			ret;
 
-	if (dep->number)
-		return 0;
+	if (resource_index != 0 && resource_index != 2)
+		return -EINVAL;
 
 	memset(&params, 0x00, sizeof(params));
 	cmd = DWC3_DEPCMD_DEPSTARTCFG;
-	dwc = dep->dwc;
+	cmd |= DWC3_DEPCMD_PARAM(resource_index);
 
-	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
+	ret = dwc3_send_gadget_ep_cmd(dwc->eps[0], cmd, &params);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < DWC3_ENDPOINTS_NUM; i++) {
-		struct dwc3_ep *dep = dwc->eps[i];
-
-		if (!dep)
-			continue;
-
-		ret = dwc3_gadget_set_xfer_resource(dep);
-		if (ret)
-			return ret;
-	}
+	/* Reset resource allocation flags */
+	for (i = resource_index; i < dwc->num_eps && dwc->eps[i]; i++)
+		dwc->eps[i]->flags &= ~DWC3_EP_RESOURCE_ALLOCATED;
 
 	return 0;
 }
@@ -881,16 +860,18 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
 		ret = dwc3_gadget_resize_tx_fifos(dep);
 		if (ret)
 			return ret;
-
-		ret = dwc3_gadget_start_config(dep);
-		if (ret)
-			return ret;
 	}
 
 	ret = dwc3_gadget_set_ep_config(dep, action);
 	if (ret)
 		return ret;
 
+	if (!(dep->flags & DWC3_EP_RESOURCE_ALLOCATED)) {
+		ret = dwc3_gadget_set_xfer_resource(dep);
+		if (ret)
+			return ret;
+	}
+
 	if (!(dep->flags & DWC3_EP_ENABLED)) {
 		struct dwc3_trb	*trb_st_hw;
 		struct dwc3_trb	*trb_link;
@@ -1044,7 +1025,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	dep->stream_capable = false;
 	dep->type = 0;
-	mask = DWC3_EP_TXFIFO_RESIZED;
+	mask = DWC3_EP_TXFIFO_RESIZED | DWC3_EP_RESOURCE_ALLOCATED;
 	/*
 	 * dwc3_remove_requests() can exit early if DWC3 EP delayed stop is
 	 * set.  Do not clear DEP flags, so that the end transfer command will
@@ -2909,6 +2890,12 @@ static int __dwc3_gadget_start(struct dwc3 *dwc)
 	/* Start with SuperSpeed Default */
 	dwc3_gadget_ep0_desc.wMaxPacketSize = cpu_to_le16(512);
 
+	ret = dwc3_gadget_start_config(dwc, 0);
+	if (ret) {
+		dev_err(dwc->dev, "failed to config endpoints\n");
+		return ret;
+	}
+
 	dep = dwc->eps[0];
 	dep->flags = 0;
 	ret = __dwc3_gadget_ep_enable(dep, DWC3_DEPCFG_ACTION_INIT);
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index 55a56cf67d736..d73e735e40810 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -119,6 +119,7 @@ int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol);
 void dwc3_ep0_send_delayed_status(struct dwc3 *dwc);
 void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt);
+int dwc3_gadget_start_config(struct dwc3 *dwc, unsigned int resource_index);
 
 /**
  * dwc3_gadget_ep_get_transfer_index - Gets transfer index from HW
-- 
2.43.0



