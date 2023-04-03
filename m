Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343216FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA42C4339B;
	Mon,  3 Apr 2023 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532257;
	bh=lxeAhdouSg4Kf/eDdcDG5KNcYTMuUWkUK1LN+kqgtOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYLyJFgXs5dMENm67e5Ifmzjda1N4QfyRryw0PzAUxI3daOt1TBCzg6WmX/Wo56BP
	 nWMT9HLXxP4Cxa2SZvt7gGPlKMLGUpL5/+V4kkBQ2Yqz2DOrcBWmmG7yruLzq0FUyr
	 hhH67nPZ1Q9MxApjVh4V4gkGWmrSwUpSXu2tmfzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/99] usb: dwc3: gadget: move cmd_endtransfer to extra function
Date: Mon,  3 Apr 2023 16:08:25 +0200
Message-Id: <20230403140356.156533529@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit e192cc7b52399d1b073f88cd3ba128b74d3a57f1 ]

This patch adds the extra function __dwc3_stop_active_transfer to
consolidate the same codepath.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220306211251.2281335-3-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d8a2bb4eb758 ("usb: dwc3: gadget: Add 1ms delay after end transfer command without IOC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 69 +++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index a0100d26de8e1..1689c09b937ae 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1639,6 +1639,40 @@ static int __dwc3_gadget_get_frame(struct dwc3 *dwc)
 	return DWC3_DSTS_SOFFN(reg);
 }
 
+/**
+ * __dwc3_stop_active_transfer - stop the current active transfer
+ * @dep: isoc endpoint
+ * @force: set forcerm bit in the command
+ * @interrupt: command complete interrupt after End Transfer command
+ *
+ * When setting force, the ForceRM bit will be set. In that case
+ * the controller won't update the TRB progress on command
+ * completion. It also won't clear the HWO bit in the TRB.
+ * The command will also not complete immediately in that case.
+ */
+static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt)
+{
+	struct dwc3_gadget_ep_cmd_params params;
+	u32 cmd;
+	int ret;
+
+	cmd = DWC3_DEPCMD_ENDTRANSFER;
+	cmd |= force ? DWC3_DEPCMD_HIPRI_FORCERM : 0;
+	cmd |= interrupt ? DWC3_DEPCMD_CMDIOC : 0;
+	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
+	memset(&params, 0, sizeof(params));
+	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
+	WARN_ON_ONCE(ret);
+	dep->resource_index = 0;
+
+	if (!interrupt)
+		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
+	else if (!ret)
+		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
+
+	return ret;
+}
+
 /**
  * dwc3_gadget_start_isoc_quirk - workaround invalid frame number
  * @dep: isoc endpoint
@@ -1808,21 +1842,8 @@ static int __dwc3_gadget_start_isoc(struct dwc3_ep *dep)
 	 * status, issue END_TRANSFER command and retry on the next XferNotReady
 	 * event.
 	 */
-	if (ret == -EAGAIN) {
-		struct dwc3_gadget_ep_cmd_params params;
-		u32 cmd;
-
-		cmd = DWC3_DEPCMD_ENDTRANSFER |
-			DWC3_DEPCMD_CMDIOC |
-			DWC3_DEPCMD_PARAM(dep->resource_index);
-
-		dep->resource_index = 0;
-		memset(&params, 0, sizeof(params));
-
-		ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
-		if (!ret)
-			dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
-	}
+	if (ret == -EAGAIN)
+		ret = __dwc3_stop_active_transfer(dep, false, true);
 
 	return ret;
 }
@@ -3605,10 +3626,6 @@ static void dwc3_reset_gadget(struct dwc3 *dwc)
 static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	bool interrupt)
 {
-	struct dwc3_gadget_ep_cmd_params params;
-	u32 cmd;
-	int ret;
-
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 		return;
@@ -3640,19 +3657,7 @@ static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * This mode is NOT available on the DWC_usb31 IP.
 	 */
 
-	cmd = DWC3_DEPCMD_ENDTRANSFER;
-	cmd |= force ? DWC3_DEPCMD_HIPRI_FORCERM : 0;
-	cmd |= interrupt ? DWC3_DEPCMD_CMDIOC : 0;
-	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
-	memset(&params, 0, sizeof(params));
-	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
-	WARN_ON_ONCE(ret);
-	dep->resource_index = 0;
-
-	if (!interrupt)
-		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	else
-		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
+	__dwc3_stop_active_transfer(dep, force, interrupt);
 }
 
 static void dwc3_clear_stall_all_ep(struct dwc3 *dwc)
-- 
2.39.2



