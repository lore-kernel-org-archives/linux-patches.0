Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52696431488;
	Thu, 30 Jul 2026 14:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421502; cv=none; b=Dm3PEwf59/kwDh9z6x7+qmCk8BsU8lXxyKhdh+K0Osi2bMGwISjJvndIDcrxljfOg/1vIG/M8JTuXjO7yFNrYUatfQ1BpntC5Bn+ssqBN6eHeUZCzFUiZ2tN/BAexH1ulMAH5KnOwJlNrwrM9T0chITCInBPmbO3yZdKigN33eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421502; c=relaxed/simple;
	bh=fjVnov6UxKCvPaGRARxnrzLvq0/9WT/vKXmwHM1lW/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=POo15e2dxCA+EoucBp+ZyXjRps4ufaXCz837cEX+aV6aMEdtUe5fr/di4OWNrW4EaVHYm+Oe47izp5P/i4PJyH+l3tLCQV7EYRI8Gn4YijwoYF+SnX7xJMYEaA0/ogEw/FFFWrFoZ9qXZ1nkKhLb8me7XEcrs2ceJxz7cNLaUlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsiBCFgg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsiBCFgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41D41F000E9;
	Thu, 30 Jul 2026 14:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421501;
	bh=hy1GxdZOqDoMsB3cYeuDPC1JlUIfBPNQYhB0jmoaDQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MsiBCFggzXxuuDnyjlHtA1HG+L/t83x5oQyocq06hTutkoxJGxnBuBMul1/J5zGat
	 5Hhn5a5tYQdVJVSWffcPqy60J7GPZCMx8f/McOhoR6jJlOeoJ8InLE6l7V88V668Lo
	 uzNioa9QSezAYqK9S+cuPjeltNSif2AGxymhEa8k=
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
Subject: [PATCH 7.1 123/744] drm/xe/guc: Keep scheduler timeline name alive
Date: Thu, 30 Jul 2026 16:06:36 +0200
Message-ID: <20260730141446.898815695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e5e53b421f29fb..cda14d954e572f 100644
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
index 1752039d333f39..54606367eea3b3 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1973,6 +1973,8 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 
 	xe_exec_queue_assign_name(q, q->guc->id);
 
+	strscpy(ge->name, q->name, sizeof(ge->name));
+
 	/*
 	 * Use primary queue's submit_wq for all secondary queues of a
 	 * multi queue group. This serialization avoids any locking around
@@ -1987,7 +1989,7 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 	err = xe_sched_init(&ge->sched, &drm_sched_ops, &xe_sched_ops,
 			    submit_wq, xe_lrc_ring_size() / MAX_JOB_SIZE_BYTES, 64,
 			    timeout, guc_to_gt(guc)->ordered_wq, NULL,
-			    q->name, gt_to_xe(q->gt)->drm.dev);
+			    ge->name, gt_to_xe(q->gt)->drm.dev);
 	if (err)
 		goto err_release_id;
 
-- 
2.53.0



