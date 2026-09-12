Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E724541A4EE;
	Sat, 12 Sep 2026 09:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205432; cv=none; b=JnCiK8ci0pz0S7dO5GhoFPRvcJihwqJaZwx+qwwsY2erZ1/riHL0IwjHo06VD/0Wc5jPhinZL9rD/AcQtExZQZ31c1wC/0ZJtYF+xdDKfrlhDtkCb57S2rnBkl31zBiN5vLIgJtOrH+CpJxupl27CSx/2QytYhkT8U7SiAYRqkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205432; c=relaxed/simple;
	bh=skRhKl8KPWYDSmuOIzg2EgBetFpgb/Ps4AXefP4uPL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cUX54iUjIPew4ZmlwP8g5IxLzUdPRh7LpygI9M1iojIZiNRIatYUWzZzcSLNoT06aSC9p+qDvgofyDEzXifnjnue9jbg25onGh8lHKjjjmfQF7Z25JeqcUHZIrMtS1ak6epq30mKY+VUrT1WQs8AHyUIqwzByRwbXF2qvAHaYFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9RufC98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9RufC98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3671F000FF;
	Sat, 12 Sep 2026 09:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205430;
	bh=FcU6ovqeYMONEu+QCih5flfw7u6asHokucy2o4N39uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9RufC98+3Cz6gAPWw/QXlQlzirgHY48+IoEPsWT1rtFXlZbbPQcqR5V7Yh9T5ITG
	 MJ1rRNMdnp9XvFk0pU/iQlenyPRIQ2QD596xnxWlk4Md/SBl5NddyPcaVyCP5ybH9S
	 coinlokshiApHZnHTxkY7z+0xurJ2U2wfBPLgzrw=
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
Subject: [PATCH 7.2 1815/1815] net/sched: fq: clamp quantum and initial_quantum in change path
Date: Sat, 12 Sep 2026 08:59:25 +0200
Message-ID: <20260912065731.651767977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6144b5686f13f..35f940b2205df 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -980,7 +980,7 @@ static int fq_resize(struct Qdisc *sch, u32 log)
 }
 
 static const struct netlink_range_validation iq_range = {
-	.max = INT_MAX,
+	.max = 1 << 20,
 };
 
 static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
@@ -1106,14 +1106,10 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1232,7 +1228,7 @@ static int fq_init(struct Qdisc *sch, struct nlattr *opt,
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



