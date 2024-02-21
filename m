Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C54B69942;
	Wed, 21 Feb 2024 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523428; cv=none; b=Jd0oYxtRd3WM4Ytp7AAj8F9B4vt8C/34pPU7O1RHnuKMSQH9JUZTGWC4kNpFpzahXIe4hj1DfF86TfyBeIEmBXER6lvsHaGmSQRbfeSR/pDV/lt1hHgvbEO76PiCNxqtrXC0LHqgtG1ZQUwJKLRcGn1caxW06EGux37dgECmJVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523428; c=relaxed/simple;
	bh=2MccHK4rRYkxAtfr/eIS4wrJYVhkj4KUsg66OJq7l3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SY2L7kOlGntxlfdsUmMpoCji4XsBSLUgqXaOTVM4OIb88zBzIvP53mRroeLOd1+eSSRoLAPGpKFte95c6Raz8q4jVn+DkDKCjjF3Qbif5eeQu+YMUYJUA2XHRNfTxCT9KopgXU1DJLUEEXIsbdsU2wlWlw2evTInsMyW+SB1MeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVpbeLAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVpbeLAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EF1C433F1;
	Wed, 21 Feb 2024 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523428;
	bh=2MccHK4rRYkxAtfr/eIS4wrJYVhkj4KUsg66OJq7l3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVpbeLAh24D6SaFeMFN8sKA5nB6W4wvuE1Kd6o9GtC35QvzT6xsbclgZdlG2GVceX
	 1f/7N2/EmAaU+VtaMKNgIlwHUbv0XCLugSAtZO34jPZ7h4Th1vHSRHe5bVnh+1ZanM
	 vMxZEmWaI+7yoZRi5ptfyUWH9kWLC+314OiN6ZoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 434/476] usb: dwc3: ep0: Dont prepare beyond Setup stage
Date: Wed, 21 Feb 2024 14:08:05 +0100
Message-ID: <20240221130024.062116191@linuxfoundation.org>
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

[ Upstream commit c96683798e272366866a5c0ce3073c0b5a256db7 ]

Since we can't guarantee that the host won't send new Setup packet
before going through the device-initiated disconnect, don't prepare
beyond the Setup stage and keep the device in EP0_SETUP_PHASE. This
ensures that the device-initated disconnect sequence can go through
gracefully. Note that the controller won't service the End Transfer
command if it can't DMA out the Setup packet.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/6bacec56ecabb2c6e49a09cedfcac281fdc97de0.1650593829.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 730e12fbec53 ("usb: dwc3: gadget: Handle EP0 request dequeuing properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/ep0.c    |  2 +-
 drivers/usb/dwc3/gadget.c | 29 +++++++++++++++++------------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 34cb8662e129..624de23782b5 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -816,7 +816,7 @@ static void dwc3_ep0_inspect_setup(struct dwc3 *dwc,
 	int ret = -EINVAL;
 	u32 len;
 
-	if (!dwc->gadget_driver)
+	if (!dwc->gadget_driver || !dwc->connected)
 		goto out;
 
 	trace_dwc3_ctrl_req(ctrl);
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3a663d71d791..2afe6784f1df 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2472,6 +2472,23 @@ static int dwc3_gadget_soft_disconnect(struct dwc3 *dwc)
 	spin_lock_irqsave(&dwc->lock, flags);
 	dwc->connected = false;
 
+	/*
+	 * Per databook, when we want to stop the gadget, if a control transfer
+	 * is still in process, complete it and get the core into setup phase.
+	 */
+	if (dwc->ep0state != EP0_SETUP_PHASE) {
+		int ret;
+
+		reinit_completion(&dwc->ep0_in_setup);
+
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
+				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
+		spin_lock_irqsave(&dwc->lock, flags);
+		if (ret == 0)
+			dev_warn(dwc->dev, "timed out waiting for SETUP phase\n");
+	}
+
 	/*
 	 * In the Synopsys DesignWare Cores USB3 Databook Rev. 3.30a
 	 * Section 4.1.8 Table 4-7, it states that for a device-initiated
@@ -2516,18 +2533,6 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 	is_on = !!is_on;
 
 	dwc->softconnect = is_on;
-	/*
-	 * Per databook, when we want to stop the gadget, if a control transfer
-	 * is still in process, complete it and get the core into setup phase.
-	 */
-	if (!is_on && dwc->ep0state != EP0_SETUP_PHASE) {
-		reinit_completion(&dwc->ep0_in_setup);
-
-		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
-				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
-		if (ret == 0)
-			dev_warn(dwc->dev, "timed out waiting for SETUP phase\n");
-	}
 
 	/*
 	 * Avoid issuing a runtime resume if the device is already in the
-- 
2.43.0



