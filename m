Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60224134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B756AC433EF;
	Mon, 12 Jun 2023 10:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566480;
	bh=o8IqCLYSgjNPUQy/BhnbP76Sq2baRD1EPN6RCgtZADI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmLctPCRJzWlfYS5AYNkXLWQEkVXd/fhciOElxpE7vkjZTsDC0rXQPXitnePCIh5X
	 wEL7v8ay6Ruw/c6iKCy24SZDwD8uwKXcTLPs6zDsXZZ6VFmpqMsPCa7EfXK8UKDEoB
	 0IIxYtS7EJwBj+xtE3N59iGzCPfVsH9FW3ZXiObc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/132] net: sched: act_police: fix sparse errors in tcf_police_dump()
Date: Mon, 12 Jun 2023 12:26:21 +0200
Message-ID: <20230612101712.406804728@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 682881ee45c81daa883dcd4fe613b0b0d988bb22 ]

Fixes following sparse errors:

net/sched/act_police.c:360:28: warning: dereference of noderef expression
net/sched/act_police.c:362:45: warning: dereference of noderef expression
net/sched/act_police.c:362:45: warning: dereference of noderef expression
net/sched/act_police.c:368:28: warning: dereference of noderef expression
net/sched/act_police.c:370:45: warning: dereference of noderef expression
net/sched/act_police.c:370:45: warning: dereference of noderef expression
net/sched/act_police.c:376:45: warning: dereference of noderef expression
net/sched/act_police.c:376:45: warning: dereference of noderef expression

Fixes: d1967e495a8d ("net_sched: act_police: add 2 new attributes to support police 64bit rate and peakrate")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_police.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 0adb26e366a7b..94be21378e7ca 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -355,23 +355,23 @@ static int tcf_police_dump(struct sk_buff *skb, struct tc_action *a,
 	opt.burst = PSCHED_NS2TICKS(p->tcfp_burst);
 	if (p->rate_present) {
 		psched_ratecfg_getrate(&opt.rate, &p->rate);
-		if ((police->params->rate.rate_bytes_ps >= (1ULL << 32)) &&
+		if ((p->rate.rate_bytes_ps >= (1ULL << 32)) &&
 		    nla_put_u64_64bit(skb, TCA_POLICE_RATE64,
-				      police->params->rate.rate_bytes_ps,
+				      p->rate.rate_bytes_ps,
 				      TCA_POLICE_PAD))
 			goto nla_put_failure;
 	}
 	if (p->peak_present) {
 		psched_ratecfg_getrate(&opt.peakrate, &p->peak);
-		if ((police->params->peak.rate_bytes_ps >= (1ULL << 32)) &&
+		if ((p->peak.rate_bytes_ps >= (1ULL << 32)) &&
 		    nla_put_u64_64bit(skb, TCA_POLICE_PEAKRATE64,
-				      police->params->peak.rate_bytes_ps,
+				      p->peak.rate_bytes_ps,
 				      TCA_POLICE_PAD))
 			goto nla_put_failure;
 	}
 	if (p->pps_present) {
 		if (nla_put_u64_64bit(skb, TCA_POLICE_PKTRATE64,
-				      police->params->ppsrate.rate_pkts_ps,
+				      p->ppsrate.rate_pkts_ps,
 				      TCA_POLICE_PAD))
 			goto nla_put_failure;
 		if (nla_put_u64_64bit(skb, TCA_POLICE_PKTBURST64,
-- 
2.39.2



