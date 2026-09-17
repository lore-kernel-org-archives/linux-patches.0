Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F4C52268E;
	Thu, 17 Sep 2026 17:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665909; cv=none; b=V2zkweqQKAvTFgFa/kaCp38HFfhvjfv1yUQeW0wHjDmqTNL6cSfwM4uUv0nOPfwVfycThaP4IvkQDBcAYenKQU00h4CEPkOYKNRIvUsvkghncNxi1Q/oFKieEo7ktAPVZyWKBLzbBTSL2IVX8l+aiIFJbSJxSSIqpi++IxZJ4sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665909; c=relaxed/simple;
	bh=rPVPV7MSIqbxl+BLHDKOum+1aUILikCwn9IqzcDjWGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MulAhG6N4a5EPJUfGsp/4HUGEW2pcNuvwmU+uWGOeACgSNm+9zcI+zuU7C3imjMr7cF+FDJLQQmjP/NrGU0YS2/zlXRUz5oZnZRnkOH5/kvuKKvz5TTm2Zpqc6Ig8YREek+BmxEZxKk121QJ9r7W8Rn3eeKfERLl8T/qcinSeM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+gGSGH2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+gGSGH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9160F1F000FF;
	Thu, 17 Sep 2026 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665908;
	bh=pLju/RKhdkhOlfzecaiGLouI+NnaG8qCM7n5Hp/rb74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+gGSGH2OsYggJu2NInkHXM4MVziE7Heg4nY2ldXoDHn/RB0/i12KgyxeEWIbOYhi
	 D9hErSawW8SqsKJW4dA1q/dhfIJgcdn8hsSO7u3+JmvAWEVwFiLghUW2AE12d5mWsQ
	 c2si2l3uCFasiYS/NxR/BC9n/YwyLhaUjmBLGA5k=
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
Subject: [PATCH 6.18 0822/1250] net/sched: dualpi2: clamp psched_mtu at all call sites
Date: Thu, 17 Sep 2026 16:10:17 +0100
Message-ID: <20260917151614.213284733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 3c01f1ca5dfc6d6911b0e5b37f5062b1dc451b94 ]

dualpi2_calculate_c_protection(), must_drop(), and get_memory_limit()
call psched_mtu() with no clamp. A huge MTU makes (s32)psched_mtu()
overflow in the signed multiply for c_protection_init, and 2 *
psched_mtu() wraps in get_memory_limit(). With a crafted size table
qdisc_pkt_len reaches ~2 GiB, causing a soft lockup / denial of service.

Clamp psched_mtu() to [1, 1<<20] at all three call sites.

Conditions to recreate the bug:
  CONFIG_NET_SCH_DUALPI2=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root dualpi2
  tc qdisc change dev dummy0 root dualpi2 stab data 32768 size_log 15 cell_log 0

Fixes: 320d031ad6e4 ("sched: Struct definition and parsing of dualpi2 qdisc")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.6
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_dualpi2.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_dualpi2.c b/net/sched/sch_dualpi2.c
index f20a798e8f36a..4ee841f7a94d4 100644
--- a/net/sched/sch_dualpi2.c
+++ b/net/sched/sch_dualpi2.c
@@ -208,9 +208,11 @@ static void dualpi2_reset_c_protection(struct dualpi2_sched_data *q)
 static void dualpi2_calculate_c_protection(struct Qdisc *sch,
 					   struct dualpi2_sched_data *q, u32 wc)
 {
+	u32 mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 1, 1 << 20);
+
 	q->c_protection_wc = wc;
 	q->c_protection_wl = MAX_WC - wc;
-	q->c_protection_init = (s32)psched_mtu(qdisc_dev(sch)) *
+	q->c_protection_init = (s32)mtu *
 		((int)q->c_protection_wc - (int)q->c_protection_wl);
 	dualpi2_reset_c_protection(q);
 }
@@ -285,8 +287,9 @@ static bool must_drop(struct Qdisc *sch, struct dualpi2_sched_data *q,
 	u64 local_l_prob;
 	bool overload;
 	u32 prob;
+	u32 mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 1, 1 << 20);
 
-	if (sch->qstats.backlog < 2 * psched_mtu(qdisc_dev(sch)))
+	if (sch->qstats.backlog < 2 * mtu)
 		return false;
 
 	prob = READ_ONCE(q->pi2_prob);
@@ -715,7 +718,8 @@ static u32 get_memory_limit(struct Qdisc *sch, u32 limit)
 	/* Apply rule of thumb, i.e., doubling the packet length,
 	 * to further include per packet overhead in memory_limit.
 	 */
-	u64 memlim = mul_u32_u32(limit, 2 * psched_mtu(qdisc_dev(sch)));
+	u64 memlim = mul_u32_u32(limit, 2 * clamp_t(u32, psched_mtu(qdisc_dev(sch)),
+						     1, 1 << 20));
 
 	if (upper_32_bits(memlim))
 		return U32_MAX;
-- 
2.53.0



