Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74414C62;
	Mon, 23 Jun 2025 21:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713331; cv=none; b=EhwgfXRgQDecKJp2riFEMneJX4qq5I8I4bF+pswuHHbEKgYibUWUvdNd2GD9gz90Hvq77fJbhDljPTw6hLB0YNU7e+dxTEfdMc583pSDqw1XfLAlBLocmGrAzHWZFbD64mHTDvpeJpxgF8EdnNSR0cvsc7IDFmiWDPobnPods/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713331; c=relaxed/simple;
	bh=6ZJli0UYyRl7pLKehZP7jLnpS/mF4xh28DDfnAGW57Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQsd83Zb9htG+VOabnVmliiklCT+U9dZFbQ62eTpciD+ksKcX/lxarC62vRjlFLPx2Hpmvl4OAGhECqWYTVP4jBz1J6/bJkr6JByeQmnWOVG+rOFesztibANAuqziBeh9ojy4YS9k3X/W4XpU5E74j1YSqJZfn5j4+zSgUKpIjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZenexkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZenexkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCA4C4CEEA;
	Mon, 23 Jun 2025 21:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713331;
	bh=6ZJli0UYyRl7pLKehZP7jLnpS/mF4xh28DDfnAGW57Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZenexkLw8cV4AaYVDoQXHfZIJjDqXdo3F6lJfwJWM9U/HkRdZMnw9M/Ep+jeLEWA
	 U4vUk7n6FMJkZScpSpGBZq+d9nFPajx5Jqmv8YYJtU/0qOzo2da2apdfwSrv4EYAYn
	 DzN2AK/3Y0dzPWEp+a/iP4P3FvvJFEkVdoKZWK6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/355] net_sched: ets: fix a race in ets_qdisc_change()
Date: Mon, 23 Jun 2025 15:05:39 +0200
Message-ID: <20250623130630.871543113@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d92adacdd8c2960be856e0b82acc5b7c5395fddb ]

Gerrard Tai reported a race condition in ETS, whenever SFQ perturb timer
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

Fixes: b05972f01e7d ("net: sched: tbf: don't call qdisc_put() while holding tree lock")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Suggested-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250611111515.1983366-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ets.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 55b3362d27106..4f4da11a2c779 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -675,7 +675,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 	for (i = q->nbands; i < oldbands; i++) {
 		if (i >= q->nstrict && q->classes[i].qdisc->q.qlen)
 			list_del_init(&q->classes[i].alist);
-		qdisc_tree_flush_backlog(q->classes[i].qdisc);
+		qdisc_purge_queue(q->classes[i].qdisc);
 	}
 	q->nstrict = nstrict;
 	memcpy(q->prio2band, priomap, sizeof(priomap));
-- 
2.39.5



