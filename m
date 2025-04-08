Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FE5269882;
	Tue,  8 Apr 2025 12:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116179; cv=none; b=BNi9nWd7/ydoipEj/2lN08zT642nW5FmsHoSsYIXTBVQ1CogE9PNy2rrtiuscBg3dnregKknbS3HIyGCTcM5oQ1j4rhr+KL9y0tyoNscMkSkBV73x3HsdfrDUmC5jAkq7Y4+uF7sPNXosr856CluDO7mAcRF/uh+P6Vm8JPp+Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116179; c=relaxed/simple;
	bh=i/UHO8LsKhhUqshojVi+0XPb38g2CT55h3p0UpAuFN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTlC/6xi0aAwgMEk3iKMxw18gjyJWE2TOKyieqe+I8FCFJF3nwulDgHyl/LRafrBoo/kUmrQOMhqELMBxbeL6FePSOgRvRwNgEypEkKkkYGrpLvIz09bFRK/oiXWsLc6EK474kTljNI/dX92zsqmVrdlxgHGI8LHNMCJKGCatfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDYCehKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDYCehKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9C7C4CEE5;
	Tue,  8 Apr 2025 12:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116179;
	bh=i/UHO8LsKhhUqshojVi+0XPb38g2CT55h3p0UpAuFN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDYCehKs6QN+b0sX9BNXwd3pB7IsQYl41Gael8xttxvC4be00aJx9mlNp4K9EDJal
	 uBqkpihepeNoF0Vp5iKnt5D7oXp/e/bLPaxm9xz81WHZHwY/aPwdp9E8vz6nPfRScm
	 srVHMIfqU9U2kZsyhcZcN+L3DdAMRcdNRC1T76Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/423] sched/eevdf: Force propagating min_slice of cfs_rq when {en,de}queue tasks
Date: Tue,  8 Apr 2025 12:45:33 +0200
Message-ID: <20250408104845.878619541@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index 49e340f9fa71b..ceb023629d48d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7103,6 +7103,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_cfs_group(se);
 
 		se->slice = slice;
+		if (se != cfs_rq->curr)
+			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
 		cfs_rq->h_nr_running++;
@@ -7232,6 +7234,8 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 		update_cfs_group(se);
 
 		se->slice = slice;
+		if (se != cfs_rq->curr)
+			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
 		cfs_rq->h_nr_running -= h_nr_running;
-- 
2.39.5



