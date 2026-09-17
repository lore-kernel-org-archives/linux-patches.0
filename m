Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0184B7A46;
	Thu, 17 Sep 2026 15:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660406; cv=none; b=HJiTYMuWM+QOBllHtoiHXplKhxVNeM2OdrY2BnMNgMaEMN9RITK85j+z9UAIeOf+GHbKWIGUDTM8vFjBH/IddCTboG6J9RUxawXosDgLp9717tGi7D/14gV7PRVjgCEaSfztaxexFe0j1VQM690NW8MvJoB2OGNYAyYTCrAyu4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660406; c=relaxed/simple;
	bh=+xesEqLCBJnuXExPrjHXHkIMJTB7ms5o+7nUlKhfK9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teX13n22d8BADimZmcOakVgwAW1Axi2hkncIW6xHROf0uwYsj+Zd2zOX700uFQwjGEmqA1aIrzuiJhsuCLN/zgbO+VWSj6RRTX50CSeaCkf5/KH+TMMjrFhfqD7YSjEfFSNvX+HvuEIdTN0zfDRVEbYZGYeqY5YJAC/V375JWCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FV54iPvO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FV54iPvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F06B1F000FF;
	Thu, 17 Sep 2026 15:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660404;
	bh=YlrwkB5lPstg+o0xu/e7ISD+wB/d+PzEgCME/y3Q/xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FV54iPvOUJEvR43i3zfWbP1B7ZfokwSnCKM7ceIWXn4fFN7byijH0A/5paHh4swsA
	 QqC5WyeZUAYyKsEIBAUJSLfsKSjTfRcG38/I+/z6tvMFT/AlmLh8/4RGxDWhhE6keS
	 6p+ykCOoLIz9saoYIFFSadv1vWsOwzPsGNJ4sLtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Yilin Zhu <zylzyl2333@gmail.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 543/733] net: bridge: use option bits for CFM/MRP frame handlers
Date: Thu, 17 Sep 2026 16:14:11 +0100
Message-ID: <20260917151405.763461382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 7a49e6b16f36b8e085521699adbca3e321b6dd0c upstream.

CFM and MRP register a global br_frame_type whose hlist_node is linked
into the per-bridge frame_type_list when the first MEP/MRP instance is
created. Enabling the protocol on multiple bridges therefore inserts the
same node into multiple lists. Unregistering it on one bridge then
corrupts list state belonging to another.

These handlers can only be installed once per bridge, and they are
uncommon. Track their per-bridge enable state with net_bridge option
bits, which already live on the Rx hot cache line, and dispatch the
matching handler directly from the receive path. Check both bits
together first as an unlikely case.

Remove the generic frame_type_list and br_frame_type helpers, which
have had no other users since CFM and MRP were added. That shrinks
struct net_bridge by 8 bytes and drops the list walk from the fast
path. When neither protocol is compiled in, BR_CFM_MRP_OPTS is 0 and
the compiler prunes the branch.

Fixes: 90c628dd47ff ("net: bridge: extend the process of special frames")
Fixes: dc32cbb3dbd7 ("bridge: cfm: Kernel space implementation of CFM. CCM frame RX added.")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Nikolay Aleksandrov <razor@blackwall.org>
Co-developed-by: Yilin Zhu <zylzyl2333@gmail.com>
Signed-off-by: Yilin Zhu <zylzyl2333@gmail.com>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/0345b9d5aa60ba416f6738ff1b87140f0a749cb8.1788417901.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_cfm.c     |   11 +++--------
 net/bridge/br_device.c  |    1 -
 net/bridge/br_input.c   |   35 ++++++++++++++---------------------
 net/bridge/br_mrp.c     |   13 +++----------
 net/bridge/br_private.h |   26 +++++++++++++++-----------
 5 files changed, 35 insertions(+), 51 deletions(-)

--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -367,7 +367,7 @@ static u32 ccm_tlv_extract(struct sk_buf
 }
 
 /* note: already called with rcu_read_lock */
-static int br_cfm_frame_rx(struct net_bridge_port *port, struct sk_buff *skb)
+int br_cfm_frame_rx(struct net_bridge_port *port, struct sk_buff *skb)
 {
 	u32 mdlevel, interval, size, index, max;
 	const struct br_cfm_common_hdr *hdr;
@@ -489,11 +489,6 @@ static int br_cfm_frame_rx(struct net_br
 	return 1;
 }
 
-static struct br_frame_type cfm_frame_type __read_mostly = {
-	.type = cpu_to_be16(ETH_P_CFM),
-	.frame_handler = br_cfm_frame_rx,
-};
-
 int br_cfm_mep_create(struct net_bridge *br,
 		      const u32 instance,
 		      struct br_cfm_mep_create *const create,
@@ -559,7 +554,7 @@ int br_cfm_mep_create(struct net_bridge
 	INIT_DELAYED_WORK(&mep->ccm_tx_dwork, ccm_tx_work_expired);
 
 	if (hlist_empty(&br->mep_list))
-		br_add_frame(br, &cfm_frame_type);
+		br_opt_toggle(br, BROPT_CFM_ENABLED, true);
 
 	hlist_add_tail_rcu(&mep->head, &br->mep_list);
 
@@ -588,7 +583,7 @@ static void mep_delete_implementation(st
 	kfree_rcu(mep, rcu);
 
 	if (hlist_empty(&br->mep_list))
-		br_del_frame(br, &cfm_frame_type);
+		br_opt_toggle(br, BROPT_CFM_ENABLED, false);
 }
 
 int br_cfm_mep_delete(struct net_bridge *br,
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -503,7 +503,6 @@ void br_dev_setup(struct net_device *dev
 	spin_lock_init(&br->lock);
 	INIT_LIST_HEAD(&br->port_list);
 	INIT_HLIST_HEAD(&br->fdb_list);
-	INIT_HLIST_HEAD(&br->frame_type_list);
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	INIT_HLIST_HEAD(&br->mrp_list);
 #endif
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -317,17 +317,25 @@ frame_finish:
 	return RX_HANDLER_CONSUMED;
 }
 
+#define BR_CFM_MRP_OPTS \
+	((IS_ENABLED(CONFIG_BRIDGE_CFM) ? BIT(BROPT_CFM_ENABLED) : 0UL) | \
+	 (IS_ENABLED(CONFIG_BRIDGE_MRP) ? BIT(BROPT_MRP_ENABLED) : 0UL))
+
 /* Return 0 if the frame was not processed otherwise 1
  * note: already called with rcu_read_lock
  */
 static int br_process_frame_type(struct net_bridge_port *p,
 				 struct sk_buff *skb)
 {
-	struct br_frame_type *tmp;
+	struct net_bridge *br = p->br;
 
-	hlist_for_each_entry_rcu(tmp, &p->br->frame_type_list, list)
-		if (unlikely(tmp->type == skb->protocol))
-			return tmp->frame_handler(p, skb);
+	if (skb->protocol == htons(ETH_P_CFM) &&
+	    br_opt_get(br, BROPT_CFM_ENABLED))
+		return br_cfm_frame_rx(p, skb);
+
+	if (skb->protocol == htons(ETH_P_MRP) &&
+	    br_opt_get(br, BROPT_MRP_ENABLED))
+		return br_mrp_process(p, skb);
 
 	return 0;
 }
@@ -425,7 +433,8 @@ static rx_handler_result_t br_handle_fra
 		}
 	}
 
-	if (unlikely(br_process_frame_type(p, skb)))
+	if (unlikely((READ_ONCE(p->br->options) & BR_CFM_MRP_OPTS) &&
+		     br_process_frame_type(p, skb)))
 		return RX_HANDLER_PASS;
 
 forward:
@@ -467,19 +476,3 @@ rx_handler_func_t *br_get_rx_handler(con
 
 	return br_handle_frame;
 }
-
-void br_add_frame(struct net_bridge *br, struct br_frame_type *ft)
-{
-	hlist_add_head_rcu(&ft->list, &br->frame_type_list);
-}
-
-void br_del_frame(struct net_bridge *br, struct br_frame_type *ft)
-{
-	struct br_frame_type *tmp;
-
-	hlist_for_each_entry(tmp, &br->frame_type_list, list)
-		if (ft == tmp) {
-			hlist_del_rcu(&ft->list);
-			return;
-		}
-}
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -6,13 +6,6 @@
 static const u8 mrp_test_dmac[ETH_ALEN] = { 0x1, 0x15, 0x4e, 0x0, 0x0, 0x1 };
 static const u8 mrp_in_test_dmac[ETH_ALEN] = { 0x1, 0x15, 0x4e, 0x0, 0x0, 0x3 };
 
-static int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
-
-static struct br_frame_type mrp_frame_type __read_mostly = {
-	.type = cpu_to_be16(ETH_P_MRP),
-	.frame_handler = br_mrp_process,
-};
-
 static bool br_mrp_is_ring_port(struct net_bridge_port *p_port,
 				struct net_bridge_port *s_port,
 				struct net_bridge_port *port)
@@ -486,7 +479,7 @@ static void br_mrp_del_impl(struct net_b
 	kfree_rcu(mrp, rcu);
 
 	if (hlist_empty(&br->mrp_list))
-		br_del_frame(br, &mrp_frame_type);
+		br_opt_toggle(br, BROPT_MRP_ENABLED, false);
 }
 
 /* Adds a new MRP instance.
@@ -536,7 +529,7 @@ int br_mrp_add(struct net_bridge *br, st
 	rcu_assign_pointer(mrp->s_port, p);
 
 	if (hlist_empty(&br->mrp_list))
-		br_add_frame(br, &mrp_frame_type);
+		br_opt_toggle(br, BROPT_MRP_ENABLED, true);
 
 	INIT_DELAYED_WORK(&mrp->test_work, br_mrp_test_work_expired);
 	INIT_DELAYED_WORK(&mrp->in_test_work, br_mrp_in_test_work_expired);
@@ -1241,7 +1234,7 @@ no_forward:
  * normal forwarding.
  * note: already called with rcu_read_lock
  */
-static int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
+int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
 {
 	/* If there is no MRP instance do normal forwarding */
 	if (likely(!test_bit(BR_MRP_AWARE_BIT, &p->flags)))
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -491,12 +491,13 @@ enum net_bridge_opts {
 	BROPT_MST_ENABLED,
 	BROPT_MDB_OFFLOAD_FAIL_NOTIFICATION,
 	BROPT_FDB_LOCAL_VLAN_0,
+	BROPT_CFM_ENABLED,
+	BROPT_MRP_ENABLED,
 };
 
 struct net_bridge {
 	spinlock_t			lock;
 	spinlock_t			hash_lock;
-	struct hlist_head		frame_type_list;
 	struct net_device		*dev;
 	unsigned long			options;
 	/* These fields are accessed on each packet */
@@ -928,16 +929,6 @@ int nbp_backup_change(struct net_bridge_
 int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
 rx_handler_func_t *br_get_rx_handler(const struct net_device *dev);
 
-struct br_frame_type {
-	__be16			type;
-	int			(*frame_handler)(struct net_bridge_port *port,
-						 struct sk_buff *skb);
-	struct hlist_node	list;
-};
-
-void br_add_frame(struct net_bridge *br, struct br_frame_type *ft);
-void br_del_frame(struct net_bridge *br, struct br_frame_type *ft);
-
 static inline bool br_rx_handler_check_rcu(const struct net_device *dev)
 {
 	return rcu_dereference(dev->rx_handler) == br_get_rx_handler(dev);
@@ -2076,6 +2067,7 @@ int br_mrp_parse(struct net_bridge *br,
 bool br_mrp_enabled(struct net_bridge *br);
 void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
 int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br);
+int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
 #else
 static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 			       struct nlattr *attr, int cmd,
@@ -2099,6 +2091,11 @@ static inline int br_mrp_fill_info(struc
 	return 0;
 }
 
+static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
+{
+	return 0;
+}
+
 #endif
 
 /* br_cfm.c */
@@ -2107,6 +2104,7 @@ int br_cfm_parse(struct net_bridge *br,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
 bool br_cfm_created(struct net_bridge *br);
 void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *p);
+int br_cfm_frame_rx(struct net_bridge_port *port, struct sk_buff *skb);
 int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br);
 int br_cfm_status_fill_info(struct sk_buff *skb,
 			    struct net_bridge *br,
@@ -2131,6 +2129,12 @@ static inline void br_cfm_port_del(struc
 {
 }
 
+static inline int br_cfm_frame_rx(struct net_bridge_port *port,
+				  struct sk_buff *skb)
+{
+	return 0;
+}
+
 static inline int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
 {
 	return -EOPNOTSUPP;


