Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFC22D8378;
	Sun,  7 Jun 2026 10:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829401; cv=none; b=M7XxYBzGEAtbWOg+dOrdjOkqA8lH+vtw2oHwEgwAsuAJQ2cXBzA/uVYZ8+G6OKhdxB1Klj4mPAbKMR39EvrSya8N/V3J0azipFaOUPNvrGqxcWp02El+Ba1jKZwv2xCzKUYWnIulJ9JNudzHlI2LmWEAIsPIxJJMg7w/HzmANZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829401; c=relaxed/simple;
	bh=K04kdKlfCIxv7cs233NKl60hYblISM6B9HyLIFZ2kRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpsGH5OjBeID1XSDuyRnv3pZCpr0BIOkl8V39FiP7dho8DvQJtNVtUsyWC6uGb76h/r01Xm0t3ZshRkeVxPnDg/VeL8JuQmqSHfW3M8dYdR+3r4iwn+RQW6SFFBfqUd09LfxJt2Zklt3JfieUON3P2sSPFKGDZYKcm16WOm2DZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sADZulKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sADZulKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46001F00893;
	Sun,  7 Jun 2026 10:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829400;
	bh=BI/HmYPpoQQh6knniOy+KZ2ck7KHBEYD0LRV57LEKdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sADZulKqz21PFRbrXf5tTAxg1K8tbT6p7Bx+NGU8kgqcJZ5js4gFR4J4Z596o1QRQ
	 o6vRAsrU4kPjA4Y8tI/MMbdLKbxG3iuwPLjySow2AWx99IgUDjgUU4wpfDTCQSH2Vf
	 5P3QdXZfrh8dA8pqaLjOxIAsIt0xPrMfe+xzSKUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jeremy Erazo <mendozayt13@gmail.com>
Subject: [PATCH 6.18 244/315] usb: gadget: composite: fix integer underflow in WebUSB GET_URL handling
Date: Sun,  7 Jun 2026 12:00:31 +0200
Message-ID: <20260607095736.525559152@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Jeremy Erazo <mendozayt13@gmail.com>

commit 6c5dbc104dadd79fc2923497c20bae759a18758c upstream.

The WebUSB GET_URL handler in composite_setup() narrows
landing_page_length to fit the host-supplied wLength using

	landing_page_length = w_length
		- WEBUSB_URL_DESCRIPTOR_HEADER_LENGTH + landing_page_offset;

If wLength is smaller than WEBUSB_URL_DESCRIPTOR_HEADER_LENGTH the
unsigned subtraction wraps, and the subsequent

	memcpy(url_descriptor->URL,
	       cdev->landing_page + landing_page_offset,
	       landing_page_length - landing_page_offset);

ends up copying close to UINT_MAX bytes from cdev->landing_page into
cdev->req->buf.  KASAN reports a slab-out-of-bounds in composite_setup
on the kmalloc-2k gadget_info allocation, and FORTIFY_SOURCE traps the
memcpy as a 4294967293-byte field-spanning write into
url_descriptor->URL (size 252).

A USB host can reach this from a single SETUP packet against any
gadget that has webusb/use=1 and a landingPage configured.

Handle the small-wLength case before the math: when the host requested
fewer bytes than the URL descriptor header, only the header is
meaningful and no URL bytes need to be copied.  Setting
landing_page_length to landing_page_offset makes the existing memcpy a
no-op and leaves the descriptor returned to the host unchanged for all
larger wLength values.

Fixes: 93c473948c58 ("usb: gadget: add WebUSB landing page support")
Cc: stable <stable@kernel.org>
Signed-off-by: Jeremy Erazo <mendozayt13@gmail.com>
Link: https://patch.msgid.link/20260512160530.352318-1-mendozayt13@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2172,7 +2172,10 @@ unknown:
 				sizeof(url_descriptor->URL)
 				- WEBUSB_URL_DESCRIPTOR_HEADER_LENGTH + landing_page_offset);
 
-			if (w_length < WEBUSB_URL_DESCRIPTOR_HEADER_LENGTH + landing_page_length)
+			if (w_length < WEBUSB_URL_DESCRIPTOR_HEADER_LENGTH)
+				landing_page_length = landing_page_offset;
+			else if (w_length <
+				 WEBUSB_URL_DESCRIPTOR_HEADER_LENGTH + landing_page_length)
 				landing_page_length = w_length
 				- WEBUSB_URL_DESCRIPTOR_HEADER_LENGTH + landing_page_offset;
 


