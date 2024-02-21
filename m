Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61217BB01;
	Wed, 21 Feb 2024 13:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523435; cv=none; b=JMRxLM1zoPZmHaDoHmdpCdlWBcGj0NH/uiCjdXAXiTvZa8ZESte8Md8Cce+U21fH/EArZF4sipe1dloDIZ0h7VhxJ7A//xe2S3jp2pr59LR/8XRWykCty/+ZKv4Y9ahHt+dlGkfFqyIe/0BYn4xnJBY6c6/xPLKkcSKegoYJ/44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523435; c=relaxed/simple;
	bh=NcNiIDeksB+8HI3imukBz4JFb7c/39qWVprYVCx95HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qtu3vPvnT4K1XnDEzSa0UpVDxKjlAOnbNK6aLRNhLbWnKsLDw+1Ca7YxFs3wMvaivZ+40jPGo0RDecrurM/y1rLynZu8EBOJ2fLijPmRR3qrr/+l/j2cML0ZxWzcMqCrtG+CJkVSYeS2XTjADN8sRc+gCnkig9dORIdesz14ZUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3BY0vPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3BY0vPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270C1C433C7;
	Wed, 21 Feb 2024 13:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523434;
	bh=NcNiIDeksB+8HI3imukBz4JFb7c/39qWVprYVCx95HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3BY0vPGr6JYDV2MxEbMwVGZVbBi4cdG3nepEjTTqzs8mjGnwWlM4zCEvygQeKeym
	 3CGYAZwaa8y1/SlCE1kXdyCUFXW/hWPo6uhafb1vyu9w5wnZl3St/bPmykQQTXRUGn
	 cUEplNyEZp6xaNC/oKE5IDnROLeD+yub9Ur8Zh58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/476] usb: dwc3: gadget: Delay issuing End Transfer
Date: Wed, 21 Feb 2024 14:08:07 +0100
Message-ID: <20240221130024.155860682@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit f66eef8fb8989a7193cafc3870f7c7b2b97f16cb ]

If the controller hasn't DMA'ed the Setup data from its fifo, it won't
process the End Transfer command. Polling for the command completion may
block the driver from servicing the Setup phase and cause a timeout.
Previously we only check and delay issuing End Transfer in the case of
endpoint dequeue. Let's do that for all End Transfer scenarios.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/2fcf3b5d90068d549589a57a27a79f76c6769b04.1650593829.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 730e12fbec53 ("usb: dwc3: gadget: Handle EP0 request dequeuing properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 4d830ba7d824..5cf2fb165a56 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2029,16 +2029,6 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 		if (r == req) {
 			struct dwc3_request *t;
 
-			/*
-			 * If a Setup packet is received but yet to DMA out, the controller will
-			 * not process the End Transfer command of any endpoint. Polling of its
-			 * DEPCMD.CmdAct may block setting up TRB for Setup packet, causing a
-			 * timeout. Delay issuing the End Transfer command until the Setup TRB is
-			 * prepared.
-			 */
-			if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status)
-				dep->flags |= DWC3_EP_DELAY_STOP;
-
 			/* wait until it is processed */
 			dwc3_stop_active_transfer(dep, true, true);
 
@@ -3663,6 +3653,18 @@ void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 		return;
 
+	/*
+	 * If a Setup packet is received but yet to DMA out, the controller will
+	 * not process the End Transfer command of any endpoint. Polling of its
+	 * DEPCMD.CmdAct may block setting up TRB for Setup packet, causing a
+	 * timeout. Delay issuing the End Transfer command until the Setup TRB is
+	 * prepared.
+	 */
+	if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status) {
+		dep->flags |= DWC3_EP_DELAY_STOP;
+		return;
+	}
+
 	/*
 	 * NOTICE: We are violating what the Databook says about the
 	 * EndTransfer command. Ideally we would _always_ wait for the
-- 
2.43.0



