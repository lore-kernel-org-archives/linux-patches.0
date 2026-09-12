Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9F537F337;
	Sat, 12 Sep 2026 19:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240579; cv=none; b=e9+vJmmX4LDN1b5jqZdoQzEhlP7Kj0iZZYn+XYL9NhCaPLNegJyL7BqULE8mpYj9vRg8HaZQUYR2QYEwG7sHKi8w/67vB3TYWyjnUfvJcWhb6xv/fVtR1BsqaqegbYmI6Q4Q1g/h8dzTPI0jPNXbS6MA1UYUMXCCD9QHycCk8ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240579; c=relaxed/simple;
	bh=xrdPqR9fR4eqX635ueEdNgm0muK4GA4x7arjzLsg1/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKmrgKmYBrV6z0H9TM9wqH4za5rqoBCFP8pdTxeJSd1G7p8q1RMvmfXjg6G5+q6PyaptEflAhLOT8t6pCn9WFTG7uWLkua/9SVkGYqaCs7Ppd4vrG23NxAk0tBhFm/cj/UdJOqT8QB6fqc46MhNrse6wKN6j2Om1mRtuyXa0Agc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjGVoyYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjGVoyYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D7C1F000FF;
	Sat, 12 Sep 2026 19:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240577;
	bh=2dNCL54gPHbgMYhEoikiTxWxavn1Eg4akgU1CnXAu3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjGVoyYVqd0NIXbk7ZVRIcNDtSjmHVBLroCmUlYfKOksXOp6d72bqyQIcsllzITZJ
	 8ohvYc1gE75QC5eT27+BEi1wpsi6fYccLSBtE1GG39EKnFYz2qCSBr6sKdSw6cA5km
	 sLOOafYMY2CgZaNaIpnR1K3hvtbEfdUZqwkchkrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 896/935] net/sched: fq_pie: clamp default quantum to avoid signed overflow
Date: Sat, 12 Sep 2026 09:05:26 +0200
Message-ID: <20260912065547.364574023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit c86cd7ed0b0e44779a3d1683f03e4353baf4bdc9 ]

fq_pie_init() sets q->quantum = psched_mtu(qdisc_dev(sch)) without
clamping. A device with a huge MTU (e.g. dummy with max_mtu == 0
accepting MTU 2147483634) makes psched_mtu() return 0x80000000, which
overflows the signed flow->deficit to INT_MIN in fq_pie_qdisc_dequeue(),
causing an infinite loop and soft lockup. Emulate fq_pie_policy which
is already bounded to [1, 1 << 20]; clamp the default to [256, 1 << 20].
256 matches fq_codel's floor and is a sane minimum for a DRR quantum.

Conditions to recreate the bug: a device whose MTU (plus
hard_header_len) wraps psched_mtu() into the sign bit (e.g. a dummy
device with max_mtu == 0 accepting MTU 2147483634). Requires
CAP_NET_ADMIN in a user namespace.

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260822195509.112717-5-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_pie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 910efc0630a14..33ec3aefde39a 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -417,7 +417,8 @@ static int fq_pie_init(struct Qdisc *sch, struct nlattr *opt,
 	pie_params_init(&q->p_params);
 	sch->limit = 10 * 1024;
 	q->p_params.limit = sch->limit;
-	q->quantum = psched_mtu(qdisc_dev(sch));
+	q->quantum = clamp_t(u32, psched_mtu(qdisc_dev(sch)),
+			     256, 1 << 20);
 	q->sch = sch;
 	q->ecn_prob = 10;
 	q->flows_cnt = 1024;
-- 
2.53.0



