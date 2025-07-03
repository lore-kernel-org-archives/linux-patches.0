Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786EE2EE97A;
	Thu,  3 Jul 2025 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555496; cv=none; b=g1TXWle567aL5tFaQxI8Wo2SaGvIIo8XOEWURsh3OS2Sx8gKA0cM83pq694cgopB/298geXy7aR7Mk7R1IJ5OWpleHVcFCqLfRa7hdSb/7TlIAQFGZhEyij3mVSheIiBPj+IpUEZg7uL4cC6XeIum5DMLowBWCg4aX6Ul+8HVUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555496; c=relaxed/simple;
	bh=AtEKIzYUt5j5gJfkxXJ06dSTm30EaQkkKZxndW6kTGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTdP11hS05nQNS3t2UT6ORv5ue7HTEfEI/Uc8DdsjXZ6v0lufo1jMIpaaGDYB/zJrV9BzTWpb1Qr99BfjFky25g0ACevOQbYtwGyB+YQRpmz9FtCuKkvH7iefV3+1tSNKyGYpQj28DiRkXJ2WKz+2QvqK+vCKCajeskyeeoHA1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBjcb32l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBjcb32l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E538CC4CEE3;
	Thu,  3 Jul 2025 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555496;
	bh=AtEKIzYUt5j5gJfkxXJ06dSTm30EaQkkKZxndW6kTGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBjcb32lIsvzZK0gkwNjkap/aT1lWO/bdcK83Hw6bLtHBn5wbeQpsgsEXcMeEkIjf
	 /A5jdUdqwsnhGvuVgVXcSiXomjhOAlLHudGJE3cvcQ+2lI2ENvJSiVVTSDOtoQv9e5
	 w0I2B8kRQhHM6unwjBUT6ABq8b9igF7U+Zu/qpYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Minas Harutyunyan <hminas@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/139] usb: dwc2: also exit clock_gating when stopping udc while suspended
Date: Thu,  3 Jul 2025 16:41:33 +0200
Message-ID: <20250703143942.363766910@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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
index ce20c06a90253..c0db3c52831a2 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4601,6 +4601,12 @@ static int dwc2_hsotg_udc_stop(struct usb_gadget *gadget)
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



