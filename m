Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CE33328ED;
	Mon, 27 Oct 2025 18:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591574; cv=none; b=angBjkw+FPgG14LtcIo4180uGROy7GTXw3AYPzz6lwPAK9D4Lt7dzM/IPVX2lwX1+RGwUZxuOK7tOjvGbwy3CUrbqOhud/fj5zeEv8ZHp+7/wotZyD7G/om2vFh0yi7pqqyQKQiJlAIHQ4B9bHhszYsvGM7yqf9Z5bgogOVd3gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591574; c=relaxed/simple;
	bh=QzJyek1+d24ji28DregmcKpMBIrxYSMOs76VJpeK4Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUqGknnp7K4Nm3qkCMW8MpUe8/v2xMeY/6eY5n4ZkgPKvjmLEui/DfV+EV8dNFflAojwM+6GrsmbIRleZ4qZ4i7To61u1+2o20VpoFtjgomx/AIva6T7Q/cYrSBmZQYrwh/au2AhQA6K9KX+66HlN6G+aDcmcGNwXDFgWzsC1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIcMx6hs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIcMx6hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C53C4CEF1;
	Mon, 27 Oct 2025 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591574;
	bh=QzJyek1+d24ji28DregmcKpMBIrxYSMOs76VJpeK4Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIcMx6hsoHeHL9ZkeMNMIPLSrZWcvcevyM0LtWSf0gK1zSQCd2F9uFXCHq0HfA3yB
	 zu4cw1zfmFbHSX/KPyp0HlIeK4kK3a8oJaZj0+PpU7sz4A4IZu4zfhZurqaelsrvAG
	 kL94yoaVW8MEv2YL859cfWPKCamqTSRJVO4qaFCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/332] net: usb: use eth_hw_addr_set() instead of ether_addr_copy()
Date: Mon, 27 Oct 2025 19:35:02 +0100
Message-ID: <20251027183531.415135103@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit af804e6db9f60b923ff5149d9bf782e0baa82a2b ]

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Convert net/usb from ether_addr_copy() to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - ether_addr_copy(dev->dev_addr, np)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 8d93ff40d49d ("net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/aqc111.c     | 2 +-
 drivers/net/usb/lan78xx.c    | 4 ++--
 drivers/net/usb/r8152.c      | 2 +-
 drivers/net/usb/rndis_host.c | 2 +-
 drivers/net/usb/rtl8150.c    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 485959771431d..ab9431ea295ad 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -720,7 +720,7 @@ static int aqc111_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret)
 		goto out;
 
-	ether_addr_copy(dev->net->dev_addr, dev->net->perm_addr);
+	eth_hw_addr_set(dev->net, dev->net->perm_addr);
 
 	/* Set Rx urb size */
 	dev->rx_urb_size = URB_SIZE;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index cabe6cdd6903a..3e3c67dc6bf74 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1756,7 +1756,7 @@ static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
 	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
 
-	ether_addr_copy(dev->net->dev_addr, addr);
+	eth_hw_addr_set(dev->net, addr);
 }
 
 /* MDIO read and write wrappers for phylib */
@@ -2331,7 +2331,7 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	ether_addr_copy(netdev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(netdev, addr->sa_data);
 
 	addr_lo = netdev->dev_addr[0] |
 		  netdev->dev_addr[1] << 8 |
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0d6f10c9bb139..57565fb2c0a11 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1545,7 +1545,7 @@ static int set_ethernet_addr(struct r8152 *tp)
 		return ret;
 
 	if (tp->version == RTL_VER_01)
-		ether_addr_copy(dev->dev_addr, sa.sa_data);
+		eth_hw_addr_set(dev, sa.sa_data);
 	else
 		ret = rtl8152_set_mac_address(dev, &sa);
 
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 1ff723e15d523..a244796fcaa44 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -422,7 +422,7 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
 	if (bp[0] & 0x02)
 		eth_hw_addr_random(net);
 	else
-		ether_addr_copy(net->dev_addr, bp);
+		eth_hw_addr_set(net, bp);
 
 	/* set a nonzero filter to enable data transfers */
 	memset(u.set, 0, sizeof *u.set);
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index c0f5e8ab1e34e..84252487ae49a 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -270,7 +270,7 @@ static void set_ethernet_addr(rtl8150_t *dev)
 	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
 
 	if (!ret) {
-		ether_addr_copy(dev->netdev->dev_addr, node_id);
+		eth_hw_addr_set(dev->netdev, node_id);
 	} else {
 		eth_hw_addr_random(dev->netdev);
 		netdev_notice(dev->netdev, "Assigned a random MAC address: %pM\n",
-- 
2.51.0



