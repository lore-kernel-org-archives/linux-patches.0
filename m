Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1780C2DFF0A;
	Tue, 17 Jun 2025 16:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178246; cv=none; b=PUIBxV6vv9mkuMTBi9+T+A7KoHrVlHYSnFoPtu5itfs5VXzNU4XMjOjYFG2ehqxkA5Js3obF0f7mTz+9acXfBpxVcdW3GCWjzYOlQVpAkSboIzm3lUMl8HbyQs8s30y/6j/7QdvRNWh71rDGZLee/EDkHPyZVqJEnpcvEPcKx94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178246; c=relaxed/simple;
	bh=6TO/yT9GfzcaQ4hkPRTDfx3IAh6ORqytCeZqLHq6t24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYOo9DBf0dUrQmxPkfCYb8bQ/J/bikGJ0N7UX8JRrTPFpRzHHmaiIW/uSyZj2CR6J/qWsrJQxaOO+BYlXJQSS9EnEWnftcP7dsTVXN2LJBt6Z4gPzgVY3O87CB9RLSGygTf354q2qu206UrGvjqv5td5l+SA1Gxfd/77i2Glp2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvwZPUFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvwZPUFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7E0C4CEF0;
	Tue, 17 Jun 2025 16:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178246;
	bh=6TO/yT9GfzcaQ4hkPRTDfx3IAh6ORqytCeZqLHq6t24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvwZPUFjSeJoCvoqBNZ38LiUstY9LQ4efT4ZbpkKdpxbxrepEDMMiETrctY1G5IXm
	 hNXdNpSEJ6pWNPzXz5a8Em9yIqdSnoD68YNeQkGIeVzPm0QXVayBqY2taCPjoBpcDf
	 P1rI/n67CJ2kLjNTmlkiXSdkesb1nNXv6hPqFCWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 468/512] net_sched: ets: fix a race in ets_qdisc_change()
Date: Tue, 17 Jun 2025 17:27:14 +0200
Message-ID: <20250617152438.541204910@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2c069f0181c62..037f764822b96 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -661,7 +661,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 	for (i = q->nbands; i < oldbands; i++) {
 		if (i >= q->nstrict && q->classes[i].qdisc->q.qlen)
 			list_del_init(&q->classes[i].alist);
-		qdisc_tree_flush_backlog(q->classes[i].qdisc);
+		qdisc_purge_queue(q->classes[i].qdisc);
 	}
 	WRITE_ONCE(q->nstrict, nstrict);
 	memcpy(q->prio2band, priomap, sizeof(priomap));
-- 
2.39.5



