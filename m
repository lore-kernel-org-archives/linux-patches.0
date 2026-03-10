Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352A82BF3E2;
	Tue, 10 Mar 2026 11:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141104; cv=none; b=hMY6sUh8JJJylAXpuIE9qxV0x/T20cmXkfH6xOhXoxQwDBwq/0Gkj6Wkwec58D/CIfWRfLKzxN3BkvcwVg4KpB7pIL4vq653zwRYQNJHSRUqDUjS2SZchDEUDGgOC6sWojYhGHTbLdq5R45i28hhR5HXs9crxSVawIrvkcAxVog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141104; c=relaxed/simple;
	bh=UboOLGsM+j5RY8vF2Z7DyofaqVousVVoTNbu/QM+uT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5OpwPzeaKN1VeHPxYHN64qiCckWk3JRAgU3MP+VWrzLHmZzPDxm8Xlx4DnJR5ZACLYGLBXmNh/X8t4uAiBKssSJuizUxAA/VpwpXyf4Q5Z1kKwiHzHyQKMaZ10xdHkvxINUwbcOgmNVSutzfzm/SFNat/4K34JcA57n06mpci4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dp2ZI+xl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dp2ZI+xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30841C2BC9E;
	Tue, 10 Mar 2026 11:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141103;
	bh=UboOLGsM+j5RY8vF2Z7DyofaqVousVVoTNbu/QM+uT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dp2ZI+xlO+d1kSaqTloCT3vbJ1TTNf/cmaQG7MUqB2khDINHNg6hflI35ODXHhacs
	 KtkydVZUcaljm9GHKHRmVDjDzA6D9hSUlCK1XJMMJsthVYjnjM+lqFk3ytsmtcLEhQ
	 Qebr6Hon/6u8fZdEJfbbQceAn61mbpN4gHJlQT3kPcPMuZvdwIokU6W/68YBW5H/hn
	 4SVt/smLKQr70RKgwEqOuJOZdyZwfRS1aI4+uQyIE7Y+Z7nhS7fWEAdpL2mdkMbP0h
	 CMkrrDHu3XHnxmWN/nukK6ETafPFXbAKhxrMEpWSCnyAXOQV3+45uLzaOnuPTr/Y4U
	 bdVzllFep2wtg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 105/311] net: usb: kalmia: validate USB endpoints
Date: Tue, 10 Mar 2026 07:02:32 -0400
Message-ID: <7e8af1bce21ee0e91aa4f17af74fab2f53554c06.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c58b6c29a4c9b8125e8ad3bca0637e00b71e2693 upstream.

The kalmia driver should validate that the device it is probing has the
proper number and types of USB endpoints it is expecting before it binds
to it.  If a malicious device were to not have the same urbs the driver
will crash later on when it blindly accesses these endpoints.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for Samsung GT-B3730")
Link: https://patch.msgid.link/2026022326-shack-headstone-ef6f@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/kalmia.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index 613fc6910f148..ee9c48f7f68f9 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -132,11 +132,18 @@ kalmia_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int status;
 	u8 ethernet_addr[ETH_ALEN];
+	static const u8 ep_addr[] = {
+		1 | USB_DIR_IN,
+		2 | USB_DIR_OUT,
+		0};
 
 	/* Don't bind to AT command interface */
 	if (intf->cur_altsetting->desc.bInterfaceClass != USB_CLASS_VENDOR_SPEC)
 		return -EINVAL;
 
+	if (!usb_check_bulk_endpoints(intf, ep_addr))
+		return -ENODEV;
+
 	dev->in = usb_rcvbulkpipe(dev->udev, 0x81 & USB_ENDPOINT_NUMBER_MASK);
 	dev->out = usb_sndbulkpipe(dev->udev, 0x02 & USB_ENDPOINT_NUMBER_MASK);
 	dev->status = NULL;
-- 
2.51.0

