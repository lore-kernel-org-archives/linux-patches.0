Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26D147ECFB;
	Thu, 20 Aug 2026 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248646; cv=none; b=mebMfXUGoU3tCrx4ix/jkHEM6EvkZ39nYvmUwbmeL25BeIqYM2zVlqpZi9RlrUvx4GfU2YFDPjEsOSgAZhzxb71JH6pXUpD3CJ2zQ6XN0U3E9LJioUcaqlXXxkHaSBm4lyyRH8u9AQtqOx7fC2/IxOHLuFGv62dknCFe7aLkE+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248646; c=relaxed/simple;
	bh=Lwcf3Wd5yyOhEe8+gl6MONyld1siS9BsE2MEzEU02mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkRavhoGOy+G6R1czA5OP4odysvxqmDBEL7VPmZ34xs4FXBo6xssTc8v4vr/5nwM/73392403PUq+5e1D5cyXYZQYnKwkfL0OEOJjieOJnLsXWw2jGUKU4znWslhJ9CXXFK0KbP3Jmct7KTvB3lhB/rndxcDepnxYLDyJJ1AAOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1c7FkOcW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1c7FkOcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1102E1F000E9;
	Thu, 20 Aug 2026 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248645;
	bh=rbIc7xWhMH9aR3LO45q5A9JyZFOb9y80aMQHB/VM8Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1c7FkOcWdHOw76gn3OYJXW2ROaGt7LteFzjsfdCijUthYJRvo+bFJ71o93FjjkZDL
	 k/JJAlxGzIYNfuc5UXOSBImuG5DOxPv/6RJc1opuGgkVpxYzJwSH/Yb5jK6TEY83G5
	 u9y/gzwVebrSrvEXAvwdvGsJBKfrlW1EkirLug8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Aaron Conole <aconole@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 273/303] openvswitch: move key and ovs_cb update out of handle_fragments
Date: Thu, 20 Aug 2026 16:56:49 +0200
Message-ID: <20260820145301.669141101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 1b83bf4489cbc47d88976291cc967a17adb8e118 ]

This patch has no functional changes and just moves key and ovs_cb update
out of handle_fragments, and skb_clear_hash() and skb->ignore_df change
into handle_fragments(), to make it easier to move the duplicate code
from handle_fragments() into nf_conntrack_ovs later.

Note that it changes to pass info->family to handle_fragments() instead
of key for the packet type check, as info->family is set according to
key->eth.type in ovs_ct_copy_action() when creating the action.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8a7ed561671a ("net/sched: act_ct: fix sk_buff leak when the header checks reject a packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -496,13 +496,12 @@ static int ovs_ct_helper(struct sk_buff
 /* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
  * value if 'skb' is freed.
  */
-static int handle_fragments(struct net *net, struct sw_flow_key *key,
-			    u16 zone, struct sk_buff *skb)
+static int handle_fragments(struct net *net, struct sk_buff *skb,
+			    u16 zone, u8 family, u8 *proto, u16 *mru)
 {
-	struct ovs_skb_cb ovs_cb = *OVS_CB(skb);
 	int err;
 
-	if (key->eth.type == htons(ETH_P_IP)) {
+	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
 
 		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
@@ -510,9 +509,9 @@ static int handle_fragments(struct net *
 		if (err)
 			return err;
 
-		ovs_cb.mru = IPCB(skb)->frag_max_size;
+		*mru = IPCB(skb)->frag_max_size;
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
-	} else if (key->eth.type == htons(ETH_P_IPV6)) {
+	} else if (family == NFPROTO_IPV6) {
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
 
 		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
@@ -523,22 +522,35 @@ static int handle_fragments(struct net *
 			return err;
 		}
 
-		key->ip.proto = ipv6_hdr(skb)->nexthdr;
-		ovs_cb.mru = IP6CB(skb)->frag_max_size;
+		*proto = ipv6_hdr(skb)->nexthdr;
+		*mru = IP6CB(skb)->frag_max_size;
 #endif
 	} else {
 		kfree_skb(skb);
 		return -EPFNOSUPPORT;
 	}
 
+	skb_clear_hash(skb);
+	skb->ignore_df = 1;
+
+	return 0;
+}
+
+static int ovs_ct_handle_fragments(struct net *net, struct sw_flow_key *key,
+				   u16 zone, int family, struct sk_buff *skb)
+{
+	struct ovs_skb_cb ovs_cb = *OVS_CB(skb);
+	int err;
+
+	err = handle_fragments(net, skb, zone, family, &key->ip.proto, &ovs_cb.mru);
+	if (err)
+		return err;
+
 	/* The key extracted from the fragment that completed this datagram
 	 * likely didn't have an L4 header, so regenerate it.
 	 */
 	ovs_flow_key_update_l3l4(skb, key);
-
 	key->ip.frag = OVS_FRAG_TYPE_NONE;
-	skb_clear_hash(skb);
-	skb->ignore_df = 1;
 	*OVS_CB(skb) = ovs_cb;
 
 	return 0;
@@ -1318,7 +1330,8 @@ int ovs_ct_execute(struct net *net, stru
 		return err;
 
 	if (key->ip.frag != OVS_FRAG_TYPE_NONE) {
-		err = handle_fragments(net, key, info->zone.id, skb);
+		err = ovs_ct_handle_fragments(net, key, info->zone.id,
+					      info->family, skb);
 		if (err)
 			return err;
 	}


