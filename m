Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2036EB50;
	Tue, 23 Jan 2024 02:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975405; cv=none; b=EdIgSGBzgaxTghbyfrtTKZWunI/FL77WVRlFkZWFAQOeMuKXLs3AArDOsKXVMNomc8u9scpxQwUehx7OXLxTqjt4Mpepl8ctrYqZDYxFA5y+5uJDDDHO3JCxySiAAz5d/zyfHpVlaIeBjbc8pbJVxz3SBkZcna4uYgDqn4N0ZfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975405; c=relaxed/simple;
	bh=uqeztJ24AhFFsjDvU+6leozVNIALYGP0rJpNkhkQYn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpzlFNKgRdsQaZ0ysPBGK9hZpyPOf7KIUIIziXB4Xb3R7RpHLoUy5N+WDL6Sc2efAhov/W35YwDWMiGMwvwLXRQtatHNSI/nHrbNpsZRa4UqGu06bKUXprZ8AU6PujQndoTtcgzcu1FMW8FOJPYHJ7Ovx7gVaKyEEldmRCi5j6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Po4vHaLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Po4vHaLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF23DC433C7;
	Tue, 23 Jan 2024 02:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975405;
	bh=uqeztJ24AhFFsjDvU+6leozVNIALYGP0rJpNkhkQYn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Po4vHaLb2ltC3GzMiSKLF98k+gGf2/Jsk2HkcPnX9kSAN8BoOFVSt8oRsu2Olomla
	 Gy3QJPEx6Sb96pLEcULFKaPv5nD5G4lUAUQvbZzskL8HMRKtr9b8jmLIVIZ1HkdbKI
	 ctT5K7iXBDSTQ/e66y06gAw9cMfZlvIUuJJphvCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.6 357/583] Revert "usb: gadget: f_uvc: change endpoint allocation in uvc_function_bind()"
Date: Mon, 22 Jan 2024 15:56:48 -0800
Message-ID: <20240122235822.943400434@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 895ee5aefb7e24203de5dffae7ce9a02d78fa3d1 upstream.

This reverts commit 3c5b006f3ee800b4bd9ed37b3a8f271b8560126e.

gadget_is_{super|dual}speed() API check UDC controller capitblity. It
should pass down highest speed endpoint descriptor to UDC controller. So
UDC controller driver can reserve enough resource at check_config(),
especially mult and maxburst. So UDC driver (such as cdns3) can know need
at least (mult + 1) * (maxburst + 1) * wMaxPacketSize internal memory for
this uvc functions.

Cc:  <stable@vger.kernel.org>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231224153816.1664687-5-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -719,13 +719,29 @@ uvc_function_bind(struct usb_configurati
 	}
 	uvc->enable_interrupt_ep = opts->enable_interrupt_ep;
 
-	ep = usb_ep_autoconfig(cdev->gadget, &uvc_fs_streaming_ep);
+	/*
+	 * gadget_is_{super|dual}speed() API check UDC controller capitblity. It should pass down
+	 * highest speed endpoint descriptor to UDC controller. So UDC controller driver can reserve
+	 * enough resource at check_config(), especially mult and maxburst. So UDC driver (such as
+	 * cdns3) can know need at least (mult + 1) * (maxburst + 1) * wMaxPacketSize internal
+	 * memory for this uvc functions. This is the only straightforward method to resolve the UDC
+	 * resource allocation issue in the current gadget framework.
+	 */
+	if (gadget_is_superspeed(c->cdev->gadget))
+		ep = usb_ep_autoconfig_ss(cdev->gadget, &uvc_ss_streaming_ep,
+					  &uvc_ss_streaming_comp);
+	else if (gadget_is_dualspeed(cdev->gadget))
+		ep = usb_ep_autoconfig(cdev->gadget, &uvc_hs_streaming_ep);
+	else
+		ep = usb_ep_autoconfig(cdev->gadget, &uvc_fs_streaming_ep);
+
 	if (!ep) {
 		uvcg_info(f, "Unable to allocate streaming EP\n");
 		goto error;
 	}
 	uvc->video.ep = ep;
 
+	uvc_fs_streaming_ep.bEndpointAddress = uvc->video.ep->address;
 	uvc_hs_streaming_ep.bEndpointAddress = uvc->video.ep->address;
 	uvc_ss_streaming_ep.bEndpointAddress = uvc->video.ep->address;
 


