Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6259B2FA638;
	Tue, 17 Jun 2025 16:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179342; cv=none; b=HXOxHQzJWLoo6Itvwdd1Lt06SvchSLkfMetJSiAeYJn+D3IG2SBVpw9JgXrFW4SDseqI02+Ci5EY4q46SNlW+mYtGuV+93450Im9/42yYSyZu5R9R9X0EOzeE5lDkWIG7Ub9PLQPwNq36MjoYiG/N2MCOKVna8jPJzli3r/fBMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179342; c=relaxed/simple;
	bh=t6e3Kcty6BYaURvBjjIbt+ccZLSKoNz4CW7kM0a7/j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2MY4JwK9Bvs3wLC/wu2XB51BdQcFuU7SJcW4UD6IZMlIMfTgt3QxTBiqh2RVa5MGJ+3e7SHGktIOVLCNIMsw+r+i1vd8aYREDnXCHUqXv+3iZMiZ/g7oX/pKANwNHybKgfHbYQsMVChvv11QguEPXhhanrfLIteXCDthTb9wCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJyGWHq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJyGWHq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DB6C4CEE3;
	Tue, 17 Jun 2025 16:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179342;
	bh=t6e3Kcty6BYaURvBjjIbt+ccZLSKoNz4CW7kM0a7/j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJyGWHq+cNQzVsOcTA+9kGQ+nbzR/2rRr8+yOQTtld/taQstntGm0JpWIs0LmSWBg
	 86URxHduh0VBTqF2HzfCdmgrrJbwcXQVi8dstNgN+iT+rz50fv4xWN8bZuNBHrC66A
	 6f498o48o+T6VpOejHnEQn6BmCBsQWdcMNzYe5/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 717/780] net_sched: prio: fix a race in prio_tune()
Date: Tue, 17 Jun 2025 17:27:05 +0200
Message-ID: <20250617152520.690641603@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc30f7a32f1a7..9e2b9a490db23 100644
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



