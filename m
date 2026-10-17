Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4DE17BED0;
	Sat, 17 Oct 2026 16:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253979; cv=none; b=olHJAz5enJZSsLaN9VSr+VY6yRDnuY+viOXvYJYIhR7j8pvqwcuRUk06wpkEZwXNknNJ4ev3orVNCRxKNBMjHjxTD9B2NRvXYRCJITKhPmsP2uZ5SGoypQBGWFCwRV6RZABRtB76xi9u61ivcr7KW7PElFZL+u5aqhQlKYRBrBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253979; c=relaxed/simple;
	bh=/lvR3BnB+zLvRwZg0scI5i+G8LAqzuISI025HnCpoiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHCeC63gZKVYW02nsM5ag5bC9jvIeLkPbDa8NZDBbQYLbfc7oU11j1xkFqZmZCeKoWs6zgc1tm9UC+C3m0OQnOT4RhRMCTZ5hbq0JIR7VetrK4ObXUs8sxqxjBv9jLgvUXGIf65SHa0FYFdPxgcNkb+jFGBWPnojGqFz5xvKvBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJP8hPYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJP8hPYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C991F000C4;
	Sat, 17 Oct 2026 16:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253978;
	bh=hMmA90p9LrYzjbWNEa5WzSo03tJZxgNYVsFNLccj4Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJP8hPYDFHfkIbQvK4UwrlDsKNF4wPdN5gcmglw0wLijdEvdvu/JhVLjfIym93UW/
	 7XSxhpDGhJgYtx0yUkf6vRnpBq3mc2LBEfEBksgONyv+yJu1SwZqwHoLkEob6F+Gp1
	 zqFMKqmGhx7ctKg3GZq9jddBukQyW5+LOMxb2/lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <jth@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/869] spi: ch341: fix devres lifetime
Date: Sat, 17 Oct 2026 17:52:18 +0200
Message-ID: <20261017160044.690370963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit abe572f630bc1f0e77041012ab075869036ede4f ]

USB drivers bind to USB interfaces and any device managed resources
should have their lifetime tied to the interface rather than parent USB
device. This avoids issues like memory leaks when drivers are unbound
without their devices being physically disconnected (e.g. on probe
deferral or configuration changes).

Fix the controller and driver data lifetime so that they are released
on driver unbind.

Note that this also makes sure that the SPI controller is placed
correctly under the USB interface in the device tree.

Fixes: 8846739f52af ("spi: add ch341a usb2spi driver")
Cc: stable@vger.kernel.org	# 6.11
Cc: Johannes Thumshirn <jth@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260327104305.1309915-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ch341.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-ch341.c b/drivers/spi/spi-ch341.c
index ded0935662605..3eaa8f176f63a 100644
--- a/drivers/spi/spi-ch341.c
+++ b/drivers/spi/spi-ch341.c
@@ -152,7 +152,7 @@ static int ch341_probe(struct usb_interface *intf,
 	if (ret)
 		return ret;
 
-	ctrl = devm_spi_alloc_host(&udev->dev, sizeof(struct ch341_spi_dev));
+	ctrl = devm_spi_alloc_host(&intf->dev, sizeof(struct ch341_spi_dev));
 	if (!ctrl)
 		return -ENOMEM;
 
@@ -163,7 +163,7 @@ static int ch341_probe(struct usb_interface *intf,
 	ch341->read_pipe = usb_rcvbulkpipe(udev, usb_endpoint_num(in));
 
 	ch341->rx_len = usb_endpoint_maxp(in);
-	ch341->rx_buf = devm_kzalloc(&udev->dev, ch341->rx_len, GFP_KERNEL);
+	ch341->rx_buf = devm_kzalloc(&intf->dev, ch341->rx_len, GFP_KERNEL);
 	if (!ch341->rx_buf)
 		return -ENOMEM;
 
@@ -171,8 +171,7 @@ static int ch341_probe(struct usb_interface *intf,
 	if (!ch341->rx_urb)
 		return -ENOMEM;
 
-	ch341->tx_buf =
-		devm_kzalloc(&udev->dev, CH341_PACKET_LENGTH, GFP_KERNEL);
+	ch341->tx_buf = devm_kzalloc(&intf->dev, CH341_PACKET_LENGTH, GFP_KERNEL);
 	if (!ch341->tx_buf) {
 		ret = -ENOMEM;
 		goto err_free_urb;
-- 
2.53.0



