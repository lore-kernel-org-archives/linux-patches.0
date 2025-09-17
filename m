Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF45316189;
	Wed, 17 Sep 2025 13:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114148; cv=none; b=vC83kBARA+Lk4BJ29/m0CI9P236wdqegUS8Jls/1YqmsYFckdipiISHTna9GZqsVHYKfVCYeD93dBwnNmYSNb14WWECOYv2w839LIJZg0/5jIT+cQkzrHwuEq74Ek9cS532NlNhev3LtLUeV0NlO74fwOk4eVgUsHHEmU8KpR/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114148; c=relaxed/simple;
	bh=nfGhTB0UbuIPnmzoqjNyJmlfXfLIUZuF3qoniN7qZ/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbEEWUevEl1hKk42+K9TBnMg1ceVNchSYgiqvfecaoYYeqwVLRt2oouyLSLzapD3+6M0dF0jLtvT7pXHHWwjpL2e3crW1QaHLYAnAEB7ESmhXfmcGcUjNgCi+5KFmw+hyIUZ3VeTNVY7Ov6V/SHDJxsUMYhH6BrQvDdr97rk9IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bx0SrZ05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bx0SrZ05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACE9C4CEF0;
	Wed, 17 Sep 2025 13:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114146;
	bh=nfGhTB0UbuIPnmzoqjNyJmlfXfLIUZuF3qoniN7qZ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bx0SrZ054RSoOqnNhVPLPF2tPBXm9xYMo75C4ay1cnF5wI36lhQzAZxrbQGErGWBD
	 wJEYdHBAimP3MxBvp+9nq5qArPWHOu00NLd9MILRLAkGKhKYPTwcZTo6N4mxnWXBuN
	 D9t35HILugEuf1vx6mU1lJYxBmqIILWWyV4ZAX9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 59/78] net: hsr: Disable promiscuous mode in offload mode
Date: Wed, 17 Sep 2025 14:35:20 +0200
Message-ID: <20250917123331.013296684@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
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
index 6e434af189bc0..511407df49151 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -529,6 +529,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
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
index 58a5a8b3891ff..044e0b456fcfb 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -202,6 +202,7 @@ struct hsr_priv {
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



