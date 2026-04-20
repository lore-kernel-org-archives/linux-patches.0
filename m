Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEE0331A78;
	Mon, 20 Apr 2026 15:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700392; cv=none; b=q7pydDDK0YpibiRsjUJohuzHho0BG6QfY0eag63atHwjNCT892dR0d0hxrqNuZVofezkZel/js4kjZIkpDfx/Q5P/9BQdqpFXqn8X0sDFUckxnTr4ScgSPmtpfM3AD9+wQ1UF6PYNUUKUB/kgpzcP/kZyW+EELNQVJS7NeGUWcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700392; c=relaxed/simple;
	bh=/pMWIMo9q3W9ChVqWrCYb6q+v06PNmVqb1xoJUpIH7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvIA9AqFqw210/NXpKQpOi3TLOK3ydbxNOPXhgpmzJnJ2AVOIkr2VvzbxoIOovQy0Ti2CJguBuz4w9RK1s8CqJWLh9l7lHELfiknaAVgFjAiU+2546t2Qb7LvEOpWSLuyvNjTD8qZJfsZDYvHmc9gnNiOuV6PG02O32scss1AIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FI2+QsNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FI2+QsNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FA9C19425;
	Mon, 20 Apr 2026 15:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700392;
	bh=/pMWIMo9q3W9ChVqWrCYb6q+v06PNmVqb1xoJUpIH7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FI2+QsNM1T05yHk7WqR0P82ICzmoGmtdEndQ2R82/FNWdEH6Vy7RZvpDbRLJGxs6Y
	 3JBp8hqad/wqsgWrIlEKPZmuqFKfqcGpNFMsnt+3hppqgf8pJ/HXEPuU8hPdcxbvS9
	 EGNOcvOwCKP+4TBvy2HCM3Mwqc9AfqVenwboHsDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 155/220] usb: gadget: renesas_usb3: validate endpoint index in standard request handlers
Date: Mon, 20 Apr 2026 17:41:36 +0200
Message-ID: <20260420153939.608626443@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


