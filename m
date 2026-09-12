Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D053A7820;
	Sat, 12 Sep 2026 20:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243457; cv=none; b=tDS40c2oDu1BBGh4Pgo3k69yPP4LzzAV8FQSXSOv567eht24YPRCgqvVeNmsXh/k1Wr9aFWwwapH9MIO1Yppnp7cHL5eFjp4QhjQxPwbiowFfDETrjqGRYTO2DxDyi2811Ar8WHnuCZVwInfVAVWwPTCkmIgq9vD+fOoYJw+Ufk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243457; c=relaxed/simple;
	bh=wO5ub6A4T++B1OvUBh4/JSYJUPoB6k3haWePHD/dHBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHe7T2Aznc5mju1FJWIhe34kfrNDQtmlYPS58rk1kdszqbAnYOK34f4FNxHF/cgHpllDFzkVmAUmaXzfpgS/p9nmFMYy9aOJkS74LM1IjVCAxPb/GCiPVjqMxyyIkNVzqHp5tQRACV+fVOCFADCLSKK7y/Cv4Oz34jlVyeKujyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgAT8HGr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgAT8HGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F901F000FF;
	Sat, 12 Sep 2026 20:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243456;
	bh=hoTAfPEI9xTGd2KZPzzoCnZ26CcE8oC5NwwL7RrVLg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgAT8HGrNUrz6SWIxFDdoJCnhHjfdCHsrmepH8hjjGa4iUzVXBK1YArcwaG55ER2z
	 Aiu22TU1TT+zhC5g49oYuBR18u6fijRu0N2gYK3bLquAeQsZ0BBOpJUA9YELEtBm6t
	 YLTAyothDZ8b4f0n38tLejrtm2A9A/Cwv/WoLJwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 761/798] net/sched: fq_codel: clamp default quantum and mtu
Date: Sat, 12 Sep 2026 09:06:29 +0200
Message-ID: <20260912065534.509859135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index ae1d19bb6c556..4a8e85622aa6e 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -491,6 +491,7 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
+	u32 mtu;
 	int i;
 	int err;
 
@@ -498,13 +499,14 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
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



