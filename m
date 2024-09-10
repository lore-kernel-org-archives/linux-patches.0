Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6F67581D;
	Tue, 10 Sep 2024 10:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964350; cv=none; b=RoHOwFczIV+/Le+3xVZ/cun/fAfLehZUfRM6OiPap0bq0mzRt5PDD6rh0VbUmdIb+vrKYsE3z39RmZg03ixmb/jrL+D0hTizRexKLaezaUXWSQJbPof8WL7F+c5P1AXWvavtSQ0nc75nYooUAIFTjIN4bE53+GeClPibRjLvfXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964350; c=relaxed/simple;
	bh=iloXmZrh46YuvrgliXlSRpjM5FTMjPdNZovt63LBgVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfjAzlJvfhiRkhuRXdykaWIv2Ekpolqobwezj657kpiD6g66idy2OLPd1P2EHk1L/1K22UXFKoKYbUex6+vKqQvCm1FiK23hyGdwlSOgMun5B4sY6Lp60kcKnLueYHTY5hHI2q3DvVwKt/dye/SrzyHGkhYo7tJbfPgRQRVxHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9ZB0ctR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9ZB0ctR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86819C4CEC3;
	Tue, 10 Sep 2024 10:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964349;
	bh=iloXmZrh46YuvrgliXlSRpjM5FTMjPdNZovt63LBgVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9ZB0ctRZbjliZ3+/KK+d/G40LqpOeXttNQNc59XHT1C2T46tramN3LJrhl9bBuJK
	 YCxnuyokYBR74d0A4Iyq0gNx+l+xq/Yc9RZ72o1KTYG9mXJ0JLg8gC5An1d+zv6v11
	 eAiRF4RfYh0yQ2Uqg2d4aoBKulUWYG1VEuS9QFyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/269] usbnet: modern method to get random MAC
Date: Tue, 10 Sep 2024 11:31:52 +0200
Message-ID: <20240910092612.633636129@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit bab8eb0dd4cb995caa4a0529d5655531c2ec5e8e ]

The driver generates a random MAC once on load
and uses it over and over, including on two devices
needing a random MAC at the same time.

Jakub suggested revamping the driver to the modern
API for setting a random MAC rather than fixing
the old stuff.

The bug is as old as the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/20240829175201.670718-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 2d14b0d78541..6cc1b56ddde2 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -61,9 +61,6 @@
 
 /*-------------------------------------------------------------------------*/
 
-// randomly generated ethernet address
-static u8	node_id [ETH_ALEN];
-
 /* use ethtool to change the level for any given device */
 static int msg_level = -1;
 module_param (msg_level, int, 0);
@@ -1731,7 +1728,6 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 
 	dev->net = net;
 	strscpy(net->name, "usb%d", sizeof(net->name));
-	eth_hw_addr_set(net, node_id);
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
@@ -1805,9 +1801,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		goto out4;
 	}
 
-	/* let userspace know we have a random address */
-	if (ether_addr_equal(net->dev_addr, node_id))
-		net->addr_assign_type = NET_ADDR_RANDOM;
+	/* this flags the device for user space */
+	if (!is_valid_ether_addr(net->dev_addr))
+		eth_hw_addr_random(net);
 
 	if ((dev->driver_info->flags & FLAG_WLAN) != 0)
 		SET_NETDEV_DEVTYPE(net, &wlan_type);
@@ -2217,7 +2213,6 @@ static int __init usbnet_init(void)
 	BUILD_BUG_ON(
 		sizeof_field(struct sk_buff, cb) < sizeof(struct skb_data));
 
-	eth_random_addr(node_id);
 	return 0;
 }
 module_init(usbnet_init);
-- 
2.43.0



