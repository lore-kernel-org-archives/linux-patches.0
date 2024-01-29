Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2182715AAD7;
	Mon, 29 Jan 2024 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548181; cv=none; b=glikUYCkqUOiOLjrTbgkhX1XBLG0pUnJc1DivQamfDlda/KsfP7GkxcaYJZaVguaQjPddGtMjItNtudXVWyG5DqxALgDW0iNhx9rF3XP8F/0tkZPzNvXXFhh9k1vIDhF5sXFbiDe6DLAokuC8dfbuC0UQXNHyBylKhqfXwYuXnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548181; c=relaxed/simple;
	bh=i/L77O4AR806kyX4YLc0D2J05VhQWlkwHPQirAuC9aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7Uyj6bcWiCaTwdC+te82yy3suK982yRaE9KSINXbiIqYwc/xLiQge6noEh+FgbHjxS/ZgyX+snAI798d6fxk3a9CHFocC+AP06SHX3MAdzdDlciRJDtPxwuiwGa639veFiKDPQtumW4wHLhcvK9XUZKMMVcyn9LHbSnqIVdGg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIfjW9BI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIfjW9BI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE943C433C7;
	Mon, 29 Jan 2024 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548181;
	bh=i/L77O4AR806kyX4YLc0D2J05VhQWlkwHPQirAuC9aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIfjW9BITZHoKCDlRV78gFFAJnK/0yoUWz+ZcSjzoUDWLgGjinzxNR/pon/zs+Jv/
	 KSSS2PphTiD9oDW1gFACFWKOcqb1dOwBYJJr79/GwHLAx3zXAOai8qZCtc4JEJnRhp
	 w6fTmDelVQHxZLKhd55aIW24Yf3QMtp8Zupk6qHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/185] usb: dwc3: gadget: Refactor EP0 forced stall/restart into a separate API
Date: Mon, 29 Jan 2024 09:03:21 -0800
Message-ID: <20240129165958.647131995@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 8f40fc0808137c157dd408d2632e63bfca2aecdb ]

Several sequences utilize the same routine for forcing the control endpoint
back into the SETUP phase.  This is required, because those operations need
to ensure that EP0 is back in the default state.

Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20230420212759.29429-3-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3c7af52c7616 ("usb: dwc3: gadget: Queue PM runtime idle on disconnect event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 53 ++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 137602d9076f..339e8c3f7c50 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -139,6 +139,24 @@ int dwc3_gadget_set_link_state(struct dwc3 *dwc, enum dwc3_link_state state)
 	return -ETIMEDOUT;
 }
 
+static void dwc3_ep0_reset_state(struct dwc3 *dwc)
+{
+	unsigned int	dir;
+
+	if (dwc->ep0state != EP0_SETUP_PHASE) {
+		dir = !!dwc->ep0_expect_in;
+		if (dwc->ep0state == EP0_DATA_PHASE)
+			dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
+		else
+			dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
+
+		dwc->eps[0]->trb_enqueue = 0;
+		dwc->eps[1]->trb_enqueue = 0;
+
+		dwc3_ep0_stall_and_restart(dwc);
+	}
+}
+
 /**
  * dwc3_ep_inc_trb - increment a trb index.
  * @index: Pointer to the TRB index to increment.
@@ -2552,16 +2570,9 @@ static int dwc3_gadget_soft_disconnect(struct dwc3 *dwc)
 		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
 				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
 		if (ret == 0) {
-			unsigned int    dir;
-
 			dev_warn(dwc->dev, "wait for SETUP phase timed out\n");
 			spin_lock_irqsave(&dwc->lock, flags);
-			dir = !!dwc->ep0_expect_in;
-			if (dwc->ep0state == EP0_DATA_PHASE)
-				dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
-			else
-				dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
-			dwc3_ep0_stall_and_restart(dwc);
+			dwc3_ep0_reset_state(dwc);
 			spin_unlock_irqrestore(&dwc->lock, flags);
 		}
 	}
@@ -3848,16 +3859,7 @@ static void dwc3_gadget_disconnect_interrupt(struct dwc3 *dwc)
 	dwc->setup_packet_pending = false;
 	usb_gadget_set_state(dwc->gadget, USB_STATE_NOTATTACHED);
 
-	if (dwc->ep0state != EP0_SETUP_PHASE) {
-		unsigned int    dir;
-
-		dir = !!dwc->ep0_expect_in;
-		if (dwc->ep0state == EP0_DATA_PHASE)
-			dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
-		else
-			dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
-		dwc3_ep0_stall_and_restart(dwc);
-	}
+	dwc3_ep0_reset_state(dwc);
 }
 
 static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
@@ -3913,20 +3915,7 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 	 * phase. So ensure that EP0 is in setup phase by issuing a stall
 	 * and restart if EP0 is not in setup phase.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE) {
-		unsigned int	dir;
-
-		dir = !!dwc->ep0_expect_in;
-		if (dwc->ep0state == EP0_DATA_PHASE)
-			dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
-		else
-			dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
-
-		dwc->eps[0]->trb_enqueue = 0;
-		dwc->eps[1]->trb_enqueue = 0;
-
-		dwc3_ep0_stall_and_restart(dwc);
-	}
+	dwc3_ep0_reset_state(dwc);
 
 	/*
 	 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
-- 
2.43.0



