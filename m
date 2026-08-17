Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5598041F5EA;
	Mon, 17 Aug 2026 14:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978232; cv=none; b=nX1BtephHwvN4ATTFVnO4QMoV349eKloM8WohXjanBlLqoyse+eyLUp4IApm5y8lX5Evpt6oyKJdPWfcwXXwUjP4spnucvTCpql/qqKX0pzfUXm6NfUIJJodPTjoY5/FkStJFmbUrrODTUucwHRkA8HNOKfthITpky6pdLED2O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978232; c=relaxed/simple;
	bh=hyFBSAE2yKL3L3slID1abWYNzS5X50G7lPEHbHkdsNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCpd3z0zAvGNbftLbKz6Rk32KVC4BNuESn1/hHNeIa8UuBPnNUonFFw/EzGol1MndHs0/ACdQpDomBd7k9xd4rN3avrwQ6YIgMD8KPG3j88DZe+P2g4tt09pCh5Dw0ZfhII7/+3S/TMVviZrlroCd9WHCDrUXhfDbU1ZseWOqR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rj61luvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rj61luvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEAF1F000E9;
	Mon, 17 Aug 2026 14:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978231;
	bh=jcc5A7HnKljlUgESDk5f0F34opX53NAewemNxAHTQN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rj61luvN19aERG2848T3sazke3P4L21JIyBLaSsJ4VdoairHLpSn5dl35MDtKYFyX
	 l4u4BRt9i4WMi7p+B/6HuBf5UyvdV8t0bLdmLpoxlD1wPwp0zwRbA/W7g5EyqFqXj6
	 A8LQ3Om/KNpnXaNG0ADIEdY4IfwUiSZVX1iP+IfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunjung Ko <hj351016@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 147/181] net/sched: act_ct: fix sk_buff leak when the header checks reject a packet
Date: Mon, 17 Aug 2026 15:34:01 +0200
Message-ID: <20260817132541.467769763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Hyunjung Ko <hj351016@gmail.com>

commit 8a7ed561671aa6a911a2de99e59ef670a4d0b1df upstream.

tcf_ct_handle_fragments() runs its header sanity checks before handing
anything to the defragmentation engine:

	if (family == NFPROTO_IPV4)
		err = tcf_ct_ipv4_is_fragment(skb, &frag);
	else
		err = tcf_ct_ipv6_is_fragment(skb, &frag);
	if (err || !frag)
		return err;

tcf_ct_ipv4_is_fragment() returns -EINVAL or -ENOMEM;
tcf_ct_ipv6_is_fragment() adds -EPROTO when ipv6_find_hdr() fails. None of
them frees or queues the skb, so on that path the caller still owns it.

tcf_ct_act() however funnels every non-zero return into the
ownership-transfer exit:

	err = tcf_ct_handle_fragments(net, skb, family, p->zone, &defrag);
	if (err)
		goto out_frag;
	...
out_frag:
	if (err != -EINPROGRESS)
		tcf_action_inc_drop_qstats(&c->common);
	return TC_ACT_CONSUMED;

TC_ACT_CONSUMED means the action took ownership of the skb, so no caller
frees it - sch_handle_ingress(), sch_handle_egress() and
tcf_qevent_handle() all deliberately skip the free for that verdict. The
skb is therefore orphaned: one sk_buff plus its data buffer is leaked per
malformed packet, unbounded. Note the drop counter is already incremented
for these errors, so the statistics claim a drop that never happens.

Three different ownership states reach out_frag: today - the skb may be
queued by the defrag engine (-EINPROGRESS), already freed by
nf_ct_handle_fragments(), or still owned by us. Tell the caller which of
those it is, and free the packet ourselves in the last case, which
restores the TC_ACT_SHOT behaviour that predated the Fixes: commit.

Reproduced on v7.2-rc6 with a 54-byte frame carrying a 40-byte IPv6
header with nexthdr = 0 (hop-by-hop) and nothing after it, on a
clsact ingress chain with "action ct". kmemleak reports one leaked
232-byte skbuff_head_cache object plus its 704-byte data buffer per
packet; with this patch it reports none.

Fixes: 3f14b377d01d ("net/sched: act_ct: fix skb leak and crash on ooo frags")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Hyunjung Ko <hj351016@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260806101235.809370-1-hj351016@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -838,8 +838,15 @@ static int tcf_ct_ipv6_is_fragment(struc
 	return 0;
 }
 
+/* On error, tells the caller whether it still owns @skb and must free it
+ * itself.  @skb is ours only when the header checks below reject the packet
+ * before it is handed to the defragmentation engine; once nf_ct_handle_
+ * fragments() has been called the skb is either queued (-EINPROGRESS) or has
+ * already been freed by it.
+ */
 static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
-				   u8 family, u16 zone, bool *defrag)
+				   u8 family, u16 zone, bool *defrag,
+				   bool *skb_is_ours)
 {
 	enum ip_conntrack_info ctinfo;
 	struct tc_skb_cb cb;
@@ -857,8 +864,12 @@ static int tcf_ct_handle_fragments(struc
 		err = tcf_ct_ipv4_is_fragment(skb, &frag);
 	else
 		err = tcf_ct_ipv6_is_fragment(skb, &frag);
-	if (err || !frag)
+	if (err) {
+		*skb_is_ours = true;
 		return err;
+	}
+	if (!frag)
+		return 0;
 
 	cb = *tc_skb_cb(skb);
 	err = nf_ct_handle_fragments(net, skb, zone, family, &proto, &cb.mru);
@@ -975,6 +986,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
 	bool add_helper = false;
+	bool skb_is_ours = false;
 	bool skip_add = false;
 	bool defrag = false;
 	struct nf_conn *ct;
@@ -1010,9 +1022,18 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct
 	 */
 	nh_ofs = skb_network_offset(skb);
 	skb_pull_rcsum(skb, nh_ofs);
-	err = tcf_ct_handle_fragments(net, skb, family, p->zone, &defrag);
-	if (err)
+	err = tcf_ct_handle_fragments(net, skb, family, p->zone, &defrag,
+				      &skb_is_ours);
+	if (err) {
+		/* The skb is still ours only when the header checks rejected
+		 * it; returning TC_ACT_CONSUMED for such a packet would leak
+		 * it, since no caller frees an skb it was told it no longer
+		 * owns.
+		 */
+		if (skb_is_ours)
+			goto drop;
 		goto out_frag;
+	}
 
 	err = nf_ct_skb_network_trim(skb, family);
 	if (err)


