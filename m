Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B5F43D4E2;
	Tue, 21 Jul 2026 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674020; cv=none; b=DIZAHAa2g1KM2OtrR4Etg5U519bObCA9TJFTDLCP+8IxJw2flLEwuayZqE3tiSU1LOeisX3kmiadjnXrJCHA8LWSy4XByhnST3c+Kuff0kucMsUjpBtjA8oWiZGbRM2hscDCjAGOwFayRwp3jjYYyKhTIPEkwSEtCw9bOxhl+cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674020; c=relaxed/simple;
	bh=kCv1BUDE+gf+ygyYJKvvfpmMrix8CLKmaPt8YMvFDHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cG7JqV+LN4Y0vlOP6uuLZcfhdjsw8SdbyjV7cBj8pjxzhX1iepspTD/scyTH6IO/Skoqmj0Xm7yArrFanPSwJ4n+ccRu89hGslilasuZBGgiWkZlXIbvap16gj+e0IjQ3f6UCsRv6heGMlVI1hnUUOJp7GXGYeL34dFpSc8YNU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgolPY5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgolPY5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CBC1F000E9;
	Tue, 21 Jul 2026 22:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674019;
	bh=MT30nC2Zug7UtxsgHiIzXPJ+03XYMkV42h/evaOq2WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgolPY5LRc55ScSiGSkV9xW1XQWwwHnAvd7dmrTyhjHChfHWXBBaqe6FBhNX9yS/r
	 AmIx30trpgKK74HvD0eu9wflIWKdTm6Tq1/+i30vp/bYlcppo/ThIWTTyvThMm0IBa
	 ZNTWAdCFLS/RsvnsiTw0ArYVdwzkn2piRjWM1F7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/699] net/sched: hhf: clear heavy-hitter state on reset
Date: Tue, 21 Jul 2026 17:22:22 +0200
Message-ID: <20260721152404.334426270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



