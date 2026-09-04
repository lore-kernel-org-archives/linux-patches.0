Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0A5358378;
	Fri,  4 Sep 2026 06:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502106; cv=none; b=MtTt+r7sVYVM/0+iQ5ApMlLn57BRgVGQ84jDeUm8hebcuNKIlCPjYUdPpD7Icbjw1IrDKTJzDEH89ZopraCSZEJzwfGllSSYDMuBYqtsSdIn8cr5rqmJ5wnZ2h9g5D2m82MlVJDbuH2uOjGUT42fpRxQSb86AbfhpDaEsvVYy7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502106; c=relaxed/simple;
	bh=TrWzlCuBEW7+XG/I4kq+HPEEsb0MCT0+xgfY+fmSA78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUzsbgLq0sMGGDC9KU97rQyuxYfbZMXJzUEvzqu9T7aaH5PsJ6HkI98lJxZAYspYfpRIfwtYtNXE3dQlwOL7bJXk+khCttwCme6g1LOj2iG/Yldv2nujN7LXJhRO63KoqXz2oKEZ8MB7AUsZJfpbjQevRj/FLGl/+aoLPfipWOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Viaui7Ra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Viaui7Ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D551F00A3D;
	Fri,  4 Sep 2026 06:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502105;
	bh=N3uqSqjkyPzo3ZwF/wiuk257mjg0ysgLBFAAjOQdHtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Viaui7RaakwZ/Sz+4zXOf6WZQI/miWIwYmv8/GU8obvmS/nRivJ7j8sDa8xKoRXZM
	 9s429Oj+Dx+kHAgSX0kSm1pcFMfOvERkLySlciR9Ee99875WI5AvWtsyTBdgiKgDef
	 au0tNQ7XJjQaGot3suJh/3bXj0Xh+j2Qc67leO+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>
Subject: [PATCH 6.12 047/403] usb: dwc2: gadget: Exit partial power down state when changing USB pull-up
Date: Fri,  4 Sep 2026 06:57:30 +0200
Message-ID: <20260904045735.894016099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Francesco Lavra <flavra@baylibre.com>

commit bf1e90189a98ca4a824fd64b4f3c6043d13c98ea upstream.

When a USB host suspends a connected device, the DWC2 USB device controller
enters a partial power down state where controller registers are not
accessible. If the USB gadget is then disconnected or deactivated
(e.g. when a gadget function is unbound from the controller), the `pullup`
callback in struct usb_gadget_ops is invoked; if the controller is kept in
partial power down, the register write in dwc2_hsotg_core_disconnect() does
not take effect; as a result, the USB host keeps seeing the device as
connected, even though the device is disabled.

Properly exit partial power down state in the pullup callback, so that the
USB host detects a device disconnection as intended.

Fixes: 97861781daff ("usb: dwc2: Allow entering hibernation from USB_SUSPEND interrupt")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Link: https://patch.msgid.link/20260728154420.2021519-1-flavra@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4680,6 +4680,7 @@ static int dwc2_hsotg_pullup(struct usb_
 {
 	struct dwc2_hsotg *hsotg = to_hsotg(gadget);
 	unsigned long flags;
+	int ret = 0;
 
 	dev_dbg(hsotg->dev, "%s: is_on: %d op_state: %d\n", __func__, is_on,
 		hsotg->op_state);
@@ -4691,6 +4692,13 @@ static int dwc2_hsotg_pullup(struct usb_
 	}
 
 	spin_lock_irqsave(&hsotg->lock, flags);
+	if (hsotg->in_ppd) {
+		ret = dwc2_exit_partial_power_down(hsotg, 0, true);
+		if (ret) {
+			dev_err(hsotg->dev, "exit partial_power_down failed\n");
+			goto exit;
+		}
+	}
 	if (is_on) {
 		hsotg->enabled = 1;
 		dwc2_hsotg_core_init_disconnected(hsotg, false);
@@ -4704,9 +4712,10 @@ static int dwc2_hsotg_pullup(struct usb_
 	}
 
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
+exit:
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 
-	return 0;
+	return ret;
 }
 
 static int dwc2_hsotg_vbus_session(struct usb_gadget *gadget, int is_active)


