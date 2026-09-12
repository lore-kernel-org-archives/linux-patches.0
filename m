Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B884BEE3C;
	Sat, 12 Sep 2026 16:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232095; cv=none; b=LQYym8sq/I9EMfTmSR23JRtd/QQCdPvfPb+gmzpy07X6wddAWt6vk1gH140GvmRaSQhBJwN1ldlTjA1rfr0NxwK5oS0aB7kGPqi1zfB+yqnDzP1f9+Rlvd9U0l+UcM0PlMnEKXDh7Z/lQBrIGrpCT2GDQ39+nBXKnTRw7F8//fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232095; c=relaxed/simple;
	bh=xkxDbDkFIaaynJcJ3eaFKooUjpRJQb4VGxPIOgeIFmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOfkYFq9ZMoMVOnXD9vsQ916/kIFElCKTL9QIRCxdQ+sAxSk4HbYBq8xxDJHt0hsNt1GikMkZda5HJgOJQUkvoPMgYHYDS1Gy2a3FdnybFgT+Cxe8EVAQPcl7dByN5YVYsKUMWgqwQKM59PprKJcVqcdtQQFS8z5yxE0gij/cno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHyzcdZo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHyzcdZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A811F000FF;
	Sat, 12 Sep 2026 16:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232094;
	bh=TuYv2cX2VqlGx+DJPe/VM8cBW0OPzOPKCOzjzzvOuAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHyzcdZo3uMnUGd5KN9TzOUkgRJvfXR/ij7a+D8Bt4A8XGEeHr9IAIsz+FVp2q9ba
	 wfjXJ3cbuIf81KkebFV6QqeobXefZ7kDYzRdTZkjG9wyGe+EhDbYu4eDV1tykKNiKE
	 ksc2IJVVFeDgV4qkaoYZweDVg7VxmxBpqnz1FlUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1105/1191] net/sched: fq_codel: clamp default quantum and mtu
Date: Sat, 12 Sep 2026 09:03:53 +0200
Message-ID: <20260912065612.972493518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e059d6c145741..ac2f643dd8427 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -495,6 +495,7 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
+	u32 mtu;
 	int i;
 	int err;
 
@@ -502,13 +503,14 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
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



