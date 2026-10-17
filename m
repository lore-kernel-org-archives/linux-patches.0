Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B8F38AC99;
	Sat, 17 Oct 2026 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254278; cv=none; b=Q9yFeP0Xmb/DDhQ5HMOgQvc/Aza2Ik5AjZBxJx5I9f51w3H2JTMrP30RUyhX1OfDr97JTN1uLglOCQklsE7aJyJUvSHNB+EM2m3VJGUUurXt6X6Q+OSOrySwwOvvlmChtocCCTApRiOspB/tXRGMQjIslE2aK15ozGUr/QqESXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254278; c=relaxed/simple;
	bh=lco/rkK77B2d/17bgq3X1IZSkW8uEV7lSNR+++vFm4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zc7aWKCHthz+k9wu9rVPHrIj8HuO5o/2EobFE3XVly6eNOnAjToKFfiglaj/snek9FgAuNmvBRi+sbFtwSQcy3ZZ/TK2+5JmHYFn5OomjheruQCtNaKhT6AeXuIEq8YZlU/DSiJhZtKyn8Gij2mRFgUfwLW81HYkyPjCSV3npmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPxO6KsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPxO6KsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED1D1F000C4;
	Sat, 17 Oct 2026 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254276;
	bh=ZlcZBg6g+LN0guHO7Aw0huZKzZsmu4w3WR2C3mdI3ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPxO6KsHGkVkecDgMiz9S342tc8zZONX1zxcQQV5F/6saJWkhWn7Up08kW3WwagLT
	 MbIfAv/iWkWjAWZ6m8GXPXXoLSAbrEqpV5CnaCppK9A1SKhcQsdg2M6Jo14059HkVA
	 HANwb173ZXtYnVkwoHhrOy4j0dNamt5b/dXviOb0=
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
Subject: [PATCH 6.12 395/869] drm/xe/guc: Keep scheduler timeline name alive
Date: Sat, 17 Oct 2026 17:53:56 +0200
Message-ID: <20261017160047.245116359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a3f421e2adc03..5282d0eb94747 100644
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
index 51bd4a0f2a18b..ed95176b0e1e8 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1472,7 +1472,7 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 	err = xe_sched_init(&ge->sched, &drm_sched_ops, &xe_sched_ops,
 			    NULL, q->lrc[0]->ring.size / MAX_JOB_SIZE_BYTES, 64,
 			    timeout, guc_to_gt(guc)->ordered_wq, NULL,
-			    q->name, gt_to_xe(q->gt)->drm.dev);
+			    ge->name, gt_to_xe(q->gt)->drm.dev);
 	if (err)
 		goto err_free;
 
@@ -1499,6 +1499,8 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 
 	xe_exec_queue_assign_name(q, q->guc->id);
 
+	strscpy(ge->name, q->name, sizeof(ge->name));
+
 	trace_xe_exec_queue_create(q);
 
 	return 0;
-- 
2.53.0



