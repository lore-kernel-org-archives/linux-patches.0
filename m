Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BFB2F25F3;
	Wed, 30 Sep 2026 15:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783033; cv=none; b=K3E8qdx/c9jNVRUc5auwJJuuFSuuGVVsqLQYRCGG+CGYadD4875SRon35fB2DUMvyDGy8ZC5icxnmuxyVxitABYTQCt/juttojPMZQ2+jMbD+T9X0bvcct0g5d+TEAi5s8/EXIcBndgFzndUb4JaQENfXQymqz7fsCBfRar0crE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783033; c=relaxed/simple;
	bh=5Q8cIVwW09DKmYOj4Y+0XZSj9G5oJ6CLDJR2PBooap0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MbA2OpqENTMXi0KIS+aUBbsbQCy/Ktl31l54/yVN1KT2oi1qeAMjO17/RA3hLORM/C7UmAGS4+OIb5rd6OZZc7f9rJD4jEhQY3aYy5DJ7f2dXECTMYNIYkv2Y2T/j0cKyJ8IAbwdHKVgi1rQIShMXp0Ljvk8qdoWLP+ZEP5EtIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ4C4Glt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ4C4Glt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A49A1F000FF;
	Wed, 30 Sep 2026 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783027;
	bh=u9wvWhRMdAT4gE7T/kUzkuWbr1P47+bN/ER/B4jEGcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJ4C4GltFs7Otd62lnYFGbt93VdPfuHM9fRE2+y91grJsUKeZ/AYFsOJkh2q5JGVa
	 dpM8GX1r5rcPeaB7GJO/9XaAJP/Qy/QleP9F2vLlO6G+WUZhmOT0ap5zAIocegKp7f
	 M42WCj1o8vhcK8KdR4WIBTcQz3pQPdQPjbJ/NNPo=
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
Subject: [PATCH 5.10 252/595] net/sched: hhf: clamp quantum in change and init paths
Date: Wed, 30 Sep 2026 17:22:25 +0200
Message-ID: <20260930152353.134648852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit eb56a495f59baf6cad5ed80e3ffb9078098b1346 ]

hhf_change() accepts any quantum from userspace, including 1. With a
crafted size table qdisc_pkt_len reaches ~2 GiB, so quantum=1 makes
the deficit-refill loop spin ~2^31 times under the qdisc lock
(a soft lockup / denial of service).

Add max(256U, ...) in hhf_change() matching fq_codel_change(). Clamp
hhf_init() to [256, 1<<20] matching the siblings, and remove the old
fallback that only set quantum=256 on overflow.

Conditions to recreate the bug:
  CONFIG_NET_SCH_HHF=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root hhf
  tc qdisc change dev dummy0 root hhf quantum 1 stab data 32768 size_log 15 cell_log 0

Fixes: 10239edf86f1 ("net-qdisc-hhf: Heavy-Hitter Filter (HHF) qdisc")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.5
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hhf.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index ba67eed62d318..baf8b586298c3 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -553,7 +553,7 @@ static int hhf_change(struct Qdisc *sch, struct nlattr *opt,
 		return err;
 
 	if (tb[TCA_HHF_QUANTUM])
-		new_quantum = nla_get_u32(tb[TCA_HHF_QUANTUM]);
+		new_quantum = max(256U, nla_get_u32(tb[TCA_HHF_QUANTUM]));
 
 	if (tb[TCA_HHF_NON_HH_WEIGHT])
 		new_hhf_non_hh_weight = nla_get_u32(tb[TCA_HHF_NON_HH_WEIGHT]);
@@ -609,7 +609,7 @@ static int hhf_init(struct Qdisc *sch, struct nlattr *opt,
 	int i;
 
 	sch->limit = 1000;
-	q->quantum = psched_mtu(qdisc_dev(sch));
+	q->quantum = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
 	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 	INIT_LIST_HEAD(&q->new_buckets);
 	INIT_LIST_HEAD(&q->old_buckets);
@@ -620,10 +620,6 @@ static int hhf_init(struct Qdisc *sch, struct nlattr *opt,
 	q->hhf_evict_timeout = HZ;      /* 1  sec */
 	q->hhf_non_hh_weight = 2;
 
-	if ((int)q->quantum <= 0 ||
-	    (u64)q->quantum * q->hhf_non_hh_weight > INT_MAX)
-		q->quantum = 256;
-
 	if (opt) {
 		int err = hhf_change(sch, opt, extack);
 
-- 
2.53.0



