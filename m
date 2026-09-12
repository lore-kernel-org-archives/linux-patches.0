Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952F047F3A1;
	Sat, 12 Sep 2026 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219485; cv=none; b=sKJjH/zp2S2m1iOA/RSDKVuZ5/xl5pjOx2MIA4oezqZy8oOG6gB6c8wmGu9K+Y4s0G+jM31VADGpR2R48UTcLurEQAiA1wcXa/izwFIAq6JiluLPVVDfFWqw0PcbYwU5zNxFeW7Qs18PW/lBM6lUAKTBOtG0+X2Pn/Dn63RTJBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219485; c=relaxed/simple;
	bh=KbeSmOJzJoLPDzQIkdHql9+mZ+F59icLA+GRwBZ/VFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BqhusqVZqj3x1Rt1m+LxJ59ZpbYVfxP9tbE5ABga2qpp4p4DLIxY0AKptvfcKWSdDTCPSMT9geyHbyS8F3QgMunW5sM6+iUamrwhJUgI3zxlyzYFlzBuVf2HQf+TrjuN0Y5VYM2bS8wFuq8D5SjjivAC2zzEYz35ledKgyaQZwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymRqbUiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymRqbUiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9816B1F000FF;
	Sat, 12 Sep 2026 13:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219483;
	bh=cM7mgEPec0e/l01o7/0ZgsgfBbEvLEGyrGPPEc+c7x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ymRqbUiPlwOHOU0xIE3aAHpkaj8aXH8r3t2YsSJi+hgLUTePctRB2jjKiiAY+6rtE
	 z9Ad2Qy+4FI0fUvliISkpbdkbFYmM3DR5D0v+kErn7dUMediJsi05UTz3ce/PKyd2h
	 F3FqvpNKiy5XCwRZUIWXrKp0QZRmm1a4rq51hkGI=
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
Subject: [PATCH 6.12 1360/1376] net/sched: fq: clamp quantum and initial_quantum in change path
Date: Sat, 12 Sep 2026 09:03:06 +0200
Message-ID: <20260912065637.844982946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index afb76d7595917..6b85bb2a4f8ab 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -909,7 +909,7 @@ static int fq_resize(struct Qdisc *sch, u32 log)
 }
 
 static const struct netlink_range_validation iq_range = {
-	.max = INT_MAX,
+	.max = 1 << 20,
 };
 
 static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
@@ -1034,14 +1034,10 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1147,7 +1143,7 @@ static int fq_init(struct Qdisc *sch, struct nlattr *opt,
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



