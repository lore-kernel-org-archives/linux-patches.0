Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B37412D1F1;
	Mon, 23 Dec 2024 16:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969941; cv=none; b=NUBZUZPcfUYHzZ4JTEUmWPPfUtjCf/yerOyUH3N4hviaMfdJB2fLxpsx6Ac2RKfqAdu0o61qAMcgbyR93FK9+e9Uw86oKsBsayCDD23rbvLpz0UHtzNX79VExuS7DIzNar4MvBv74XG8RmyE3liSJY7sHinpMkyWP/wl3z0RMqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969941; c=relaxed/simple;
	bh=Cg2QgYA/3MNp2l0QIYIjwYoaIWMFJAiqg3HDZTsek5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYgeVVmgiOMigaa1nm8x2u6T7GLMiYS3cy/MWJgnzc7j+flXah6SMvA2U0p1rnwxhvxy31FJ52wkr3xtYIjtKNoiZtjrm+dpBrkL28Pn/t5z/PEYaKOWgP8Nm0Gp07/O2GoxAdKXndCqeM2gcdi3wRUCmE5z8Af0cCNDwpQeKow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKk7N4kP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKk7N4kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D85C4CED4;
	Mon, 23 Dec 2024 16:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969940;
	bh=Cg2QgYA/3MNp2l0QIYIjwYoaIWMFJAiqg3HDZTsek5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKk7N4kPK/IFPgKBBkJmnlwsMjqd3+PtyJ41jOb967vfEzVjabL7enrDZMaLQPGbE
	 MqnhszWHsOVxqUgLvlfO36URqll1kQum20fZQXTnVWe9ZN9NpAlqDDAINeJAnvUOo6
	 XAWpXDVediONPW7/wDXDtsYbdxt8zo3xFqGbRdR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/160] i915/guc: Reset engine utilization buffer before registration
Date: Mon, 23 Dec 2024 16:58:28 +0100
Message-ID: <20241223155412.437562491@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit abcc2ddae5f82aa6cfca162e3db643dd33f0a2e8 ]

On GT reset, we store total busyness counts for all engines and
re-register the utilization buffer with GuC. At that time we should
reset the buffer, so that we don't get spurious busyness counts on
subsequent queries.

To repro this issue, run igt@perf_pmu@busy-hang followed by
igt@perf_pmu@most-busy-idle-check-all for a couple iterations.

Fixes: 77cdd054dd2c ("drm/i915/pmu: Connect engine busyness stats from GuC to pmu")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241127174006.190128-2-umesh.nerlige.ramappa@intel.com
(cherry picked from commit abd318237fa6556c1e5225529af145ef15d5ff0d)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index ed979847187f..4793759f4d4a 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1243,6 +1243,21 @@ static void __get_engine_usage_record(struct intel_engine_cs *engine,
 	} while (++i < 6);
 }
 
+static void __set_engine_usage_record(struct intel_engine_cs *engine,
+				      u32 last_in, u32 id, u32 total)
+{
+	struct iosys_map rec_map = intel_guc_engine_usage_record_map(engine);
+
+#define record_write(map_, field_, val_) \
+	iosys_map_wr_field(map_, 0, struct guc_engine_usage_record, field_, val_)
+
+	record_write(&rec_map, last_switch_in_stamp, last_in);
+	record_write(&rec_map, current_context_index, id);
+	record_write(&rec_map, total_runtime, total);
+
+#undef record_write
+}
+
 static void guc_update_engine_gt_clks(struct intel_engine_cs *engine)
 {
 	struct intel_engine_guc_stats *stats = &engine->stats.guc;
@@ -1543,6 +1558,9 @@ static void guc_timestamp_ping(struct work_struct *wrk)
 
 static int guc_action_enable_usage_stats(struct intel_guc *guc)
 {
+	struct intel_gt *gt = guc_to_gt(guc);
+	struct intel_engine_cs *engine;
+	enum intel_engine_id id;
 	u32 offset = intel_guc_engine_usage_offset(guc);
 	u32 action[] = {
 		INTEL_GUC_ACTION_SET_ENG_UTIL_BUFF,
@@ -1550,6 +1568,9 @@ static int guc_action_enable_usage_stats(struct intel_guc *guc)
 		0,
 	};
 
+	for_each_engine(engine, gt, id)
+		__set_engine_usage_record(engine, 0, 0xffffffff, 0);
+
 	return intel_guc_send(guc, action, ARRAY_SIZE(action));
 }
 
-- 
2.39.5



