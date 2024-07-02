Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAC71BD4EA;
	Tue,  2 Jul 2024 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941519; cv=none; b=BRCy4gncrriW2t20CrsqpyU6fL54fV+f/QpDOJ2MR4t4mX2ILSP9uvtnmoWkjuCt1SFFj0N124Foj07C/dwTP3kI9T4AUy3S6ycPWnrtza6OaQinRwZkMI0TPWLp9Kq3RLZAsc/f9Qaw095oIbsRh5YpvhR6+lrxXeAREx/lX34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941519; c=relaxed/simple;
	bh=QLB+Du/t2w5uujg3Hh6MSfV6jsQThM+hk7On1GT1KuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCqXXxr50mgWvibkbQ6uOejRkweHtJA8ewKCyX7rXmfXppZyR/IpA6u7PtAlQq4oG1PAg7BaN1XPmc/zMqK2Wdd7nGtY4pRtzW6BI57oULDfWUHHQEhAWH58Zhw4ZBU4R/Y7VQ0dKjuOV6fEId5xWsY1Oq92z+RMk0HfEXsJ+qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bng2AWTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bng2AWTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F52C116B1;
	Tue,  2 Jul 2024 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941519;
	bh=QLB+Du/t2w5uujg3Hh6MSfV6jsQThM+hk7On1GT1KuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bng2AWTkUMN84s6jcPSSKwbV+DPdvmlSOmrhdQIszTVD4nzPxJeyqLLJcu8ejKRL8
	 OtDSZiMDTtnkfZsqKTnXl8Bw1zenY11mZn4V24xmebV982DPKlR3YQMI1WPG2zCg5L
	 +LuvcElqgAqUfOiJ5GSJbSxV09t0EWpjSzI67zQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Liu <neal_liu@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH 6.1 088/128] usb: gadget: aspeed_udc: fix device address configuration
Date: Tue,  2 Jul 2024 19:04:49 +0200
Message-ID: <20240702170229.552214498@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

commit dba7567c2fbbf10a4de2471cdb0e16e5572dc007 upstream.

In the aspeed UDC setup, we configure the UDC hardware with the assigned
USB device address.

However, we have an off-by-one in the bitmask, so we're only setting the
lower 6 bits of the address (USB addresses being 7 bits, and the
hardware bitmask being bits 0:6).

This means that device enumeration fails if the assigned address is
greater than 64:

[  344.607255] usb 1-1: new high-speed USB device number 63 using ehci-platform
[  344.808459] usb 1-1: New USB device found, idVendor=cc00, idProduct=cc00, bcdDevice= 6.10
[  344.817684] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  344.825671] usb 1-1: Product: Test device
[  344.831075] usb 1-1: Manufacturer: Test vendor
[  344.836335] usb 1-1: SerialNumber: 00
[  349.917181] usb 1-1: USB disconnect, device number 63
[  352.036775] usb 1-1: new high-speed USB device number 64 using ehci-platform
[  352.249432] usb 1-1: device descriptor read/all, error -71
[  352.696740] usb 1-1: new high-speed USB device number 65 using ehci-platform
[  352.909431] usb 1-1: device descriptor read/all, error -71

Use the correct mask of 0x7f (rather than 0x3f), and generate this
through the GENMASK macro, so we have numbers that correspond exactly
to the hardware register definition.

Fixes: 055276c13205 ("usb: gadget: add Aspeed ast2600 udc driver")
Cc: stable@vger.kernel.org
Reviewed-by: Neal Liu <neal_liu@aspeedtech.com>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://lore.kernel.org/r/20240613-aspeed-udc-v2-1-29501ce9cb7a@codeconstruct.com.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/aspeed_udc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/udc/aspeed_udc.c
+++ b/drivers/usb/gadget/udc/aspeed_udc.c
@@ -66,8 +66,8 @@
 #define USB_UPSTREAM_EN			BIT(0)
 
 /* Main config reg */
-#define UDC_CFG_SET_ADDR(x)		((x) & 0x3f)
-#define UDC_CFG_ADDR_MASK		(0x3f)
+#define UDC_CFG_SET_ADDR(x)		((x) & UDC_CFG_ADDR_MASK)
+#define UDC_CFG_ADDR_MASK		GENMASK(6, 0)
 
 /* Interrupt ctrl & status reg */
 #define UDC_IRQ_EP_POOL_NAK		BIT(17)


