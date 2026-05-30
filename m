Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677651DE4EF;
	Sat, 30 May 2026 16:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159069; cv=none; b=hcaHjMQLilg6UYhNWkp9lZGeSjzEGbPkHjFHspSwk1Gq2sR9MQncf3bivVpsvW/WnWOXeBsD+eJ9AcR96QzEfqpQ0DypOjSH9QU6h0pCF4HTL55ifY/pJzxTbQ5S/dWOy5lQ7lsRX542Vaxh4r2NGSuIxsMqYIOeL1S4FAHqWCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159069; c=relaxed/simple;
	bh=TaTNHgOgRLbMwyiR7VeeMbexdnfQhvhNPPb4zIP64nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqTsS/ReI11VudKEBfKNCoZahNY7Byv5rKiahVzosJ/CmCdT3DYypTsZODGrg0XFM6bfjb/Tj2LWELYhoK+F9raILbWfq/ORig/ODCRlyLc1RI4zNL6Skb8FVRL9r86Z8Fo9grwKKdrxF/zZGNeb3HNRn4taFRYOoxHgHUd1i5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtDHI6bJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtDHI6bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD411F00893;
	Sat, 30 May 2026 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159068;
	bh=1oxgLL+ZKDozYFcmRtpEeA5GrecWpt1jsFKWjVyjApM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtDHI6bJnqIewJHF4lBPM2wR2j8rXcvfdXP2ua+tN2U2OdmDXA9M2BtzpDO95SpiD
	 ppiYtA21K3XTHaaGSd+65xB8INnwp8ECuV20mOzNVeakKMfCDUHFjjaLYM7M6Zv9Yz
	 K6vKMSYOgQ3fracombJo2dCQggC3XC4VAs61Bhz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 069/969] usb: gadget: renesas_usb3: validate endpoint index in standard request handlers
Date: Sat, 30 May 2026 17:53:13 +0200
Message-ID: <20260530160302.276456444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f880aac8a57ebd92abfa685d45424b2998ac1059 upstream.

The GET_STATUS and SET/CLEAR_FEATURE handlers extract the endpoint
number from the host-supplied wIndex without any sort of validation.
Fix this up by validating the number of endpoints actually match up with
the number the device has before attempting to dereference a pointer
based on this math.

This is just like what was done in commit ee0d382feb44 ("usb: gadget:
aspeed_udc: validate endpoint index for ast udc") for the aspeed driver.

Fixes: 746bfe63bba3 ("usb: gadget: renesas_usb3: add support for Renesas USB3.0 peripheral controller")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Link: https://patch.msgid.link/2026040647-sincerity-untidy-b104@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -1628,6 +1628,10 @@ static bool usb3_std_req_get_status(stru
 		break;
 	case USB_RECIP_ENDPOINT:
 		num = le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;
+		if (num >= usb3->num_usb3_eps) {
+			stall = true;
+			break;
+		}
 		usb3_ep = usb3_get_ep(usb3, num);
 		if (usb3_ep->halt)
 			status |= 1 << USB_ENDPOINT_HALT;
@@ -1740,7 +1744,8 @@ static bool usb3_std_req_feature_endpoin
 	struct renesas_usb3_ep *usb3_ep;
 	struct renesas_usb3_request *usb3_req;
 
-	if (le16_to_cpu(ctrl->wValue) != USB_ENDPOINT_HALT)
+	if ((le16_to_cpu(ctrl->wValue) != USB_ENDPOINT_HALT) ||
+	    (num >= usb3->num_usb3_eps))
 		return true;	/* stall */
 
 	usb3_ep = usb3_get_ep(usb3, num);


