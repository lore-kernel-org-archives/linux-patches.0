Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F0F2236EB;
	Tue, 30 Sep 2025 15:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245041; cv=none; b=SndXlPp63UPxXPkVwAxi40fo3Wl5f9fl22FZ/7A1E+8ZCBZVI8du+6fJ1kRmawa/m6wIxfOWm6kbWZM2iMD/1lYrFyynG6tMEtCe9VeEcXySxWk+MueRC2GnMn5gs8lJqBlgvY48NjhK3kT9eBAT1bpINIoE6g//eLRNuhMQBNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245041; c=relaxed/simple;
	bh=FNemlHQubb2vUNf4eFWT71HP6NW8vDbd4dW5XVws0TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jszPUc+/0knbbME6rbiEhbcod4OTVXVKocOnmk2xx8qT9uMHV5LCBDmReL7njMc5aqpGoHKdG8Q6dresxNyOcbDZ7ZWV6Qa86lqFrPVym03AVLStr5O3K0cNcKxTvPrl7W9sBtsHlsTXeAAvE+OKFyk8vYovamCndmu2T4mS8hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJPTe8Rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJPTe8Rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4E3C4CEF0;
	Tue, 30 Sep 2025 15:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245041;
	bh=FNemlHQubb2vUNf4eFWT71HP6NW8vDbd4dW5XVws0TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJPTe8RjQ5CudmDu3EoXRJwpi13d+a5zLRsmD/tdmON5broX/devf7XhTSNteal70
	 PO/yM0kNownrfX45U8oiO3V6F7gtoYCopmdR4cwn1jt4SWOQIR3ceZgdbk3XWO/vAc
	 OMAT/6jtVRgDPrGQEYoydHp0cXLI6qwr/R1rWGrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/151] net: hsr: Disable promiscuous mode in offload mode
Date: Tue, 30 Sep 2025 16:46:17 +0200
Message-ID: <20250930143829.485434348@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

From: Ravi Gunasekaran <r-gunasekaran@ti.com>

[ Upstream commit e748d0fd66abc4b1c136022e4e053004fce2b792 ]

When port-to-port forwarding for interfaces in HSR node is enabled,
disable promiscuous mode since L2 frame forward happens at the
offloaded hardware.

Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230614114710.31400-1-r-gunasekaran@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8884c6939913 ("hsr: use rtnl lock when iterating over ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c |  5 +++++
 net/hsr/hsr_main.h   |  1 +
 net/hsr/hsr_slave.c  | 15 +++++++++++----
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 0ffb28406fdc0..4967dc22824c7 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -532,6 +532,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	if (res)
 		goto err_add_master;
 
+	/* HSR forwarding offload supported in lower device? */
+	if ((slave[0]->features & NETIF_F_HW_HSR_FWD) &&
+	    (slave[1]->features & NETIF_F_HW_HSR_FWD))
+		hsr->fwd_offloaded = true;
+
 	res = register_netdevice(hsr_dev);
 	if (res)
 		goto err_unregister;
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 53d1f7a824630..4188516cde5da 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -212,6 +212,7 @@ struct hsr_priv {
 	u8 net_id;		/* for PRP, it occupies most significant 3 bits
 				 * of lan_id
 				 */
+	bool fwd_offloaded;	/* Forwarding offloaded to HW */
 	unsigned char		sup_multicast_addr[ETH_ALEN] __aligned(sizeof(u16));
 				/* Align to u16 boundary to avoid unaligned access
 				 * in ether_addr_equal
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 0e6daee488b4f..52302a0546133 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -137,9 +137,14 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 	struct hsr_port *master;
 	int res;
 
-	res = dev_set_promiscuity(dev, 1);
-	if (res)
-		return res;
+	/* Don't use promiscuous mode for offload since L2 frame forward
+	 * happens at the offloaded hardware.
+	 */
+	if (!port->hsr->fwd_offloaded) {
+		res = dev_set_promiscuity(dev, 1);
+		if (res)
+			return res;
+	}
 
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	hsr_dev = master->dev;
@@ -158,7 +163,9 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 fail_rx_handler:
 	netdev_upper_dev_unlink(dev, hsr_dev);
 fail_upper_dev_link:
-	dev_set_promiscuity(dev, -1);
+	if (!port->hsr->fwd_offloaded)
+		dev_set_promiscuity(dev, -1);
+
 	return res;
 }
 
-- 
2.51.0



