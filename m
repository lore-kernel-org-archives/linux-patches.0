Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1048F5E;
	Tue,  8 Jul 2025 16:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993778; cv=none; b=RT7T/vYSrI3m/7bxE1g0LTpVMNH7SfpXHz8VScVFsshAkDwuA9MwvrVlI9VT0IaQRdRZl6/VRLIXKjT63xMXOQzZ2QeXpN8r2tDVtmrucPFlkfEgH0Nhy3TXsRQNmxcj+N6Jt/z+RRW8dji9RM9jVtVlDnMjeQ3e7Met+WG2/x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993778; c=relaxed/simple;
	bh=BFwVwBMDzkNs5aOlV5wZWt/D2CjGnwmiK9FLtK8B+Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqHQuG0rw1sPx5tqDfAW+se7HXPmeKpllBTCFaGvrhpWNX2LowiXSay7HU0D9b7yjP7v0Q2QD+ytv5jgq5YGCID6+0dIqpYFLbrtDy2Mli0pyevLrRm9BKv69sCtFmqE+95AFMUY0+nffmx7gyAuKpm+j88A/jMjk3GOiepW+Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fs5cm3SA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fs5cm3SA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81A3C4CEED;
	Tue,  8 Jul 2025 16:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993778;
	bh=BFwVwBMDzkNs5aOlV5wZWt/D2CjGnwmiK9FLtK8B+Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fs5cm3SAAjfiKSbnux6VRMkeE3dF7RmngMVXxKxvZqJxdpIPNDuA0Kku7LfgUkNfk
	 SI09ZysGBt0ha+ermG7yD7wNlYycnKBT1Qv5Mrd1O+LTIUA3MLxuLqEOEf6kj1V8F+
	 CffQdlQbh2NsCUR6B/s4gv91Eg1MPEqak+8BkHpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Minas Harutyunyan <hminas@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/160] usb: dwc2: also exit clock_gating when stopping udc while suspended
Date: Tue,  8 Jul 2025 18:20:52 +0200
Message-ID: <20250708162231.929277214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit af076a41f8a28faf9ceb9dd2d88aef2c202ef39a ]

It is possible that the gadget will be disabled, while the udc is
suspended. When enabling the udc in that case, the clock gating
will not be enabled again. Leaving the phy unclocked. Even when the
udc is not enabled, connecting this powered but not clocked phy leads
to enumeration errors on the host side.

To ensure that the clock gating will be in an valid state, we ensure
that the clock gating will be enabled before stopping the udc.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Link: https://lore.kernel.org/r/20250417-dwc2_clock_gating-v1-1-8ea7c4d53d73@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 7d8523398e191..525d1d0cfc249 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4602,6 +4602,12 @@ static int dwc2_hsotg_udc_stop(struct usb_gadget *gadget)
 	if (!hsotg)
 		return -ENODEV;
 
+	/* Exit clock gating when driver is stopped. */
+	if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
+	    hsotg->bus_suspended && !hsotg->params.no_clock_gating) {
+		dwc2_gadget_exit_clock_gating(hsotg, 0);
+	}
+
 	/* all endpoints should be shutdown */
 	for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 		if (hsotg->eps_in[ep])
-- 
2.39.5



