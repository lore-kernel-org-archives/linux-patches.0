Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E12C4D37CB;
	Fri,  9 Oct 2026 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556194; cv=none; b=MJoC/vC6RgkS61zeW9qgQBkrX2Z/PDTdJq8ncjWyxAAmjZDnpTkKCeEnbqXfEBp8CeX9vSiajy8CqyqXBK7zjS2YUOkIzLwnsJ9sgCdezTb3z3Ph0SJdE+9I20bOxpk9O0A9Lv16uMmlOrMUTxR/hl7eaGsDOcjPQRinmv3WztU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556194; c=relaxed/simple;
	bh=pQMT5Wdi2IeCIOdjQutMyUN4wJX6nusrlbjLPuIhz4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI8cYyuV42X8hBVci7vlV4kcpYTHt5n14N+SQtIriVNxiRjc4rOYk49SgvqEp9V8UW30KYzSb0mZzOZWvIZssqhxud4vDL3XCxoWEjng0sY4PrNqtN6nDfhJUxhTYqJyYWiGHVfKrxgCMxoEYwXDxzakJJYT6/xnuaZMSKQd7ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zP0Fyuew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zP0Fyuew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E3B1F000FF;
	Fri,  9 Oct 2026 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556193;
	bh=iqMILKWL0m/+EKX/JsC08yOHN1qvsDcElpdW7idYg1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zP0FyuewBJXjFbPWwQIbCQRyAgwpXDjp1BdMVA9xl1k+bHsNNnOkyS30mcmgE8eMm
	 aYmi1WC0REmN3yYFNmbiq9zSzYtkkLTq+kuw3pnRtRMwVzcaUeKPFBDIaxa5QdIvzS
	 tIGijVQ6TDsGUt1X9MXsfKGCr2hD0ceT//eXhz9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 135/428] net/sched: sch_codel: match the no-drop threshold to the packet size
Date: Fri,  9 Oct 2026 16:07:52 +0200
Message-ID: <20261009140949.145992861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

[ Upstream commit 54518e0e827f4ca9229ae657022c60bf60f5c1bf ]

commit 6439461f1618 ("net/sched: sch_codel: clamp default mtu to avoid
disabling CoDel") clamped q->params.mtu to [256, 1 << 20]. The value is
the CoDel no-drop threshold (codel_impl.h "*backlog <= params->mtu"), so
on a link whose maximum transmitted packet size is below 256 the floor
extends CoDel's minimum-backlog exemption beyond one packet and delays
drop or mark eligibility by several small packets.

Keep the upper bound that guards the original overflow (psched_mtu()
wrapping to ~2 GiB on a huge-MTU device) but drop the 256 floor, so the
threshold tracks the real device packet size.

Conditions to recreate the bug: attach a codel qdisc on a link whose
MTU plus hard_header_len is below 256 (e.g. a CAN interface). At that
MTU the no-drop threshold must equal the device MTU plus its
hard-header length; before this patch it was forced to 256.
Requires CAP_NET_ADMIN in a user namespace.

Fixes: 6439461f1618 ("net/sched: sch_codel: clamp default mtu to avoid disabling CoDel")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260819143136.57350-1-jhs@mojatatu.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-34MS.v1.20260925165535@mojatatu.com.2
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_codel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 6aa5829d69612..a1ba2e355f2d1 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -205,7 +205,7 @@ static int codel_init(struct Qdisc *sch, struct nlattr *opt,
 	codel_params_init(&q->params);
 	codel_vars_init(&q->vars);
 	codel_stats_init(&q->stats);
-	q->params.mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
+	q->params.mtu = min_t(u32, psched_mtu(qdisc_dev(sch)), 1 << 20);
 
 	if (opt) {
 		int err = codel_change(sch, opt, extack);
-- 
2.53.0



