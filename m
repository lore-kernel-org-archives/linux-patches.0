Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6652E2286;
	Wed, 30 Sep 2026 16:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785210; cv=none; b=gvzN4mSnbcvR9x8qia7EeRjGgvdgqI2wrcp5lXH8HOh+402+3JdE3OGA5vehti8xa1DzkYeyWFwH/0FBrR98HHVGppMac9HumbfcLK17WrhBXSCOQ8W4X/IomQxMfsUlIaoTZntR2NIEvjNm1SNpm6Oq30joGbATv1lmJ6tvnG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785210; c=relaxed/simple;
	bh=+vjsAQy+F1GrskGp2BrbzCKtXaHxGTE/pZkm4GLFJjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ddYFxGZCt1kSTjHMALb1kqGFjOv/PpS+txgaDwNRR8H+HUX3OGpBETzU5V2S45XIGsmaUdrUz0WjV/+xQEALRNIIbPtION0RFshSbTV4o/pFI+0FFAlAcaGXGrX8+5tq87d1ej0ymFObh0mSd5/Lw/XQjVeACdYeLNldUKTamvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQuPW/sl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQuPW/sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6381F000FF;
	Wed, 30 Sep 2026 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785206;
	bh=7u3oBbMddiV8ElvxNAINxHFs0ytoge54wh918wOCi4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQuPW/slhyFrS9xDIeLh2iIE/SVUNP25g8XVvuS5FzUIxbYOUPI7zCjWYw/Tf+HeO
	 dy/tcByDmU6wYtto4N4C6MsYnz66L7/m+ufEPz9+pY39JykPgI7wUOUIuaElBZgXTv
	 L75gYtdw9GuqHGaCK6ZuBUkWG9byGDA0xAWQSKns=
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
Subject: [PATCH 6.1 426/982] net/sched: hhf: clamp quantum in change and init paths
Date: Wed, 30 Sep 2026 17:19:22 +0200
Message-ID: <20260930152425.950717508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



