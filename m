Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CC4267F5F;
	Tue,  8 Apr 2025 11:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110292; cv=none; b=rH3HLPPKn8BAZHXOXuzteF8/XW/ATmue0DMpg04nMcShs4+lcntmqVbYPNEc/6cin9sEbEt0NamIcqvskmb6iykLkKD15BQdMwL2IeBd9gxDx1mnJU1J1X2Soi6UgJIvj4mwXshvU22p+i4kC+YBilKGYFLEoruBfsigsmq3SF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110292; c=relaxed/simple;
	bh=VUvcz841LylGbzByai3tEbFGSStiHYAZH1iHZM40yjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqfrNZ/GkqRP4Vj7FKiA8y65k1+wDYnRKhYQO+QXoMNVgjuyvNWhkBT15DB1ES0a2AQjD1f/vtpTDYo0dbBB6vq1STU/a346eSq+l/01vwmca1AHvLeipIA/VXIeqq2O+akmVG0l+XKQBCatC+yGd0TP3ddEWhltgjDmR+nFwZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3eSZ+xS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3eSZ+xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EE3C4CEEA;
	Tue,  8 Apr 2025 11:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110292;
	bh=VUvcz841LylGbzByai3tEbFGSStiHYAZH1iHZM40yjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3eSZ+xSvU5XT37EYDLHykF+OMoIGZj3CziaMRI1U0vYqyYWWy0eEqgxECpRJ0jui
	 pvCb90Q6J3HudxMeUQ01otSyPAL0ryvtpnwGrTCTpTqIWaDYUsIT/+yfwyH1fmoSMh
	 pifa/gzBYRagDyG2VoYBsdwLOWS0hPgstQ6qx8s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 011/731] sched/eevdf: Force propagating min_slice of cfs_rq when {en,de}queue tasks
Date: Tue,  8 Apr 2025 12:38:28 +0200
Message-ID: <20250408104914.521529333@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit 563bc2161b94571ea425bbe2cf69fd38e24cdedf ]

When a task is enqueued and its parent cgroup se is already on_rq, this
parent cgroup se will not be enqueued again, and hence the root->min_slice
leaves unchanged. The same issue happens when a task is dequeued and its
parent cgroup se has other runnable entities, and the parent cgroup se
will not be dequeued.

Force propagating min_slice when se doesn't need to be enqueued or
dequeued. Ensure the se hierarchy always get the latest min_slice.

Fixes: aef6987d8954 ("sched/eevdf: Propagate min_slice up the cgroup hierarchy")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250211063659.7180-1-dtcccc@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 61a5d08ac3324..89c7260103e18 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7004,6 +7004,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_cfs_group(se);
 
 		se->slice = slice;
+		if (se != cfs_rq->curr)
+			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
 		cfs_rq->h_nr_runnable += h_nr_runnable;
@@ -7133,6 +7135,8 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 		update_cfs_group(se);
 
 		se->slice = slice;
+		if (se != cfs_rq->curr)
+			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
 		cfs_rq->h_nr_runnable -= h_nr_runnable;
-- 
2.39.5



