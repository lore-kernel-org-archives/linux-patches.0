Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8432C1586;
	Sat, 12 Sep 2026 11:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212769; cv=none; b=IYcPOQoWqWkbSnqE/FKjXRAFbcvZHxhamlgZU/jsICnuJreFeDVc9TaZBXte2F4KeZvlUBmviWmzSNHOj+a6bnvRnPhXmasYj5PGx4j7cQ4qNMWMOQQKWKyIBIZ4OsF1YicBkW1BmZKwTsh+Y+6JB8ej/ABsUrelFpc1zadsX6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212769; c=relaxed/simple;
	bh=5iYxo8LOC6n+a9G/I9QAdEOqrFUcSLL25a2+M5lFHbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NT2B8J2zi97UHsdKGjvq3JpLJpxpFQhZvEvhg/0oy6DRQUwNUECM8LT06P572fvrRTk0H+cQS5070yrGiVkkJGcR+I4bQR1pX/HvXIz/rCDuACVCAZwgQ2drHtJSMD3EhJGGw/GJGzV1OXxno99gts6o5wrzMR6mOlFKHYUhUiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szbVER4q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szbVER4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153841F000FF;
	Sat, 12 Sep 2026 11:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212768;
	bh=alfIpo66M4YqPfQjbFfljIWdjA4I2dUKYdxZeb3Aujo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szbVER4qJp0+aJlIU/P+UevggH5qDOp0172So/iuSDOpQKjhuvIl1ROJBAFxKRsc+
	 fNa//RXiLP/Bd49dFCFUUQ6yO6p762RZguEEWKtE/7MyinxGrKUbvJWw3r2/G49vf2
	 y2b9QiXux3+0cDtz4gpzwcQwAYbXAlgcfzKBMSfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1503/1518] net/sched: fq: clamp quantum and initial_quantum in change path
Date: Sat, 12 Sep 2026 09:01:12 +0200
Message-ID: <20260912065657.564014800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 094cc07f98dfe70a34e2a1923af17fd29b8cf622 ]

The fq change path accepts TCA_FQ_QUANTUM in [1, INT_MAX] and
TCA_FQ_INITIAL_QUANTUM up to INT_MAX, while fq_init() already clamps to
[1, 1<<20]. A user can override the init clamp via tc qdisc change,
restoring the small-quantum deficit spin that the init clamp prevents.

Narrow iq_range.max to 1<<20 so TCA_FQ_INITIAL_QUANTUM is rejected at
parse time. Clamp TCA_FQ_QUANTUM to [256, 1<<20] in fq_change() and
fq_init() quantum to [256, 1<<20] for tiny-MTU devices.

Conditions to recreate the bug:
  CONFIG_NET_SCH_FQ=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root fq
  tc qdisc change dev dummy0 root fq quantum 1 stab data 32768 size_log 15 cell_log 0

Fixes: 709f34f7c28d ("net/sched: fq: add overflow bounds to quantum and initial quantum")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.2
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 9df9c93ae4e4c..7599a4f7a3e2a 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -924,7 +924,7 @@ static int fq_resize(struct Qdisc *sch, u32 log)
 }
 
 static const struct netlink_range_validation iq_range = {
-	.max = INT_MAX,
+	.max = 1 << 20,
 };
 
 static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
@@ -1050,14 +1050,10 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
 			   nla_get_u32(tb[TCA_FQ_FLOW_PLIMIT]));
 
 	if (tb[TCA_FQ_QUANTUM]) {
-		u32 quantum = nla_get_u32(tb[TCA_FQ_QUANTUM]);
+		u32 quantum = clamp_t(u32, nla_get_u32(tb[TCA_FQ_QUANTUM]),
+				     256, 1 << 20);
 
-		if (quantum > 0 && quantum <= (1 << 20)) {
-			WRITE_ONCE(q->quantum, quantum);
-		} else {
-			NL_SET_ERR_MSG_MOD(extack, "invalid quantum");
-			err = -EINVAL;
-		}
+		WRITE_ONCE(q->quantum, quantum);
 	}
 
 	if (tb[TCA_FQ_INITIAL_QUANTUM])
@@ -1176,7 +1172,7 @@ static int fq_init(struct Qdisc *sch, struct nlattr *opt,
 	sch->limit		= 10000;
 	q->flow_plimit		= 100;
 	mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 1, 1 << 20);
-	q->quantum		= min_t(u32, 2 * mtu, 1 << 20);
+	q->quantum		= clamp_t(u32, 2 * mtu, 256, 1 << 20);
 	q->initial_quantum	= min_t(u32, 10 * mtu, 1 << 20);
 	q->flow_refill_delay	= msecs_to_jiffies(40);
 	q->flow_max_rate	= ~0UL;
-- 
2.53.0



