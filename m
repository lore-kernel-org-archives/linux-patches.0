Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6359B29C338;
	Thu, 15 Jan 2026 17:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496538; cv=none; b=ZQRd74f0SjO2AmsoKRr40k/a/jMk0iywOqX7FJFLUyw9UYWiRoUxbIPJSHwfbx2WoDNuW7k8zHTmewSqRRVI5Jxchb82FPLtL/DDBCTHzWvU4mmiRxbDKaQuwTrL+xcn2cfVGtlDrKfI2kRacIgbF5qM9YSodT9i24C8T3nKR2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496538; c=relaxed/simple;
	bh=MEUGeqtiP9VmQbAHu8Kyz+y6nTBDrpEqy1+6pWEipog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQTgv69/wDaGKjGcliU84MJlue3o1awRwBFN1y7VyU8daUpFFzO9sgw+cC6tlqxjXhbpZy3/KshOz6jiBB0LrtCPN00RlikyjClC2mL3JdtnEMTJErkNmgk3d+uSmrvAC7bw5xiEGNz2eNIadubkaZxYtyPDPnzjw36lI8mrLLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSEec1+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSEec1+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDC2C19422;
	Thu, 15 Jan 2026 17:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496538;
	bh=MEUGeqtiP9VmQbAHu8Kyz+y6nTBDrpEqy1+6pWEipog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSEec1+kIv0ClJxPfmx1XY2gHphNmINIw/ZoC/HhYeM+blQLLzRq20r1c1WtzlxEq
	 r+ter6vZC939siTGJBX8EGkFrfagySbRJzGxTqug3iLONyIsx6jKvk+KnRxEZ/ZGkP
	 B4hs8ODX7rFW1TzF4b/Ez8r7vHwbgq95kAfjeeb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Xin Wang <x.wang@intel.com>
Subject: [PATCH 6.12 030/119] drm/xe: Ensure GT is in C0 during resumes
Date: Thu, 15 Jan 2026 17:47:25 +0100
Message-ID: <20260115164153.049939936@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Wang <x.wang@intel.com>

commit 95d0883ac8105717f59c2dcdc0d8b9150f13aa12 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -17,7 +17,7 @@
 #include "xe_device_sysfs.h"
 #include "xe_ggtt.h"
 #include "xe_gt.h"
-#include "xe_guc.h"
+#include "xe_gt_idle.h"
 #include "xe_irq.h"
 #include "xe_pcode.h"
 #include "xe_trace.h"
@@ -165,6 +165,9 @@ int xe_pm_resume(struct xe_device *xe)
 	drm_dbg(&xe->drm, "Resuming device\n");
 	trace_xe_pm_resume(xe, __builtin_return_address(0));
 
+	for_each_gt(gt, xe, id)
+		xe_gt_idle_disable_c6(gt);
+
 	for_each_tile(tile, xe, id)
 		xe_wa_apply_tile_workarounds(tile);
 
@@ -451,6 +454,9 @@ int xe_pm_runtime_resume(struct xe_devic
 
 	xe_rpm_lockmap_acquire(xe);
 
+	for_each_gt(gt, xe, id)
+		xe_gt_idle_disable_c6(gt);
+
 	if (xe->d3cold.allowed) {
 		err = xe_pcode_ready(xe, true);
 		if (err)


