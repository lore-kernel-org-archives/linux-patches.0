Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0F81A4AAA;
	Mon, 23 Dec 2024 16:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970708; cv=none; b=sY+IrU3zwZpRsM9kukyz8wiLDR5u4hhTBGuXQ0auK05UR1ACdoAR8j0GE903BTdvvD+Jy6/hLNnjQZrV2vVnt+IoFoKLUqOWQ1yl3hu2DhM9KaRtVko1gMRV6F6ZDrT6w+2boE5QmqULlriGKWf4rzx2K7FSFTo86WqMLe65sI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970708; c=relaxed/simple;
	bh=3/TX9GeHCa2LcMAeJj4lvZzF0xBsMC/SnuHUoObX7aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URHhKlWfJtcOapOPX0+26oiiUrCtP6Re2P8Y9BSoju13WWYB0lRaCuTNvvm0GZX9Yr03sFXlMrzlxK8tyynNiquBBYZJ8XvgqdwoRHqx73wtEDiJ8TR6Pq9X+aKyY2ghqLgXOIsLBBUkT12x6nNrLXhJhSVd/VMjxe1ZtkH34Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eege5LQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eege5LQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BB1C4CED3;
	Mon, 23 Dec 2024 16:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970708;
	bh=3/TX9GeHCa2LcMAeJj4lvZzF0xBsMC/SnuHUoObX7aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eege5LQBa9fo9HJbHuodR/NHInuGxUVFLZx60eBs4UCJM26hM/4IcFkOJVE57UyK8
	 KhhAZSsqhL2rIZSbvo4OCFAEU/dBHh/32opKxZ+WKurv3Ofwzc2vFgQ4aqeCEdszC8
	 sQqCFlVZkXZVzGOMFDE/SgzWMwp6OptbNCzMGUJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/83] i915/guc: Reset engine utilization buffer before registration
Date: Mon, 23 Dec 2024 16:59:25 +0100
Message-ID: <20241223155355.416245544@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56df4c4a8a1a..4bfc1131b4f0 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1213,6 +1213,21 @@ static void __get_engine_usage_record(struct intel_engine_cs *engine,
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
@@ -1404,6 +1419,9 @@ static void guc_timestamp_ping(struct work_struct *wrk)
 
 static int guc_action_enable_usage_stats(struct intel_guc *guc)
 {
+	struct intel_gt *gt = guc_to_gt(guc);
+	struct intel_engine_cs *engine;
+	enum intel_engine_id id;
 	u32 offset = intel_guc_engine_usage_offset(guc);
 	u32 action[] = {
 		INTEL_GUC_ACTION_SET_ENG_UTIL_BUFF,
@@ -1411,6 +1429,9 @@ static int guc_action_enable_usage_stats(struct intel_guc *guc)
 		0,
 	};
 
+	for_each_engine(engine, gt, id)
+		__set_engine_usage_record(engine, 0, 0xffffffff, 0);
+
 	return intel_guc_send(guc, action, ARRAY_SIZE(action));
 }
 
-- 
2.39.5



