Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D5B306D37;
	Mon, 27 Oct 2025 19:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591963; cv=none; b=RhNQR+NLgVzcFljaTJa44l1LIj5vU7iQswR7fN6P2s9Z+mWgJt4H9Q0I/jMbG4B+LAAJWjq+M+m92eVNsMP4y2kfqhvseGd99EAJc/9sbOEtf4O/zO8I0coxQ9C7Ssg1trsNMfrne8miRlnuPmYcQZxN1Xl0b/J1JV/j63umCZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591963; c=relaxed/simple;
	bh=1Hka3bpoh71dCYNtRq31PpZtsfy8Y8oo4Dmz88Y5LUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu2MRk3xLPuZEdMYQ7gbb/+YLz7mVLMTI5daNh+CPM0x5Ha5B/2I7ty/ZTmSpaCsXf60o6xUSbCzCXjoh90bLjrGCXQjL5K3xv229eOdCncU5gg1U7wblNGBavfOwtR5xayBMLiytrIIYjYozUa9JQoCsHjt6TDBVTODszzYhc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaMTMVFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaMTMVFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C21C4CEF1;
	Mon, 27 Oct 2025 19:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591963;
	bh=1Hka3bpoh71dCYNtRq31PpZtsfy8Y8oo4Dmz88Y5LUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaMTMVFY/8h5ub8QY3+lYcxn3nel3iknLdZNy8kKqvEytU9RZexPeyV7IxkfHpjyA
	 9aXD21uCyMVKd4sZ694z6y98m8pDrjNkDG9GtpdBT+OY664zLvlabFAvgrtA9zSnZA
	 tTujOEsu2tO6rh/GqsSCgMZ5abxZOrFoS9p5Lqwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/123] net: usb: use eth_hw_addr_set() instead of ether_addr_copy()
Date: Mon, 27 Oct 2025 19:35:09 +0100
Message-ID: <20251027183447.179980260@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6be07557bc63d..00aba7e1d0b95 100644
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
index 2279a4b8cd4e3..4be15489a2c2a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1819,7 +1819,7 @@ static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
 	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
 
-	ether_addr_copy(dev->net->dev_addr, addr);
+	eth_hw_addr_set(dev->net, addr);
 }
 
 /* MDIO read and write wrappers for phylib */
@@ -2394,7 +2394,7 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	ether_addr_copy(netdev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(netdev, addr->sa_data);
 
 	addr_lo = netdev->dev_addr[0] |
 		  netdev->dev_addr[1] << 8 |
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 1dfa0091fa307..1bd18a6292803 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1724,7 +1724,7 @@ static int set_ethernet_addr(struct r8152 *tp, bool in_resume)
 		return ret;
 
 	if (tp->version == RTL_VER_01)
-		ether_addr_copy(dev->dev_addr, sa.sa_data);
+		eth_hw_addr_set(dev, sa.sa_data);
 	else
 		ret = __rtl8152_set_mac_address(dev, &sa, in_resume);
 
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index e5f6614da5acc..f3e4a68b6c947 100644
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
index 324bec0c22fb4..57f1056a27b14 100644
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



