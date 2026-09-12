Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ACE374E6F;
	Sat, 12 Sep 2026 09:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205147; cv=none; b=FINN+E8fpfU70rsh1HyWZPBHpXWrc7INS+hI2HxdIHCT8X4HXNtyG5zyeVeH4w6sjczPXoeekzhHlnuNAXiKcDCTDhJB9Ld7VyFqIYaIr2SVaGTzsvSnkjeoomLZpVFxDJCgnyGq2UXKJTYjsjlas3EEjSzb9BLt5LRDwdWEcC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205147; c=relaxed/simple;
	bh=kSeATJfwR1fHebRo6nx5kknoROxlGo0o6bv+QuKHc84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeqt1DVY6SiueqYVnYF86Pv0fq8u9EneeNZ3uy25MKFbc0tiUwajt3UCr+LsAhJodLEpozpst18ygH7aHGF+91txH14jCenAJjFH4OQFv8RBLJfMS+JVxMQKyK2h+327KIIOPSnLo8vRuvwnP+sRbb4OGCmXVqMAFHsuBcjjWMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnOofuzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnOofuzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5934C1F000FF;
	Sat, 12 Sep 2026 09:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205146;
	bh=xvxsAHg5r1BgNqYvk4B05vH5upx/4e70coI488tA0GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnOofuzwnVEK1EvNorHYgc6Uayia3G80P1+MdkC+2+QwRAB/GDziFxSU8B+jkqDuW
	 /oMghKzEahC+czG8bT/KiN19wy/+Qafjhwz8ZxV1XQRjmwtsoPMusX8rq0HF17PDtE
	 kfbtmrDA/aqpeenK20wV/VLV+/7gKw6ZCGLkuqLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1758/1815] net/sched: fq: add overflow bounds to quantum and initial quantum
Date: Sat, 12 Sep 2026 08:58:28 +0200
Message-ID: <20260912065730.261333427@linuxfoundation.org>
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
index 4b5f6d896c6d5..6144b5686f13f 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -1226,12 +1226,14 @@ static int fq_init(struct Qdisc *sch, struct nlattr *opt,
 		   struct netlink_ext_ack *extack)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
+	u32 mtu;
 	int i, err;
 
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



