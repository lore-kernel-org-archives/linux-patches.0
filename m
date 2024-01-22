Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A088C4E1D0;
	Tue, 23 Jan 2024 00:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970266; cv=none; b=Dp1E/aqSC5NDq0lKav1DxEAppzvtMvdAMDcWDmgZ9tU5kQxmbZRrzg/mIsNb0jrTODj87/kIYXeICXPxr9S3sflHRNuOqrekSKN4ETM26PMtdZBNHdp66yb5ecAMAsdDjUv8xJgvha+DfUzohFvGHfCcL/I5a5ZfyZUNr9UNTSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970266; c=relaxed/simple;
	bh=mQlChY3N5gnooNj3rIzwvjujXMbOfggAI+gSlkmOAiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmtuhQgKi9K1eITTKNzxu9UUwHe2IhqUECDwJ8RqBj0iCqzEU69EelpsP9WpHsivDpKDfJQ7lsCJOa4Zmxv9Zqu2jxEmRGsVb96xUrFmdXfVRTXMDplzqIlOvm/ZA8Fj1xlPXKKyJWNJr4nFfytjTiAfA/WpptH74s727x5sSxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL+H5qpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL+H5qpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E806C433C7;
	Tue, 23 Jan 2024 00:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970266;
	bh=mQlChY3N5gnooNj3rIzwvjujXMbOfggAI+gSlkmOAiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vL+H5qpe3tXGg4xLC/p8Y736n6VE5R1meETg8oni3RTbbC32h1AgcXpXmjs4YLrXF
	 r361XjkHpTFLlsiBq7giAMTz2VBKpZQJE9E4Gmkv/To+Cln4t57Pn5oPIS51Cb8EcL
	 0C4kem7DK8gQwoblKJdEL1rB/7cdKcuvdtEuccJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 623/641] netfilter: propagate net to nf_bridge_get_physindev
Date: Mon, 22 Jan 2024 15:58:47 -0800
Message-ID: <20240122235837.747213432@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

[ Upstream commit a54e72197037d2c9bfcd70dddaac8c8ccb5b41ba ]

This is a preparation patch for replacing physindev with physinif on
nf_bridge_info structure. We will use dev_get_by_index_rcu to resolve
device, when needed, and it requires net to be available.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 9874808878d9 ("netfilter: bridge: replace physindev with physinif in nf_bridge_info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter_bridge.h           |  2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c        |  2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c        |  2 +-
 net/netfilter/ipset/ip_set_hash_netiface.c |  8 ++++----
 net/netfilter/nf_log_syslog.c              | 13 +++++++------
 net/netfilter/nf_queue.c                   |  2 +-
 net/netfilter/xt_physdev.c                 |  2 +-
 7 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index f980edfdd278..e927b9a15a55 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -56,7 +56,7 @@ static inline int nf_bridge_get_physoutif(const struct sk_buff *skb)
 }
 
 static inline struct net_device *
-nf_bridge_get_physindev(const struct sk_buff *skb)
+nf_bridge_get_physindev(const struct sk_buff *skb, struct net *net)
 {
 	const struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index f01b038fc1cd..86e7d390671a 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -289,7 +289,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	 * build the eth header using the original destination's MAC as the
 	 * source, and send the RST packet directly.
 	 */
-	br_indev = nf_bridge_get_physindev(oldskb);
+	br_indev = nf_bridge_get_physindev(oldskb, net);
 	if (br_indev) {
 		struct ethhdr *oeth = eth_hdr(oldskb);
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index d45bc54b7ea5..27b2164f4c43 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -354,7 +354,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	 * build the eth header using the original destination's MAC as the
 	 * source, and send the RST packet directly.
 	 */
-	br_indev = nf_bridge_get_physindev(oldskb);
+	br_indev = nf_bridge_get_physindev(oldskb, net);
 	if (br_indev) {
 		struct ethhdr *oeth = eth_hdr(oldskb);
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 95aeb31c60e0..30a655e5c4fd 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -138,9 +138,9 @@ hash_netiface4_data_next(struct hash_netiface4_elem *next,
 #include "ip_set_hash_gen.h"
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-static const char *get_physindev_name(const struct sk_buff *skb)
+static const char *get_physindev_name(const struct sk_buff *skb, struct net *net)
 {
-	struct net_device *dev = nf_bridge_get_physindev(skb);
+	struct net_device *dev = nf_bridge_get_physindev(skb, net);
 
 	return dev ? dev->name : NULL;
 }
@@ -177,7 +177,7 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-		const char *eiface = SRCDIR ? get_physindev_name(skb) :
+		const char *eiface = SRCDIR ? get_physindev_name(skb, xt_net(par)) :
 					      get_physoutdev_name(skb);
 
 		if (!eiface)
@@ -395,7 +395,7 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-		const char *eiface = SRCDIR ? get_physindev_name(skb) :
+		const char *eiface = SRCDIR ? get_physindev_name(skb, xt_net(par)) :
 					      get_physoutdev_name(skb);
 
 		if (!eiface)
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index c66689ad2b49..58402226045e 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -111,7 +111,8 @@ nf_log_dump_packet_common(struct nf_log_buf *m, u8 pf,
 			  unsigned int hooknum, const struct sk_buff *skb,
 			  const struct net_device *in,
 			  const struct net_device *out,
-			  const struct nf_loginfo *loginfo, const char *prefix)
+			  const struct nf_loginfo *loginfo, const char *prefix,
+			  struct net *net)
 {
 	const struct net_device *physoutdev __maybe_unused;
 	const struct net_device *physindev __maybe_unused;
@@ -121,7 +122,7 @@ nf_log_dump_packet_common(struct nf_log_buf *m, u8 pf,
 			in ? in->name : "",
 			out ? out->name : "");
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	physindev = nf_bridge_get_physindev(skb);
+	physindev = nf_bridge_get_physindev(skb, net);
 	if (physindev && in != physindev)
 		nf_log_buf_add(m, "PHYSIN=%s ", physindev->name);
 	physoutdev = nf_bridge_get_physoutdev(skb);
@@ -148,7 +149,7 @@ static void nf_log_arp_packet(struct net *net, u_int8_t pf,
 		loginfo = &default_loginfo;
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out, loginfo,
-				  prefix);
+				  prefix, net);
 	dump_arp_packet(m, loginfo, skb, skb_network_offset(skb));
 
 	nf_log_buf_close(m);
@@ -845,7 +846,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 		loginfo = &default_loginfo;
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in,
-				  out, loginfo, prefix);
+				  out, loginfo, prefix, net);
 
 	if (in)
 		dump_mac_header(m, loginfo, skb);
@@ -880,7 +881,7 @@ static void nf_log_ip6_packet(struct net *net, u_int8_t pf,
 		loginfo = &default_loginfo;
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out,
-				  loginfo, prefix);
+				  loginfo, prefix, net);
 
 	if (in)
 		dump_mac_header(m, loginfo, skb);
@@ -916,7 +917,7 @@ static void nf_log_unknown_packet(struct net *net, u_int8_t pf,
 		loginfo = &default_loginfo;
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out, loginfo,
-				  prefix);
+				  prefix, net);
 
 	dump_mac_header(m, loginfo, skb);
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 3dfcb3ac5cb4..e2f334f70281 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -84,7 +84,7 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 	const struct sk_buff *skb = entry->skb;
 
 	if (nf_bridge_info_exists(skb)) {
-		entry->physin = nf_bridge_get_physindev(skb);
+		entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
 		entry->physout = nf_bridge_get_physoutdev(skb);
 	} else {
 		entry->physin = NULL;
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index ec6ed6fda96c..343e65f377d4 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -59,7 +59,7 @@ physdev_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	    (!!outdev ^ !(info->invert & XT_PHYSDEV_OP_BRIDGED)))
 		return false;
 
-	physdev = nf_bridge_get_physindev(skb);
+	physdev = nf_bridge_get_physindev(skb, xt_net(par));
 	indev = physdev ? physdev->name : NULL;
 
 	if ((info->bitmask & XT_PHYSDEV_OP_ISIN &&
-- 
2.43.0



