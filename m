Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38BC2264DD;
	Tue, 17 Jun 2025 16:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178825; cv=none; b=G3rulxlcQCTr5VTMcdUFfAExH9xy6TyDyk1YT80uQVh5ZrgNErgwNFUIUG1sxOud8bzAKDVA9BWScnC8MBGKkcE+MnD2z6Ek2xaVLkTijBIuwPKV0CP06MhfFDqPxu1TvotS3fb4CapRy8UY/HDez8h5f7umOcYCQt6IJrzRpl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178825; c=relaxed/simple;
	bh=Y3Y4dPqES2+OlWSpJhj912MVGSWelqeNPoHr8pB1bXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMvv3/fiYsFEhpnhQeIi8mr0Sqt8jVN+ipT1Mjn+kemaR3puaLvd4l9hF7yDcJBKj53wX8IH+cIR4yf6SU+xk7CqKjSm623Lg0nDuRwf6jO20hDxl/QvSPe0/oRZcLIq+lOVsMqnsu/A9/0m7fKSg8MmNDk3xDVtHAFq+SL8a2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swi5FOWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swi5FOWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2A8C4CEE7;
	Tue, 17 Jun 2025 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178825;
	bh=Y3Y4dPqES2+OlWSpJhj912MVGSWelqeNPoHr8pB1bXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swi5FOWCxg9FI+trV9Z3f/4A/8/uiTW7WDQ2Esz2mIKtL4V4FrqnApbdM1i+jSuUX
	 oKWeyIiGr9PFQPR/pl9Z7z3yfc4WQc/uS3XYnTpwhfWxKbWwis6gAjRkKcYM1onsoR
	 wTqyO9dKCVgFBaTzFFya+BZipLNVpabyM0r/jD/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 565/780] net: lan966x: Make sure to insert the vlan tags also in host mode
Date: Tue, 17 Jun 2025 17:24:33 +0200
Message-ID: <20250617152514.492010656@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 427bdc0e4908c..7001584f1b7a6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -879,6 +879,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	lan966x_vlan_port_set_vlan_aware(port, 0);
 	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
 	lan966x_vlan_port_apply(port);
+	lan966x_vlan_port_rew_host(port);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 1f9df67f05044..4f75f06883693 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -497,6 +497,7 @@ void lan966x_vlan_port_apply(struct lan966x_port *port);
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
index fa34a739c748e..7da22520724ce 100644
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



