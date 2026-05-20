Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F251335F619;
	Wed, 20 May 2026 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297079; cv=none; b=gBkaMfcIB+nNsXbFFVEHdivPA8pcbBkEbym4vmzkCZk+ttlnM7rT9O02jP16EsfCS/l2HXDbJ2TtxV3FemTbqCKvGN7gHg0v3H/FS3IYMUhVKQT0c9CcElgDLTPGa0u46rs1FxirsExabm4+OzWuvNDZz8aHHY5a3EsVIjFs1Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297079; c=relaxed/simple;
	bh=ML1HoFFDutZvZr1pZbwZrio2WGzyLPH8f2uNGUWvXSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5WnuVHiWLc8Iub7UcdWugS6/Y/qr3v+4mVVQeqMbBD5BmmjD4tBdin5q4ZTKy24L5apMuLtO9ge9d6GPrugWxOxdqPmx4E8/hUTGQ73H1tLAYXOgydV5ns7rsEAhX5VG65K3/jd67Ud6daZRZO/ud2LVD4BwChXX/AN9uy/vWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGHvHsi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGHvHsi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637691F000E9;
	Wed, 20 May 2026 17:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297077;
	bh=OqRaGXFs162IdTy+E+Q5X46YZu0j2s/BzJHpCPqz32I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGHvHsi27AJK6JFZBC9IuiG2AYHY2YUY4o31rqIt/nNSwqegIrQ/dDieQod9hexfs
	 aUnH6rh+/CdnO0nyp/DIz6UCwCOHISVw9otyUvGAgleAq7RXBp8fGBz1IVyjpD0SnW
	 fDMYFC9g7tmAPvDQnJWAXRxmvaAx2/VarDNOKUTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1040/1146] sched/fair: Fix wakeup_preempt_fair() for not waking up task
Date: Wed, 20 May 2026 18:21:30 +0200
Message-ID: <20260520162211.767879912@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 9f6d929ee2c6f0266edb564bcd2bd47fd6e884a8 ]

Make sure to only call pick_next_entity() on an non-empty cfs_rq.

The assumption that p is always enqueued and not delayed, is only true for
wakeup. If p was moved while delayed, pick_next_entity() will dequeue it and
the cfs might become empty. Test if there are still queued tasks before trying
again to determine if p could be the next one to be picked.

There are at least 2 cases:

When cfs becomes idle, it tries to pull tasks but if those pulled tasks are
delayed, they will be dequeued when attached to cfs. attach_tasks() ->
attach_task() -> wakeup_preempt(rq, p, 0);

A misfit task running on cfs A triggers a load balance to be pulled on a better
cpu, the load balance on cfs B starts an active load balance to pulled the
running misfit task. If there is a delayed dequeue task on cfs A, it can be
pulled instead of the previously running misfit task. attach_one_task() ->
attach_task() -> wakeup_preempt(rq, p, 0);

Fixes: ac8e69e69363 ("sched/fair: Fix wakeup_preempt_fair() vs delayed dequeue")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260503104503.1732682-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 87200a22b3169..3bce48ad0bc5a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8922,9 +8922,10 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
 
 	/*
 	 * Because p is enqueued, nse being null can only mean that we
-	 * dequeued a delayed task.
+	 * dequeued a delayed task. If there are still entities queued in
+	 * cfs, check if the next one will be p.
 	 */
-	if (!nse)
+	if (!nse && cfs_rq->nr_queued)
 		goto pick;
 
 	if (sched_feat(RUN_TO_PARITY))
-- 
2.53.0



