Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6181F8919;
	Tue,  3 Dec 2024 16:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242624; cv=none; b=YNug3i7WozfIPtWlOPO0cL4LiLJ/Gxd+BYRZ327+d7VZ/lSDGj873WoxqxYVaYeIJobTHh628o5dG8EJBMNPhDwe3aihWS23xBRMI2CwVroJxdyQ6iVOPT08owP4Sw02b/oROuDK3W8bfq6sczS0GYl9BkW3E/I7fMY1G4Y2woY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242624; c=relaxed/simple;
	bh=R9ABN/1hsXsm6/rUg/AQFbjgs7Iv15cUa0rvU9l3qh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtQipewzZwdUYYop3IHEBbMFl0vfB3N1zHepqeH9v2AEbVZnZsQSIDIk44z4oT2ooZFCEJkcLLelgoijx2aY3ohwhJQZpF4AMgDPS4pioJlp+NVX+tT0J47J++hO8JLBZG2niwUkaY8q977sJ4Tcj6DUh2D5llS57Q4VXTuovII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzYl1Wr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzYl1Wr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AADC4CECF;
	Tue,  3 Dec 2024 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242624;
	bh=R9ABN/1hsXsm6/rUg/AQFbjgs7Iv15cUa0rvU9l3qh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzYl1Wr9s7aPUgqfVKZitwFTbLi13Lia/9q0qry/KrB/lyZ8Edho3FukLN2aF1ZI7
	 kTOMhvsYlnyZ3frUY73xvS9/mVckujXJ7GRgZWkQMu+LrL6osdz8wrncK5GuvfXZdr
	 He8ZQ6A1ZrQboUMVNT29d1HoPxmxhBn9AGSqBbvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 760/826] usb: dwc3: gadget: Add missing check for single port RAM in TxFIFO resizing logic
Date: Tue,  3 Dec 2024 15:48:07 +0100
Message-ID: <20241203144813.411587631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

commit 61eb055cd3048ee01ca43d1be924167d33e16fdc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.h   |    4 +++
 drivers/usb/dwc3/gadget.c |   54 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 50 insertions(+), 8 deletions(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -915,6 +915,7 @@ struct dwc3_hwparams {
 #define DWC3_MODE(n)		((n) & 0x7)
 
 /* HWPARAMS1 */
+#define DWC3_SPRAM_TYPE(n)	(((n) >> 23) & 1)
 #define DWC3_NUM_INT(n)		(((n) & (0x3f << 15)) >> 15)
 
 /* HWPARAMS3 */
@@ -925,6 +926,9 @@ struct dwc3_hwparams {
 #define DWC3_NUM_IN_EPS(p)	(((p)->hwparams3 &		\
 			(DWC3_NUM_IN_EPS_MASK)) >> 18)
 
+/* HWPARAMS6 */
+#define DWC3_RAM0_DEPTH(n)	(((n) & (0xffff0000)) >> 16)
+
 /* HWPARAMS7 */
 #define DWC3_RAM1_DEPTH(n)	((n) & 0xffff)
 
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -688,6 +688,44 @@ static int dwc3_gadget_calc_tx_fifo_size
 }
 
 /**
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
+/**
  * dwc3_gadget_clear_tx_fifos - Clears txfifo allocation
  * @dwc: pointer to the DWC3 context
  *
@@ -753,7 +791,7 @@ static int dwc3_gadget_resize_tx_fifos(s
 {
 	struct dwc3 *dwc = dep->dwc;
 	int fifo_0_start;
-	int ram1_depth;
+	int ram_depth;
 	int fifo_size;
 	int min_depth;
 	int num_in_ep;
@@ -773,7 +811,7 @@ static int dwc3_gadget_resize_tx_fifos(s
 	if (dep->flags & DWC3_EP_TXFIFO_RESIZED)
 		return 0;
 
-	ram1_depth = DWC3_RAM1_DEPTH(dwc->hwparams.hwparams7);
+	ram_depth = dwc3_gadget_calc_ram_depth(dwc);
 
 	if ((dep->endpoint.maxburst > 1 &&
 	     usb_endpoint_xfer_bulk(dep->endpoint.desc)) ||
@@ -794,7 +832,7 @@ static int dwc3_gadget_resize_tx_fifos(s
 
 	/* Reserve at least one FIFO for the number of IN EPs */
 	min_depth = num_in_ep * (fifo + 1);
-	remaining = ram1_depth - min_depth - dwc->last_fifo_depth;
+	remaining = ram_depth - min_depth - dwc->last_fifo_depth;
 	remaining = max_t(int, 0, remaining);
 	/*
 	 * We've already reserved 1 FIFO per EP, so check what we can fit in
@@ -820,9 +858,9 @@ static int dwc3_gadget_resize_tx_fifos(s
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
@@ -3075,7 +3113,7 @@ static int dwc3_gadget_check_config(stru
 	struct dwc3 *dwc = gadget_to_dwc(g);
 	struct usb_ep *ep;
 	int fifo_size = 0;
-	int ram1_depth;
+	int ram_depth;
 	int ep_num = 0;
 
 	if (!dwc->do_fifo_resize)
@@ -3098,8 +3136,8 @@ static int dwc3_gadget_check_config(stru
 	fifo_size += dwc->max_cfg_eps;
 
 	/* Check if we can fit a single fifo per endpoint */
-	ram1_depth = DWC3_RAM1_DEPTH(dwc->hwparams.hwparams7);
-	if (fifo_size > ram1_depth)
+	ram_depth = dwc3_gadget_calc_ram_depth(dwc);
+	if (fifo_size > ram_depth)
 		return -ENOMEM;
 
 	return 0;


