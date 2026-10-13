Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF624F4D06;
	Tue, 13 Oct 2026 12:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893560; cv=none; b=AYDX7GobM/nlCE6iDB9MlPpdKcYMkdYEbFbOOOFi8c87unC1CDtMcUuwGC6v/yPtEElpuPpxU0MaxPsvwsSf6RBcrlnpSviQtWFfscU0iz9oRHuwPYVSuzMyOcOFpw3lzkR1unKCial21cMjRwZnIgE0tqYuqhgtjL+1wO9G2Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893560; c=relaxed/simple;
	bh=Ca9Oe47tSW7FemOF4SPHnQ4rklExym61VlxTRb0RJbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESwO6IG9u9RbP37zdz6gombfYCyOEL58SkL1ivk2aTU5u1jMtwhfRt1HTvrdPgWKtD+RAiZCQhUQuz2Dv4gH2o3pvVdrITBx64j7d3gTcwEQL+DD+CZ259gesJ1Xfxs+j2mkwjBrFWweQyuuEDfzuXEF4yN40kLeA64PzVqbzCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMa2lTas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMa2lTas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B031F00893;
	Tue, 13 Oct 2026 12:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893558;
	bh=oH17Lv5qNB60RM9l3PSyLojZgPq6j/JV1YEKrvDilyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HMa2lTasEyhey5y58dzhmhF8EUty9rQzk26/WOlyf4OIWC8IcIIwit8IYYwlOXhUy
	 ke6c41RUQ5E7Z6n7yTQn2zCtuInMWTX9nmOIAAiTN0jm/zOiWgZm4vP5JMCTXIdBqY
	 0vIGI3TW9Kh3uLSjhBW5Tlnh0OLfeiaQJ+NqHi+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/621] drm/xe/guc: Keep scheduler timeline name alive
Date: Tue, 13 Oct 2026 13:34:22 +0200
Message-ID: <20261013112927.196260573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvind Yadav <arvind.yadav@intel.com>

[ Upstream commit 299bc6d50b1bed7d1f408391736712f01a0855e2 ]

The scheduler keeps a pointer to the timeline name, but q->name
is freed with the exec queue while scheduler fences can still
reference it.

Store the name in struct xe_guc_exec_queue so it shares
the scheduler's RCU-deferred lifetime.

Fixes: 6bd90e700b42 ("drm/xe: Make dma-fences compliant with the safe access rules")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Acked-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260714064402.2457257-1-arvind.yadav@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 41075f0eb5dcbd3b065d15f15ef7bbe9315188e8)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_exec_queue_types.h | 5 +++++
 drivers/gpu/drm/xe/xe_guc_submit.c           | 4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h b/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
index c30c0e3ccbbb9..107e136a90848 100644
--- a/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
@@ -10,6 +10,7 @@
 #include <linux/workqueue.h>
 
 #include "xe_gpu_scheduler_types.h"
+#include "xe_hw_fence_types.h"
 
 struct dma_fence;
 struct xe_exec_queue;
@@ -24,6 +25,10 @@ struct xe_guc_exec_queue {
 	struct rcu_head rcu;
 	/** @sched: GPU scheduler for this xe_exec_queue */
 	struct xe_gpu_scheduler sched;
+	/**
+	 * @name: Scheduler timeline name, kept with @sched until RCU free.
+	 */
+	char name[MAX_FENCE_NAME_LEN];
 	/** @entity: Scheduler entity for this xe_exec_queue */
 	struct xe_sched_entity entity;
 	/**
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 37be39eb96fda..693d3b3051c7b 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1684,7 +1684,7 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 	err = xe_sched_init(&ge->sched, &drm_sched_ops, &xe_sched_ops,
 			    NULL, q->lrc[0]->ring.size / MAX_JOB_SIZE_BYTES, 64,
 			    timeout, guc_to_gt(guc)->ordered_wq, NULL,
-			    q->name, gt_to_xe(q->gt)->drm.dev);
+			    ge->name, gt_to_xe(q->gt)->drm.dev);
 	if (err)
 		goto err_free;
 
@@ -1711,6 +1711,8 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 
 	xe_exec_queue_assign_name(q, q->guc->id);
 
+	strscpy(ge->name, q->name, sizeof(ge->name));
+
 	trace_xe_exec_queue_create(q);
 
 	return 0;
-- 
2.53.0



