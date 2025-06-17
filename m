Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F54B2EA147;
	Tue, 17 Jun 2025 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177055; cv=none; b=CqPVPSkhjOj+GZNZh/UOzNix+iqQstJWsiIoS3FvoxpPcLhJ3ixxPMtUUxEi9If5pgGdIqw0BKY4V1RHDc7REen+RkSdnygEsuoawUGnAZNyg6ojQq8ds6igkHcdiu5qmgYwg0OeD8UQOqoJsH7pmAEo63UUsh9DpsA2rJbSr2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177055; c=relaxed/simple;
	bh=DSJCaVJ65dURo79OC2EpU+Xl8dvqi8j+YZVlCnolhmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9cGOy6jSzRGyPNCEI5Ppp+5V9xE/8Dp6UBNvqsBiNNvMDmGk2x3hFrJ4rNbkeh2uup3y2+v3utHYZTiXhGTl/y+7L6aX2/hF1jNaBPNHNJ+39pJjT4Ts6okKmw4dLecR62CgIT7c0KtfMMP6VEUALu1Qj8bxvISmUTWH11pdL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmNQbb3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmNQbb3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C9AC4CEE3;
	Tue, 17 Jun 2025 16:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177054;
	bh=DSJCaVJ65dURo79OC2EpU+Xl8dvqi8j+YZVlCnolhmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmNQbb3Ke4mQONRytb8HptdJT9e/Ljycl2Mfo6ym1IAWf6soNKZC3EEvg2uMFffy+
	 hQAFUmDa/ljmXrDmp5p96OjPEtTJwBmr4RzDAlObtu+blWFtt58fgUcO5arTY7neZU
	 JAkKtBbfBRQSaJ3FtZFiCRS73Wamv/TO1sfJ8w8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 327/356] net_sched: prio: fix a race in prio_tune()
Date: Tue, 17 Jun 2025 17:27:22 +0200
Message-ID: <20250617152351.312150156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



