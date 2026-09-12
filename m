Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179153F9F47;
	Sat, 12 Sep 2026 09:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205152; cv=none; b=hljX+RG4VnDIPEZacoW1fSp9IG2iO0jC0lVBXRDzbUVn2vXvDpOf/2Tng8of2+AoLMYCYduiQE9Kf2Xymkxj4diLAeeAtDyw7dmVi91povk9LXZZ2DZyzBSkSVE4c0gyteBSgS1C30dcfQKrqLvxzOs9HegG3aGag7pzAwBR/K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205152; c=relaxed/simple;
	bh=GF3yRuNV2lYa6xK5fpbycJ3zLm4eTGoHqsgp3h7C/aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXZ5sNzwqP6RqJVkDKg9EedIRLunck0SFPwIUvoyPlIePhy4XJC5LCq4NU9442GN4sylUt1turDhKau0eeT4XcXLRlhEi7KYr5rorlFqyvvXS4inN65Cd84loeeNzY+qNbQpPmEdO1oIb5b7z3+WwsXlUuXE4TRW5SI0FOWqFfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwWb3wwM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwWb3wwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617A21F000FF;
	Sat, 12 Sep 2026 09:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205150;
	bh=vzhXjztKlh3toPLUIJ1f47wLeX2dYIYILBSDkiuJ+Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwWb3wwMMiax5oiOPyUJPTM4cZ0r9zT/7Cfamc24DH4IzWY8Kx3zZgTU29khedNfj
	 mVs6KjiPAcVbfY+HqRCuJGtIfY2FQbjMeRgtaa4YG9rbTN/qrCA9OqYTAAwVZqLr+n
	 IR0aQW0KVM+vSfcAVK4OoECVyZIa28LXyMd8HfXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1759/1815] net/sched: fq_codel: clamp default quantum and mtu
Date: Sat, 12 Sep 2026 08:58:29 +0200
Message-ID: <20260912065730.284488813@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit d9ebd8f9aa8b2773235889cb903fafd61f2d8585 ]

fq_codel_init() sets q->quantum = psched_mtu(qdisc_dev(sch)) without
clamping. A device with a huge MTU (e.g. dummy with max_mtu == 0
accepting MTU 2147483634) makes psched_mtu() return 0x80000000, which
overflows the signed flow->deficit to INT_MIN in fq_codel_dequeue(),
causing an infinite loop and soft lockup. Emulate fq_codel_change()
and constrain to [256, FQ_CODEL_QUANTUM_MAX].

The same unclamped psched_mtu() is assigned to q->cparams.mtu a bit
below, and fq_codel_change() never updates it. codel_should_drop()
tests "*backlog <= params->mtu"; with mtu == 0x80000000 (~2 GiB) and
the default 32 MiB memory_limit, the test is always true, so CoDel is
silently and completely disabled (no drops, no ECN). Declare a single
clamped mtu and assign both q->quantum and q->cparams.mtu from it,
which also removes the double psched_mtu() call.

Conditions to recreate the bug: a device whose MTU (plus
hard_header_len) wraps psched_mtu() into the sign bit (e.g. a dummy
device with max_mtu == 0 accepting MTU 2147483634). Requires
CAP_NET_ADMIN in a user namespace.

Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260822195509.112717-3-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_codel.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 6cce86ba383cf..969b2510b0b86 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -509,6 +509,7 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
+	u32 mtu;
 	int i;
 	int err;
 
@@ -516,13 +517,14 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 	q->flows_cnt = 1024;
 	q->memory_limit = 32 << 20; /* 32 MBytes */
 	q->drop_batch_size = 64;
-	q->quantum = psched_mtu(qdisc_dev(sch));
+	mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, FQ_CODEL_QUANTUM_MAX);
+	q->quantum = mtu;
 	INIT_LIST_HEAD(&q->new_flows);
 	INIT_LIST_HEAD(&q->old_flows);
 	codel_params_init(&q->cparams);
 	codel_stats_init(&q->cstats);
 	q->cparams.ecn = true;
-	q->cparams.mtu = psched_mtu(qdisc_dev(sch));
+	q->cparams.mtu = mtu;
 
 	if (opt) {
 		err = fq_codel_change(sch, opt, extack);
-- 
2.53.0



