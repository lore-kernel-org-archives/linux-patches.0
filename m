Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3873DAC02;
	Wed, 30 Sep 2026 19:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795289; cv=none; b=XY86qliy69bcnDUFHKi9st9oCaUg4I5OMPR3SkOdSJ9cEoolI1cAK38ctSR8N9rqABWlueZnumzVOkcFe7YdxvtYeFi+7IGUbRCvIupxdGOIpEMkK9jja9PYtxBd6u53yUecJxg9KciGtWOeba1LJ1AmVJ3ID0NykgV3vd8WAl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795289; c=relaxed/simple;
	bh=bc5SEHMFgssKT07jGN6uptYqKOjwTsvbUGzW2TJ8rMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYIvsg0g4heMkoTXOI4nPvpHL/y/8cPDLOVvmJBv8Z6pO9zZeo1tdiUPTBWz9GL5jD28pR5brpA0oP9ClYFB2awbLn/2LlOSrLZQmhCNLM0YBtsiKQvOCLBnWTC3INTn48i1627VdPpo7LdfPwhkWIuq08j9gIDkeN49gQnnf+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzYBZ3Fv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzYBZ3Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EEE1F000FF;
	Wed, 30 Sep 2026 19:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795287;
	bh=A2ziyuz0rsPsfcMc2V8VSybVw7RMlmV/OLHkvp8XA48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OzYBZ3FvhjaK7SIcyTUrHOdmhs8R/ttHbb12OhrOv3P9Z7rBS4pJrfqHjqvdqo/ri
	 Ehl4fyMEre7FpORN7SD06JuNzEadc5PT0wHF2S7ok1nvKs/SwWBjqEFRLCy032xjkn
	 zlz/V8OcPXo+vWruA9L1FfPqI1C32/l/eBZlNBRo=
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
Subject: [PATCH 6.6 0507/1193] net/sched: fq_pie: clamp quantum in change path
Date: Wed, 30 Sep 2026 17:19:51 +0200
Message-ID: <20260930152445.429380989@linuxfoundation.org>
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

[ Upstream commit 4864f58c53eb47257d55e01f47d4a9f355f7f970 ]

fq_pie_change() accepts any quantum value from userspace, including 1.
With a crafted size table qdisc_pkt_len reaches ~2 GiB, so quantum=1
makes the deficit-refill loop spin ~2^31 times under the qdisc lock
(a soft lockup / denial of service).

Add max(256U, ...) matching fq_codel_change().

Conditions to recreate the bug:
  CONFIG_NET_SCH_FQ_PIE=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root fq_pie
  tc qdisc change dev dummy0 root fq_pie quantum 1 stab data 32768 size_log 15 cell_log 0

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.3
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_pie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index f8fb1d1af6abb..75d6e7716ae8e 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -339,7 +339,8 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
 			   nla_get_u32(tb[TCA_FQ_PIE_BETA]));
 
 	if (tb[TCA_FQ_PIE_QUANTUM])
-		WRITE_ONCE(q->quantum, nla_get_u32(tb[TCA_FQ_PIE_QUANTUM]));
+		WRITE_ONCE(q->quantum,
+			   max(256U, nla_get_u32(tb[TCA_FQ_PIE_QUANTUM])));
 
 	if (tb[TCA_FQ_PIE_MEMORY_LIMIT])
 		WRITE_ONCE(q->memory_limit,
-- 
2.53.0



