Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190891B3927;
	Mon, 10 Mar 2025 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628242; cv=none; b=VARkw5X+6jta/GTpmKKAW82ovzjksIpcrw4v6TvyunoQo8NkS0rPMW6EgnnhGlgiT8u/ui/XAbyGoTKjuuIzwnHKpVI4mKnbCAkG6ecxOGme90q1o2qpw5oqYhIwzl2oneNvPcmRYtT+RfP6yZVgC8UCrGWPqHa+HOiu6+/C804=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628242; c=relaxed/simple;
	bh=GxmhEsVtt9ORjJpRWftHutEM/fsS4fp01mqEUFhcrzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G52L16qYkU7FtEi3yComxxIc5Lef0J9hQi/7zAN9pP6/Qqfu0y4/Jfnmtd/omRPzptBxCdxvlU2Wg7S6Wg+z+w7FQGJN0gtd1S9CS5z0LNaa0nf5uVdcZ12nhH8+LMyZEvkKh2ukaUMq+5satvyL2Rv+3XJWm9hBfcjXnL8+Lqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enUhxn2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enUhxn2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F00C4CEE5;
	Mon, 10 Mar 2025 17:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628242;
	bh=GxmhEsVtt9ORjJpRWftHutEM/fsS4fp01mqEUFhcrzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enUhxn2MvXKrPFxfY985zI3F/YSezOv7DeLboqOHRYOcxfR5ulqmWyQolAPtE/GD7
	 jXIOgnVscRrSu8wcVQ1IDNGBXMQZoMKsLzlgAv9JVkvwDcDdvG2x1Ypnnu/wpj6zpm
	 WACMSV8uyX7/9kEzRNt0II4T+Kp5lr0xuUZFEtVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.6 105/145] usb: gadget: Set self-powered based on MaxPower and bmAttributes
Date: Mon, 10 Mar 2025 18:06:39 +0100
Message-ID: <20250310170439.001818141@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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
@@ -1050,10 +1050,11 @@ static int set_config(struct usb_composi
 	else
 		usb_gadget_set_remote_wakeup(gadget, 0);
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
@@ -2615,7 +2616,9 @@ void composite_suspend(struct usb_gadget
 
 	cdev->suspended = 1;
 
-	usb_gadget_set_selfpowered(gadget);
+	if (cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
+		usb_gadget_set_selfpowered(gadget);
+
 	usb_gadget_vbus_draw(gadget, 2);
 }
 
@@ -2649,8 +2652,11 @@ void composite_resume(struct usb_gadget
 		else
 			maxpower = min(maxpower, 900U);
 
-		if (maxpower > USB_SELF_POWER_VBUS_MAX_DRAW)
+		if (maxpower > USB_SELF_POWER_VBUS_MAX_DRAW ||
+		    !(cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
 			usb_gadget_clear_selfpowered(gadget);
+		else
+			usb_gadget_set_selfpowered(gadget);
 
 		usb_gadget_vbus_draw(gadget, maxpower);
 	} else {


