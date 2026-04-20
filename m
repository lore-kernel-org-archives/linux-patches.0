Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D225B342510;
	Mon, 20 Apr 2026 16:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700987; cv=none; b=YEiqonU91CwWYCwoW+vJdV0Kl+Gw12zoT122UCcfmxvSuSXMFh0zHJvgTnZiWNV3tqOvbghW/ZP0rhaNKn2OoLKsdvRlnnpWIdzaApeKqnZRhWCuXghlEy2NUxMQrMvEgIBR+wTWdFmFNSdFW2Ew/Rhy7+EitG9fWBmB04jE7fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700987; c=relaxed/simple;
	bh=hpf56xAxP06hX7EIWKJjCEAB3XXbUIGM8hQ+hooR/vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggSh11cVOsd2MkmFAnuGlkzQlo5XIB2NJn1qRWuJry8O61KqQTS6MO2fnVymat/izCteaZJXohG2pJxf7qoEYbnvtq86wNvt3SYH7XQifsrijG4qcz+QXmB5Qvmb+YgwCNQIFkg37a6zIgpUEqC/IlKKRo6SPu+NiFSHZb/vCXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCSdqQTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCSdqQTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5587BC2BCB4;
	Mon, 20 Apr 2026 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700987;
	bh=hpf56xAxP06hX7EIWKJjCEAB3XXbUIGM8hQ+hooR/vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCSdqQTMruT6CKyWll+AC48XNP5G7r/d1wzqRpsUiQP8AIsoQhdG1nkS1O6L9OXsO
	 Rxm0JMU5wYI2DLV8X9CuAG2PiUd1YXMYAVK9XHlIQo6t9MaEAf4TJ+sIDj7y2Xtrsz
	 pmfaL8lKdeDeRUn3+LQsCAoIM2VDnpcOown1UJu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 136/198] usb: gadget: renesas_usb3: validate endpoint index in standard request handlers
Date: Mon, 20 Apr 2026 17:41:55 +0200
Message-ID: <20260420153940.504071396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
@@ -1669,6 +1669,10 @@ static bool usb3_std_req_get_status(stru
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
@@ -1781,7 +1785,8 @@ static bool usb3_std_req_feature_endpoin
 	struct renesas_usb3_ep *usb3_ep;
 	struct renesas_usb3_request *usb3_req;
 
-	if (le16_to_cpu(ctrl->wValue) != USB_ENDPOINT_HALT)
+	if ((le16_to_cpu(ctrl->wValue) != USB_ENDPOINT_HALT) ||
+	    (num >= usb3->num_usb3_eps))
 		return true;	/* stall */
 
 	usb3_ep = usb3_get_ep(usb3, num);


