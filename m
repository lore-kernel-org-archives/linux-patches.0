Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF4D188CC1;
	Tue, 10 Sep 2024 09:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961145; cv=none; b=DAEhcqZzISZG9vnDrXh5wKE9u6SUVzoW9vT+59YD9E3Vm4dwim2OdI1vdRSi4g2EqpjGlcctMBdwf+M5bgoDTIxIdidC1BxPl/KGJQSAN1uyA90/p7G+hCWrQgmwkxJ76vE6GolLTszZ309GxS/fA6Fon4btOXJrD2pLWtiWVL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961145; c=relaxed/simple;
	bh=s5sMqgvBgxMphbkMJ/6+ZvwMLfHSHMNEXz3LJ1PF2aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJqzMwJAY/tT6Rl9ce0ZoaMBfCrorDwLxDWxTZnsi+5zdMP6U7dlYaoQQNwoqiIQ3cLYw9IREpS8LKZ9yoDuAqs6bsI0FpWOrk02QyJeYu5SueQd6Fx7afZgiABp9NnQSiLfmyT0ND9J3vy+AQIDaqEKmBe+wceB3obrDquslDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgAdbEd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgAdbEd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F69C4CEC3;
	Tue, 10 Sep 2024 09:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961145;
	bh=s5sMqgvBgxMphbkMJ/6+ZvwMLfHSHMNEXz3LJ1PF2aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgAdbEd/zfxW5jwBERGJt5K1PFstPZLwEybtKR9jooSPM9FEbRg2plloHDGjFZ0E2
	 vPVPZnEgnBsook8rbPen3wSBI3TOVN0RsoNimnnAvt/VSk2cjbAKVY+4cIV91tV49V
	 1P4tEEEoDVjrH6iRPrTkL5uCMz2BF68S8tEm6cpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/96] usbnet: modern method to get random MAC
Date: Tue, 10 Sep 2024 11:31:43 +0200
Message-ID: <20240910092543.334987980@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 16225654d88c..938335f4738d 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -79,9 +79,6 @@
 
 /*-------------------------------------------------------------------------*/
 
-// randomly generated ethernet address
-static u8	node_id [ETH_ALEN];
-
 /* use ethtool to change the level for any given device */
 static int msg_level = -1;
 module_param (msg_level, int, 0);
@@ -1725,7 +1722,6 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 
 	dev->net = net;
 	strscpy(net->name, "usb%d", sizeof(net->name));
-	eth_hw_addr_set(net, node_id);
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
@@ -1799,9 +1795,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
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
@@ -2211,7 +2207,6 @@ static int __init usbnet_init(void)
 	BUILD_BUG_ON(
 		FIELD_SIZEOF(struct sk_buff, cb) < sizeof(struct skb_data));
 
-	eth_random_addr(node_id);
 	return 0;
 }
 module_init(usbnet_init);
-- 
2.43.0



