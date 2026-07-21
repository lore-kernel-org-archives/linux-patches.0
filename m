Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65563E1723;
	Tue, 21 Jul 2026 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653551; cv=none; b=qg6SIv8P6HiC/EVwDbU2jrpBf8qy+JVTga9VCgwwQoPekRy2jTbvzvHZW3zW5DBZvURKGvu6FDy5aAh0IQOgNV5K/1ZVA588eNC+Ib8vmLR142O6EB3e5udouUiPD47FeQpLb8VcBOUqRjw1RdvACLnG8XD9UMf08QML1nWe2Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653551; c=relaxed/simple;
	bh=Hkzu0sTSjyjaxK+4B5yLpNlYaJoEyIzh+FZ3+4SwG/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDST4PVnE900DRlwxec4mdcbqojUNdoXUBkUkwkbOf3CNGOLWOCAtGTWiVJJMUflpeuGhmt/F+DOYokGRveqB3+CVt0e2fK6HdpYgdluOp7h/hZt0cvCPRlstAcuuWDjqhaQDdu7C6m1MuaLdfIQUEdVxmFMu8V26nu3j8oNdC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCVbBPWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCVbBPWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291CA1F000E9;
	Tue, 21 Jul 2026 17:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653549;
	bh=9lY7vaywUG4qabquyVBH7+PoxzcF9z8StcNJDbtv3qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCVbBPWD8JCMCVyQUFFxaF+RegsCzZN5ReXiTN7Ll5JNtgh392Nb8UAbrkXYIT0OF
	 4Aw8Yp04d4NQx23u+j/QDgqpUCYpCm+1DjoY12YEhZLq/dmMose+ddNjlnXd+OoYQw
	 EvMXAS0nkhbTZpA9PUarBLfRy/zxMXJsqcfCa3xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1368/2077] net/sched: hhf: clear heavy-hitter state on reset
Date: Tue, 21 Jul 2026 17:17:21 +0200
Message-ID: <20260721152625.083621100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1e25b75daae2e5..d85cb0263b675a 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -462,12 +462,39 @@ static struct sk_buff *hhf_dequeue(struct Qdisc *sch)
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



