Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1CE350A2A;
	Tue, 21 Oct 2025 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076694; cv=none; b=jDUTyA1cn15PiYtFB3ZblcDzSOVq76vH0dJT4IcQBPzz5ObIGowpLrUBlqypLflXFZdmxP1kPrjmKqnWexU7f4SLkqWpdJ19Ilk043GHKodnYquSinXcSykT6fuakPPKqEU5SJgfhjtvZ9G0ikZI3uk0OSzoCCoQ2AMAYzJUbaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076694; c=relaxed/simple;
	bh=wFVLpyKImQbsGKPiM2Bjiu1EXngTC4M3/lGBlg+EUdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfwT2qLm26wrCQFEDSr2fNXv5i0yC9Fd5wiycXsLt9EKT73EMBT0ZdUAqkLa3swqDIMpBJK7W6udlLeqR0zCZUEaqRPgJLFzBpg/ucDTGe8DQ1lS6SLSRSiZJGpvktN9UDFUSweV4psGPozmAjrNroN/1ihus25/2FlCDHKobIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/PmiyuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/PmiyuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200CFC4CEF1;
	Tue, 21 Oct 2025 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076692;
	bh=wFVLpyKImQbsGKPiM2Bjiu1EXngTC4M3/lGBlg+EUdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/PmiyuJbLA51xWt+4+YhExMryo/3vox2FoJfqVG1nJ6YpTebY6nN/1DO+qUZEye9
	 JCpWybPbcsPJZDmKOdZNGZkrfEdsz0PRVm2dTEPajq3mLLqSqDcffa118VOqN3K7Pi
	 3LHU1dxWsGZk8UterROg66cYrU54kjHcWpUeSHWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 001/136] drm/xe/guc: Check GuC running state before deregistering exec queue
Date: Tue, 21 Oct 2025 21:49:49 +0200
Message-ID: <20251021195035.992460476@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

commit 9f64b3cd051b825de0a2a9f145c8e003200cedd5 upstream.

In normal operation, a registered exec queue is disabled and
deregistered through the GuC, and freed only after the GuC confirms
completion. However, if the driver is forced to unbind while the exec
queue is still running, the user may call exec_destroy() after the GuC
has already been stopped and CT communication disabled.

In this case, the driver cannot receive a response from the GuC,
preventing proper cleanup of exec queue resources. Fix this by directly
releasing the resources when GuC is not running.

Here is the failure dmesg log:
"
[  468.089581] ---[ end trace 0000000000000000 ]---
[  468.089608] pci 0000:03:00.0: [drm] *ERROR* GT0: GUC ID manager unclean (1/65535)
[  468.090558] pci 0000:03:00.0: [drm] GT0:     total 65535
[  468.090562] pci 0000:03:00.0: [drm] GT0:     used 1
[  468.090564] pci 0000:03:00.0: [drm] GT0:     range 1..1 (1)
[  468.092716] ------------[ cut here ]------------
[  468.092719] WARNING: CPU: 14 PID: 4775 at drivers/gpu/drm/xe/xe_ttm_vram_mgr.c:298 ttm_vram_mgr_fini+0xf8/0x130 [xe]
"

v2: use xe_uc_fw_is_running() instead of xe_guc_ct_enabled().
    As CT may go down and come back during VF migration.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20251010172529.2967639-2-shuicheng.lin@intel.com
(cherry picked from commit 9b42321a02c50a12b2beb6ae9469606257fbecea)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -41,6 +41,7 @@
 #include "xe_ring_ops_types.h"
 #include "xe_sched_job.h"
 #include "xe_trace.h"
+#include "xe_uc_fw.h"
 #include "xe_vm.h"
 
 static struct xe_guc *
@@ -1285,7 +1286,17 @@ static void __guc_exec_queue_process_msg
 	xe_assert(xe, !(q->flags & EXEC_QUEUE_FLAG_PERMANENT));
 	trace_xe_exec_queue_cleanup_entity(q);
 
-	if (exec_queue_registered(q))
+	/*
+	 * Expected state transitions for cleanup:
+	 * - If the exec queue is registered and GuC firmware is running, we must first
+	 *   disable scheduling and deregister the queue to ensure proper teardown and
+	 *   resource release in the GuC, then destroy the exec queue on driver side.
+	 * - If the GuC is already stopped (e.g., during driver unload or GPU reset),
+	 *   we cannot expect a response for the deregister request. In this case,
+	 *   it is safe to directly destroy the exec queue on driver side, as the GuC
+	 *   will not process further requests and all resources must be cleaned up locally.
+	 */
+	if (exec_queue_registered(q) && xe_uc_fw_is_running(&guc->fw))
 		disable_scheduling_deregister(guc, q);
 	else
 		__guc_exec_queue_fini(guc, q);


