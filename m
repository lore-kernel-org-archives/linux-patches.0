Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5290412CDA5;
	Mon, 23 Mar 2026 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282214; cv=none; b=OQWNbDf4uUzxhO7D+eBwKgqnHoRZmXJuVaITxIqBvIrp+Tk6R2bs4n73vIiJ+8LQPdHoM1eSnpH7IDR38gQWZlN0pPra1l3tlknZujvJ63HiwHccwRgCK2GTcunQqAQCEU7B9+gL2d8fnuH7Re8u1WiWV3ncpYG8fXmNC9setCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282214; c=relaxed/simple;
	bh=njftkFTkzqCsxOb6ZpzeehxjWEvoZs5LOmdcKzgNt5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTaVN3Yc0Sk1YrwIZ+nxhJ4TzHPpFIzmxkALDCc3k+HdgaxKSm57tCHakFETnzJjWwuRlJXHCoNZBqwIVFCgRcN/y3ekHipiByDFK7Y6EMMlLD/D73k5PvHcqDmd6rcQlDcmnRLWBMXc+w0zG0N0JjrvsC9BRz7zHLTEGjaQfpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rroX0vpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rroX0vpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870B6C4CEF7;
	Mon, 23 Mar 2026 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282213;
	bh=njftkFTkzqCsxOb6ZpzeehxjWEvoZs5LOmdcKzgNt5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rroX0vpu+uDClOW0c3vl9AYt4qs0mZ3zHEBFclYgCsykF9o62qr256JYwglZWdud9
	 02rAItYfcAFhGtjFyQmg+QpYgsgnTEkiqFuhpBFD96/g7oY8EOavLRk1GKU5hy+ENK
	 7ahl0dv4NgWaHPiNlSyMBABGs1p/LAR6qq2WwrBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 073/481] net: usb: kalmia: validate USB endpoints
Date: Mon, 23 Mar 2026 14:40:55 +0100
Message-ID: <20260323134527.014436750@linuxfoundation.org>
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
 drivers/net/usb/kalmia.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -132,11 +132,18 @@ kalmia_bind(struct usbnet *dev, struct u
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


