Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B64CA784;
	Wed, 30 Sep 2026 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789819; cv=none; b=nEZF9DTSu35QUitY9UIN18bjvjd5YUtfERTI4TjvY67IlHvlmhBC3SHUTOsQNDx3FgliRMoWllcuwZqbcOgF3XUdAQntHjOwvtDNEga3rvVd6Knx0VJENqBX/3RmPpbnXs5ualD/7AcNALAppSL3I6UWewqdv69NgzLfR9RpQ2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789819; c=relaxed/simple;
	bh=7vMnjgVmCo1sNX6uM1bvZxCqmnCizVk/SmtQFgHD5l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEaDV1qbNZkQtgrsJ4EOiU9r/SOkdRHvx1MsDQwxMinTmm3FAaG53h2Cq86Ds4A6ELMwWpAHaEWtAea5ArxsPjxjhQml4IhTa9wCwOb9kDDZQVmx0kD6zv4pHgDWUptQmSVwFKSdHheSAVFlps5cx2cSgDThC1U0S6g1UdX0oIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8zWuBdD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8zWuBdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7721F000FF;
	Wed, 30 Sep 2026 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789817;
	bh=kymO7So/PnFJIpSJ3iTxf6EVRZsQJyBAt/DfEJrX1g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8zWuBdDsMg9la1aO6ktxlj/tjjLBat4Xk4bYFy1QFOpi9MyitOFyUYhyLBm/nJKt
	 lAygLt1u9tdS1OG0df/ZxoFjFiuncNqq8w8lIowvWQkSkAWeqCFbrec2JMHBo0XYNN
	 EfhIwzmajTnJbtOuhYaXtb2nL+29clzlxz2M8WWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Elson Serrao <elson.serrao@oss.qualcomm.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 611/877] usb: dwc3: clear forceRM when issuing EndTransfer
Date: Wed, 30 Sep 2026 17:25:22 +0200
Message-ID: <20260930152427.839966792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Elson Serrao <elson.serrao@oss.qualcomm.com>

[ Upstream commit b58e6200450d350314db0ecda7d6d1bde3281e80 ]

The forceRM bit of the DEPCMD register controls the behavior of the
EndTransfer command used to stop an active transfer. Older DWC3
programming guide revisions recommended setting forceRM=1 when
issuing EndTransfer. Newer programming guide revisions recommend
issuing EndTransfer with forceRM cleared.

With forceRM=1 on DWC_usb31 v2.00a and v2.10a controllers, a transfer
aborted through the ep_dequeue path was observed to remain active
after EndTransfer completion. A subsequent StartTransfer issued on the
same endpoint triggered writes associated with the aborted transfer.
This resulted in an SMMU fault because the transfer buffer had already
been unmapped during EndTransfer command-completion cleanup.

Using forceRM=0 eliminates the issue. Although older DWC3 programming
guide revisions recommended setting forceRM=1, no issues are known
from using forceRM=0. Clear forceRM when issuing EndTransfer to provide
consistent EndTransfer behavior and align with newer programming guide
recommendations.

Fixes: 1e43c86d84fb ("usb: dwc3: core: Add DWC31 version 2.00a controller")
Cc: stable <stable@kernel.org>
Signed-off-by: Elson Serrao <elson.serrao@oss.qualcomm.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260813151456.867008-1-elson.serrao@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c    |    2 +-
 drivers/usb/dwc3/gadget.c |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -304,7 +304,7 @@ void dwc3_ep0_out_start(struct dwc3 *dwc
 
 		dwc3_ep->flags &= ~DWC3_EP_DELAY_STOP;
 		if (dwc->connected)
-			dwc3_stop_active_transfer(dwc3_ep, true, true);
+			dwc3_stop_active_transfer(dwc3_ep, false, true);
 		else
 			dwc3_remove_requests(dwc, dwc3_ep, -ESHUTDOWN);
 	}
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -991,7 +991,7 @@ static int __dwc3_gadget_ep_enable(struc
 			 * controller to generate an ERDY to initiate the
 			 * stream.
 			 */
-			dwc3_stop_active_transfer(dep, true, true);
+			dwc3_stop_active_transfer(dep, false, true);
 
 			/*
 			 * All stream eps will reinitiate stream on NoStream
@@ -1019,7 +1019,7 @@ void dwc3_remove_requests(struct dwc3 *d
 {
 	struct dwc3_request		*req;
 
-	dwc3_stop_active_transfer(dep, true, false);
+	dwc3_stop_active_transfer(dep, false, false);
 
 	/* If endxfer is delayed, avoid unmapping requests */
 	if (dep->flags & DWC3_EP_DELAY_STOP)
@@ -1709,7 +1709,7 @@ static int __dwc3_gadget_kick_transfer(s
 		if (ret == -EAGAIN)
 			return ret;
 
-		dwc3_stop_active_transfer(dep, true, true);
+		dwc3_stop_active_transfer(dep, false, true);
 
 		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
 			dwc3_gadget_move_cancelled_request(req, DWC3_REQUEST_STATUS_DEQUEUED);
@@ -1746,6 +1746,11 @@ static int __dwc3_gadget_get_frame(struc
  * the controller won't update the TRB progress on command
  * completion. It also won't clear the HWO bit in the TRB.
  * The command will also not complete immediately in that case.
+ *
+ * Older programming guide revisions recommended setting ForceRM to 1
+ * when ending a transfer. Newer programming guide revisions now
+ * recommend keeping ForceRM cleared, and TRBs are properly updated
+ * on command completion.
  */
 static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt)
 {
@@ -1871,7 +1876,7 @@ static int dwc3_gadget_start_isoc_quirk(
 		 * to wait for the next XferNotReady to test the command again
 		 */
 		if (cmd_status == 0) {
-			dwc3_stop_active_transfer(dep, true, true);
+			dwc3_stop_active_transfer(dep, false, true);
 			return 0;
 		}
 	}
@@ -2154,7 +2159,7 @@ static int dwc3_gadget_ep_dequeue(struct
 			struct dwc3_request *t;
 
 			/* wait until it is processed */
-			dwc3_stop_active_transfer(dep, true, true);
+			dwc3_stop_active_transfer(dep, false, true);
 
 			/*
 			 * Remove any started request if the transfer is
@@ -2231,7 +2236,7 @@ int __dwc3_gadget_ep_set_halt(struct dwc
 			return 0;
 		}
 
-		dwc3_stop_active_transfer(dep, true, true);
+		dwc3_stop_active_transfer(dep, false, true);
 
 		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
 			dwc3_gadget_move_cancelled_request(req, DWC3_REQUEST_STATUS_STALLED);
@@ -3343,7 +3348,7 @@ static void dwc3_nostream_work(struct wo
 		dwc3_send_gadget_generic_command(dwc, cmd, dep->number);
 	} else {
 		dep->flags |= DWC3_EP_DELAY_START;
-		dwc3_stop_active_transfer(dep, true, true);
+		dwc3_stop_active_transfer(dep, false, true);
 		spin_unlock_irqrestore(&dwc->lock, flags);
 		return;
 	}
@@ -3687,7 +3692,7 @@ static bool dwc3_gadget_endpoint_trbs_co
 	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
 		list_empty(&dep->started_list) &&
 		(list_empty(&dep->pending_list) || status == -EXDEV))
-		dwc3_stop_active_transfer(dep, true, true);
+		dwc3_stop_active_transfer(dep, false, true);
 	else if (dwc3_gadget_ep_should_continue(dep))
 		if (__dwc3_gadget_kick_transfer(dep) == 0)
 			no_started_trb = false;


