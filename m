Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7674224C060;
	Mon, 23 Jun 2025 13:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685303; cv=none; b=VmQJGvPA3v5Ug4keW4CwUy/UPSbi+kivZdJkdN0yWalccFrB24dDAMUCE/508yA+21RcmrDP1SNt7bgjA9x5bxuv0RmuZJuuEwotoIfzbW3zq4QOt4ypoQWWgULJa8TKWOPS7kL2lpuJFH5NhttLu93ZLnNeEQky4Gu1uojQOIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685303; c=relaxed/simple;
	bh=GO5+/SbhHIuZH2VuqkvwI/eTr4aCbswXFOJEnUsCO/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZK2h6oOLzN//fjz+1NZUkDji2ubLhqItdIoiy1Azr10bMooQJT3+Tt+kmpkXzn5ZDE9N3qAHtIko5PRn1Ba3ukHI7VX1h+laNFfeduXUMGFvO+TahW/phYMGC8vdTzcMl6GbBi15Jv5hA/Sd0XrXkvGIwhqq+FZ5VZMY5DejCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ar/osI0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ar/osI0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B98AC4CEEA;
	Mon, 23 Jun 2025 13:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685303;
	bh=GO5+/SbhHIuZH2VuqkvwI/eTr4aCbswXFOJEnUsCO/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ar/osI0T2GQbI1g4Ud373+11N87egFpEgfc9HGs/LVopkBVR3pIlKWdyezGWomPIj
	 S+z6aCEsWlTP6I9c1NM5qxt5bisO3e7m9MniHJzlUwlJGnWDPg75CjXmKos9Qkhev7
	 /kQDax5GtybAuGmdmtEdyM8JLnt7KDlj+SlAAX6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/222] net_sched: prio: fix a race in prio_tune()
Date: Mon, 23 Jun 2025 15:06:58 +0200
Message-ID: <20250623130614.596052732@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 647941702f9fc..62c1b1f352b26 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -213,7 +213,7 @@ static int prio_tune(struct Qdisc *sch, struct nlattr *opt,
 	memcpy(q->prio2band, qopt->priomap, TC_PRIO_MAX+1);
 
 	for (i = q->bands; i < oldbands; i++)
-		qdisc_tree_flush_backlog(q->queues[i]);
+		qdisc_purge_queue(q->queues[i]);
 
 	for (i = oldbands; i < q->bands; i++) {
 		q->queues[i] = queues[i];
-- 
2.39.5



