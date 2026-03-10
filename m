Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1168E38A719;
	Tue, 10 Mar 2026 11:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142009; cv=none; b=Xe8nMpZ5wHlHmxHQ7Y0tBtx+3BCZfxBqv2JygdZDVTqP+FqapfdmtqTuXFwa5tO/LGcAAg1ls5LVGyjl535dKWKMW9yXbsKikXHP7UUFrw8z4ekPPwX9XPh8kelovJ5OhAqu0ccIqTCu/s5Mb3k6kXvKJjzM7T3vuaFgxRzPHEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142009; c=relaxed/simple;
	bh=UboOLGsM+j5RY8vF2Z7DyofaqVousVVoTNbu/QM+uT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7AlF0GTQ9GRHe6i1oLBHt9sZLMo2j7bMSJu6va7Iu1FgwH9XS7TMjmLmotxBm1MSjp9MQzcrm3NumdF1QmmhJ1D3X15NpzY7os+NbNJJajAu8F6Mt26/VOcCb3i53qwvo3+/rvbrXSPq1cwDt3UoDEs41ZcgcPDnrCXdVNipSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mw+8za31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mw+8za31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38897C2BC9E;
	Tue, 10 Mar 2026 11:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142008;
	bh=UboOLGsM+j5RY8vF2Z7DyofaqVousVVoTNbu/QM+uT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw+8za31n7WshNKrCyRUNPH9G0bzWyQMS+UcnmV2ik+U2PWKfVLK/zZ9eCQN8fFxI
	 i+wNpgADKU9c8nUHK3zCPUg0ZX59t8TDnj54NzDnixbNbvunKhtmGwVPlOv/QmNq2U
	 78h0tn4NlFM83bHx25hC3Cxn/t7QJkrJgiYRg3ldFpPiNHk0Cf5BZY/YDEC66mwL0m
	 We1+YAY1SWJhwIRsFe1YAfvfzdCizZ6G5SNWLhmd2n98n/676BcqDEHHQZv0PaLWnl
	 vvt1H+yyPjsitwQOUFv7Xd9uPaj4DPMpBfAImdM+ojbHoWKcxz4fFp17VnHRxJc+9E
	 ctfCeMhmZjo6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 135/314] net: usb: kalmia: validate USB endpoints
Date: Tue, 10 Mar 2026 07:16:34 -0400
Message-ID: <9519d1ab440d665ec50a3ed686fc8bd3a4739628.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

