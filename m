Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2175E3A5E88;
	Sat, 12 Sep 2026 20:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243463; cv=none; b=MWMySmG5fi5qaOT0hRNHT0Vt3bboTIwR9t7fs9wJJTvv93I0kX51aeh4kZbejdUQq7EWpCo6KQwhNzmmmszK6SjafNdzv3QlMH9qqCIj5ZlYb9azFkzuSKueJA8bRin4gqyh4oMz52J0YtmzllhvzN5Wh6+Fm0AiPYCxqaRZC68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243463; c=relaxed/simple;
	bh=Hl63JvkQH6xuq1ex1mO3OK3U1wS7MIi9nbEDxTQaqOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vl9Re6/g3lm4TnuUTg1R7fLnIK1EfXGOQ/hOutg+5wamXc8BYasZqOdw/UpVWR1hy/AEGNfRzHkrX3E3s97NwirOzwYUfvQ4/fXDH3QrHH8oeqHyVIKbh+b2mzSu6t/qpQgIOKWWJQUlQ2HWF7FMOQgu84tr00aNNnVltu3rT2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EukiAVUi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EukiAVUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F1B1F000FF;
	Sat, 12 Sep 2026 20:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243462;
	bh=aAKX9ybRKgAfdmempE5ie3DxMSWFVxTfcsYdOexWY98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EukiAVUiaMeM5QBm653yF1w9EQk3+wZJyU2d6mAK8FxUSilTbMFYjbpKdqviJYwre
	 jVVhQQAUhBhu9w5+ZphQwQGbgDBr9fp2sU0tH8hpkovCPNhkpn+HvYuMnxxIynpWK3
	 njZQGCmuYEXEX/pSsRooju4ruaSg4LYqow+0N3Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 763/798] net/sched: fq_pie: clamp default quantum to avoid signed overflow
Date: Sat, 12 Sep 2026 09:06:31 +0200
Message-ID: <20260912065534.556274103@linuxfoundation.org>
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
index b62a1c0c4817f..c5c728576c161 100644
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



