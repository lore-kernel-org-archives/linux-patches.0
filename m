Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85F918B491;
	Tue, 10 Sep 2024 10:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965072; cv=none; b=VZRkITcHy+VScX9hgk5hrnMI9ZC6GFIJpQhz9ba9cJ0VvT+ytd6aYxeYC6H4OuILwPAyXxr0U0j3B09VQwpeYviHTrKHrilER9r/+eQ8oQnltVlkm0seCGlB0YR2pEOcHuVWKn9HKWapvxyMiK3a4fgwMVhls/e9WnRurh0cTYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965072; c=relaxed/simple;
	bh=S+q8KxIEBwF4Q7DqjafNlQsKAwOH5k9Th5itgCqsCtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMC1qT4+UkcYAtc5RwoP148aqP0o97898qFCRO6gU3M94BIEuxxSIbL9523umMkk13qKL942SVxy00U2BhIf79mW9CkQ3nFpkZ4ErPW7SaePpskKTB21wh/DSjJ/eVBUeSkWYl+TcL/WcAzqBAE4fKG1a5JyiBVM7oUjsvnhD8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2xgrgCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2xgrgCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39436C4CEC3;
	Tue, 10 Sep 2024 10:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965072;
	bh=S+q8KxIEBwF4Q7DqjafNlQsKAwOH5k9Th5itgCqsCtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2xgrgCEqHAclXFshuv5lshMp1CLWkrmy1jqpCt6q+wva02TrEfHSwKMYdi/pNZxC
	 u0kXoDFSWgTsnJQU/3ZAE7GRpMfrNQWC21hOLnVx67xPtkQ1igAEHGSD9zdcNBIlv7
	 63Gni6ldN0BYsVhDj5ddi+uwOmiydKKnY3S0sAvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/186] usbnet: modern method to get random MAC
Date: Tue, 10 Sep 2024 11:33:35 +0200
Message-ID: <20240910092559.517630637@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e87d3108ef05..669cd20cfe00 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -64,9 +64,6 @@
 
 /*-------------------------------------------------------------------------*/
 
-// randomly generated ethernet address
-static u8	node_id [ETH_ALEN];
-
 /* use ethtool to change the level for any given device */
 static int msg_level = -1;
 module_param (msg_level, int, 0);
@@ -1696,7 +1693,6 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 
 	dev->net = net;
 	strscpy(net->name, "usb%d", sizeof(net->name));
-	eth_hw_addr_set(net, node_id);
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
@@ -1770,9 +1766,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
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
@@ -2182,7 +2178,6 @@ static int __init usbnet_init(void)
 	BUILD_BUG_ON(
 		sizeof_field(struct sk_buff, cb) < sizeof(struct skb_data));
 
-	eth_random_addr(node_id);
 	return 0;
 }
 module_init(usbnet_init);
-- 
2.43.0



