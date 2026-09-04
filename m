Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC75F3EC6AE;
	Fri,  4 Sep 2026 05:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500500; cv=none; b=iwX2wgjxk0/EZNuSZbNtvAXJfy1pCsmdNgmf1NN/UO0LNLfMfr3O9YHrirvnUo2XdSraYiB2Ca9jBubmYGCYaIdG9ZPDKr/RK0w5/ZspyH7bNiec+DE/bYlIh3TwvN4X+X5RZvktTnIG+Pu8eHiKA0eif2ZWHWykWwlG2IVm5+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500500; c=relaxed/simple;
	bh=V49gfxvv9tfimYSrvZQay+13qUxXNKhMMQaghGyvjt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQSLkzY3JQsopITCQzFA3JzylnyAYDQNk19znTgtVwPUjD8Bbj2eEhht0kHhcODtZldqH1dNHYAkBD9uDex00OqFtkXb4ephbTYwpb6qoNLnmuBzpDwCAqnlCt7zTZgXkgV8huBxWvk6BlqFx8mEwrlTh26LKYN2xtoKGtI9yP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwGYOou3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwGYOou3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0F91F00A3D;
	Fri,  4 Sep 2026 05:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500498;
	bh=DKW7Q8sW5pOSX9vsXsdab9K08kIBIx6xvq+C33wlAc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwGYOou3ur4sC8T2kTkPCY28p3NNmkax7BVqx2LCcEgkURocq9qYPHytKL0LOTWrr
	 bfN+5CgSYzd9a5XuVkhMc4uKvs8QLAUVHFR97savW9erkC5WrZk5K23k9LnphISq9f
	 b8Jg6h+YBs4vtC5qEtF4ngGJOvLJAiURn61Pjdjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>
Subject: [PATCH 6.18 071/552] usb: dwc2: gadget: Exit partial power down state when changing USB pull-up
Date: Fri,  4 Sep 2026 06:53:48 +0200
Message-ID: <20260904045749.458222020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


