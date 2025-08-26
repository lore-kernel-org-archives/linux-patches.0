Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F43D1A316E;
	Tue, 26 Aug 2025 14:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218612; cv=none; b=jPT87c8Fz1ex0YZB0yEzHVj+zTs0dGnDQb1Ctt6OrOpIbzCR7PFD6/OFA6xaX++G5UDsM9H9V+5myDPgrFJCF5VhgfkbcTDetSHmoG4BitNCAoc4yMlx5aItInv2LdnQzniGLLiIHm52xnkaIzjHZnrVL2NruGXoCRjMlutXPDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218612; c=relaxed/simple;
	bh=KLm9vnn+741y8sEJqCmzELFwfKgx121rsXgTgDxwbjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yc62VdorNiipRvGPws2OqrykjFn01qIm9t+jii18q2zWQ+9iQOGY80J3QxYmIdVSNxykxOnWGdgF4PN3bvFQVYpW2r4AJ2oiVLXcL/zi05PQZ5NZMUBYCDcJR50GL08aNR2epQ6G32pYmxrgWYSGYGlZ/JpILAGFOf8m/1GHNAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jD5e2VRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jD5e2VRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D03C4CEF1;
	Tue, 26 Aug 2025 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218612;
	bh=KLm9vnn+741y8sEJqCmzELFwfKgx121rsXgTgDxwbjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jD5e2VRBAlsRLqlfzd1WUN+Ti7/L0ycMm8tlLYsmaxIV6KGdwcs8ODosP/eggoub3
	 5vBXzkg1Q159OgjIVQq8rcVywwFmIxOrtOrvsfByt3+SfNcL6ejjs2Gntw5bgVb1nV
	 EoyY41pJ8ieXq/Hi52tRVGH7KYai2F9633jd2isk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Li <jun.li@nxp.com>,
	Peter Chen <peter.chen@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/403] usb: chipidea: udc: protect usb interrupt enable
Date: Tue, 26 Aug 2025 13:06:32 +0200
Message-ID: <20250826110907.904682515@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Li <jun.li@nxp.com>

[ Upstream commit 72dc8df7920fc24eba0f586c56e900a1643ff2b3 ]

We hit the problem with below sequence:
- ci_udc_vbus_session() update vbus_active flag and ci->driver
is valid,
- before calling the ci_hdrc_gadget_connect(),
usb_gadget_udc_stop() is called by application remove gadget
driver,
- ci_udc_vbus_session() will contine do ci_hdrc_gadget_connect() as
gadget_ready is 1, so udc interrupt is enabled, but ci->driver is
NULL.
- USB connection irq generated but ci->driver is NULL.

As udc irq only should be enabled when gadget driver is binded, so
add spinlock to protect the usb irq enable for vbus session handling.

Signed-off-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Stable-dep-of: b7a62611fab7 ("usb: chipidea: add USB PHY event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/udc.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index e9ef6271e20d..9212c3842a1b 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1539,13 +1539,18 @@ static const struct usb_ep_ops usb_ep_ops = {
 static void ci_hdrc_gadget_connect(struct usb_gadget *_gadget, int is_active)
 {
 	struct ci_hdrc *ci = container_of(_gadget, struct ci_hdrc, gadget);
+	unsigned long flags;
 
 	if (is_active) {
 		pm_runtime_get_sync(&_gadget->dev);
 		hw_device_reset(ci);
-		hw_device_state(ci, ci->ep0out->qh.dma);
-		usb_gadget_set_state(_gadget, USB_STATE_POWERED);
-		usb_udc_vbus_handler(_gadget, true);
+		spin_lock_irqsave(&ci->lock, flags);
+		if (ci->driver) {
+			hw_device_state(ci, ci->ep0out->qh.dma);
+			usb_gadget_set_state(_gadget, USB_STATE_POWERED);
+			usb_udc_vbus_handler(_gadget, true);
+		}
+		spin_unlock_irqrestore(&ci->lock, flags);
 	} else {
 		usb_udc_vbus_handler(_gadget, false);
 		if (ci->driver)
@@ -1564,19 +1569,16 @@ static int ci_udc_vbus_session(struct usb_gadget *_gadget, int is_active)
 {
 	struct ci_hdrc *ci = container_of(_gadget, struct ci_hdrc, gadget);
 	unsigned long flags;
-	int gadget_ready = 0;
 
 	spin_lock_irqsave(&ci->lock, flags);
 	ci->vbus_active = is_active;
-	if (ci->driver)
-		gadget_ready = 1;
 	spin_unlock_irqrestore(&ci->lock, flags);
 
 	if (ci->usb_phy)
 		usb_phy_set_charger_state(ci->usb_phy, is_active ?
 			USB_CHARGER_PRESENT : USB_CHARGER_ABSENT);
 
-	if (gadget_ready)
+	if (ci->driver)
 		ci_hdrc_gadget_connect(_gadget, is_active);
 
 	return 0;
@@ -1836,6 +1838,7 @@ static int ci_udc_stop(struct usb_gadget *gadget)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ci->lock, flags);
+	ci->driver = NULL;
 
 	if (ci->vbus_active) {
 		hw_device_state(ci, 0);
@@ -1848,7 +1851,6 @@ static int ci_udc_stop(struct usb_gadget *gadget)
 		pm_runtime_put(&ci->gadget.dev);
 	}
 
-	ci->driver = NULL;
 	spin_unlock_irqrestore(&ci->lock, flags);
 
 	ci_udc_stop_for_otg_fsm(ci);
-- 
2.39.5



