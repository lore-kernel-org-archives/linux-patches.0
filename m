Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B471E22E6;
	Mon, 23 Jun 2025 21:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715729; cv=none; b=sBhWF/aw7Liqb3LRqkGZO5+06Le3dF6OeTK1/XpbE/tOgYM7jfQ6E4ZQeh03/EkU8k7A7kVs09DtB4/gK1HU36hb/Sogjnv2k/1rGJMxH96fRXfVaQzPrBhWW2O/+i2ShsRb0FnSWMtQXMZTp4gYdPfcf+KiQJbhbYtM91/ebRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715729; c=relaxed/simple;
	bh=LtwW+5GRnQzfM9SBa/5kAARD5A3BbOWuPrrKOW/NLAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz5VJOgrprMlMo1R4sahW8mKvmooAE8BaNtHKvHDWxZbUuPJNuvZPLnfK7Dpp7nmgm535CijjkoIUa+parKPBfcXPX10BYTLpeeD+MDZ5foN2M5nTi3mPPiU6PdHIM/eSaHNKUqDI2cEh9kTeoGOByst7sHcq1Wo/FIAOr0IdOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMlSLdGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMlSLdGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA140C4CEED;
	Mon, 23 Jun 2025 21:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715729;
	bh=LtwW+5GRnQzfM9SBa/5kAARD5A3BbOWuPrrKOW/NLAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMlSLdGjSsfx9vcGTEqs5vesHzB5/XSJtFPgT5+ZqVUoVYqwFStSxEIanPSJtytXM
	 biPReQmypSRfP86SBaP3M37YKEIgZNFX0XCuopRsoHEa0Sv3c0C/IeyaoYOl2J6uUu
	 xIRuWu/UirJyc6+fdGuQD6IvvI8Y1SNiGUd4ycvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 258/508] net_sched: prio: fix a race in prio_tune()
Date: Mon, 23 Jun 2025 15:05:03 +0200
Message-ID: <20250623130651.598400832@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d35acc1be3480505b5931f17e4ea9b7617fea4d3 ]

Gerrard Tai reported a race condition in PRIO, whenever SFQ perturb timer
fires at the wrong time.

The race is as follows:

CPU 0                                 CPU 1
[1]: lock root
[2]: qdisc_tree_flush_backlog()
[3]: unlock root
 |
 |                                    [5]: lock root
 |                                    [6]: rehash
 |                                    [7]: qdisc_tree_reduce_backlog()
 |
[4]: qdisc_put()

This can be abused to underflow a parent's qlen.

Calling qdisc_purge_queue() instead of qdisc_tree_flush_backlog()
should fix the race, because all packets will be purged from the qdisc
before releasing the lock.

Fixes: 7b8e0b6e6599 ("net: sched: prio: delay destroying child qdiscs on change")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Suggested-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250611111515.1983366-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_prio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index fdc5ef52c3ee9..fdd9caa41e80f 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -211,7 +211,7 @@ static int prio_tune(struct Qdisc *sch, struct nlattr *opt,
 	memcpy(q->prio2band, qopt->priomap, TC_PRIO_MAX+1);
 
 	for (i = q->bands; i < oldbands; i++)
-		qdisc_tree_flush_backlog(q->queues[i]);
+		qdisc_purge_queue(q->queues[i]);
 
 	for (i = oldbands; i < q->bands; i++) {
 		q->queues[i] = queues[i];
-- 
2.39.5



