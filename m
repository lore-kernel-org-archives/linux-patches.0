Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34FD157A72;
	Mon,  6 Jan 2025 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176981; cv=none; b=lYjtxfd/TJe66liwlMcUXuBLtm6YCyV7QdTY4PKUednSJz1U6vp1SeO9O9am2XfwiwS1btsxrA6dMhZ5AtP/Ut5+ZFGe9v1cFyQC7NyyFcZ3As3MkQAcXhltJKJq7DCZvZLOZ5t4LHjc+V5YBKW+4UP9adnyME5te/eBl8WwV6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176981; c=relaxed/simple;
	bh=oAVrGcKtDO1iUAFcj+GMCPCm6R1CSiQauU3l4dQPOUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDaL05gjxR2fFdmHHkEdclVRW1NK5TXFAmnsYdc7z+4TgAzMWK8IdVbrkooJmSMBHfUO9cghFnWMpLIyJ6E3NlZMcF9+ApZ//thWhRlSxfYO879HQ7426CHDNtjZnRteJHDtfaoUR0Uvb5eVeljPU0kvZSOhZhGepDuEfWWQYho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljUpPnJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljUpPnJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAA3C4CED6;
	Mon,  6 Jan 2025 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176981;
	bh=oAVrGcKtDO1iUAFcj+GMCPCm6R1CSiQauU3l4dQPOUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljUpPnJCSa8OGCSDXjsOo78ClQWzt7pQo1gqSVzCtkE+a2wxLUiN21z0/3/xTqOwL
	 +TEbNyVp48Ke5y5I2IAL5dVtMm26OO6uO7Jg3Z3pyV95ATLShRorqjnD4QoLttljsy
	 mkT+gGvKiL6LFNKzeJlqkntEcf0l6YO894QieEyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/222] usb: dwc3: gadget: Add missing check for single port RAM in TxFIFO resizing logic
Date: Mon,  6 Jan 2025 16:13:36 +0100
Message-ID: <20250106151151.063927335@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

[ Upstream commit 61eb055cd3048ee01ca43d1be924167d33e16fdc ]

The existing implementation of the TxFIFO resizing logic only supports
scenarios where more than one port RAM is used. However, there is a need
to resize the TxFIFO in USB2.0-only mode where only a single port RAM is
available. This commit introduces the necessary changes to support
TxFIFO resizing in such scenarios by adding a missing check for single
port RAM.

This fix addresses certain platform configurations where the existing
TxFIFO resizing logic does not work properly due to the absence of
support for single port RAM. By adding this missing check, we ensure
that the TxFIFO resizing logic works correctly in all scenarios,
including those with a single port RAM.

Fixes: 9f607a309fbe ("usb: dwc3: Resize TX FIFOs to meet EP bursting requirements")
Cc: stable@vger.kernel.org # 6.12.x: fad16c82: usb: dwc3: gadget: Refine the logic for resizing Tx FIFOs
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20241112044807.623-1-selvarasu.g@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.h   |  4 +++
 drivers/usb/dwc3/gadget.c | 54 +++++++++++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index b118f4aab189..d00bf714a7cc 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -899,6 +899,7 @@ struct dwc3_hwparams {
 #define DWC3_MODE(n)		((n) & 0x7)
 
 /* HWPARAMS1 */
+#define DWC3_SPRAM_TYPE(n)	(((n) >> 23) & 1)
 #define DWC3_NUM_INT(n)		(((n) & (0x3f << 15)) >> 15)
 
 /* HWPARAMS3 */
@@ -909,6 +910,9 @@ struct dwc3_hwparams {
 #define DWC3_NUM_IN_EPS(p)	(((p)->hwparams3 &		\
 			(DWC3_NUM_IN_EPS_MASK)) >> 18)
 
+/* HWPARAMS6 */
+#define DWC3_RAM0_DEPTH(n)	(((n) & (0xffff0000)) >> 16)
+
 /* HWPARAMS7 */
 #define DWC3_RAM1_DEPTH(n)	((n) & 0xffff)
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index b560996bd421..656460c0c1dd 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -687,6 +687,44 @@ static int dwc3_gadget_calc_tx_fifo_size(struct dwc3 *dwc, int mult)
 	return fifo_size;
 }
 
+/**
+ * dwc3_gadget_calc_ram_depth - calculates the ram depth for txfifo
+ * @dwc: pointer to the DWC3 context
+ */
+static int dwc3_gadget_calc_ram_depth(struct dwc3 *dwc)
+{
+	int ram_depth;
+	int fifo_0_start;
+	bool is_single_port_ram;
+
+	/* Check supporting RAM type by HW */
+	is_single_port_ram = DWC3_SPRAM_TYPE(dwc->hwparams.hwparams1);
+
+	/*
+	 * If a single port RAM is utilized, then allocate TxFIFOs from
+	 * RAM0. otherwise, allocate them from RAM1.
+	 */
+	ram_depth = is_single_port_ram ? DWC3_RAM0_DEPTH(dwc->hwparams.hwparams6) :
+			DWC3_RAM1_DEPTH(dwc->hwparams.hwparams7);
+
+	/*
+	 * In a single port RAM configuration, the available RAM is shared
+	 * between the RX and TX FIFOs. This means that the txfifo can begin
+	 * at a non-zero address.
+	 */
+	if (is_single_port_ram) {
+		u32 reg;
+
+		/* Check if TXFIFOs start at non-zero addr */
+		reg = dwc3_readl(dwc->regs, DWC3_GTXFIFOSIZ(0));
+		fifo_0_start = DWC3_GTXFIFOSIZ_TXFSTADDR(reg);
+
+		ram_depth -= (fifo_0_start >> 16);
+	}
+
+	return ram_depth;
+}
+
 /**
  * dwc3_gadget_clear_tx_fifos - Clears txfifo allocation
  * @dwc: pointer to the DWC3 context
@@ -753,7 +791,7 @@ static int dwc3_gadget_resize_tx_fifos(struct dwc3_ep *dep)
 {
 	struct dwc3 *dwc = dep->dwc;
 	int fifo_0_start;
-	int ram1_depth;
+	int ram_depth;
 	int fifo_size;
 	int min_depth;
 	int num_in_ep;
@@ -773,7 +811,7 @@ static int dwc3_gadget_resize_tx_fifos(struct dwc3_ep *dep)
 	if (dep->flags & DWC3_EP_TXFIFO_RESIZED)
 		return 0;
 
-	ram1_depth = DWC3_RAM1_DEPTH(dwc->hwparams.hwparams7);
+	ram_depth = dwc3_gadget_calc_ram_depth(dwc);
 
 	if ((dep->endpoint.maxburst > 1 &&
 	     usb_endpoint_xfer_bulk(dep->endpoint.desc)) ||
@@ -794,7 +832,7 @@ static int dwc3_gadget_resize_tx_fifos(struct dwc3_ep *dep)
 
 	/* Reserve at least one FIFO for the number of IN EPs */
 	min_depth = num_in_ep * (fifo + 1);
-	remaining = ram1_depth - min_depth - dwc->last_fifo_depth;
+	remaining = ram_depth - min_depth - dwc->last_fifo_depth;
 	remaining = max_t(int, 0, remaining);
 	/*
 	 * We've already reserved 1 FIFO per EP, so check what we can fit in
@@ -820,9 +858,9 @@ static int dwc3_gadget_resize_tx_fifos(struct dwc3_ep *dep)
 		dwc->last_fifo_depth += DWC31_GTXFIFOSIZ_TXFDEP(fifo_size);
 
 	/* Check fifo size allocation doesn't exceed available RAM size. */
-	if (dwc->last_fifo_depth >= ram1_depth) {
+	if (dwc->last_fifo_depth >= ram_depth) {
 		dev_err(dwc->dev, "Fifosize(%d) > RAM size(%d) %s depth:%d\n",
-			dwc->last_fifo_depth, ram1_depth,
+			dwc->last_fifo_depth, ram_depth,
 			dep->endpoint.name, fifo_size);
 		if (DWC3_IP_IS(DWC3))
 			fifo_size = DWC3_GTXFIFOSIZ_TXFDEP(fifo_size);
@@ -3078,7 +3116,7 @@ static int dwc3_gadget_check_config(struct usb_gadget *g)
 	struct dwc3 *dwc = gadget_to_dwc(g);
 	struct usb_ep *ep;
 	int fifo_size = 0;
-	int ram1_depth;
+	int ram_depth;
 	int ep_num = 0;
 
 	if (!dwc->do_fifo_resize)
@@ -3101,8 +3139,8 @@ static int dwc3_gadget_check_config(struct usb_gadget *g)
 	fifo_size += dwc->max_cfg_eps;
 
 	/* Check if we can fit a single fifo per endpoint */
-	ram1_depth = DWC3_RAM1_DEPTH(dwc->hwparams.hwparams7);
-	if (fifo_size > ram1_depth)
+	ram_depth = dwc3_gadget_calc_ram_depth(dwc);
+	if (fifo_size > ram_depth)
 		return -ENOMEM;
 
 	return 0;
-- 
2.39.5



