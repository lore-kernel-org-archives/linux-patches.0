Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B543BC661;
	Mon, 23 Mar 2026 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282585; cv=none; b=dQrXq7SI+FsaoFah3GwB8Lvgt8nZxBuhw0Eo6tIeR1bs6FC9W8xLBBkmR7R6NhQnTrGxevLJtycYD4MOYxsRA9E6kXcVbMg2MqtWSYPl3v+QibYmFDDgJGcpmbldFXLiZNTZZ7xAlYUVuVaD9fw6hyZakju4HSpBhQYjbynwfyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282585; c=relaxed/simple;
	bh=VrIcAZdwIml6eaUQStZjlCx07mVY2c57P/XAV/zkoOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRdlQOjMBH/rTrCRT9b7gH1eNhkaDEzIr3vTK4k2UWVa14Vr2rujHdvsQAwivggFiN1DXVxQvuhXpfx1hK/71/64afZWjXyzk0IuZZNE9TJEkLbfvL0qI1Pa3KjHl10EbdKj6Ixz3Wlv7rrwXRrMPo/rvgisge0ZL7Ifa//s6fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Xs/DBZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xs/DBZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B71C4CEF7;
	Mon, 23 Mar 2026 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282584;
	bh=VrIcAZdwIml6eaUQStZjlCx07mVY2c57P/XAV/zkoOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Xs/DBZccUcSnaPujPzIjAQx2VKpF8OZW0EuS524teH1sg8rTosuatlZ4yOyZRbKn
	 C+qNyr+Wel120yDpfdpHnL2zlHkUqsn6mmuN7aQ4KPt8imOQGahuZ3viGV8SHRi64+
	 ta12FjnoUryTqi1cxffgO1JTKzk1Q0zWrWzVIDYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 211/481] usb: cdc-acm: Restore CAP_BRK functionnality to CH343
Date: Mon, 23 Mar 2026 14:43:13 +0100
Message-ID: <20260323134530.307981231@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 14ae24cba291bddfdc296bbcbfd00cd09d0498ef upstream.

The CH343 USB/serial adapter is as buggy as it is popular (very).
One of its quirks is that despite being capable of signalling a
BREAK condition, it doesn't advertise it.

This used to work nonetheless until 66aad7d8d3ec5 ("usb: cdc-acm:
return correct error code on unsupported break") applied some
reasonable restrictions, preventing breaks from being emitted on
devices that do not advertise CAP_BRK.

Add a quirk for this particular device, so that breaks can still
be produced on some of my machines attached to my console server.

Fixes: 66aad7d8d3ec5 ("usb: cdc-acm: return correct error code on unsupported break")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable <stable@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260301124440.1192752-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    5 +++++
 drivers/usb/class/cdc-acm.h |    1 +
 2 files changed, 6 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1355,6 +1355,8 @@ made_compressed_probe:
 		acm->ctrl_caps = h.usb_cdc_acm_descriptor->bmCapabilities;
 	if (quirks & NO_CAP_LINE)
 		acm->ctrl_caps &= ~USB_CDC_CAP_LINE;
+	if (quirks & MISSING_CAP_BRK)
+		acm->ctrl_caps |= USB_CDC_CAP_BRK;
 	acm->ctrlsize = ctrlsize;
 	acm->readsize = readsize;
 	acm->rx_buflimit = num_rx_buf;
@@ -1978,6 +1980,9 @@ static const struct usb_device_id acm_id
 	.driver_info = IGNORE_DEVICE,
 	},
 
+	/* CH343 supports CAP_BRK, but doesn't advertise it */
+	{ USB_DEVICE(0x1a86, 0x55d3), .driver_info = MISSING_CAP_BRK, },
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -113,3 +113,4 @@ struct acm {
 #define CLEAR_HALT_CONDITIONS		BIT(5)
 #define SEND_ZERO_PACKET		BIT(6)
 #define DISABLE_ECHO			BIT(7)
+#define MISSING_CAP_BRK			BIT(8)


