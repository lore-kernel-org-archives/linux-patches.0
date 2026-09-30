Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA336826E;
	Wed, 30 Sep 2026 19:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796297; cv=none; b=KWpjid/WKeKvVeQltog+NM3MD66i0X7fvUWMPHQkMeFZHRjDGtFzCPUH2Kn1Yzg0dS8rRYd+fgCeQQi4zU8Zg22/OwTAS4mfNH6q+3s8qOmIZsuiQ3vUN33jo06qnJNOIgOUBtLriL5FFzoiinh6UIXR7D17A6uzYXv7DuJ39OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796297; c=relaxed/simple;
	bh=cM2Nx6ZwQ4eqtxXnBBZokiwjPLQtYragtfSDqFFxPpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qg0IK/RoIfXR+AFL/uMonHnfASDCZmHmqTleIYqoghvRoemCJtVCGdxIXuNc114mUH0e4P0exBqoraj9q+6otsVgVYinaEkl2GG+EOtXpTcuzDzSGWlfygHNJqY9bkszJ9SZ+TjRpySgPmXTOtWkxD++DVuqTskcxdAosezljac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JUyJw7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JUyJw7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2981F1F000FF;
	Wed, 30 Sep 2026 19:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796295;
	bh=17BK64YTp5lil1a/2B073tyFsRDbFaq3gTuv82ssi48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JUyJw7uTZIkN5giorHm3kwbeH8pfqop0T0pI+jXTsfOh+9BuYO8vz+4uJ8cF6OFa
	 v8wqRlpitC1rX3espvPDCBHMs5CIzHk2XohpPhjzKXEhlUkBGtapYP0jCQgPBkeBrn
	 PUp+TQ0y1sHZak7F2e80kLlXLHAVT3KnOiSgHRTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	hybris <hybris@mojatatu.ai>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 0864/1193] net/sched: hhf: cap hh_flows_limit at change time
Date: Wed, 30 Sep 2026 17:25:48 +0200
Message-ID: <20260930152453.429020788@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit 2cef2588c995722a901368def30befeef9ae55c6 upstream.

hhf_change() stores TCA_HHF_HH_FLOWS_LIMIT with no upper bound. A huge
hh_flows_limit lets each new heavy-hitter flow pass the
hh_flows_current_cnt check in alloc_new_hh() and forces a fixed-size
kzalloc(GFP_ATOMIC) per flow under spoofed traffic, for unbounded memory
growth.

Bound the attribute with NLA_POLICY_MAX() at 2*HH_FLOWS_CNT (the
hhf_init() default) and report the rejected value via extack. The
deprecated nested parse is kept: legacy tc does not set NLA_F_NESTED on
TCA_OPTIONS. Configs relying on hh_limit above the default were relying
on unbounded, unsafe behaviour and are not supported going forward.

hhf_init() also ran hhf_change() before setting the default
hh_flows_limit, so a user-supplied hh_limit at add time was clobbered
back to 2048. Set the default before hhf_change() so the configured
value sticks.

This is a follow-up to commit eb56a495f59b ("net/sched: hhf: clamp
quantum in change and init paths"), which bounded the quantum of the
same qdisc; the hh_flows_limit bound is the remaining unbounded knob of
that series' scope.

Conditions to recreate the bug: CAP_NET_ADMIN in a user namespace;
tc qdisc change dev X root hhf hh_limit 4294967295 succeeds and the
value is echoed by tc qdisc show, unbounding heavy-hitter flow
allocations; also tc qdisc add dev X root hhf hh_limit 500 stores 2048
instead of 500.

Fixes: 10239edf86f1 ("net-qdisc-hhf: Heavy-Hitter Filter (HHF) qdisc")
Cc: stable@vger.kernel.org
Reported-by: Sashiko (gemini) <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260822195509.112717-1-jhs@mojatatu.com
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Tested-by: hybris <hybris@mojatatu.ai>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-B855.v1.20260911153152@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_hhf.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -526,7 +526,7 @@ static void hhf_destroy(struct Qdisc *sc
 static const struct nla_policy hhf_policy[TCA_HHF_MAX + 1] = {
 	[TCA_HHF_BACKLOG_LIMIT]	 = { .type = NLA_U32 },
 	[TCA_HHF_QUANTUM]	 = { .type = NLA_U32 },
-	[TCA_HHF_HH_FLOWS_LIMIT] = { .type = NLA_U32 },
+	[TCA_HHF_HH_FLOWS_LIMIT] = NLA_POLICY_MAX(NLA_U32, 2 * HH_FLOWS_CNT),
 	[TCA_HHF_RESET_TIMEOUT]	 = { .type = NLA_U32 },
 	[TCA_HHF_ADMIT_BYTES]	 = { .type = NLA_U32 },
 	[TCA_HHF_EVICT_TIMEOUT]	 = { .type = NLA_U32 },
@@ -545,7 +545,7 @@ static int hhf_change(struct Qdisc *sch,
 	u32 new_hhf_non_hh_weight = q->hhf_non_hh_weight;
 
 	err = nla_parse_nested_deprecated(tb, TCA_HHF_MAX, opt, hhf_policy,
-					  NULL);
+					  extack);
 	if (err < 0)
 		return err;
 
@@ -617,6 +617,9 @@ static int hhf_init(struct Qdisc *sch, s
 	q->hhf_evict_timeout = HZ;      /* 1  sec */
 	q->hhf_non_hh_weight = 2;
 
+	/* Cap max active HHs at twice len of hh_flows table. */
+	q->hh_flows_limit = 2 * HH_FLOWS_CNT;
+
 	if (opt) {
 		int err = hhf_change(sch, opt, extack);
 
@@ -633,8 +636,6 @@ static int hhf_init(struct Qdisc *sch, s
 		for (i = 0; i < HH_FLOWS_CNT; i++)
 			INIT_LIST_HEAD(&q->hh_flows[i]);
 
-		/* Cap max active HHs at twice len of hh_flows table. */
-		q->hh_flows_limit = 2 * HH_FLOWS_CNT;
 		q->hh_flows_overlimit = 0;
 		q->hh_flows_total_cnt = 0;
 		q->hh_flows_current_cnt = 0;


