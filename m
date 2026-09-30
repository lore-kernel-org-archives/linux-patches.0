Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F943DDDA1;
	Wed, 30 Sep 2026 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795294; cv=none; b=HgnPDFW/LVArXGUtKjljo2kDg4Ls9ZP15KPdtfvMQhQEXar9KIv1SxIodHf8AnmwrQktexrSe1HrHPwW1xhzJDytAxNwYWkQGz0iwjVEIm9TIcIwnwuvzhgZZqYHucZrTEL8oXCvxpAZdvEjbnd7b2TYdx+qdMYjxrH0rWIfxl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795294; c=relaxed/simple;
	bh=yBqgVH34Mp2HwKaJ7w/Is9u15n0hduEOgfjYAe7nf+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBdUuST1NG2ox3ddI7AA6MiWau3woH5iEuNgMuOWSCEM46f4bWLLDbjLov3I8QdHQ/vpNrNVFW2wNLwP44ii6+fNOz/0hdMH7ZJ8UPwQ5x5Q9rQlPjYS3+I9+s8HdxcG6v4l8RQtp08+pYTu4yv8Sqb/RcmJJECsk0Ghvce2Tas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlrlpIOT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlrlpIOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35D81F000FF;
	Wed, 30 Sep 2026 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795293;
	bh=za/Hc0Wk5pqDdV5/GWwX1hb+8z1CZIloA5MRO8a2Dow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlrlpIOTcEP83vhlXZGsYMCBm1m0wi+LI6ji1pyIUjnazer5m1VLULhruZaOZjKiR
	 fduSwBJujtJdssqWCPwZXYOIo1TMQ025nJ+ef2dTO+athjizGr2b8/lS+u6b7DUVWJ
	 9XoFQhK3XP1vYHTIpdAYqDzOmh2SRUEMnUXf0zTk=
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
Subject: [PATCH 6.6 0509/1193] net/sched: hhf: clamp quantum in change and init paths
Date: Wed, 30 Sep 2026 17:19:53 +0200
Message-ID: <20260930152445.474618670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f9eab403ac161..fa7480474976f 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -550,7 +550,7 @@ static int hhf_change(struct Qdisc *sch, struct nlattr *opt,
 		return err;
 
 	if (tb[TCA_HHF_QUANTUM])
-		new_quantum = nla_get_u32(tb[TCA_HHF_QUANTUM]);
+		new_quantum = max(256U, nla_get_u32(tb[TCA_HHF_QUANTUM]));
 
 	if (tb[TCA_HHF_NON_HH_WEIGHT])
 		new_hhf_non_hh_weight = nla_get_u32(tb[TCA_HHF_NON_HH_WEIGHT]);
@@ -606,7 +606,7 @@ static int hhf_init(struct Qdisc *sch, struct nlattr *opt,
 	int i;
 
 	sch->limit = 1000;
-	q->quantum = psched_mtu(qdisc_dev(sch));
+	q->quantum = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
 	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 	INIT_LIST_HEAD(&q->new_buckets);
 	INIT_LIST_HEAD(&q->old_buckets);
@@ -617,10 +617,6 @@ static int hhf_init(struct Qdisc *sch, struct nlattr *opt,
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



