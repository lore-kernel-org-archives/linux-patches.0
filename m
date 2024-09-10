Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1606A188A0C;
	Tue, 10 Sep 2024 10:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963027; cv=none; b=Cu7siC978PcEZoZhf/M+WwTJ58g4VuJpnerG8EK5oiH09PnplS4/uEMgYHBOIf9dffCDJPbXulez2UurWcU9c4G4tHVM8RYlr+CH10xTSQNo1On95Z/JZrLKtUqUsI+cTeB1qzTyH+Chs1WlYqbAJ0s0xf38YDwlARxdYhWjne0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963027; c=relaxed/simple;
	bh=gU/ww9U8LtCqcoalfInV1+ATQYmyFhXG0rIv029wrTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5RUR0Aj0wb7Ll5CrEHL74Z4dcO1PppdboECEFnGtYNTQPcirIthEIUwtm04p262lDgd8X5oLQDtifxLJVwikg2sOs1WPno161lG7w7Hh0nTELrgJjG/qukbclFQx8NdRHlwNwe8YlIXyqorvRGNhhTOlioZPAdUZHp9snvSoAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qMKwo16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qMKwo16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C05EC4CEC6;
	Tue, 10 Sep 2024 10:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963026;
	bh=gU/ww9U8LtCqcoalfInV1+ATQYmyFhXG0rIv029wrTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qMKwo16pdP3RpTpxzmXlhogZfercQZRXcwbDDb+im/B0XZfETqONdViD6h308ZlU
	 Gbjfn9Do3jbW11lGZvd1OIREmmrR00CBiyJrrsAzc9EfnHQBzxeHJ28hQ6ciEnXC23
	 Jt+eZZYXpAeqbLkVcaAqDv2PfOyLDNBcriPx+kPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/192] usbnet: modern method to get random MAC
Date: Tue, 10 Sep 2024 11:31:47 +0200
Message-ID: <20240910092601.410755827@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
index 405e588f8a3a..0f848d318544 100644
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
@@ -1726,7 +1723,6 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 
 	dev->net = net;
 	strscpy(net->name, "usb%d", sizeof(net->name));
-	eth_hw_addr_set(net, node_id);
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
@@ -1800,9 +1796,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
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
@@ -2212,7 +2208,6 @@ static int __init usbnet_init(void)
 	BUILD_BUG_ON(
 		sizeof_field(struct sk_buff, cb) < sizeof(struct skb_data));
 
-	eth_random_addr(node_id);
 	return 0;
 }
 module_init(usbnet_init);
-- 
2.43.0



