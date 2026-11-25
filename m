Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626318;
	b=Zs5mcCpTCzbzQ+5pKp+6r4PA9ZviyK8TVQ7Smr0Ezzddh9xUJXSBMKnXtAkvIv1xNRlN
	 b0INriLd366UCTiAGcd+PXrSwmeGNafs3pqSwzh9xq1TbMsF7ObfrmVtfChWDPU6J7aUQ
	 LYB7co00ezygJeLRH+mneCQOX1dyUnxKCU2jVUefDMbHyETfS57EswciwioGihc6kOHxf
	 dANCRoMZiAVdSu73UMYiLJbnQj270diZExm5nB32U3ZmPWGWrdXnlLFaQFOB2bV5VEQBJ
	 UYVeaeIu8u0tNKeU2ChEmEwPw6c9w0vZnUAMGf1mObZsTFZsfQow4gQX7fW9+t7X89w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+U2VDOa4miK/cXNQGl/pXRTU6vD8RpPOLZa9HVD4prQ=;
	b=z4rMicMVBFMwX799NBnOg6lA7izhCHLyzgRjJsbCv2f+8ZCsm7ehRhqPPBByyQBEO0o3
	 GRbA++12qH4OsdbnxIeaI6667zewAQ4qCLdNnVDqkRhfWDjNAvnEtWdYbDfX8rhPk9Ji1
	 41cuGNy22qkVM699fKA2Qu+iKeulrr+Uf+dHMyCWNHKCPfntHqdzKUCxJXVz/GcRbHapH
	 YUnFil4cgsbI5PMptaTjISyKkHjBGe3aja0Aie/TKwkn/sqXNvX8XEwh4GJ/BBEx5otUr
	 u5b6rWLRDqcSgjK9zDbtDa401IDLxQSnMPmBrpLPqJQfLWehcP2OH3SoLu0alud+m6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NlrdQTdl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA96B606A323;
	Wed, 25 Nov 2026 17:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NlrdQTdl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9851F000C0;
	Wed, 25 Nov 2026 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626317;
	bh=+U2VDOa4miK/cXNQGl/pXRTU6vD8RpPOLZa9HVD4prQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlrdQTdlT6RybzIVNOb3PO6IX+4in8Wz9PJwCLaws1j8NeCOq4NCrwICfpK+RPtCS
	 u7CCEvIQPVxv4mFDsG7Hf8w9d6VMv2bnV3ADg3m/LRhQ2xABrNNNt86zBGpIf7D9gb
	 Io27utftwWh7xcSpSPqLYXJpCC2jLNhNUEtaWa2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 758/816] usb: dwc3: gadget: Wait for End Transfer completion on ep disable
Date: Wed, 25 Nov 2026 15:38:26 +0100
Message-ID: <20261125143906.719258256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 1338410c21a5710b7ba88057034d35367ba0f054 upstream.

The End Transfer command on ep disable is issued without interrupt, and
the endpoint flags are cleared right after a fixed delay. The command
may not have completed by then. If the function driver re-enables the
endpoint and queues a request, the next Start Transfer fails with "No
Resource".

Issue the End Transfer command with interrupt on ep disable, and keep
DWC3_EP_END_TRANSFER_PENDING and DWC3_EP_TRANSFER_STARTED until the
command completes. Defer the no-op Start Transfer of a stream endpoint
re-enabled in the meantime to the command completion.

Fixes: c5353b225df9 ("usb: dwc3: gadget: don't enable interrupt when disabling endpoint")
Cc: stable <stable@kernel.org>
Reported-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Closes: https://lore.kernel.org/linux-usb/20260227121236.963-1-selvarasu.g@samsung.com/
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/24fa8adeb0222dab415c8c2799405188440bad4b.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.h   |    4 +++-
 drivers/usb/dwc3/ep0.c    |    2 +-
 drivers/usb/dwc3/gadget.c |   42 +++++++++++++++++++++++++++++++++++-------
 3 files changed, 39 insertions(+), 9 deletions(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -771,6 +771,7 @@ struct dwc3_ep {
 #define DWC3_EP_TXFIFO_RESIZED		BIT(12)
 #define DWC3_EP_DELAY_STOP             BIT(13)
 #define DWC3_EP_RESOURCE_ALLOCATED	BIT(14)
+#define DWC3_EP_PENDING_NOOP_START	BIT(15)
 
 	/* This last one is specific to EP0 */
 #define DWC3_EP0_DIR_IN			BIT(31)
@@ -1662,7 +1663,8 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_
 int dwc3_send_gadget_generic_command(struct dwc3 *dwc, unsigned int cmd,
 		u32 param);
 void dwc3_gadget_clear_tx_fifos(struct dwc3 *dwc);
-void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep, int status);
+void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep, int status,
+			  bool interrupt);
 #else
 static inline int dwc3_gadget_init(struct dwc3 *dwc)
 { return 0; }
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -315,7 +315,7 @@ void dwc3_ep0_out_start(struct dwc3 *dwc
 		if (dwc->connected)
 			dwc3_stop_active_transfer(dwc3_ep, false, true);
 		else
-			dwc3_remove_requests(dwc, dwc3_ep, -ESHUTDOWN);
+			dwc3_remove_requests(dwc, dwc3_ep, -ESHUTDOWN, false);
 	}
 }
 
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1007,9 +1007,14 @@ static int __dwc3_gadget_ep_enable(struc
 	 * Response Update Transfer command.
 	 */
 	if (dep->stream_capable) {
-		ret = dwc3_gadget_ep_start_noop_transfer(dep);
-		if (ret < 0)
-			return ret;
+		if (dep->flags & (DWC3_EP_END_TRANSFER_PENDING |
+				  DWC3_EP_DELAY_STOP)) {
+			dep->flags |= DWC3_EP_PENDING_NOOP_START;
+		} else {
+			ret = dwc3_gadget_ep_start_noop_transfer(dep);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 out:
@@ -1018,16 +1023,21 @@ out:
 	return 0;
 }
 
-void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep, int status)
+void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep, int status,
+			  bool interrupt)
 {
 	struct dwc3_request		*req;
 
-	dwc3_stop_active_transfer(dep, false, false);
+	dwc3_stop_active_transfer(dep, false, interrupt);
 
 	/* If endxfer is delayed, avoid unmapping requests */
 	if (dep->flags & DWC3_EP_DELAY_STOP)
 		return;
 
+	/* Give the controller time to stop accessing the request buffers */
+	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING)
+		mdelay(1);
+
 	/* - giveback all requests to gadget driver */
 	while (!list_empty(&dep->started_list)) {
 		req = next_request(&dep->started_list);
@@ -1076,7 +1086,7 @@ static int __dwc3_gadget_ep_disable(stru
 
 	dep->flags &= ~DWC3_EP_ENABLED;
 
-	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
+	dwc3_remove_requests(dwc, dep, -ESHUTDOWN, true);
 
 	dep->stream_capable = false;
 	dep->type = 0;
@@ -1088,6 +1098,15 @@ static int __dwc3_gadget_ep_disable(stru
 	 */
 	if (dep->flags & DWC3_EP_DELAY_STOP)
 		mask |= (DWC3_EP_DELAY_STOP | DWC3_EP_TRANSFER_STARTED);
+
+	/*
+	 * The End Transfer command is still in progress.  Do not clear the
+	 * flags, so that the ep is only rearmed once the command completes.
+	 */
+	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING)
+		mask |= (DWC3_EP_END_TRANSFER_PENDING |
+			 DWC3_EP_TRANSFER_STARTED);
+
 	dep->flags &= mask;
 
 	/* Clear out the ep descriptors for non-ep0 */
@@ -2547,7 +2566,7 @@ static void dwc3_stop_active_transfers(s
 		if (!dep)
 			continue;
 
-		dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
+		dwc3_remove_requests(dwc, dep, -ESHUTDOWN, false);
 	}
 }
 
@@ -3878,7 +3897,16 @@ static void dwc3_gadget_endpoint_command
 			dwc3_ep0_send_delayed_status(dwc);
 	}
 
+	if (dep->flags & DWC3_EP_PENDING_NOOP_START) {
+		dep->flags &= ~DWC3_EP_PENDING_NOOP_START;
+
+		if (!(dep->flags & DWC3_EP_DELAY_START) &&
+		    (dep->flags & DWC3_EP_ENABLED))
+			dwc3_gadget_ep_start_noop_transfer(dep);
+	}
+
 	if ((dep->flags & DWC3_EP_DELAY_START) &&
+	    (dep->flags & DWC3_EP_ENABLED) &&
 	    !usb_endpoint_xfer_isoc(dep->endpoint.desc))
 		__dwc3_gadget_kick_transfer(dep);
 


