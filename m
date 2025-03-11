Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764771684AC;
	Tue, 11 Mar 2025 15:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706266; cv=none; b=OJKPWetVDOQNG1Ho/zbveKiRN8ojvOXjhro9vM90Mh0KzxY2Bk2LctRnqX+FmVyaGHmLzxSchliVH7quhCmCfvSjsABPiF4j8RF81L1H+CHRnF+c47U83M2SlHk5O+dnavm3m9cUXnqmEVQooTgqgrZ11xGGEhJglvSzharfkWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706266; c=relaxed/simple;
	bh=BcJeBIkzsJxsx0CLQAGJ4I2/EtttW/2N2Q9liRYkEhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxgUidTWTKahTLIYLeFG9XG+dH099/KzWnIh/IVXE3ichsklzgNzqFtUHX9Q8r2wHhi2JJ/adWu9mVCn2bl1p9AaoTEgUD82lbFvf7/z+6C8ja4hrkP4rQkS33aSxM+fG7RZVjn9tytJfPSjxhIDhvBMb0olDbdG8JJUZPJbPFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtyvWSFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtyvWSFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F088FC4CEE9;
	Tue, 11 Mar 2025 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706266;
	bh=BcJeBIkzsJxsx0CLQAGJ4I2/EtttW/2N2Q9liRYkEhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtyvWSFgDatT8FTy9T8qokRdlD54x7QBbwq3IMaVSDNeOyfEgJKupgUiK8qtnqdY9
	 gTmstl9/WamJj2q04Ql6AA2nKCmjnU8vjDZy3DQ5SKvbjNn3k7uth/74RZGqMt1SoK
	 o1OVLECR/fGT1wM5GJec6S6lOy4VHywIKvIAhN1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 5.4 319/328] usb: gadget: Set self-powered based on MaxPower and bmAttributes
Date: Tue, 11 Mar 2025 16:01:29 +0100
Message-ID: <20250311145727.579297104@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 40e89ff5750fca2c1d6da93f98a2038716bba86c upstream.

Currently the USB gadget will be set as bus-powered based solely
on whether its bMaxPower is greater than 100mA, but this may miss
devices that may legitimately draw less than 100mA but still want
to report as bus-powered. Similarly during suspend & resume, USB
gadget is incorrectly marked as bus/self powered without checking
the bmAttributes field. Fix these by configuring the USB gadget
as self or bus powered based on bmAttributes, and explicitly set
it as bus-powered if it draws more than 100mA.

Cc: stable <stable@kernel.org>
Fixes: 5e5caf4fa8d3 ("usb: gadget: composite: Inform controller driver of self-powered")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250217120328.2446639-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -915,10 +915,11 @@ static int set_config(struct usb_composi
 	else
 		power = min(power, 900U);
 done:
-	if (power <= USB_SELF_POWER_VBUS_MAX_DRAW)
-		usb_gadget_set_selfpowered(gadget);
-	else
+	if (power > USB_SELF_POWER_VBUS_MAX_DRAW ||
+	    !(c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
 		usb_gadget_clear_selfpowered(gadget);
+	else
+		usb_gadget_set_selfpowered(gadget);
 
 	usb_gadget_vbus_draw(gadget, power);
 	if (result >= 0 && cdev->delayed_status)
@@ -2365,7 +2366,9 @@ void composite_suspend(struct usb_gadget
 
 	cdev->suspended = 1;
 
-	usb_gadget_set_selfpowered(gadget);
+	if (cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
+		usb_gadget_set_selfpowered(gadget);
+
 	usb_gadget_vbus_draw(gadget, 2);
 }
 
@@ -2394,8 +2397,11 @@ void composite_resume(struct usb_gadget
 		else
 			maxpower = min(maxpower, 900U);
 
-		if (maxpower > USB_SELF_POWER_VBUS_MAX_DRAW)
+		if (maxpower > USB_SELF_POWER_VBUS_MAX_DRAW ||
+		    !(cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
 			usb_gadget_clear_selfpowered(gadget);
+		else
+			usb_gadget_set_selfpowered(gadget);
 
 		usb_gadget_vbus_draw(gadget, maxpower);
 	}


