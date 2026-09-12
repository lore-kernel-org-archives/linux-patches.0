Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ABD32B108;
	Sat, 12 Sep 2026 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226421; cv=none; b=TSaOgQR7xEGPXJZQhLlo+6sUfAp4DDykK4vnVTAL8g2STIYi9gbQOXdae3amnMOknJ1eAJYkuOU6pwGasxnl0i3enR7dakAREmSFCq39o+MihXTTytdDMoiupsqf3ysPDFe3QObmbTALdD3pq4Mmaut+brygRys592yLU7hb2A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226421; c=relaxed/simple;
	bh=yxWkFolI5wxKo0ErZZdo5Ad1xggso6x7cNRdkKfqB2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mL3/4ymXEQ8rybjNykm7Kgdn1Z5rN4aZEkjBtIx3mRAsYH6wVCrMYonHGhE/gZfcDNUKXdzJzpjnhBUu7b9KrmQjr3LGvixDZQax9wVOgex+tX0OM/IIMaqjSxsINT0ctcQJ1/T9OVpDHyqFtNe8rNDXFH368FLXDTApAQ0bO24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoZbU2tI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoZbU2tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38ECE1F000FF;
	Sat, 12 Sep 2026 15:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226420;
	bh=8PYSXlHknDqT9X7WyB7CbPZZeL5WotZxczT6e2mGrMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoZbU2tI2q+rGYf6eADFik6CACwcbk/rXJmTshnKMnDgomTMShPKQKThkf9AZxEv9
	 J0MHSwEUKTLRjUw8Nq8+aerneMwQSnY0DLum2xye6VP/QRTZ/d905C4giL685rrrF1
	 +z9IF4jO6FaIfTcI2/mSVorfNqHSCCCyj1c0WSE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1397/1424] net/sched: sch_htb: limit htb_classify inner-class filter hops
Date: Sat, 12 Sep 2026 09:03:49 +0200
Message-ID: <20260912065638.548160195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 729c4896ab829169f95915d65edd530325910b37 ]

htb_classify() follows each filter-selected inner class by switching
to cl->filter_list, but never bounds the number of hops. A filter on
an inner class can point back to itself or to another inner class that
points back, creating an infinite loop in the packet classification
path with the qdisc lock held and BH disabled — a soft lockup / panic
from a single packet.

Bound the traversal with a hop counter and drop the packet with a
rate-limited warning once the bound is exceeded. The counter is
incremented at the point the inner filter chain is picked up, after the
TC_ACT_* switch has consumed the classifier verdict, so a terminal
TC_ACT_QUEUED/STOLEN/TRAP on the last permitted chain still sets *qerr
to __NET_XMIT_STOLEN and the packet is not charged as a drop by this
qdisc or its parent.

The bound is TC_HTB_MAXDEPTH, taken from HTB's own parameters rather than
from the qdisc hierarchy depth limit. Class levels run from 0 to
TC_HTB_MAXDEPTH - 1, so a traversal that strictly descends in level can
take at most TC_HTB_MAXDEPTH hops. That descent is what a sane
configuration does, but it is assumed here rather than enforced:
htb_find() resolves a classid against every class in the qdisc, so a
filter may equally select a sibling or an ancestor. The normal
root -> inner -> leaf path takes a single hop, so the bound does not
affect legitimate classification.

htb_classify() can now return NULL irrespective of CONFIG_NET_CLS_ACT,
whereas previously every NULL return sat inside that ifdef. The NULL
handler in htb_enqueue() therefore cannot stay conditional either, so
drop the ifdef around it. This matches hfsc_enqueue(), which has always
handled a NULL class unconditionally. Without it, a kernel built
without actions would dereference a NULL class instead of dropping.

Conditions to recreate the bug:
- CONFIG_NET_SCHED, CONFIG_NET_SCH_HTB, CONFIG_NET_CLS_U32,
  CONFIG_LOCKUP_DETECTOR.
- Create an HTB qdisc on a device (e.g. lo), add an inner class
  1:1 with a leaf child 1:10, install a root u32 filter selecting
  1:1, and an inner-class u32 filter on 1:1 also selecting 1:1.
- Send one packet (ping). On the unfixed kernel the classify loop
  spins with the qdisc lock held; with softlockup_panic=1 it panics.
- Reachable from unprivileged user via unshare -Urn (CAP_NET_ADMIN).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Vega <vega@nebusec.ai>
Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260826143339.271935-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index f1b903b367174..ed1bf8406ae6b 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -223,6 +223,7 @@ static struct htb_class *htb_classify(struct sk_buff *skb, struct Qdisc *sch,
 	struct htb_class *cl;
 	struct tcf_result res;
 	struct tcf_proto *tcf;
+	unsigned int hops = 0;
 	int result;
 
 	/* allow to select class by setting skb->priority to valid classid;
@@ -265,6 +266,10 @@ static struct htb_class *htb_classify(struct sk_buff *skb, struct Qdisc *sch,
 		if (!cl->level)
 			return cl;	/* we hit leaf; return it */
 
+		if (++hops > TC_HTB_MAXDEPTH) {
+			pr_warn_ratelimited("htb: classify loop detected, dropping packet\n");
+			return NULL;
+		}
 		/* we have got inner class; apply inner filter chain */
 		tcf = rcu_dereference_bh(cl->filter_list);
 	}
@@ -632,13 +637,11 @@ static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		} else {
 			return qdisc_drop(skb, sch, to_free);
 		}
-#ifdef CONFIG_NET_CLS_ACT
 	} else if (!cl) {
 		if (ret & __NET_XMIT_BYPASS)
 			qdisc_qstats_drop(sch);
 		__qdisc_drop(skb, to_free);
 		return ret;
-#endif
 	} else if ((ret = qdisc_enqueue(skb, cl->leaf.q,
 					to_free)) != NET_XMIT_SUCCESS) {
 		if (net_xmit_drop_count(ret)) {
-- 
2.53.0



