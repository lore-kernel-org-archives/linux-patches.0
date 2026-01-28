Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFD9305057;
	Wed, 28 Jan 2026 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615814; cv=none; b=npeDOXARCOHNLUpFXSFe2r9x+d37Gy4fuw/rBnrCv6lc32VCKzFhRBJ2GYyaaNcSenwDKcZs6vKVIhlimr2Wgz6udYROZ6NRE8/efrlauSkfWNvHG4u5ogOs01iPQxu6ioauqYbhIGM0SygQMkV/NcDbZblFVrAsmWRVcqyNhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615814; c=relaxed/simple;
	bh=UnM8/ko445BlkBQviDxXwOQVzWqjiDkpmnMfIo5CLPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uBzPVBGYD5wolQxXMRVMys2BA7TUxYq9i2UXfY2lII75ypbyfx+sHmznaCrQlxbB02YxxL5tFzWxEhQv7VZA0Ru0gKXtJLrx47W1WY4ATq1tJPbopYoKUt1FLz4jsbf/p8PO46XbK2rQg8Z3A99yDE4VJkbJVDHf9bmdUf6O6LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=op/C/DkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="op/C/DkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A67C4CEF7;
	Wed, 28 Jan 2026 15:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615813;
	bh=UnM8/ko445BlkBQviDxXwOQVzWqjiDkpmnMfIo5CLPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=op/C/DkA2o3GDRqX2ObeJox6J6oCx1idykHmL3KYAAdda0Dn3ZrZLK9yfMKQBn2Oe
	 ftqgBhUEknMgaoVdQriaW2e0Y2FDwjSxov7OM7BwsCe49LrzvrloaVI/Uo7FD+0WNM
	 JQjqPFkrpBsMBOyv2lJgw0jivHTk12Zwk+a7nn2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/227] drm/xe/pm: Add scope-based cleanup helper for runtime PM
Date: Wed, 28 Jan 2026 16:22:46 +0100
Message-ID: <20260128145348.819333250@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 50a59230fa63989d59253622a8dd6386cca0db07 ]

Add a scope-based helpers for runtime PM that may be used to simplify
cleanup logic and potentially avoid goto-based cleanup.

For example, using

        guard(xe_pm_runtime)(xe);

will get runtime PM and cause a corresponding put to occur automatically
when the current scope is exited.  'xe_pm_runtime_noresume' can be used
as a guard replacement for the corresponding 'noresume' variant.
There's also an xe_pm_runtime_ioctl conditional guard that can be used
as a replacement for xe_runtime_ioctl():

        ACQUIRE(xe_pm_runtime_ioctl, pm)(xe);
        if ((ret = ACQUIRE_ERR(xe_pm_runtime_ioctl, &pm)) < 0)
                /* failed */

In a few rare cases (such as gt_reset_worker()) we need to ensure that
runtime PM is dropped when the function is exited by any means
(including error paths), but the function does not need to acquire
runtime PM because that has already been done earlier by a different
function.  For these special cases, an 'xe_pm_runtime_release_only'
guard can be used to handle the release without doing an acquisition.

These guards will be used in future patches to eliminate some of our
goto-based cleanup.

v2:
 - Specify success condition for xe_pm runtime_ioctl as _RET >= 0 so
   that positive values will be properly identified as success and
   trigger destructor cleanup properly.

v3:
 - Add comments to the kerneldoc for the existing 'get' functions
   indicating that scope-based handling should be preferred where
   possible.  (Gustavo)

Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20251118164338.3572146-31-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 59e7528dbfd52efbed05e0f11b2143217a12bc74)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Stable-dep-of: f262015b9797 ("drm/xe: Update wedged.mode only after successful reset policy change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 21 +++++++++++++++++++++
 drivers/gpu/drm/xe/xe_pm.h | 17 +++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 2c5a44377994b..a58bf004aee73 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -660,6 +660,13 @@ static void xe_pm_runtime_lockdep_prime(void)
 /**
  * xe_pm_runtime_get - Get a runtime_pm reference and resume synchronously
  * @xe: xe device instance
+ *
+ * When possible, scope-based runtime PM (through guard(xe_pm_runtime)) is
+ * be preferred over direct usage of this function.  Manual get/put handling
+ * should only be used when the function contains goto-based logic which
+ * can break scope-based handling, or when the lifetime of the runtime PM
+ * reference does not match a specific scope (e.g., runtime PM obtained in one
+ * function and released in a different one).
  */
 void xe_pm_runtime_get(struct xe_device *xe)
 {
@@ -692,6 +699,13 @@ void xe_pm_runtime_put(struct xe_device *xe)
  * xe_pm_runtime_get_ioctl - Get a runtime_pm reference before ioctl
  * @xe: xe device instance
  *
+ * When possible, scope-based runtime PM (through
+ * ACQUIRE(xe_pm_runtime_ioctl, ...)) is be preferred over direct usage of this
+ * function.  Manual get/put handling should only be used when the function
+ * contains goto-based logic which can break scope-based handling, or when the
+ * lifetime of the runtime PM reference does not match a specific scope (e.g.,
+ * runtime PM obtained in one function and released in a different one).
+ *
  * Returns: Any number greater than or equal to 0 for success, negative error
  * code otherwise.
  */
@@ -761,6 +775,13 @@ static bool xe_pm_suspending_or_resuming(struct xe_device *xe)
  * It will warn if not protected.
  * The reference should be put back after this function regardless, since it
  * will always bump the usage counter, regardless.
+ *
+ * When possible, scope-based runtime PM (through guard(xe_pm_runtime_noresume))
+ * is be preferred over direct usage of this function.  Manual get/put handling
+ * should only be used when the function contains goto-based logic which can
+ * break scope-based handling, or when the lifetime of the runtime PM reference
+ * does not match a specific scope (e.g., runtime PM obtained in one function
+ * and released in a different one).
  */
 void xe_pm_runtime_get_noresume(struct xe_device *xe)
 {
diff --git a/drivers/gpu/drm/xe/xe_pm.h b/drivers/gpu/drm/xe/xe_pm.h
index 59678b310e55f..e8005775be39e 100644
--- a/drivers/gpu/drm/xe/xe_pm.h
+++ b/drivers/gpu/drm/xe/xe_pm.h
@@ -6,6 +6,7 @@
 #ifndef _XE_PM_H_
 #define _XE_PM_H_
 
+#include <linux/cleanup.h>
 #include <linux/pm_runtime.h>
 
 #define DEFAULT_VRAM_THRESHOLD 300 /* in MB */
@@ -35,4 +36,20 @@ bool xe_rpm_reclaim_safe(const struct xe_device *xe);
 struct task_struct *xe_pm_read_callback_task(struct xe_device *xe);
 int xe_pm_module_init(void);
 
+static inline void __xe_pm_runtime_noop(struct xe_device *xe) {}
+
+DEFINE_GUARD(xe_pm_runtime, struct xe_device *,
+	     xe_pm_runtime_get(_T), xe_pm_runtime_put(_T))
+DEFINE_GUARD(xe_pm_runtime_noresume, struct xe_device *,
+	     xe_pm_runtime_get_noresume(_T), xe_pm_runtime_put(_T))
+DEFINE_GUARD_COND(xe_pm_runtime, _ioctl, xe_pm_runtime_get_ioctl(_T), _RET >= 0)
+
+/*
+ * Used when a function needs to release runtime PM in all possible cases
+ * and error paths, but the wakeref was already acquired by a different
+ * function (i.e., get() has already happened so only a put() is needed).
+ */
+DEFINE_GUARD(xe_pm_runtime_release_only, struct xe_device *,
+	     __xe_pm_runtime_noop(_T), xe_pm_runtime_put(_T));
+
 #endif
-- 
2.51.0



