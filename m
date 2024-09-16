Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5704213DB9F;
	Mon, 16 Sep 2024 12:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488390; cv=none; b=M3njwYwYWHpB8kXtUxGKSKO1Jq5ORVc3FmEHdazpkxrTqnnUdQUpoFIWj0Ny1QKlcBjiCnig5KZUwtJXCVCcsWojJVBKREHskfLV7vkexAwTbJBc6btYpD++Zyljs3XOPE19xLlV/21BGU7wg9eFybDVDABoP+xU8yNcA4PVYiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488390; c=relaxed/simple;
	bh=npRHdzbg8iwR1Uvnpv0oLapwMPf+Rb8YPpUMjCPBi4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qINyVTKPvbADNK/8bIIw0/GEnkvjkoZdIEdzQTOcbfoQHrkg1f5a0yYc7+10JcwbZiy6CrUvjcaz5ZhY6s9P9P3iTTpFo1Ocp5T/Ahx/QM5LvXy/BjRwTy9Qu4HCf261yOf5BUFunUyVL2QvSJhgED5chCL8p1Anb1gSaP1Pzc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6REVaJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6REVaJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4E0C4CEC4;
	Mon, 16 Sep 2024 12:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488390;
	bh=npRHdzbg8iwR1Uvnpv0oLapwMPf+Rb8YPpUMjCPBi4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6REVaJxrjpuT9sQzV8wlUEv9feU4GzHkHq4OmA6ehFpIe6IYpb/IZwu6RLtHM4hl
	 7DhNaUYHr3Eq/lKemO08wguC9I+SDs4Jr2W/BCtCP2TC6uobR7ohiNFQLSj9LVkouB
	 QFzau3ADHtlpqRph/uMbEbkulidFIKvKqsYGT88M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 069/121] net: hsr: Send supervisory frames to HSR network with ProxyNodeTable data
Date: Mon, 16 Sep 2024 13:44:03 +0200
Message-ID: <20240916114231.456883169@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit 5f703ce5c981ee02c00e210d5b155bbbfbf11263 ]

This patch provides support for sending supervision HSR frames with
MAC addresses stored in ProxyNodeTable when RedBox (i.e. HSR-SAN) is
enabled.

Supervision frames with RedBox MAC address (appended as second TLV)
are only send for ProxyNodeTable nodes.

This patch series shall be tested with hsr_redbox.sh script.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b3c9e65eb227 ("net: hsr: remove seqnr_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c   | 63 ++++++++++++++++++++++++++++++++++--------
 net/hsr/hsr_forward.c  | 37 +++++++++++++++++++++++--
 net/hsr/hsr_framereg.c | 12 ++++++++
 net/hsr/hsr_framereg.h |  2 ++
 net/hsr/hsr_main.h     |  4 ++-
 net/hsr/hsr_netlink.c  |  1 +
 6 files changed, 105 insertions(+), 14 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index e6904288d40d..e4cc6b78dcfc 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -73,9 +73,15 @@ static void hsr_check_announce(struct net_device *hsr_dev)
 			mod_timer(&hsr->announce_timer, jiffies +
 				  msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL));
 		}
+
+		if (hsr->redbox && !timer_pending(&hsr->announce_proxy_timer))
+			mod_timer(&hsr->announce_proxy_timer, jiffies +
+				  msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL) / 2);
 	} else {
 		/* Deactivate the announce timer  */
 		timer_delete(&hsr->announce_timer);
+		if (hsr->redbox)
+			timer_delete(&hsr->announce_proxy_timer);
 	}
 }
 
@@ -279,10 +285,11 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master)
 	return NULL;
 }
 
-static void send_hsr_supervision_frame(struct hsr_port *master,
-				       unsigned long *interval)
+static void send_hsr_supervision_frame(struct hsr_port *port,
+				       unsigned long *interval,
+				       const unsigned char *addr)
 {
-	struct hsr_priv *hsr = master->hsr;
+	struct hsr_priv *hsr = port->hsr;
 	__u8 type = HSR_TLV_LIFE_CHECK;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_sup_tlv *hsr_stlv;
@@ -296,9 +303,9 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 		hsr->announce_count++;
 	}
 
-	skb = hsr_init_skb(master);
+	skb = hsr_init_skb(port);
 	if (!skb) {
-		netdev_warn_once(master->dev, "HSR: Could not send supervision frame\n");
+		netdev_warn_once(port->dev, "HSR: Could not send supervision frame\n");
 		return;
 	}
 
@@ -321,11 +328,12 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	hsr_stag->tlv.HSR_TLV_length = hsr->prot_version ?
 				sizeof(struct hsr_sup_payload) : 12;
 
-	/* Payload: MacAddressA */
+	/* Payload: MacAddressA / SAN MAC from ProxyNodeTable */
 	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
-	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
+	ether_addr_copy(hsr_sp->macaddress_A, addr);
 
-	if (hsr->redbox) {
+	if (hsr->redbox &&
+	    hsr_is_node_in_db(&hsr->proxy_node_db, addr)) {
 		hsr_stlv = skb_put(skb, sizeof(struct hsr_sup_tlv));
 		hsr_stlv->HSR_TLV_type = PRP_TLV_REDBOX_MAC;
 		hsr_stlv->HSR_TLV_length = sizeof(struct hsr_sup_payload);
@@ -340,13 +348,14 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 		return;
 	}
 
-	hsr_forward_skb(skb, master);
+	hsr_forward_skb(skb, port);
 	spin_unlock_bh(&hsr->seqnr_lock);
 	return;
 }
 
 static void send_prp_supervision_frame(struct hsr_port *master,
-				       unsigned long *interval)
+				       unsigned long *interval,
+				       const unsigned char *addr)
 {
 	struct hsr_priv *hsr = master->hsr;
 	struct hsr_sup_payload *hsr_sp;
@@ -396,7 +405,7 @@ static void hsr_announce(struct timer_list *t)
 
 	rcu_read_lock();
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
-	hsr->proto_ops->send_sv_frame(master, &interval);
+	hsr->proto_ops->send_sv_frame(master, &interval, master->dev->dev_addr);
 
 	if (is_admin_up(master->dev))
 		mod_timer(&hsr->announce_timer, jiffies + interval);
@@ -404,6 +413,37 @@ static void hsr_announce(struct timer_list *t)
 	rcu_read_unlock();
 }
 
+/* Announce (supervision frame) timer function for RedBox
+ */
+static void hsr_proxy_announce(struct timer_list *t)
+{
+	struct hsr_priv *hsr = from_timer(hsr, t, announce_proxy_timer);
+	struct hsr_port *interlink;
+	unsigned long interval = 0;
+	struct hsr_node *node;
+
+	rcu_read_lock();
+	/* RedBOX sends supervisory frames to HSR network with MAC addresses
+	 * of SAN nodes stored in ProxyNodeTable.
+	 */
+	interlink = hsr_port_get_hsr(hsr, HSR_PT_INTERLINK);
+	list_for_each_entry_rcu(node, &hsr->proxy_node_db, mac_list) {
+		if (hsr_addr_is_redbox(hsr, node->macaddress_A))
+			continue;
+		hsr->proto_ops->send_sv_frame(interlink, &interval,
+					      node->macaddress_A);
+	}
+
+	if (is_admin_up(interlink->dev)) {
+		if (!interval)
+			interval = msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
+
+		mod_timer(&hsr->announce_proxy_timer, jiffies + interval);
+	}
+
+	rcu_read_unlock();
+}
+
 void hsr_del_ports(struct hsr_priv *hsr)
 {
 	struct hsr_port *port;
@@ -590,6 +630,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	timer_setup(&hsr->announce_timer, hsr_announce, 0);
 	timer_setup(&hsr->prune_timer, hsr_prune_nodes, 0);
 	timer_setup(&hsr->prune_proxy_timer, hsr_prune_proxy_nodes, 0);
+	timer_setup(&hsr->announce_proxy_timer, hsr_proxy_announce, 0);
 
 	ether_addr_copy(hsr->sup_multicast_addr, def_multicast_addr);
 	hsr->sup_multicast_addr[ETH_ALEN - 1] = multicast_spec;
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 05a61b8286ec..960ef386bc3a 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -117,6 +117,35 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 	return true;
 }
 
+static bool is_proxy_supervision_frame(struct hsr_priv *hsr,
+				       struct sk_buff *skb)
+{
+	struct hsr_sup_payload *payload;
+	struct ethhdr *eth_hdr;
+	u16 total_length = 0;
+
+	eth_hdr = (struct ethhdr *)skb_mac_header(skb);
+
+	/* Get the HSR protocol revision. */
+	if (eth_hdr->h_proto == htons(ETH_P_HSR))
+		total_length = sizeof(struct hsrv1_ethhdr_sp);
+	else
+		total_length = sizeof(struct hsrv0_ethhdr_sp);
+
+	if (!pskb_may_pull(skb, total_length + sizeof(struct hsr_sup_payload)))
+		return false;
+
+	skb_pull(skb, total_length);
+	payload = (struct hsr_sup_payload *)skb->data;
+	skb_push(skb, total_length);
+
+	/* For RedBox (HSR-SAN) check if we have received the supervision
+	 * frame with MAC addresses from own ProxyNodeTable.
+	 */
+	return hsr_is_node_in_db(&hsr->proxy_node_db,
+				 payload->macaddress_A);
+}
+
 static struct sk_buff *create_stripped_skb_hsr(struct sk_buff *skb_in,
 					       struct hsr_frame_info *frame)
 {
@@ -499,7 +528,8 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 					   frame->sequence_nr))
 			continue;
 
-		if (frame->is_supervision && port->type == HSR_PT_MASTER) {
+		if (frame->is_supervision && port->type == HSR_PT_MASTER &&
+		    !frame->is_proxy_supervision) {
 			hsr_handle_sup_frame(frame);
 			continue;
 		}
@@ -637,6 +667,9 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 
 	memset(frame, 0, sizeof(*frame));
 	frame->is_supervision = is_supervision_frame(port->hsr, skb);
+	if (frame->is_supervision && hsr->redbox)
+		frame->is_proxy_supervision =
+			is_proxy_supervision_frame(port->hsr, skb);
 
 	n_db = &hsr->node_db;
 	if (port->type == HSR_PT_INTERLINK)
@@ -688,7 +721,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 	/* Gets called for ingress frames as well as egress from master port.
 	 * So check and increment stats for master port only here.
 	 */
-	if (port->type == HSR_PT_MASTER) {
+	if (port->type == HSR_PT_MASTER || port->type == HSR_PT_INTERLINK) {
 		port->dev->stats.tx_packets++;
 		port->dev->stats.tx_bytes += skb->len;
 	}
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 614df9649794..73bc6f659812 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -36,6 +36,14 @@ static bool seq_nr_after(u16 a, u16 b)
 #define seq_nr_before(a, b)		seq_nr_after((b), (a))
 #define seq_nr_before_or_eq(a, b)	(!seq_nr_after((a), (b)))
 
+bool hsr_addr_is_redbox(struct hsr_priv *hsr, unsigned char *addr)
+{
+	if (!hsr->redbox || !is_valid_ether_addr(hsr->macaddress_redbox))
+		return false;
+
+	return ether_addr_equal(addr, hsr->macaddress_redbox);
+}
+
 bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
 {
 	struct hsr_self_node *sn;
@@ -591,6 +599,10 @@ void hsr_prune_proxy_nodes(struct timer_list *t)
 
 	spin_lock_bh(&hsr->list_lock);
 	list_for_each_entry_safe(node, tmp, &hsr->proxy_node_db, mac_list) {
+		/* Don't prune RedBox node. */
+		if (hsr_addr_is_redbox(hsr, node->macaddress_A))
+			continue;
+
 		timestamp = node->time_in[HSR_PT_INTERLINK];
 
 		/* Prune old entries */
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index 7619e31c1d2d..993fa950d814 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -22,6 +22,7 @@ struct hsr_frame_info {
 	struct hsr_node *node_src;
 	u16 sequence_nr;
 	bool is_supervision;
+	bool is_proxy_supervision;
 	bool is_vlan;
 	bool is_local_dest;
 	bool is_local_exclusive;
@@ -35,6 +36,7 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *node_db,
 			      enum hsr_port_type rx_port);
 void hsr_handle_sup_frame(struct hsr_frame_info *frame);
 bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr);
+bool hsr_addr_is_redbox(struct hsr_priv *hsr, unsigned char *addr);
 
 void hsr_addr_subst_source(struct hsr_node *node, struct sk_buff *skb);
 void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 23850b16d1ea..ab1f8d35d9dc 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -170,7 +170,8 @@ struct hsr_node;
 
 struct hsr_proto_ops {
 	/* format and send supervision frame */
-	void (*send_sv_frame)(struct hsr_port *port, unsigned long *interval);
+	void (*send_sv_frame)(struct hsr_port *port, unsigned long *interval,
+			      const unsigned char addr[ETH_ALEN]);
 	void (*handle_san_frame)(bool san, enum hsr_port_type port,
 				 struct hsr_node *node);
 	bool (*drop_frame)(struct hsr_frame_info *frame, struct hsr_port *port);
@@ -197,6 +198,7 @@ struct hsr_priv {
 	struct list_head	proxy_node_db;	/* RedBox HSR proxy nodes */
 	struct hsr_self_node	__rcu *self_node;	/* MACs of slaves */
 	struct timer_list	announce_timer;	/* Supervision frame dispatch */
+	struct timer_list	announce_proxy_timer;
 	struct timer_list	prune_timer;
 	struct timer_list	prune_proxy_timer;
 	int announce_count;
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 898f18c6da53..f6ff0b61e08a 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -131,6 +131,7 @@ static void hsr_dellink(struct net_device *dev, struct list_head *head)
 	del_timer_sync(&hsr->prune_timer);
 	del_timer_sync(&hsr->prune_proxy_timer);
 	del_timer_sync(&hsr->announce_timer);
+	timer_delete_sync(&hsr->announce_proxy_timer);
 
 	hsr_debugfs_term(hsr);
 	hsr_del_ports(hsr);
-- 
2.43.0



