Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3652F3368B2;
	Mon, 20 Apr 2026 15:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699837; cv=none; b=fizMvSJR2kLQ8o6nZvsavp974NNm4s685HmRF+VfoNerwHdEoNGpJWTmgC3Dh7H1O3uBAuXSg+LDDRZsN4t09BKIeqpmeoxFvjimiuMc+Bzcj5f+YONeu0DQtwDisiC9b8pdPValA5b31e9H0d3akfTuaGwdQqT4/Vnl82zXjSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699837; c=relaxed/simple;
	bh=Ft7LUKvXDJdRUx8ePc2A8FM3yBczQJ7P0vZv6p0ifrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJPaSo/e0afz52U+qZmnfTlNjttO/04qYAtgAHAzl+Jb5YWiUQ7kzja0wNc+TX9/4QFzkVVGeLXrCqZBfzlBD7zGepRu7toKbBcIFb43MbmsNjFfkw6T3ElJrFph/Tz6tqgb+LFyC+ZuE5G/6kD6yhikh/6EMt/PAXJniLksJ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSlwXjvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSlwXjvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1CBC2BCB8;
	Mon, 20 Apr 2026 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699836;
	bh=Ft7LUKvXDJdRUx8ePc2A8FM3yBczQJ7P0vZv6p0ifrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSlwXjvdJ5k0lQT1uoZCCWlV6FyYyhmYaKHvQP756QKQKMFVwNEY+s/uLEUnN1U4y
	 Y7/neB4dA9Lwq7viIAy9wRAagLk6rGmMjbJ9E3ZqLyhvHVwf1QWkvHPArVKjMwOHdf
	 eScqOev4M3FMKxzyLl0COkjohuQEuAzWrABwc29c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 7.0 17/76] usb: gadget: renesas_usb3: validate endpoint index in standard request handlers
Date: Mon, 20 Apr 2026 17:41:28 +0200
Message-ID: <20260420153911.449839710@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


