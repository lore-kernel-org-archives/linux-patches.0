Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B843A6EEB;
	Sat, 17 Oct 2026 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254911; cv=none; b=mlZ6wwNaNwKivetubm/7Sgn/PuGYsRGU9bPVVuDN5iMFcscXFzNNs0MwEP4NO+RqzlMN10JA50ws2OmOarBB66exj0Vxv+J2nDrXjXbSD4Yw+I8vpPoiAHbigNsFMz+P5qLC89cgOZxnTaoO3QfVNMC6vjfR7zoN9baanx8tVJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254911; c=relaxed/simple;
	bh=lV6f996qRFY751Qx+X6Yktg8FvtmC+cQ+zkvPJoVrvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrgEMeaxDDiz8VirdiFK0K/rrqAx5g1eXDObGrusE7Crplhbld3TkrdW1JDEEiGb0gUXN62FrDvN5txZJd4olE/SomKa4hQEsRFyiweiPP7xsOrdXFKlZ8BlD1ZJkFLPYJ3mSEjbsHOb7BB7w+0yhl3NGGedtMFawwh6Y9khxh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfKkn3nV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfKkn3nV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117EC1F000C4;
	Sat, 17 Oct 2026 16:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254909;
	bh=qPeKVY78tOW/IgDq3LrHYz1viVcvwZGvHLhT+tmtQHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfKkn3nVSMTheim/msWfVbg9I7x5wdK/p2wsu/j03muLOP8yCmhnVl1cijY4G0FXH
	 vE0OzimONs9VYi8jgJx/YtcflFWCFau6yNDP3vaqfLWjksZBLHzI8poeGD8Ts3IoMJ
	 PFjYL/2X6eYp5lzB61DzU45AaVdAW/Ku3VhL8V/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 600/869] net/sched: act_ife: Only operate on Ethernet frames
Date: Sat, 17 Oct 2026 17:57:21 +0200
Message-ID: <20261017160052.426888635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 5b483f7791b079bb97d411f1066652ff659207ff ]

act_ife encapsulates/decapsulates the original Ethernet header and uses
skb->dev->hard_header_len as the length of that header. That is only
correct for Ethernet devices: on a device where hard_header_len does not
match the L2 header that was actually pulled (PPP reports PPP_HDRLEN
while nothing is stripped on ingress), the ingress skb_push()/skb_pull()
use the wrong length and can hit skb_under_panic when headroom is tight.

IFE is Ethernet-only by design - it builds an outer ethhdr, rewrites
h_source/h_dest/h_proto, and calls eth_type_trans() on decode - so
instead of trying to make the offsets work for arbitrary link types,
simply drop packets that do not carry an Ethernet header.

Checking skb->dev->type alone is not enough. We have to cater for a
corner case where mirred can redirect an skb from a non-Ethernet device
to an Ethernet one, and skb->dev then says nothing about the framing the
skb actually has: an skb redirected from ppp0 reaches the target's ingress
hook with mac_len 0 and no Ethernet header at all. So at ingress also
require mac_len to be ETH_HLEN. On egress mac_len is not maintained, so
the device type is all we have; a bogus redirect there yields a malformed
frame rather than an out-of-bounds push, and it would be malformed with or
without IFE.

That corner case is not theoretical - redirecting from ppp0 into a veth
that has an ife encode action on its ingress hook panics without this
patch:

  skbuff: skb_under_panic: len:98 put:14 head:ffff88800e410000
          data:ffff88800e40fff5 tail:0x57 end:0x640 dev:veth3
  kernel BUG at net/core/skbuff.c:214!
  Call Trace:
   skb_push (net/core/skbuff.c:224 net/core/skbuff.c:2657)
   tcf_ife_act (net/sched/act_ife.c:829 net/sched/act_ife.c:874)
   tc_run (net/core/dev.c:4463)
   netif_receive_skb (net/core/dev.c:6463 net/core/dev.c:6522)
   tcf_mirred_to_dev (net/sched/act_mirred.c:248 net/sched/act_mirred.c:328)
   tcf_mirred_act (net/sched/act_mirred.c:489)
   tc_run (net/core/dev.c:4463)
   process_backlog (net/core/dev.c:6728)

With Ethernet framing guaranteed, use ETH_HLEN instead of
hard_header_len.

Fixes: 295a6e06d21e ("net/sched: act_ife: Change to use ife module")
Reported-by: vega@nebusec.ai
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260821164031.32824-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ife/ife.c       | 14 +++++++-------
 net/sched/act_ife.c | 32 ++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/net/ife/ife.c b/net/ife/ife.c
index 7a75947a31e31..2ddf725d3389e 100644
--- a/net/ife/ife.c
+++ b/net/ife/ife.c
@@ -37,7 +37,7 @@ void *ife_encode(struct sk_buff *skb, u16 metalen)
 	 * where ORIGDATA = original ethernet header ...
 	 */
 	int hdrm = metalen + IFE_METAHDRLEN;
-	int total_push = hdrm + skb->dev->hard_header_len;
+	int total_push = hdrm + ETH_HLEN;
 	struct ifeheadr *ifehdr;
 	struct ethhdr *iethh;	/* inner ether header */
 	int skboff = 0;
@@ -50,9 +50,9 @@ void *ife_encode(struct sk_buff *skb, u16 metalen)
 	iethh = (struct ethhdr *) skb->data;
 
 	__skb_push(skb, total_push);
-	memcpy(skb->data, iethh, skb->dev->hard_header_len);
+	memcpy(skb->data, iethh, ETH_HLEN);
 	skb_reset_mac_header(skb);
-	skboff += skb->dev->hard_header_len;
+	skboff += ETH_HLEN;
 
 	/* total metadata length */
 	ifehdr = (struct ifeheadr *) (skb->data + skboff);
@@ -69,12 +69,12 @@ void *ife_decode(struct sk_buff *skb, u16 *metalen)
 	int total_pull;
 	u16 ifehdrln;
 
-	if (!pskb_may_pull(skb, skb->dev->hard_header_len + IFE_METAHDRLEN))
+	if (!pskb_may_pull(skb, ETH_HLEN + IFE_METAHDRLEN))
 		return NULL;
 
-	ifehdr = (struct ifeheadr *) (skb->data + skb->dev->hard_header_len);
+	ifehdr = (struct ifeheadr *)(skb->data + ETH_HLEN);
 	ifehdrln = ntohs(ifehdr->metalen);
-	total_pull = skb->dev->hard_header_len + ifehdrln;
+	total_pull = ETH_HLEN + ifehdrln;
 
 	if (unlikely(ifehdrln < 2))
 		return NULL;
@@ -82,7 +82,7 @@ void *ife_decode(struct sk_buff *skb, u16 *metalen)
 	if (unlikely(!pskb_may_pull(skb, total_pull + ETH_HLEN)))
 		return NULL;
 
-	ifehdr = (struct ifeheadr *)(skb->data + skb->dev->hard_header_len);
+	ifehdr = (struct ifeheadr *)(skb->data + ETH_HLEN);
 	skb_set_mac_header(skb, total_pull);
 	__skb_pull(skb, total_pull);
 	*metalen = ifehdrln - IFE_METAHDRLEN;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 3333714b68650..b0d66ba80baad 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -28,6 +28,7 @@
 #include <uapi/linux/tc_act/tc_ife.h>
 #include <net/tc_act/tc_ife.h>
 #include <linux/etherdevice.h>
+#include <linux/if_arp.h>
 #include <net/ife.h>
 #include <net/tc_wrapper.h>
 
@@ -723,7 +724,7 @@ static int tcf_ife_decode(struct sk_buff *skb, const struct tc_action *a,
 	tcf_lastuse_update(&ife->tcf_tm);
 
 	if (skb_at_tc_ingress(skb))
-		skb_push(skb, skb->dev->hard_header_len);
+		skb_push(skb, ETH_HLEN);
 
 	tlv_data = ife_decode(skb, &metalen);
 	if (unlikely(!tlv_data)) {
@@ -795,7 +796,7 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 	   where ORIGDATA = original ethernet header ...
 	 */
 	u16 metalen = ife_get_sz(skb, p);
-	int hdrm = metalen + skb->dev->hard_header_len + IFE_METAHDRLEN;
+	int hdrm = metalen + ETH_HLEN + IFE_METAHDRLEN;
 	unsigned int skboff = 0;
 	int new_len = skb->len + hdrm;
 	bool exceed_mtu = false;
@@ -826,7 +827,7 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 	if (skb_at_tc_ingress(skb))
-		skb_push(skb, skb->dev->hard_header_len);
+		skb_push(skb, ETH_HLEN);
 
 	ife_meta = ife_encode(skb, metalen);
 	if (!ife_meta)
@@ -856,11 +857,27 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 	oethh->h_proto = htons(p->eth_type);
 
 	if (skb_at_tc_ingress(skb))
-		skb_pull(skb, skb->dev->hard_header_len);
+		skb_pull(skb, ETH_HLEN);
 
 	return action;
 }
 
+/* IFE encapsulates the original Ethernet header and, on decode, expects to
+ * find one, so it can only ever work on skbs that carry one. Loopback carries
+ * Ethernet header as well, so it qualifies here.
+ * At ingress, also verify that the L2 header about to be pushed back really
+ * is an Ethernet header because the skb could've been redirected with mirred
+ * from a non-Ethernet device.
+ */
+static bool tcf_ife_is_eth_skb(const struct sk_buff *skb)
+{
+	if (skb->dev->type != ARPHRD_ETHER &&
+	    skb->dev->type != ARPHRD_LOOPBACK)
+		return false;
+
+	return !skb_at_tc_ingress(skb) || skb->mac_len == ETH_HLEN;
+}
+
 TC_INDIRECT_SCOPE int tcf_ife_act(struct sk_buff *skb,
 				  const struct tc_action *a,
 				  struct tcf_result *res)
@@ -869,6 +886,13 @@ TC_INDIRECT_SCOPE int tcf_ife_act(struct sk_buff *skb,
 	struct tcf_ife_params *p;
 	int ret;
 
+	if (unlikely(!tcf_ife_is_eth_skb(skb))) {
+		bstats_update(this_cpu_ptr(ife->common.cpu_bstats), skb);
+		tcf_lastuse_update(&ife->tcf_tm);
+		qstats_cpu_drop_inc(ife->common.cpu_qstats);
+		return TC_ACT_SHOT;
+	}
+
 	p = rcu_dereference_bh(ife->params);
 	if (p->flags & IFE_ENCODE) {
 		ret = tcf_ife_encode(skb, a, res, p);
-- 
2.53.0



