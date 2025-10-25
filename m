Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490FF22A4DB;
	Sat, 25 Oct 2025 16:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409478; cv=none; b=ULDfzkOm3dY6kAnYvsDUTD+FKxn0kvHLlaVkUjwRncHvfaEc1ILyGn1WotjspDs2KpEYCaunBMqFmd68YnN0WSjtx6lhZsezeoPNO7XAn3DwyZ6EoUJddKXIvhgGMZxhw95/d5HpExA0PURs2hYPqs9VVV/eV9HliYSaStJKSGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409478; c=relaxed/simple;
	bh=cX5pTKlpEQevGbZjn7IpLbIVzLQNoO0WL7C5EIr3MB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fj9wfyQ0iJrS17RU3mxS12W3lJgH8zeMcM0Zf8nTPkzAaFede9tTR9VXa8BawNkEljYvAsaEYoWqhl/HRKyoo4fo+Y4Uao77NIZ/0PQkDJoAjIo+JiR7xDpsMV3X56Fv5QiIp1HbgruyfKB5xGR6PESoLKTNcRgR72VcjaTgO4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+sFBSK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+sFBSK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414B6C4CEF5;
	Sat, 25 Oct 2025 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409478;
	bh=cX5pTKlpEQevGbZjn7IpLbIVzLQNoO0WL7C5EIr3MB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+sFBSK+LVv5tVJ5iojT7SJiRb4JN1naZ31ptuqH4RF1LcpYAxRDDyS1f4IF7jVze
	 LPqyWJMgfSW9zw3t55SzH7EOB3abnW6qYBtM0740GLljamWsrKDqKzNRgIikSEOfum
	 9J2tXgV2GTmiixkuKRb77usJQyisFPUd8kKmb8V0smJ1MAqpmfJ+K5mS0aUZWVXySN
	 0RXW6ExYWGDUAXG/4JKV+3C5lLi73OCglU7K4hCBVuk/+46/TAPG1KNwcIU9An4IDL
	 fi6Iy4TpRthRvYaOPf9e47d0nr4fpcOefE7oNtiEDsE+ILjAKmfLNysI3KsHJAq1LY
	 i9Tnmknmioifg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xin Wang <x.wang@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe: Ensure GT is in C0 during resumes
Date: Sat, 25 Oct 2025 11:59:32 -0400
Message-ID: <20251025160905.3857885-341-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Wang <x.wang@intel.com>

[ Upstream commit 95d0883ac8105717f59c2dcdc0d8b9150f13aa12 ]

This patch ensures the gt will be awake for the entire duration
of the resume sequences until GuCRC takes over and GT-C6 gets
re-enabled.

Before suspending GT-C6 is kept enabled, but upon resume, GuCRC
is not yet alive to properly control the exits and some cases of
instability and corruption related to GT-C6 can be observed.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4037

Suggested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Xin Wang <x.wang@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4037
Link: https://lore.kernel.org/r/20250827000633.1369890-3-x.wang@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes real user-visible bugs: The commit addresses resume-time
  instability and corruption linked to GT-C6 being enabled before GuC
  (power control) is up, as described in the message and tracked by the
  referenced issue. Keeping the GT awake through resume avoids those
  failures.

- Small, contained change: It only adds early RC6 disable during resume
  paths and the required header:
  - Adds `#include "xe_gt_idle.h"` so the helper is visible
    (drivers/gpu/drm/xe/xe_pm.c:21).
  - System resume: disables GT-C6 for all GTs right at resume entry,
    before any other resume work (drivers/gpu/drm/xe/xe_pm.c:184-186).
  - Runtime resume: same early disable for all GTs
    (drivers/gpu/drm/xe/xe_pm.c:570-572).
  - No architectural changes, no interface changes, no behavior changes
    outside resume paths.

- Correct technical fix: The helper `xe_gt_idle_disable_c6()` safely
  forces GT out of RC6 before resume proceeds:
  - Implementation clears RC6 and RC state under forcewake and is a no-
    op on VFs (drivers/gpu/drm/xe/xe_gt_idle.c:389-407).
  - If forcewake is not available yet, it returns `-ETIMEDOUT`; the
    resume continues without regressing behavior (callers ignore return,
    which is acceptable to prevent blocking resume).

- Proper handoff to re-enable C-states: RC6 is re-enabled by GuC Power
  Conservation once firmware is up, or explicitly when GuC PC is
  skipped:
  - `xe_uc_load_hw()` starts GuC PC during GT bringup
    (drivers/gpu/drm/xe/xe_uc.c:215).
  - If GuC PC is skipped, RC6 is explicitly re-enabled via
    `xe_gt_idle_enable_c6(gt)` (drivers/gpu/drm/xe/xe_guc_pc.c:1257).
  - Thus the “keep GT awake only until GuC takes over” intent is
    fulfilled, avoiding prolonged power impact.

- Low regression risk:
  - Scope limited to early resume time; worst-case effect is slightly
    higher power during resume window.
  - No changes to suspend sequencing, only resume entry.
  - SR-IOV VFs unaffected (helper is no-op there).
  - Resume sequences already transition to GuC-controlled power states,
    so this change aligns with existing design.

- Stable backport suitability:
  - Bug fix with user impact (instability/corruption) and a minimal,
    targeted change.
  - No new features or ABI changes.
  - Touches the `drm/xe` driver only, not core subsystems.
  - If a target stable branch predates `xe_gt_idle_disable_c6()` or
    `xe_gt_idle.h`, the backport must include or adapt to the equivalent
    RC6 control helper; otherwise this applies cleanly.

Overall, this is a classic stable-worthy fix: minimal, isolated, and
prevents real-world resume failures without architectural churn.

 drivers/gpu/drm/xe/xe_pm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 3e301e42b2f19..9fccc7a855f30 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -18,7 +18,7 @@
 #include "xe_device.h"
 #include "xe_ggtt.h"
 #include "xe_gt.h"
-#include "xe_guc.h"
+#include "xe_gt_idle.h"
 #include "xe_i2c.h"
 #include "xe_irq.h"
 #include "xe_pcode.h"
@@ -177,6 +177,9 @@ int xe_pm_resume(struct xe_device *xe)
 	drm_dbg(&xe->drm, "Resuming device\n");
 	trace_xe_pm_resume(xe, __builtin_return_address(0));
 
+	for_each_gt(gt, xe, id)
+		xe_gt_idle_disable_c6(gt);
+
 	for_each_tile(tile, xe, id)
 		xe_wa_apply_tile_workarounds(tile);
 
@@ -547,6 +550,9 @@ int xe_pm_runtime_resume(struct xe_device *xe)
 
 	xe_rpm_lockmap_acquire(xe);
 
+	for_each_gt(gt, xe, id)
+		xe_gt_idle_disable_c6(gt);
+
 	if (xe->d3cold.allowed) {
 		err = xe_pcode_ready(xe, true);
 		if (err)
-- 
2.51.0

