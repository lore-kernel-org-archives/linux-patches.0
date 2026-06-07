Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176F12DFF04;
	Sun,  7 Jun 2026 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829408; cv=none; b=jG0+Rs7GG2IIwE7PaBG9PCSr7MqIuJaXIZ+W+ANvSt4IzjtCPQJ9+M1/2FSTNSbl6RPjgiEBjdDyMO9obzCFaHf22NSxee5Q9iRW/v3Uj0W+AIPK7MPQ31Xpjcru5h55L6kO1NW0wATfIxDH26xXCk/hb50F7yT8kX1FTn2yuts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829408; c=relaxed/simple;
	bh=hCKuciCAC/Z01Zrcbn8NUv/cMr/JdaQqKscBV5VoXyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfOUldnlwEcVROgK9NR5L4gadNrLo4cQGTzi7s87hV2+oNlT3LETn6l4o1imDd8nyje5/0zM47LX+OnU/5odxWDApUiUqJ0y6jCM2pyaJKys8Kqh8dhwwe+E/ahuHwWZ3BPDT+q0cZ8CHmzAFXRYBt/KIb6TsjNGRVTnbm9zXl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kz0SCtZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kz0SCtZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6C11F00893;
	Sun,  7 Jun 2026 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829407;
	bh=bAhOicAqaaIfymWHcxIg2kPy3YoTWdUwWiGsnPHjwj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kz0SCtZ3u8YzDIz2AhP6KzXxhkiUt/vxMbTedi6FTekA4N1IgkFF7amsW/azkrlNu
	 nAMO32N7mWdtPs28YqHmG53y3cGVXUdoI56uDecMsqxsLlv0hazXweTSTAHScRLNlv
	 yrS3+trFybBx5PwoX9xSrbvH/dDJXKYltHQkzmQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jeremy Erazo <mendozayt13@gmail.com>
Subject: [PATCH 7.0 276/332] usb: gadget: composite: fix integer underflow in WebUSB GET_URL handling
Date: Sun,  7 Jun 2026 12:00:45 +0200
Message-ID: <20260607095738.184692226@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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
 


