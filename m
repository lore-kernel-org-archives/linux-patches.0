Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF4C1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE4AC433C8;
	Tue, 25 Jul 2023 11:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283693;
	bh=EIVF2hqAdC7t/tt2n92QFJNht++KwE3yKP65bXrViyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecQkoOjmlRzj0qpccBSLrbNbZawppda+05TzJQszht0RrOTlJ40GDRmBs1R8QzkzD
	 rU/kUS3U/Gt98D2g4osxWIF+0K2xZxyD+wf44b7c8/Q+YG3lesHeM0dGpoKtXeCiFW
	 FGm94wJ130tswEC0z/hZWDPmt1X5EImO9kbriqZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/509] net: create netdev->dev_addr assignment helpers
Date: Tue, 25 Jul 2023 12:39:59 +0200
Message-ID: <20230725104556.440764132@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 48eab831ae8b9f7002a533fa4235eed63ea1f1a3 ]

Recent work on converting address list to a tree made it obvious
we need an abstraction around writing netdev->dev_addr. Without
such abstraction updating the main device address is invisible
to the core.

Introduce a number of helpers which for now just wrap memcpy()
but in the future can make necessary changes to the address
tree.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 391af06a02e7 ("wifi: wl3501_cs: Fix an error handling path in wl3501_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/etherdevice.h | 12 ++++++++++++
 include/linux/netdevice.h   | 18 ++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 99209f50915f4..b060514bf25d2 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -299,6 +299,18 @@ static inline void ether_addr_copy(u8 *dst, const u8 *src)
 #endif
 }
 
+/**
+ * eth_hw_addr_set - Assign Ethernet address to a net_device
+ * @dev: pointer to net_device structure
+ * @addr: address to assign
+ *
+ * Assign given address to the net_device, addr_assign_type is not changed.
+ */
+static inline void eth_hw_addr_set(struct net_device *dev, const u8 *addr)
+{
+	ether_addr_copy(dev->dev_addr, addr);
+}
+
 /**
  * eth_hw_addr_inherit - Copy dev_addr from another net_device
  * @dst: pointer to net_device to copy dev_addr to
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8f03cc42bd43f..302abfc2a1f63 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4474,6 +4474,24 @@ void __hw_addr_unsync_dev(struct netdev_hw_addr_list *list,
 void __hw_addr_init(struct netdev_hw_addr_list *list);
 
 /* Functions used for device addresses handling */
+static inline void
+__dev_addr_set(struct net_device *dev, const u8 *addr, size_t len)
+{
+	memcpy(dev->dev_addr, addr, len);
+}
+
+static inline void dev_addr_set(struct net_device *dev, const u8 *addr)
+{
+	__dev_addr_set(dev, addr, dev->addr_len);
+}
+
+static inline void
+dev_addr_mod(struct net_device *dev, unsigned int offset,
+	     const u8 *addr, size_t len)
+{
+	memcpy(&dev->dev_addr[offset], addr, len);
+}
+
 int dev_addr_add(struct net_device *dev, const unsigned char *addr,
 		 unsigned char addr_type);
 int dev_addr_del(struct net_device *dev, const unsigned char *addr,
-- 
2.39.2



