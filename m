Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71A31DDC04;
	Mon, 23 Jun 2025 21:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714433; cv=none; b=p1dXTyo4/UTDAT/gsMuC6v+OxrsSyGYulmYWSZI5glJD2L06IGg4NbGqMBlGtGA1dOPjoEsmW1zcG6wLNa/VI7tNDymY5iDrhEZR9s9M2szYTQSv6ewHKDnKAeN+Lel/AVyRazjjYcEzaiL5PetpH65ADBAHKqW3ykwIpSeVg7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714433; c=relaxed/simple;
	bh=JVNNcEkRlrX/M0UV4Y0wvQ9EqjEDYMeZPU6BauaEgbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=codUpWSrn87eaAQYgNzt/l7vJHvSaEEt+/hxxCfFkOmvbGhEWswV2iD4oE2JCuOe6VM24Jm+Mvo98M43S/7WMl3NQ6Qw04An8tTn6rEqx4X2x4cHL4hLYbXJaJL9KeyWPHR6oNnM+cb8DjLn9nM/QMIfQYjix0jxRqaPK5LzEKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfF6yN67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfF6yN67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CDCC4CEEA;
	Mon, 23 Jun 2025 21:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714433;
	bh=JVNNcEkRlrX/M0UV4Y0wvQ9EqjEDYMeZPU6BauaEgbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfF6yN67ftxlmV7VTY836hla9VYPxX/b3jSSV1BYOR4n0ViRZId15mg0FEnFB19z7
	 9ZLT3fNt+V9fHOtM09Tcxz3nzpT7X2J0urpH7tI+JEGFq+Mz50//y0Hj1GKb15veiw
	 GIvYIGVy64hlTAFo+Nd+5ytF7aPRE0q8eCKSOt+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/508] net: lan966x: Make sure to insert the vlan tags also in host mode
Date: Mon, 23 Jun 2025 15:03:37 +0200
Message-ID: <20250623130649.505861969@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
index 9ce46588aaf03..8c048ffde23d6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -811,6 +811,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	lan966x_vlan_port_set_vlan_aware(port, 0);
 	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
 	lan966x_vlan_port_apply(port);
+	lan966x_vlan_port_rew_host(port);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 4ec33999e4df6..ff5736d2c7a6b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -388,6 +388,7 @@ void lan966x_vlan_port_apply(struct lan966x_port *port);
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



