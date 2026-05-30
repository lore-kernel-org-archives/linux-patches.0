Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1E5137750;
	Sat, 30 May 2026 18:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166874; cv=none; b=ipeBfBH0etxyqcEdXj4eIDZK3kJd4OzJABfHqFtRAXKWHiLG/02JQs6avEXYK72wN0h6aILXatQvRqkyT04HVMKmISI5OlYrEuvzht1Gw2U2bH0kGVd9yn4IDR35Dqwfn7fqOj2qnA7Lr+4TTeeSuXswAjsQV3jq1QlQSLq30EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166874; c=relaxed/simple;
	bh=T853UM8fa0pecTD/3DtrJe5j+TTRjs9IPpLBryC2mHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQFr726Du5w+KXPdWjjJ6pqCfHEyg08LCE3zhHio0pmvyKPi0SJnt8jeCzblKocJBDMSaC+8e18D5oTHJ1orepqbO/X1u2STDiun/oGROYoAgF820nUVjcU0sGHIMsndAhaOgcFfJzlOsP9fVwhyftmG2zsDqA4sq6IDzP3+JSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwEccew6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwEccew6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8DB1F00893;
	Sat, 30 May 2026 18:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166873;
	bh=ykT75Mnyo2iz3KY1a6SUiqTAJOSsmVPm2y6nqrP2avA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwEccew688qmkAwosbKhMZmAqtO/mfouWYJsQyKBeoJjGTzWd2kpVrctNv2BSCOMA
	 iPkWN1/VxvopM8HXNwvxqLJq6tu+GlyzniBB/e8wsD7SZWNGOeBGRH9KWh4JFmb3rn
	 pf/mX4kHPQMolPDZe/aHsgnpTazS5U1vUnizPdMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yannick Vignon <yannick.vignon@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 497/589] net/sched: taprio: Fix init procedure
Date: Sat, 30 May 2026 18:06:18 +0200
Message-ID: <20260530160237.681665893@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yannick Vignon <yannick.vignon@nxp.com>

[ Upstream commit ebca25ead0711729e0aeeec45062e7ac4df3e158 ]

Commit 13511704f8d759 ("net: taprio offload: enforce qdisc to netdev queue mapping")
resulted in duplicate entries in the qdisc hash.
While this did not impact the overall operation of the qdisc and taprio
code paths, it did result in an infinite loop when dumping the qdisc
properties, at least on one target (NXP LS1028 ARDB).
Removing the duplicate call to qdisc_hash_add() solves the problem.

Fixes: 13511704f8d759 ("net: taprio offload: enforce qdisc to netdev queue mapping")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 85812bad227bc..50f430280337d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1723,8 +1723,6 @@ static void taprio_attach(struct Qdisc *sch)
 		if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
 			qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
 			old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
-			if (ntx < dev->real_num_tx_queues)
-				qdisc_hash_add(qdisc, false);
 		} else {
 			old = dev_graft_qdisc(qdisc->dev_queue, sch);
 			qdisc_refcount_inc(sch);
-- 
2.53.0



