Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7263F23DD;
	Tue, 17 Mar 2026 16:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766018; cv=none; b=Mtq3IvhejLeOMPeMEmRUjkihllZXux61S5jOLht5QOl5Xjj1igGHHQsfsbQ/9l/eQvyS9kCNErKfGhfGUgwETONI9YJC75wBnEyh30Wo0KWM19PjMbCdHDQsDgUS/GUjYtbx1eIuAMtUHSajRjZRGmpv69FYUodo7r7Hl0OrxA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766018; c=relaxed/simple;
	bh=XMdvbywyBdTN/mtXtQgt4if08D94igd348M05D12siI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOlCRJzb5IpJLe9iM3097U32sKKn2T/8gQfnidfcQ70w3KCFDqAEUoZELP3HSEPmSBqTXOzmsdJhcXzP22kYr5PiAqjVq+rWaaUzD2OJug4pyzKWz7VB5Bz2cQbxJtI6PoYFPkxS3PD/V1N7edbAVKdsQ5HI3fvdoVAS1P1SNPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nq35d988; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nq35d988"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019AAC2BC86;
	Tue, 17 Mar 2026 16:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766018;
	bh=XMdvbywyBdTN/mtXtQgt4if08D94igd348M05D12siI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nq35d988+L6B3Sx5e9GEZ+u9wZfnF8r86y0xViLdeY50Ur2XW3RXOj5bsbgRI7Dt+
	 fyuea+RozxT/S/8GeuWCKz7l/IMhAlaB3ODWC7tpBRzBGuWqTFTMcnYTgqd3aFknzX
	 rXLLr0Mqht1zLtGi7Ct64LRwCtrZLKjXd7KeESBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.19 152/378] usb: cdc-acm: Restore CAP_BRK functionnality to CH343
Date: Tue, 17 Mar 2026 17:31:49 +0100
Message-ID: <20260317163012.605843931@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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
@@ -1379,6 +1379,8 @@ made_compressed_probe:
 		acm->ctrl_caps = h.usb_cdc_acm_descriptor->bmCapabilities;
 	if (quirks & NO_CAP_LINE)
 		acm->ctrl_caps &= ~USB_CDC_CAP_LINE;
+	if (quirks & MISSING_CAP_BRK)
+		acm->ctrl_caps |= USB_CDC_CAP_BRK;
 	acm->ctrlsize = ctrlsize;
 	acm->readsize = readsize;
 	acm->rx_buflimit = num_rx_buf;
@@ -2002,6 +2004,9 @@ static const struct usb_device_id acm_id
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


