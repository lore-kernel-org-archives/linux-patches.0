Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F14FD275;
	Thu, 17 Sep 2026 17:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666085; cv=none; b=bHtUB8TFGV+cXJqm7xSGQjMcXsN8dBMxhJa7jL6NMDC04bJkhyaIIMSGiF1Djzt5O55stCKd9083aJXOOVjtXZCYxZ+32WHAiQ5c4LVJZ0lm1H1wLhAfMOTHDrwDEkhVt53s+7NmKQ/R5nsR+oA5R1TOlnHzIvyN1U+L/OODW6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666085; c=relaxed/simple;
	bh=iKqyyy7SHuOeUsRaix/SqsWHqVTsU5fraOsGtx+7yjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bg2L2WpBQu3geS772HCZfXXUOm4fVFduKTB3Vk/dFjPBLkRhxz3NlYAFGKxsZpZGmYUIHA7KDfDGovcdpCtOkEk9n44K99cg/KYGCGVOm4CBko9VIkp36ySxcabTMSIYhmYYUTHxk9aHZF8GOI68tnSswl8bChylMOEa5cb6uxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIf2oxz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIf2oxz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86B11F000FF;
	Thu, 17 Sep 2026 17:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666084;
	bh=fdWgrq2WMWRF+a02osTsDNjf/qgknQyTDy98DERhof0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIf2oxz+DaiPLGC/148+SacRcDOmONOjFQzKAWVK69snUdSwHghnI2TnwgXjFnqso
	 s1HCe5eOAwSgXLexv3WpQFQs1J2CedAs9cYts8sIgZmD5u0jDSc0SJhmYiAu687exs
	 M7yOZocXs/Wl9wJu0KrJbTCrf7FEGdQFoDKyBRO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0919/1250] sched/eevdf: Fix augmented max_slice
Date: Thu, 17 Sep 2026 16:11:54 +0100
Message-ID: <20260917151616.912766291@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 9a8bc9bb4c3fb3218b4f151f98a722fbeb5b5c34 ]

Similarly to se->min_slice, init se->max_slice with se->slice before
enqueueing the entity so the augmented callback computes it correctly
at parent level.

Fixes: 6e3c0a4e1ad1 ("sched/fair: Fix lag clamp")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://patch.msgid.link/20260907123855.1297976-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2aeb12a6ce2d0..92ef592d97b69 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -921,6 +921,8 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	sum_w_vruntime_add(cfs_rq, se);
 	se->min_vruntime = se->vruntime;
 	se->min_slice = se->slice;
+	se->max_slice = se->slice;
+
 	rb_add_augmented_cached(&se->run_node, &cfs_rq->tasks_timeline,
 				__entity_less, &min_vruntime_cb);
 }
-- 
2.53.0



