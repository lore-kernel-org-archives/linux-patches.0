Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149562590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6BEC433D2;
	Sun, 22 Jan 2023 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400699;
	bh=UBcKzpUIyAczdqfCWH+BOhYLnA8vlr5uTUMyxJiba68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIaJffilefLlh7/1T077Y4XZbrH8oqy5qnJHXNiBq5rjb/rb99qA8+T3eRRgV4VQc
	 50q7XNna+b+vEuLVimvnk1vu8JcLQ15YWQHGhwLmGldSByshPqZM2+sri/ocGq+EdG
	 EzrSjE0PzL3lbAHvqdXWINJEePIbJ1IkRrJFYpt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 076/117] usb: cdns3: remove fetched trb from cache before dequeuing
Date: Sun, 22 Jan 2023 16:04:26 +0100
Message-Id: <20230122150235.954119331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pawel Laszczak <pawell@cadence.com>

commit 1301c7b9f7efad2f11ef924e317c18ebd714fc9a upstream.

After doorbell DMA fetches the TRB. If during dequeuing request
driver changes NORMAL TRB to LINK TRB but doesn't delete it from
controller cache then controller will handle cached TRB and packet
can be lost.

The example scenario for this issue looks like:
1. queue request - set doorbell
2. dequeue request
3. send OUT data packet from host
4. Device will accept this packet which is unexpected
5. queue new request - set doorbell
6. Device lost the expected packet.

By setting DFLUSH controller clears DRDY bit and stop DMA transfer.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20221115100039.441295-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2610,6 +2610,7 @@ int cdns3_gadget_ep_dequeue(struct usb_e
 	u8 req_on_hw_ring = 0;
 	unsigned long flags;
 	int ret = 0;
+	int val;
 
 	if (!ep || !request || !ep->desc)
 		return -EINVAL;
@@ -2645,6 +2646,13 @@ found:
 
 	/* Update ring only if removed request is on pending_req_list list */
 	if (req_on_hw_ring && link_trb) {
+		/* Stop DMA */
+		writel(EP_CMD_DFLUSH, &priv_dev->regs->ep_cmd);
+
+		/* wait for DFLUSH cleared */
+		readl_poll_timeout_atomic(&priv_dev->regs->ep_cmd, val,
+					  !(val & EP_CMD_DFLUSH), 1, 1000);
+
 		link_trb->buffer = cpu_to_le32(TRB_BUFFER(priv_ep->trb_pool_dma +
 			((priv_req->end_trb + 1) * TRB_SIZE)));
 		link_trb->control = cpu_to_le32((le32_to_cpu(link_trb->control) & TRB_CYCLE) |
@@ -2656,6 +2664,10 @@ found:
 
 	cdns3_gadget_giveback(priv_ep, priv_req, -ECONNRESET);
 
+	req = cdns3_next_request(&priv_ep->pending_req_list);
+	if (req)
+		cdns3_rearm_transfer(priv_ep, 1);
+
 not_found:
 	spin_unlock_irqrestore(&priv_dev->lock, flags);
 	return ret;


