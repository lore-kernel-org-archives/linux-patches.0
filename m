Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0881E9B2C;
	Tue, 11 Mar 2025 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707569; cv=none; b=FLvPuvPmPpcdgVJ+GWAzn4EtPJ6oywJEbAfzwy4g8T2TiXrqOMcQCWFVlMAKO+X3f2U/ZkD7Q1FHU9PJgJ9mV2UCXbrKPMaVKvgEfaKs7YPp64NmkHPpjjBCNX11S79Mx6v/SVJmGxtmrEkqAHj54YkcfdSMD9aMqfvyVbnsc84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707569; c=relaxed/simple;
	bh=1oy2Ugcf7aIgDlHKSNyOdSJ8O0nV2KZcotIf11Z1lHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qng6d0W8Q7eKykc2K/AaxYHv7bUDHWoGB42bXDNbl4fXucFpsXYc8Rd+V4YCGVbvcscr/lHszCg8DCwkhvk+BekQIbrFqbU6UvSJ9XkbmEEMY5C50/OmWYL36b81h1Row5PAl8xMSMQNOWeJi4oSptcZoCFkkOuhtPpYxTr/LEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRHAPTn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRHAPTn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073C9C4CEE9;
	Tue, 11 Mar 2025 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707569;
	bh=1oy2Ugcf7aIgDlHKSNyOdSJ8O0nV2KZcotIf11Z1lHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRHAPTn80cHz78lt0cBWN5MjoTLxEs664GpbjIabKicKkeWNE+9iZTA4jiHpr5Tub
	 W9RYYWDjdWLidk4Ymee0PMav2W/DdQ5O4ijR24WsBaMFG7zGepZSUki3eYo474OxDJ
	 oX9fmLur1u/011XKrQVPG0SY94Mkuw4EuL3CRUb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 5.10 433/462] usb: gadget: Set self-powered based on MaxPower and bmAttributes
Date: Tue, 11 Mar 2025 16:01:39 +0100
Message-ID: <20250311145815.438432347@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


