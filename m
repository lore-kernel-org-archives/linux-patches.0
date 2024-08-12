Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEBA1494B8;
	Mon, 12 Aug 2024 16:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480520; cv=none; b=eKNVMqz/QTKBigjBIKaZv92/T6h1FA5NsjiuemJxOPsxi3YS2dwuhIt7WZaop+EYIpLH2KLY+VWsgRGaSIaRsgx7Eq6HcwaRylB9du14FoXCHuLFBa+cVB/kxwtaSJtx7cZgDzGK6xg0mAX4Dj3g4Fq+Iqo7bX4K9DxIfWOSces=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480520; c=relaxed/simple;
	bh=0wimM8+pB+Op2gw2bI3TWhNhdJ0RWg/M9LLfbzNs9Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FccaERTz7+4eS4IjAnZM3zhH2fxrtqV+tbJE5j4Dmxrr2du9j7VpsrNlHjKTK25vEOiVj9AtEI6IKM/XruPjsW70/HSDQp3p3eLDEPJhEKcfr/FiRCN/NFkxHjSK/z22Um0TnGurFzDVzzUdGdW8pUCLuX06NdI34iLI7pQOd0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njnVr6Zq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njnVr6Zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A78C32782;
	Mon, 12 Aug 2024 16:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480520;
	bh=0wimM8+pB+Op2gw2bI3TWhNhdJ0RWg/M9LLfbzNs9Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njnVr6ZqpnabHCSqPIxWYxVyB79jv7M2/vbv8HzG+8fNTiMIIBY5Ni8R86QFdcseU
	 hd4n8w512sGUynQ46lHj2bP+bcW78WXitzJTIm/LVh5PJaTl/rT+YCqx7D5uGCChm2
	 6CPQDaZcu0VSL2CLwncstNyM91rygg0BK4omascc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <crwulff@gmail.com>
Subject: [PATCH 6.10 189/263] usb: gadget: core: Check for unset descriptor
Date: Mon, 12 Aug 2024 18:03:10 +0200
Message-ID: <20240812160153.781718847@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wulff <crwulff@gmail.com>

commit 973a57891608a98e894db2887f278777f564de18 upstream.

Make sure the descriptor has been set before looking at maxpacket.
This fixes a null pointer panic in this case.

This may happen if the gadget doesn't properly set up the endpoint
for the current speed, or the gadget descriptors are malformed and
the descriptor for the speed/endpoint are not found.

No current gadget driver is known to have this problem, but this
may cause a hard-to-find bug during development of new gadgets.

Fixes: 54f83b8c8ea9 ("USB: gadget: Reject endpoints with 0 maxpacket value")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Wulff <crwulff@gmail.com>
Link: https://lore.kernel.org/r/20240725010419.314430-2-crwulff@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -118,12 +118,10 @@ int usb_ep_enable(struct usb_ep *ep)
 		goto out;
 
 	/* UDC drivers can't handle endpoints with maxpacket size 0 */
-	if (usb_endpoint_maxp(ep->desc) == 0) {
-		/*
-		 * We should log an error message here, but we can't call
-		 * dev_err() because there's no way to find the gadget
-		 * given only ep.
-		 */
+	if (!ep->desc || usb_endpoint_maxp(ep->desc) == 0) {
+		WARN_ONCE(1, "%s: ep%d (%s) has %s\n", __func__, ep->address, ep->name,
+			  (!ep->desc) ? "NULL descriptor" : "maxpacket 0");
+
 		ret = -EINVAL;
 		goto out;
 	}


