Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEDD2ED877;
	Tue, 17 Jun 2025 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176134; cv=none; b=HVH9XaqzbiELA7HMLPpmzWZLuCm8FMVxNC93HIRScZfLgiv52IigENVaqD3Cj8wH3FBlX9POkh23RbMUIj8Wt/pxtTaji2uzk4aNIyauWeqwEimWsv0yZOkN6uFGQEf47j9w8hGZXB0MCgVOwfUqmBoPR4gZ/2VRkPiacAhED0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176134; c=relaxed/simple;
	bh=XSH42miACtDUDeda3JC3CJwlb+SYuGGRrdYHw2kwEoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHZxMX7Hf98qe3UBM9EFon5U8KKK13zQtrt/fimeOhnKJQzt91zZJypK+KuPeI/0KdTZKX/DBP5xANJQAQ4iVHVSPCONH2Mt799cNs8l7/nzpIw/aQl82gmiqSpwFfGvJoSOUkMTyydximdHTt60lerIay2AK3bKJN1xKPy8TYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImnOxjt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImnOxjt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBA4C4CEE3;
	Tue, 17 Jun 2025 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176134;
	bh=XSH42miACtDUDeda3JC3CJwlb+SYuGGRrdYHw2kwEoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImnOxjt2Ve0WxTH0iMAmO+zQIu0IrjKux95y3/AXSB0P9UtVMRDRo1WnHrf6wW1dA
	 07tTpZf6JD7+GnfpZW7OFgDyVybR4/qKt1cgAZRDevJ+AQl1Ff243Q39rLolEnxxra
	 EnTuS4xnn9Iwxo14AHF71lpSAk74yYsu7NTbvBUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/356] net: lan966x: Make sure to insert the vlan tags also in host mode
Date: Tue, 17 Jun 2025 17:26:03 +0200
Message-ID: <20250617152348.189314248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 27eab4c644236a9324084a70fe79e511cbd07393 ]

When running these commands on DUT (and similar at the other end)
ip link set dev eth0 up
ip link add link eth0 name eth0.10 type vlan id 10
ip addr add 10.0.0.1/24 dev eth0.10
ip link set dev eth0.10 up
ping 10.0.0.2

The ping will fail.

The reason why is failing is because, the network interfaces for lan966x
have a flag saying that the HW can insert the vlan tags into the
frames(NETIF_F_HW_VLAN_CTAG_TX). Meaning that the frames that are
transmitted don't have the vlan tag inside the skb data, but they have
it inside the skb. We already get that vlan tag and put it in the IFH
but the problem is that we don't configure the HW to rewrite the frame
when the interface is in host mode.
The fix consists in actually configuring the HW to insert the vlan tag
if it is different than 0.

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Fixes: 6d2c186afa5d ("net: lan966x: Add vlan support.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20250528093619.3738998-1-horatiu.vultur@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |  1 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  1 +
 .../microchip/lan966x/lan966x_switchdev.c     |  1 +
 .../ethernet/microchip/lan966x/lan966x_vlan.c | 21 +++++++++++++++++++
 4 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 05f6c92275830..b424e75fd40c4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -881,6 +881,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	lan966x_vlan_port_set_vlan_aware(port, 0);
 	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
 	lan966x_vlan_port_apply(port);
+	lan966x_vlan_port_rew_host(port);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index b65d58a1552b5..5a16d76eb000d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -549,6 +549,7 @@ void lan966x_vlan_port_apply(struct lan966x_port *port);
 bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 vid);
 void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
 				      bool vlan_aware);
+void lan966x_vlan_port_rew_host(struct lan966x_port *port);
 int lan966x_vlan_port_set_vid(struct lan966x_port *port,
 			      u16 vid,
 			      bool pvid,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 1c88120eb291a..bcb4db76b75cd 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -297,6 +297,7 @@ static void lan966x_port_bridge_leave(struct lan966x_port *port,
 	lan966x_vlan_port_set_vlan_aware(port, false);
 	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
 	lan966x_vlan_port_apply(port);
+	lan966x_vlan_port_rew_host(port);
 }
 
 int lan966x_port_changeupper(struct net_device *dev,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
index 3c44660128dae..ffb245fb7d678 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -149,6 +149,27 @@ void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
 	port->vlan_aware = vlan_aware;
 }
 
+/* When the interface is in host mode, the interface should not be vlan aware
+ * but it should insert all the tags that it gets from the network stack.
+ * The tags are not in the data of the frame but actually in the skb and the ifh
+ * is configured already to get this tag. So what we need to do is to update the
+ * rewriter to insert the vlan tag for all frames which have a vlan tag
+ * different than 0.
+ */
+void lan966x_vlan_port_rew_host(struct lan966x_port *port)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 val;
+
+	/* Tag all frames except when VID=0*/
+	val = REW_TAG_CFG_TAG_CFG_SET(2);
+
+	/* Update only some bits in the register */
+	lan_rmw(val,
+		REW_TAG_CFG_TAG_CFG,
+		lan966x, REW_TAG_CFG(port->chip_port));
+}
+
 void lan966x_vlan_port_apply(struct lan966x_port *port)
 {
 	struct lan966x *lan966x = port->lan966x;
-- 
2.39.5



