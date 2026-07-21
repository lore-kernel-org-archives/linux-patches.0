Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9A24028F7;
	Tue, 21 Jul 2026 18:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658053; cv=none; b=sS95CCl6PT0XdgK9Uw7w6UmqfptSo7JRcp3414CbqDMw/mu/Fgr8YD8DOGXqBX7zt/YUGcyniAMMXEi9MTPR67v5gBTyi3W3kix1jTUuqig/ENmXX/7i1aWx2wGBofzXbsne8p7J7b3C2hk3qDz0SKnpy3oI2rhleETlqyLb32A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658053; c=relaxed/simple;
	bh=Hqf/mXmoatH4UpvjHwj1PfrvRweSByKgP6q1knt61JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqzsgYNhe+coElRe4k/yBAPMP6KsMyuk4+UqwYp7Mr4IVKNAYQ+nITwxXB+IBqBEG2IB5us/lzSi0XFTCxOazaVHnL20Fq8S2V7TQiE3FD9NXxYvvaV6eUjNDNqOw95id6bZdNNqtYTIIgpJXut5thUqJAeRIAaREI/SwSuhDRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ujv0hizv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ujv0hizv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518211F000E9;
	Tue, 21 Jul 2026 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658050;
	bh=n4bLqs74C/Q7rExfmp7jwscz5ETZfq6L7umnQJqrBSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ujv0hizvqyCAB6j3RdZlS0+qbxc2Dhf5B85+n7uwKqTELh8+ExKYHYPQgjE76VRI6
	 sdn2G1C7OOiJY8VEFRsEWupPnGGVqZKZ7RXcij4HqKUh40z2Ow9xHIKP94fflLeu5i
	 +bqFTUHiNXdTWYN0JCp6In9ph2falDxN04Yry4iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0997/1611] net/sched: hhf: clear heavy-hitter state on reset
Date: Tue, 21 Jul 2026 17:18:33 +0200
Message-ID: <20260721152537.816526644@linuxfoundation.org>
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
index 81c3a388c94376..e1c9d1edc8a99b 100644
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



