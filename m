Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC541DF754;
	Mon, 12 May 2025 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072980; cv=none; b=efn7Hb2mwVJVb2SCjMM5gsQ6XtvhkxylZNKytovDzkIYTAsPBNhc0JjOQkofXIz2kgKE1EdzUZnCknrehYZk7MJA++yzHVD88j1fQrAMohIsxGkSu4RPvFlJCQmgNwPMyoJl2LY8yyybKNPd7BDrzPJfDr/B8jJ69IPKFWk2ghM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072980; c=relaxed/simple;
	bh=CdgnZHW8H9by2KwPNh/etlLtSRu20hLEWzPqaScotbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igxfEbmv6l/NVOHzR7ZCQzMmBEDuwhn1meiei0qqpt8ayVQKiZmtbkrPe3CEv71McLzgTupfW73Z5ZhXkPi5kJ6Fhrhk2GBWI/FGJ3e0KqVP4im3496wP0tvt1zpHd8Aq+a61EXLPxfCdmKiwmZwzfFywpa8Jnc2Ia7dbrdlwLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FfREc1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FfREc1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508FCC4CEE7;
	Mon, 12 May 2025 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072979;
	bh=CdgnZHW8H9by2KwPNh/etlLtSRu20hLEWzPqaScotbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FfREc1B6nB3Q9ZfOE9QtlntfiImCxZabCQbgOgdjm+rMchJDIZY08ttt6eEq12jl
	 +tafMrJOgQ9g8W9/kTBO4gtJf1EEpwaR4G+ZPugerg9DpywHYukwVrq4vrlCI+O6Wo
	 KVarPbQQAacnHQselbZ0j3Wp1RBXjjDqte/+LvH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 116/184] usb: dwc3: gadget: Make gadget_wakeup asynchronous
Date: Mon, 12 May 2025 19:45:17 +0200
Message-ID: <20250512172046.552464824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 2372f1caeca433c4c01c2482f73fbe057f5168ce upstream.

Currently gadget_wakeup() waits for U0 synchronously if it was
called from func_wakeup(), this is because we need to send the
function wakeup command soon after the link is active. And the
call is made synchronous by polling DSTS continuosly for 20000
times in __dwc3_gadget_wakeup(). But it observed that sometimes
the link is not active even after polling 20K times, leading to
remote wakeup failures. Adding a small delay between each poll
helps, but that won't guarantee resolution in future. Hence make
the gadget_wakeup completely asynchronous.

Since multiple interfaces can issue a function wakeup at once,
add a new variable wakeup_pending_funcs which will indicate the
functions that has issued func_wakup, this is represented in a
bitmap format. If the link is in U3, dwc3_gadget_func_wakeup()
will set the bit corresponding to interface_id and bail out.
Once link comes back to U0, linksts_change irq is triggered,
where the function wakeup command is sent based on bitmap.

Cc: stable <stable@kernel.org>
Fixes: 92c08a84b53e ("usb: dwc3: Add function suspend and function wakeup support")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250422103231.1954387-4-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.h   |    4 +++
 drivers/usb/dwc3/gadget.c |   60 +++++++++++++++++-----------------------------
 2 files changed, 27 insertions(+), 37 deletions(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1168,6 +1168,9 @@ struct dwc3_scratchpad_array {
  * @gsbuscfg0_reqinfo: store GSBUSCFG0.DATRDREQINFO, DESRDREQINFO,
  *		       DATWRREQINFO, and DESWRREQINFO value passed from
  *		       glue driver.
+ * @wakeup_pending_funcs: Indicates whether any interface has requested for
+ *			 function wakeup in bitmap format where bit position
+ *			 represents interface_id.
  */
 struct dwc3 {
 	struct work_struct	drd_work;
@@ -1398,6 +1401,7 @@ struct dwc3 {
 	int			num_ep_resized;
 	struct dentry		*debug_root;
 	u32			gsbuscfg0_reqinfo;
+	u32			wakeup_pending_funcs;
 };
 
 #define INCRX_BURST_MODE 0
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -277,8 +277,6 @@ int dwc3_send_gadget_generic_command(str
 	return ret;
 }
 
-static int __dwc3_gadget_wakeup(struct dwc3 *dwc, bool async);
-
 /**
  * dwc3_send_gadget_ep_cmd - issue an endpoint command
  * @dep: the endpoint to which the command is going to be issued
@@ -2348,10 +2346,8 @@ static int dwc3_gadget_get_frame(struct
 	return __dwc3_gadget_get_frame(dwc);
 }
 
-static int __dwc3_gadget_wakeup(struct dwc3 *dwc, bool async)
+static int __dwc3_gadget_wakeup(struct dwc3 *dwc)
 {
-	int			retries;
-
 	int			ret;
 	u32			reg;
 
@@ -2379,8 +2375,7 @@ static int __dwc3_gadget_wakeup(struct d
 		return -EINVAL;
 	}
 
-	if (async)
-		dwc3_gadget_enable_linksts_evts(dwc, true);
+	dwc3_gadget_enable_linksts_evts(dwc, true);
 
 	ret = dwc3_gadget_set_link_state(dwc, DWC3_LINK_STATE_RECOV);
 	if (ret < 0) {
@@ -2399,27 +2394,8 @@ static int __dwc3_gadget_wakeup(struct d
 
 	/*
 	 * Since link status change events are enabled we will receive
-	 * an U0 event when wakeup is successful. So bail out.
+	 * an U0 event when wakeup is successful.
 	 */
-	if (async)
-		return 0;
-
-	/* poll until Link State changes to ON */
-	retries = 20000;
-
-	while (retries--) {
-		reg = dwc3_readl(dwc->regs, DWC3_DSTS);
-
-		/* in HS, means ON */
-		if (DWC3_DSTS_USBLNKST(reg) == DWC3_LINK_STATE_U0)
-			break;
-	}
-
-	if (DWC3_DSTS_USBLNKST(reg) != DWC3_LINK_STATE_U0) {
-		dev_err(dwc->dev, "failed to send remote wakeup\n");
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -2440,7 +2416,7 @@ static int dwc3_gadget_wakeup(struct usb
 		spin_unlock_irqrestore(&dwc->lock, flags);
 		return -EINVAL;
 	}
-	ret = __dwc3_gadget_wakeup(dwc, true);
+	ret = __dwc3_gadget_wakeup(dwc);
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
@@ -2468,14 +2444,10 @@ static int dwc3_gadget_func_wakeup(struc
 	 */
 	link_state = dwc3_gadget_get_link_state(dwc);
 	if (link_state == DWC3_LINK_STATE_U3) {
-		ret = __dwc3_gadget_wakeup(dwc, false);
-		if (ret) {
-			spin_unlock_irqrestore(&dwc->lock, flags);
-			return -EINVAL;
-		}
-		dwc3_resume_gadget(dwc);
-		dwc->suspended = false;
-		dwc->link_state = DWC3_LINK_STATE_U0;
+		dwc->wakeup_pending_funcs |= BIT(intf_id);
+		ret = __dwc3_gadget_wakeup(dwc);
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		return ret;
 	}
 
 	ret = dwc3_send_gadget_generic_command(dwc, DWC3_DGCMD_DEV_NOTIFICATION,
@@ -4320,6 +4292,8 @@ static void dwc3_gadget_linksts_change_i
 {
 	enum dwc3_link_state	next = evtinfo & DWC3_LINK_STATE_MASK;
 	unsigned int		pwropt;
+	int			ret;
+	int			intf_id;
 
 	/*
 	 * WORKAROUND: DWC3 < 2.50a have an issue when configured without
@@ -4395,7 +4369,7 @@ static void dwc3_gadget_linksts_change_i
 
 	switch (next) {
 	case DWC3_LINK_STATE_U0:
-		if (dwc->gadget->wakeup_armed) {
+		if (dwc->gadget->wakeup_armed || dwc->wakeup_pending_funcs) {
 			dwc3_gadget_enable_linksts_evts(dwc, false);
 			dwc3_resume_gadget(dwc);
 			dwc->suspended = false;
@@ -4418,6 +4392,18 @@ static void dwc3_gadget_linksts_change_i
 	}
 
 	dwc->link_state = next;
+
+	/* Proceed with func wakeup if any interfaces that has requested */
+	while (dwc->wakeup_pending_funcs && (next == DWC3_LINK_STATE_U0)) {
+		intf_id = ffs(dwc->wakeup_pending_funcs) - 1;
+		ret = dwc3_send_gadget_generic_command(dwc, DWC3_DGCMD_DEV_NOTIFICATION,
+						       DWC3_DGCMDPAR_DN_FUNC_WAKE |
+						       DWC3_DGCMDPAR_INTF_SEL(intf_id));
+		if (ret)
+			dev_err(dwc->dev, "Failed to send DN wake for intf %d\n", intf_id);
+
+		dwc->wakeup_pending_funcs &= ~BIT(intf_id);
+	}
 }
 
 static void dwc3_gadget_suspend_interrupt(struct dwc3 *dwc,


