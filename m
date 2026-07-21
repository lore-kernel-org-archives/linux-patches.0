Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B4C449B2A;
	Tue, 21 Jul 2026 22:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672125; cv=none; b=iSqAIuS34nK6cW5XAEZA1rAjLNf4M52u4hq2Lagub5RvEr5fZ2BQXXMgo1zssnzVwpgMdbe7SDy03VVaVzy6MwF5dE+vnNKHCuecakG29njUYB9m8MOfUFVNggg3kSh12mJ+hObZKCJ0AvnZIUjrNJmI3CfdqFIAZYKOg68X074=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672125; c=relaxed/simple;
	bh=nQXWj4FVe2yO9Aqf7u+27Lv6/nVLUBuKEi1jwzY7Yv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShQJCLC5eQDS3k5gfEsbkAwSBKxMOOOQKlv5D3fAjlG1SyDnBCZIATZCBhqwXgag0PPCkh5rEj8PJZxgVlSYCU+4jFg2V5pRBpYYnoM89x5i69AiBNGKM+sUZntjpPkvnciIcQ+MN99Hr2uJv8EpzFchUymYF/qv/MxTrc95ENU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D05A4sgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D05A4sgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A61E1F000E9;
	Tue, 21 Jul 2026 22:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672123;
	bh=QDSXGh2s5UvtOQ+i2lBJLJTwaBAs8NGzFJ10ts64D3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D05A4sgBambkz96r2g5/67qeq3gnnWSdc7PXYwUb/OWyds4xsOL9HdFjPp99ikxOr
	 1Yjiea8TvtgJ15IPxHSxGEzissz+cUhifYg4d3/E+G05CPnJ0SUlWMNQRd2yTphyWj
	 Ia4/vgZzXXYtZllQ2hHVB4NODaaKEIOZqX0PA5Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 507/843] net/sched: hhf: clear heavy-hitter state on reset
Date: Tue, 21 Jul 2026 17:22:22 +0200
Message-ID: <20260721152417.435773176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit a225f8c20712713406ae47024b8df42deacddd4a ]

HHF reset does not clear the classifier state used to identify heavy
hitters.  Packets after reset can therefore be scheduled using flow
history from before the reset.

The reset operation should return the qdisc to an empty state.

Clear the heavy-hitter classifier tables when HHF is reset.

Fixes: 10239edf86f1 ("net-qdisc-hhf: Heavy-Hitter Filter (HHF) qdisc")
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hhf.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index 73cabb4451ce7a..1fb9294a27f252 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -461,12 +461,39 @@ static struct sk_buff *hhf_dequeue(struct Qdisc *sch)
 	return skb;
 }
 
+static void hhf_reset_classifier(struct hhf_sched_data *q)
+{
+	int i;
+
+	if (!q->hh_flows)
+		return;
+
+	for (i = 0; i < HH_FLOWS_CNT; i++) {
+		struct hh_flow_state *flow, *next;
+		struct list_head *head = &q->hh_flows[i];
+
+		list_for_each_entry_safe(flow, next, head, flowchain) {
+			list_del(&flow->flowchain);
+			kfree(flow);
+		}
+	}
+	WRITE_ONCE(q->hh_flows_current_cnt, 0);
+
+	for (i = 0; i < HHF_ARRAYS_CNT; i++) {
+		if (q->hhf_valid_bits[i])
+			bitmap_zero(q->hhf_valid_bits[i], HHF_ARRAYS_LEN);
+	}
+	q->hhf_arrays_reset_timestamp = hhf_time_stamp();
+}
+
 static void hhf_reset(struct Qdisc *sch)
 {
+	struct hhf_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb;
 
 	while ((skb = hhf_dequeue(sch)) != NULL)
 		rtnl_kfree_skbs(skb, skb);
+	hhf_reset_classifier(q);
 }
 
 static void hhf_destroy(struct Qdisc *sch)
-- 
2.53.0



