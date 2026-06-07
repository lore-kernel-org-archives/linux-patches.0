Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96315318EF4;
	Sun,  7 Jun 2026 10:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827682; cv=none; b=NEr3v0omQOU5lZLqRf9g3ePl20OQSxVuLa1E1VMH9q731Cg08EEGkHgsmt4/BUz9AiJ7iBccb8qHDBw4hEXZ1iVcRUQpJC/P5qmR+sXmAMIUhIVkfpjVBfKDqpcQKzuuQro3akfYxrjj2Su03PESTMDjD6qg5Jrro6K80OYicgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827682; c=relaxed/simple;
	bh=+Wqz2UAsjZrGMGm0Y2d0Uh+2/hYtjsOWvNBE6xHP9Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfHezSvBiKDkPe2YhgiVCz2DhgGQzDZALyj9nFHQSpmS+V6iJTZMBsd3JZDD1bsZBJ37TtVyNzdfDqWGkq6qA+YhrGSWnfpPNuEX+hSap1BK3+oM8G2HxPiXWOKpXtCgvxAiFlYFpy08AvUT5HLsbeeE97V92jWvbcVOmJW0E/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITh3ibfa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITh3ibfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76141F00893;
	Sun,  7 Jun 2026 10:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827680;
	bh=1CRarCfeUpxFJBe1tuIiXGw5kG/6CiPy8Cv7YEw8Hhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITh3ibfaqPlMxUzL0mQum1NRBPBa72A8o6RQIFlrQ6IluK1ZvgWTrO5QTFRUT8VTC
	 2zeUJ4cyq5sPqlYy5WBfCFXGb1Rx0vHVt1dhmwQYsLF039/20qysof8lC0nfebPLtH
	 QBgTyZPhT+XzR0lF7UI6ftbX4YCyynjmcdS4m/MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/307] net/sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loop
Date: Sun,  7 Jun 2026 11:57:55 +0200
Message-ID: <20260607095730.639553529@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit db875221ab08d213a83bf30196ae8b64d55a3403 ]

When mirred redirects to ingress (from either ingress or egress) the loop
state from sched_mirred_dev array dev is lost because of 1) the packet
deferral into the backlog and 2) the fact the sched_mirred_dev array is
cleared. In such cases, if there was a loop we won't discover it.

Here's a simple test to reproduce:
ip a add dev port0 10.10.10.11/24

tc qdisc add dev port0 clsact
tc filter add dev port0 egress protocol ip \
   prio 10 matchall action mirred ingress redirect dev port1

tc qdisc add dev port1 clsact
tc filter add dev port1 ingress protocol ip \
   prio 10 matchall action mirred egress redirect dev port0

ping -c 1 -W0.01 10.10.10.10

Fixes: fe946a751d9b ("net/sched: act_mirred: add loop detection")
Tested-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260525122556.973584-6-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: e80ad525fc7e ("net/sched: act_mirred: Fix return code in early mirred redirect error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 47 +++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 35812b6808e0a8..ae9b307ad66e0d 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -26,6 +26,10 @@
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_wrapper.h>
 
+#define MIRRED_DEFER_LIMIT 3
+_Static_assert(MIRRED_DEFER_LIMIT <= 3,
+	       "MIRRED_DEFER_LIMIT exceeds tc_depth bitfield width");
+
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
@@ -234,12 +238,15 @@ tcf_mirred_forward(bool at_ingress, bool want_ingress, struct sk_buff *skb)
 {
 	int err;
 
-	if (!want_ingress)
+	if (!want_ingress) {
 		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
-	else if (!at_ingress)
-		err = netif_rx(skb);
-	else
-		err = netif_receive_skb(skb);
+	} else {
+		skb->tc_depth++;
+		if (!at_ingress)
+			err = netif_rx(skb);
+		else
+			err = netif_receive_skb(skb);
+	}
 
 	return err;
 }
@@ -417,6 +424,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 	struct netdev_xmit *xmit;
 	bool m_mac_header_xmit;
 	struct net_device *dev;
+	bool want_ingress;
 	int i, m_eaction;
 	u32 blockid;
 
@@ -425,7 +433,8 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 #else
 	xmit = this_cpu_ptr(&softnet_data.xmit);
 #endif
-	if (unlikely(xmit->sched_mirred_nest >= MIRRED_NEST_LIMIT)) {
+	if (unlikely(xmit->sched_mirred_nest >= MIRRED_NEST_LIMIT ||
+		     skb->tc_depth >= MIRRED_DEFER_LIMIT)) {
 		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
 				     netdev_name(skb->dev));
 		return TC_ACT_SHOT;
@@ -444,23 +453,27 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 		tcf_action_inc_overlimit_qstats(&m->common);
 		return retval;
 	}
-	for (i = 0; i < xmit->sched_mirred_nest; i++) {
-		if (xmit->sched_mirred_dev[i] != dev)
-			continue;
-		pr_notice_once("tc mirred: loop on device %s\n",
-			       netdev_name(dev));
-		tcf_action_inc_overlimit_qstats(&m->common);
-		return retval;
-	}
 
-	xmit->sched_mirred_dev[xmit->sched_mirred_nest++] = dev;
+	m_eaction = READ_ONCE(m->tcfm_eaction);
+	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
+	if (!want_ingress) {
+		for (i = 0; i < xmit->sched_mirred_nest; i++) {
+			if (xmit->sched_mirred_dev[i] != dev)
+				continue;
+			pr_notice_once("tc mirred: loop on device %s\n",
+				       netdev_name(dev));
+			tcf_action_inc_overlimit_qstats(&m->common);
+			return retval;
+		}
+		xmit->sched_mirred_dev[xmit->sched_mirred_nest++] = dev;
+	}
 
 	m_mac_header_xmit = READ_ONCE(m->tcfm_mac_header_xmit);
-	m_eaction = READ_ONCE(m->tcfm_eaction);
 
 	retval = tcf_mirred_to_dev(skb, m, dev, m_mac_header_xmit, m_eaction,
 				   retval);
-	xmit->sched_mirred_nest--;
+	if (!want_ingress)
+		xmit->sched_mirred_nest--;
 
 	return retval;
 }
-- 
2.53.0



