Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216438;
	b=TFzmpDvV1SEacbx6kemxgqU00RENJfDZ3nIAA7i7LQHU2FXvH/YBzp/01LCbEoK1HC7p
	 QFfYqvlV6RWOSIyAX7tgTUxdeuuAojvgmtAljPBF43KbcNcGb0TC/KppHOvqA8UQWoi+P
	 Q7tSawpUoRc6miIoNHZWRIH12+Mw1yYNzwFLOyEL9TYKPsECXmM+Ovw9TroyyHTgwmLwX
	 d9lVNKL7jZ1ngrPgnTEHyQ4hAQwq9/8F44U13eKft8xGVZYXYPq+pn3NkciwT2l8QBRpH
	 BOE0iP821e6o5hKERm0HDlafwZJT1kOSgYbD/5SY4ppIDJXSfpQuCBP7P9E6tDtZaEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=glnvxXJoW8X5OoqJogXIggFqf0GwFYmnMY4s6HXie4o=;
	b=hXXYPOKn+gYFX2Jm1kJyI1n/V56N4heEuNP6636C3PRhGvHZP8evBjsVb3borjupCwbH
	 F1nMXN3mtrA2fdhnva3nQK8EyQJmrW5fw0SVAflChkWcL8oQbsgMhIayTQU3uINJqr9cJ
	 PO4UF6GAG+i7Zmuj6ttzT+ANFztQf49SffJydv2oug5YA1QfWUcnScW8U8ge/SDl3heZT
	 6vNVpKb2kXdTKxwTTonAZrksvLEKq9oX+lKXtoWDdv7zaoY3ixoQUCJt/baX0T52uXQkr
	 09XaeSFcP0Z/FTXZB4zpU6Ivxv8aMjoTfZ1/ElZbYJZQcDBKQzs+K+afW7j5OKlbYyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DB10VDeY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D76606A31E;
	Wed, 28 Oct 2026 19:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DB10VDeY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945421F01825;
	Wed, 28 Oct 2026 19:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216438;
	bh=glnvxXJoW8X5OoqJogXIggFqf0GwFYmnMY4s6HXie4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DB10VDeYAIf5DgYTJF6bVsdqh4OCff2LaaigS6euRgrw8IpRAtHfL9zxm05IdcPQ6
	 AD1bDcL0MhDyH2gqJLQR+jidhta/kOFXDDouQf3LUo2cqeBIFrAxomRUZSCLkBkT6H
	 LWL554+XUs57yHzQWZHW4ILQyjOlKViS0SV8yrC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1513/1887] net/sched: fq: add overflow bounds to quantum and initial quantum
Date: Wed, 28 Oct 2026 18:00:09 +0100
Message-ID: <20261028170533.893833548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 709f34f7c28dc4dd6c40343d101850f11e172312 ]

fq_init() computes quantum = 2 * psched_mtu() and initial_quantum = 10 *
psched_mtu() with no overflow check. A device with a huge MTU (e.g. dummy
with max_mtu == 0 accepting MTU 2147483634) makes psched_mtu() return
0x80000000; the 2 * and 10 * multiplications wrap to 0 in 32-bit
arithmetic, so q->quantum == 0. Then in fq_dequeue() the credit-refill
loop adds 0 to f->credit (which stays <= 0) and goto begin loops
forever under the qdisc lock, creating a soft lockup.

Clamp psched_mtu() to [1, 1 << 20] before multiplying so the product
cannot wrap, then cap the result at 1 << 20, matching the bound already
enforced on TCA_FQ_QUANTUM in fq_change().

Conditions to recreate the bug: a device whose MTU (plus
hard_header_len) is large enough that 2 * psched_mtu() wraps (e.g. a
dummy device with max_mtu == 0 accepting MTU 2147483634). Requires
CAP_NET_ADMIN in a user namespace.

Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260822195509.112717-2-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 2223edfd7aa77..ee8629d116473 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -930,12 +930,14 @@ static int fq_init(struct Qdisc *sch, struct nlattr *opt,
 		   struct netlink_ext_ack *extack)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
+	u32 mtu;
 	int err;
 
 	sch->limit		= 10000;
 	q->flow_plimit		= 100;
-	q->quantum		= 2 * psched_mtu(qdisc_dev(sch));
-	q->initial_quantum	= 10 * psched_mtu(qdisc_dev(sch));
+	mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 1, 1 << 20);
+	q->quantum		= min_t(u32, 2 * mtu, 1 << 20);
+	q->initial_quantum	= min_t(u32, 10 * mtu, 1 << 20);
 	q->flow_refill_delay	= msecs_to_jiffies(40);
 	q->flow_max_rate	= ~0UL;
 	q->time_next_delayed_flow = ~0ULL;
-- 
2.53.0



