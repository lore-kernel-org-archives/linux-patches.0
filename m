Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78DA4ED183;
	Thu, 17 Sep 2026 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665799; cv=none; b=ApmkyGbxcGwKnA2iv+Hlj/NDy+td3p3SD8eyDNlMDs4HSvfO8regoOIOD5DYF/0YtWw/hfZT1WhxtozDIdZc8NuMHWERZHGoKsd2IXP7CEIj2fZ5qlRWjOQMFvZusv9lbJcvshRJVCHEzJ4vx0vVEYjn2MUUwrupfe5nsvXZKfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665799; c=relaxed/simple;
	bh=ZrjtqgqPrx+P+UQ8fFHp7zm+5AjO+cxDMDBjqowOXZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khSUKH8xYeromBYUm/9q37gPI94bUllSE3ks2t1Wje8jJTttko/SwVGr9MB9/ZaKtRzdX8UrR6EY941x/yrNsSQbadspTtTGQmV0N4Zxzyj0j51vRXVs/njTOHMzChptoqPY1fSe4M4L6VVNQ6D6jCfFNHFVHXm1x69M8a/MNcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDMArdQ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDMArdQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0FB1F000FF;
	Thu, 17 Sep 2026 17:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665798;
	bh=YTBayTECqohYf/brPAJ8yFGnN5vIyVdfKq54FaW0Qnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDMArdQ3d+E7DMVpqK1wfFqbLA2m/RjLsZW1dr7wcw4yFxFjwiZrUmXJsz4iyz0EV
	 xVQ28BSM/DBuTLBTVg/h7gbPidNpcfsrH7LPVb3hxJae7yFfkrL32kelG6soUj1blt
	 PcxU3OHtSLW2+0zgLc+VuzG5jIDehcHTJi7kU+8Q=
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
Subject: [PATCH 6.18 0825/1250] net/sched: ets: clamp quantum in parse and fallback paths
Date: Thu, 17 Sep 2026 16:10:20 +0100
Message-ID: <20260917151614.299729806@linuxfoundation.org>
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

[ Upstream commit 1c38487f46b243bfeefec0c0c86023a3904f2214 ]

ets_qdisc_change() falls back to psched_mtu() with no floor for bands
without an explicit quantum. With a crafted size table qdisc_pkt_len
reaches ~2 GiB, so a zero psched_mtu on a headerless device makes the
deficit-refill loop spin under the qdisc lock.

Move the floor into ets_quantum_parse() so explicitly configured quanta
are also clamped to [256, 1<<20], not just the fallback path.

Conditions to recreate the bug:
  CONFIG_NET_SCH_ETS=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root ets bands 3 strict 2 quanta 1 1

Fixes: dcc68b4d8084 ("net: sch_ets: Add a new Qdisc")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.9
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ets.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index a4b07b661b775..27e549646dee1 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -83,11 +83,7 @@ static int ets_quantum_parse(struct Qdisc *sch, const struct nlattr *attr,
 			     unsigned int *quantum,
 			     struct netlink_ext_ack *extack)
 {
-	*quantum = nla_get_u32(attr);
-	if (!*quantum) {
-		NL_SET_ERR_MSG(extack, "ETS quantum cannot be zero");
-		return -EINVAL;
-	}
+	*quantum = clamp_t(u32, nla_get_u32(attr), 256, 1 << 20);
 	return 0;
 }
 
@@ -634,11 +630,13 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 			return err;
 	}
 	/* If there are more bands than strict + quanta provided, the remaining
-	 * ones are ETS with quantum of MTU. Initialize the missing values here.
+	 * ones are ETS with quantum of max(MTU, 256). Initialize the missing
+	 * values here.
 	 */
 	for (i = nstrict; i < nbands; i++) {
 		if (!quanta[i])
-			quanta[i] = psched_mtu(qdisc_dev(sch));
+			quanta[i] = clamp_t(u32, (u32)psched_mtu(qdisc_dev(sch)),
+					    256, 1 << 20);
 	}
 
 	/* Before commit, make sure we can allocate all new qdiscs */
-- 
2.53.0



