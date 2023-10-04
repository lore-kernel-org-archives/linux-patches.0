Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FF619BD6
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJDLozYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A13C433C7;
	Wed,  4 Oct 2023 18:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444241;
	bh=Hf/b0rlHO/SI2/19bQPtCZ4B22zCCQuSVdfnnxF0Ilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJDLozYZxrSd661rQWgDqu9xf4JS3HP4OUBOCjPUiQyrvSiJGr3KGP2Yj3GmVZxI0
	 4V75seuV62JiqEGHUn1iQx35jrVEFFKMd6JVwIw4D/vtJkVBG3SxweA5AUR4ZtTKiU
	 JXFAs5OGpjKt81uFPP7GTLmX8kNpQDoFRoe2aVS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 152/321] i915/guc: Get runtime pm in busyness worker only if already active
Date: Wed,  4 Oct 2023 19:54:57 +0200
Message-ID: <20231004175236.305884247@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 907ef0398c938be8232b77c61cfcf50fbfd95554 ]

Ideally the busyness worker should take a gt pm wakeref because the
worker only needs to be active while gt is awake. However, the gt_park
path cancels the worker synchronously and this complicates the flow if
the worker is also running at the same time. The cancel waits for the
worker and when the worker releases the wakeref, that would call gt_park
and would lead to a deadlock.

The resolution is to take the global pm wakeref if runtime pm is already
active. If not, we don't need to update the busyness stats as the stats
would already be updated when the gt was parked.

Note:
- We do not requeue the worker if we cannot take a reference to runtime
  pm since intel_guc_busyness_unpark would requeue the worker in the
  resume path.

- If the gt was parked longer than time taken for GT timestamp to roll
  over, we ignore those rollovers since we don't care about tracking the
  exact GT time. We only care about roll overs when the gt is active and
  running workloads.

- There is a window of time between gt_park and runtime suspend, where
  the worker may run. This is acceptable since the worker will not find
  any new data to update busyness.

v2: (Daniele)
- Edit commit message and code comment
- Use runtime pm in the worker
- Put runtime pm after enabling the worker
- Use Link tag and add Fixes tag

v3: (Daniele)
- Reword commit and comments and add details

Link: https://gitlab.freedesktop.org/drm/intel/-/issues/7077
Fixes: 77cdd054dd2c ("drm/i915/pmu: Connect engine busyness stats from GuC to pmu")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230925192117.2497058-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit e2f99b79d4c594cdf7ab449e338d4947f5ea8903)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c | 38 +++++++++++++++++--
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index b5b7f2fe8c78e..dc7b40e06e38a 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1432,6 +1432,36 @@ static void guc_timestamp_ping(struct work_struct *wrk)
 	unsigned long index;
 	int srcu, ret;
 
+	/*
+	 * Ideally the busyness worker should take a gt pm wakeref because the
+	 * worker only needs to be active while gt is awake. However, the
+	 * gt_park path cancels the worker synchronously and this complicates
+	 * the flow if the worker is also running at the same time. The cancel
+	 * waits for the worker and when the worker releases the wakeref, that
+	 * would call gt_park and would lead to a deadlock.
+	 *
+	 * The resolution is to take the global pm wakeref if runtime pm is
+	 * already active. If not, we don't need to update the busyness stats as
+	 * the stats would already be updated when the gt was parked.
+	 *
+	 * Note:
+	 * - We do not requeue the worker if we cannot take a reference to runtime
+	 *   pm since intel_guc_busyness_unpark would requeue the worker in the
+	 *   resume path.
+	 *
+	 * - If the gt was parked longer than time taken for GT timestamp to roll
+	 *   over, we ignore those rollovers since we don't care about tracking
+	 *   the exact GT time. We only care about roll overs when the gt is
+	 *   active and running workloads.
+	 *
+	 * - There is a window of time between gt_park and runtime suspend,
+	 *   where the worker may run. This is acceptable since the worker will
+	 *   not find any new data to update busyness.
+	 */
+	wakeref = intel_runtime_pm_get_if_active(&gt->i915->runtime_pm);
+	if (!wakeref)
+		return;
+
 	/*
 	 * Synchronize with gt reset to make sure the worker does not
 	 * corrupt the engine/guc stats. NB: can't actually block waiting
@@ -1440,10 +1470,9 @@ static void guc_timestamp_ping(struct work_struct *wrk)
 	 */
 	ret = intel_gt_reset_trylock(gt, &srcu);
 	if (ret)
-		return;
+		goto err_trylock;
 
-	with_intel_runtime_pm(&gt->i915->runtime_pm, wakeref)
-		__update_guc_busyness_stats(guc);
+	__update_guc_busyness_stats(guc);
 
 	/* adjust context stats for overflow */
 	xa_for_each(&guc->context_lookup, index, ce)
@@ -1452,6 +1481,9 @@ static void guc_timestamp_ping(struct work_struct *wrk)
 	intel_gt_reset_unlock(gt, srcu);
 
 	guc_enable_busyness_worker(guc);
+
+err_trylock:
+	intel_runtime_pm_put(&gt->i915->runtime_pm, wakeref);
 }
 
 static int guc_action_enable_usage_stats(struct intel_guc *guc)
-- 
2.40.1



