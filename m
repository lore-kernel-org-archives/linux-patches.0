Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72113FB1B;
	Mon, 23 Jun 2025 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715775; cv=none; b=dYfBlxbfxnHD2vH4ycuU///SMrTYIvml604mz23S6XVivuKzbLKNHs8XzP0pmTHe7H2h0PEDJyXZvxhwFIt9w8Qmv8ztOwBDwKzKZoWjJC2C1uBdRk58dYbizvM75daRyrzqEye9Jw9N0cM60qo+yNuJYQoz3cIpfbrmEGJ+4NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715775; c=relaxed/simple;
	bh=4wc7EZVjJmPvuKDnOfA1NrjJkzIODexqt5bTWRaaiss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWA77OfaH8oaUHR6R8fxDTjUJqwP9zm5Iw7amKx7joT+NtFLahPk0vN5RV+TfBkoxATfCVQ9rjXSj2JEECWSH61EAuoAtS8JJM5ad7aUVOEiaqeC3YzZ8oYxFVMGBsXBqf4+pvMFUVJjHe0FuJiC+fSDPtnfLMhGLGaWadU1/mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9BimHHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9BimHHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC9AC4CEEA;
	Mon, 23 Jun 2025 21:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715775;
	bh=4wc7EZVjJmPvuKDnOfA1NrjJkzIODexqt5bTWRaaiss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9BimHHCaPMUMzafFt1kWLaa/0NQapW0mm9Ny9Dl8GVnSj00+LVWENuIKRYJhZf5W
	 F9EhCJ6ZOOIhkRihxhPGlIwSdYrm1FdkNzpTBLmhWjJ7OLnW9NwoWEawrAb6cKF198
	 rbL9tb6O1PKzcSRzf+7WGCeB0YEl/S1dC+S8lLTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/508] net_sched: ets: fix a race in ets_qdisc_change()
Date: Mon, 23 Jun 2025 15:05:06 +0200
Message-ID: <20250623130651.669094285@linuxfoundation.org>
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
index 9da86db4d2c2f..3ee46f6e005da 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -661,7 +661,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
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



