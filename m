Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201145505C4;
	Thu, 17 Sep 2026 15:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659835; cv=none; b=QH6d+0kig0oTjVuumUTPvpV3XqxxQxc0UNZiDaPO82nNkEYVcgoIqCqo3NgacG5KYDk78OzDy4VSgfaeEUMv4kQijZTzFclAxTUZ/jWOGIkv6esaYq5leSuXshUgPRbRZLiZU+ugT0B54B/KHZS10DBE/KLU2qIUnNthrFzggV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659835; c=relaxed/simple;
	bh=P/HIlpAbNpX3jR7+595SFJoFHuMsMpR0yC8jflbnot4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cUZ9NCdbaNZwFCvSNrI2bf00AOLwwS8hALu/v2ZnJ5WYjn5rMMWGQcA1eviow6mQf8IbbQ6wLsOaB5RYaXuwA9tsoPsGnB0H65SSFeFpAJTBZhFlPPeSz6Uh7d58Nk4jzDh2Gr9PkgpgKYzN7MOlYTMHeviT5H6fL/t2Y8iGLN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqxeaFvS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqxeaFvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7221F00893;
	Thu, 17 Sep 2026 15:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659829;
	bh=piInThYONUQkH+/ASj8jLurL2WJeba93/Zh+Ac/ZCmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqxeaFvSf0HWtzfzUpiXDduXmEDT0UCp0+qw7MFBOVKF5iivOlvw6Kn8e5gjyHtYO
	 xMkD/U3kq3FkBGO5qImAqPLmY34fYx2F/651Rdauf6acNMUBWrJQaTr+R0m8wtHsm4
	 Pkql4vGUpVkPG7+X407Y8VDTaEQh5lU6vQTxkxS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varun Gupta <varun.gupta@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 388/733] drm/xe: Guard page-fault worker with runtime PM check
Date: Thu, 17 Sep 2026 16:11:36 +0100
Message-ID: <20260917151401.367521375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varun Gupta <varun.gupta@intel.com>

[ Upstream commit 20fce5b34b21a995839743b4917a1edd2fd503ba ]

During VM teardown, the VM's runtime PM reference is dropped
asynchronously, allowing the device to autosuspend while stale page
faults belonging to the now-dead VM are still queued. When the
page-fault worker later tries to ack one of these, it calls into
guc_ct_send_locked() on an already-suspended device, tripping:

  Assertion `!xe_pm_runtime_suspended(xe)` failed!
  WARNING at xe_device.c:1267 xe_device_assert_mem_access+0x11c/0x140 [xe]

A live VM/exec queue always holds a PM reference while it has
outstanding work, so if the device is suspended at ack time, the
owning context is already gone and the fault is stale.

Take a runtime PM reference across the entire pagefault
queue worker to safely deliver acks for torn-down VMs.

v3:
 - Move PM ref to the generic xe_pagefault_queue_work using
   guard(xe_pm_runtime)(xe) instead of tracking it in the GuC
   backend(Matt Brost).

v2:
 - Hold PM ref across the entire batch (begin/end) instead of per-ack.
   This prevents the device from autosuspending mid-batch, which would
   leave write_only acks written but the end flush skipped, and skip
   counter++, desyncing the cadence check.(Himal)
 - Add a comment explaining stale faults.(Himal)

Fixes: f289f7807119 ("drm/xe: Add xe_guc_pagefault layer")
Signed-off-by: Varun Gupta <varun.gupta@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patch.msgid.link/20260907050011.497181-2-varun.gupta@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit fcc2431d2213dc4d04250c4f1ae87d9c3ae0d455)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo: Added xe_device struct for compatibility while cherry-picking]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pagefault.c       | 10 ++++++++++
 drivers/gpu/drm/xe/xe_pagefault_types.h |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pagefault.c b/drivers/gpu/drm/xe/xe_pagefault.c
index dbf8f71d3328a..a4986df8328d6 100644
--- a/drivers/gpu/drm/xe/xe_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_pagefault.c
@@ -16,6 +16,7 @@
 #include "xe_hw_engine.h"
 #include "xe_pagefault.h"
 #include "xe_pagefault_types.h"
+#include "xe_pm.h"
 #include "xe_svm.h"
 #include "xe_trace_bo.h"
 #include "xe_vm.h"
@@ -292,9 +293,17 @@ static void xe_pagefault_queue_work(struct work_struct *w)
 {
 	struct xe_pagefault_queue *pf_queue =
 		container_of(w, typeof(*pf_queue), worker);
+	struct xe_device *xe = pf_queue->xe;
 	struct xe_pagefault pf;
 	unsigned long threshold;
 
+	/*
+	 * A live VM holds a PM reference, but a torn-down VM does not.
+	 * Guard the entire worker loop to safely drain stale faults and
+	 * prevent autosuspends from desyncing batched CT flushes.
+	 */
+	guard(xe_pm_runtime)(xe);
+
 #define USM_QUEUE_MAX_RUNTIME_MS      20
 	threshold = jiffies + msecs_to_jiffies(USM_QUEUE_MAX_RUNTIME_MS);
 
@@ -365,6 +374,7 @@ static int xe_pagefault_queue_init(struct xe_device *xe,
 	drm_dbg(&xe->drm, "xe_pagefault_entry_size=%d, total_num_eus=%d, pf_queue->size=%u",
 		xe_pagefault_entry_size(), total_num_eus, pf_queue->size);
 
+	pf_queue->xe = xe;
 	spin_lock_init(&pf_queue->lock);
 	INIT_WORK(&pf_queue->worker, xe_pagefault_queue_work);
 
diff --git a/drivers/gpu/drm/xe/xe_pagefault_types.h b/drivers/gpu/drm/xe/xe_pagefault_types.h
index c4ee625b93ddd..f63a12aa0d4f7 100644
--- a/drivers/gpu/drm/xe/xe_pagefault_types.h
+++ b/drivers/gpu/drm/xe/xe_pagefault_types.h
@@ -8,6 +8,7 @@
 
 #include <linux/workqueue.h>
 
+struct xe_device;
 struct xe_gt;
 struct xe_pagefault;
 
@@ -118,6 +119,8 @@ struct xe_pagefault {
  * queue to absorb the device’s worst-case number of outstanding faults.
  */
 struct xe_pagefault_queue {
+	/** @xe: Back-pointer to the Xe device */
+	struct xe_device *xe;
 	/**
 	 * @data: Data in queue containing struct xe_pagefault, protected by
 	 * @lock
-- 
2.53.0



