Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA943AEB2C;
	Wed, 30 Sep 2026 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788647; cv=none; b=bMI7ndQrpizqUar/yGuK+WieqJSpaVSZ+s0m+uaemvZg44jKim0rENFGK6UX0mRQfuQJnXaFrXpofv44gj5tU/eEQ3eRg6eI/lVXvPuCivMGZOjOaX2wzgDyElPXATViM9gzh36wqx/X0X9K68mszvlm4JG6Jgb7mBPZrllRhAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788647; c=relaxed/simple;
	bh=/zClz/z7ozmOLbZXDP3QgjE7hr5eqB173ldiukRBYJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9fc/pHgElMyJcF+D7qyBI6yZ9XiPmGGX82ZBAkHySYoZAG9h19jY3BwN+hv1DWUxfWe5MqD790bz4kwN+eqIJw7HLur/VjEun9q4paZxocbuqgNz9j3A6Qp8KpcmDFkCkHQZPG36545yI/YZWy31Q9eYpv5JZcQMqyn/cW8/8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOFrwG8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOFrwG8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1741F00898;
	Wed, 30 Sep 2026 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788645;
	bh=E0j13IObsfakL8IJ+W1tjV444IHyZvGjNAZvgqwkSa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOFrwG8tuDyGM8LWHoXLC6hi8KplGe1fOPsIMs57aJVncKCHZMslzfhgWwSXghk2G
	 /enHz21kZbHCcTgSX9RP117yLNcbsb10NpWwNxJdauTNTo5Z1voT23ooOREWt/SUxc
	 3ZURBigPjowZAM8svq4UPqgzb5NZVQbNPful6IKQ=
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
Subject: [PATCH 6.12 197/877] net/sched: hhf: cap hh_flows_limit at change time
Date: Wed, 30 Sep 2026 17:18:28 +0200
Message-ID: <20260930152418.976264508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -621,6 +621,9 @@ static int hhf_init(struct Qdisc *sch, s
 	q->hhf_evict_timeout = HZ;      /* 1  sec */
 	q->hhf_non_hh_weight = 2;
 
+	/* Cap max active HHs at twice len of hh_flows table. */
+	q->hh_flows_limit = 2 * HH_FLOWS_CNT;
+
 	if (opt) {
 		int err = hhf_change(sch, opt, extack);
 
@@ -637,8 +640,6 @@ static int hhf_init(struct Qdisc *sch, s
 		for (i = 0; i < HH_FLOWS_CNT; i++)
 			INIT_LIST_HEAD(&q->hh_flows[i]);
 
-		/* Cap max active HHs at twice len of hh_flows table. */
-		q->hh_flows_limit = 2 * HH_FLOWS_CNT;
 		q->hh_flows_overlimit = 0;
 		q->hh_flows_total_cnt = 0;
 		q->hh_flows_current_cnt = 0;


