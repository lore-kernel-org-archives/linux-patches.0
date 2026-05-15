Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A4324A06A;
	Fri, 15 May 2026 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862661; cv=none; b=R7uNL+/kJivN3w4o3aPdINnAbqxF7KrW4Ui+mUgEWMYHYziL9xUL8UdQ7zCg3zP7B+WQfCM6Y3LPwIaFTNvWm/5SEhKtsVkk/1h3PesRcsRi3nUgmnibAQY/NuQO7SM3bxJ0IYWtUjQ4YCvu5pBgoSkz2aqvslcxvfS+dh1nLwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862661; c=relaxed/simple;
	bh=UT3F8X4fkhIHwSJiYz0Mv0m3K/NvIyc5VjpbzlPd/uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pty4/+ZHrf9psIn5MKA3OacPu3CMRf573VxsVl/E7WNxN/6rvenDq3nmm6Hbqm7hZxwG7tyjykSgXBrDIEWllGzyoJLmjUmwoW+VIWtj8mQrMumMkKL+T0r8FMVUzSsQtnSRYZEKTYIY4iG+W9nmCr3AI/LhFCv5SqHLSdIN7p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xr3YCInf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xr3YCInf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D89C2BCC7;
	Fri, 15 May 2026 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862661;
	bh=UT3F8X4fkhIHwSJiYz0Mv0m3K/NvIyc5VjpbzlPd/uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xr3YCInfDhASj7wMGieH1PSXskQpg1iTDpBLcCihrgoh/j6bkG4VkX0WYDBXwqAU9
	 w1nyUkEvzHXcX/NmSIVF7l3uYlwrzGDXP1/WxE+B2WddcE2cveEpuvoPWqALvBa6p6
	 uGktlEpyyQvYAbCQE0UYzyk+/T0iJYHj7e2ebuQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <jth@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 093/201] spi: ch341: fix devres lifetime
Date: Fri, 15 May 2026 17:48:31 +0200
Message-ID: <20260515154700.547451232@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit abe572f630bc1f0e77041012ab075869036ede4f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ch341.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-ch341.c
+++ b/drivers/spi/spi-ch341.c
@@ -152,7 +152,7 @@ static int ch341_probe(struct usb_interf
 	if (ret)
 		return ret;
 
-	ctrl = devm_spi_alloc_host(&udev->dev, sizeof(struct ch341_spi_dev));
+	ctrl = devm_spi_alloc_host(&intf->dev, sizeof(struct ch341_spi_dev));
 	if (!ctrl)
 		return -ENOMEM;
 
@@ -163,7 +163,7 @@ static int ch341_probe(struct usb_interf
 	ch341->read_pipe = usb_rcvbulkpipe(udev, usb_endpoint_num(in));
 
 	ch341->rx_len = usb_endpoint_maxp(in);
-	ch341->rx_buf = devm_kzalloc(&udev->dev, ch341->rx_len, GFP_KERNEL);
+	ch341->rx_buf = devm_kzalloc(&intf->dev, ch341->rx_len, GFP_KERNEL);
 	if (!ch341->rx_buf)
 		return -ENOMEM;
 
@@ -171,8 +171,7 @@ static int ch341_probe(struct usb_interf
 	if (!ch341->rx_urb)
 		return -ENOMEM;
 
-	ch341->tx_buf =
-		devm_kzalloc(&udev->dev, CH341_PACKET_LENGTH, GFP_KERNEL);
+	ch341->tx_buf = devm_kzalloc(&intf->dev, CH341_PACKET_LENGTH, GFP_KERNEL);
 	if (!ch341->tx_buf) {
 		ret = -ENOMEM;
 		goto err_free_urb;


