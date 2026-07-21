Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914E646C4DD;
	Tue, 21 Jul 2026 18:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658502; cv=none; b=TkquG7nKZf2jLghrx0D2n4HedKx7k0TUt3nQXQiXCoFxe3IgLFy/aRXJ5qSx2Lr3BdwSlYLbnnszZuOHxjWEmXMANcNlVREOpV2oPMEjRbjzg2hCSNeKqqvCB25azdgmIJsMQJIheCSPGVv+AJzCmgVZNDKUcJwLcaEmSbZdhG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658502; c=relaxed/simple;
	bh=bzZvdBQ63RnnUaAXEWxFcGRpjpnneZ/8djc5ZkahYMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JouFD3cPiMw/lHC36UNXYqJ6wvoNkAZg3He5jiZT/dYasEjcs73aAQlPlIM3XagKDBvKkegDWyAYwT1g1ezRRSJKyUO1l++AynRhxvs15+RRCLJTwmtf+tPWYp7NGSOOh7jf2A5T1SusodGtfoGb9FlX0lq/RfLLPqGIVhho1sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giPL8Xbc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giPL8Xbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A291F000E9;
	Tue, 21 Jul 2026 18:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658500;
	bh=7+dnw/hY6plUE4El7A5vEDdRahzgnnu/lj5P2SwJ2/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giPL8XbcrlywxwI7xVHMqoTErVE2X6yvP/UWIFkZ406iuZhB/ihvKxekefJexNGKJ
	 Jm9okOR/DfnGeD68kjo1K90HTcipV5MSIhZ92bzcHPMo9ySHwVN5LhqwGqxKw3MLyr
	 uFjLBL3oGrPw2J3KRQBXB5hdK0jPUZFFylh081F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Haoze Xie <royenheart@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 1168/1611] netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst
Date: Tue, 21 Jul 2026 17:21:24 +0200
Message-ID: <20260721152541.697026135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoze Xie <royenheart@gmail.com>

commit c9c9b37f8c5505224e8d206184df3bb668ee00cf upstream.

The br_netfilter fake rtable is embedded in struct net_bridge and is
attached to bridged packets with skb_dst_set_noref(). If such a packet is
queued to NFQUEUE, __nf_queue() upgrades that fake dst with
skb_dst_force().

At that point the queued skb can hold a real dst reference after bridge
teardown has started. The problem is not that every bridged packet needs
its own dst reference. The problem is that NFQUEUE can keep the bridge
private fake dst alive after unregister begins.

Fix this by keeping the bridge fake dst model unchanged and pinning the
bridge master device only while the packet sits in NFQUEUE. Record the
bridge device in nf_queue_entry when the queued skb carries a bridge fake
dst, take a device reference for the queue lifetime, and drop it when the
queue entry is freed.

Also make sure queued entries are reaped when that bridge device goes
down, and drop the redundant nf_bridge_info_exists() test from the fake
dst detection.

This keeps netdev_priv(br->dev) alive until verdict completion, so the
embedded fake rtable and its metrics backing storage cannot be freed out
from under dst_release(). It also avoids the constant refcount bump and
avoids using ipv4-specific dst helpers for IPv6 bridge traffic.

Fixes: 34666d467cbf ("netfilter: bridge: move br_netfilter out of the core")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_queue.h |    1 +
 net/netfilter/nf_queue.c         |   14 ++++++++++++++
 net/netfilter/nfnetlink_queue.c  |    3 +++
 3 files changed, 18 insertions(+)

--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -18,6 +18,7 @@ struct nf_queue_entry {
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	struct net_device	*bridge_dev;
 	struct net_device	*physin;
 	struct net_device	*physout;
 #endif
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -67,6 +67,7 @@ static void nf_queue_entry_release_refs(
 		nf_queue_sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_put(entry->bridge_dev);
 	dev_put(entry->physin);
 	dev_put(entry->physout);
 #endif
@@ -83,6 +84,8 @@ static void __nf_queue_entry_init_physde
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	const struct sk_buff *skb = entry->skb;
+	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev = NULL;
 
 	if (nf_bridge_info_exists(skb)) {
 		entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
@@ -91,6 +94,16 @@ static void __nf_queue_entry_init_physde
 		entry->physin = NULL;
 		entry->physout = NULL;
 	}
+
+	if (entry->state.pf == NFPROTO_BRIDGE &&
+	    dst && (dst->flags & DST_FAKE_RTABLE))
+		dev = dst_dev_rcu(dst);
+
+	/* Must hold a reference on the bridge device: dst_hold() protects
+	 * the dst itself, but the fake rtable is embedded in bridge-private
+	 * storage that netdevice teardown can free independently.
+	 */
+	entry->bridge_dev = dev;
 #endif
 }
 
@@ -107,6 +120,7 @@ bool nf_queue_entry_get_refs(struct nf_q
 	dev_hold(state->out);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_hold(entry->bridge_dev);
 	dev_hold(entry->physin);
 	dev_hold(entry->physout);
 #endif
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1253,6 +1253,9 @@ dev_cmp(struct nf_queue_entry *entry, un
 
 	if (physinif == ifindex || physoutif == ifindex)
 		return 1;
+
+	if (entry->bridge_dev && entry->bridge_dev->ifindex == ifindex)
+		return 1;
 #endif
 	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
 		return 1;


