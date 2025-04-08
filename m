Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD65126989E;
	Tue,  8 Apr 2025 12:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115533; cv=none; b=QHPKZTLO1KzlBnSXfiTKLifj+qIDXR6i8iG/ijZuuilhwxJkbcDJiUDnxwUJ7bB+d2yyf3e4/Bjd1Gpk1iAPNxFQdcp4ErZsa6EvIbeXMoz8A3Z72Vwu/7W1QiMlAoekoVX39U2Zuv+Jp0KOkUZD30mC3E28AXJa4dVOJYy3Vho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115533; c=relaxed/simple;
	bh=jYEFZo32rm8uQe7sObVFKDehXAVS2+eV4/ht7D/eutc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svnhFmzgXttmrsc5VkVnZ3A17tw64pf+hkQmZAercgpiuMOwo5MIHvaCpflWV1bKJCJa+0G1F/XOsTaRkQgZJsGh5wFzco5OBcWEk+SFV0dG0/+C1zSX7P5KCar81fAGhrIhCITcCJCozLsJHMfb6CwtlpmIPg3jdB1u3BVPcOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCrDo225; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCrDo225"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F989C4CEE5;
	Tue,  8 Apr 2025 12:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115533;
	bh=jYEFZo32rm8uQe7sObVFKDehXAVS2+eV4/ht7D/eutc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCrDo22509mF/0fGYYrLJivvJPK+TsvE6fab+CCEZSIkUNE/GC9ZDJ38AuV2PI5gg
	 Yv5tQz/vS0ZUYbFHvS47La3hGxPImBqZbfQ93bCHcGkguxILrCB95YIPPapDZk5oC2
	 EuQs0C/G8l5NjoQ7eLLpSIPwtL6eP24u6NJPzzwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/204] PM: sleep: Adjust check before setting power.must_resume
Date: Tue,  8 Apr 2025 12:49:01 +0200
Message-ID: <20250408104820.638276066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit eeb87d17aceab7803a5a5bcb6cf2817b745157cf ]

The check before setting power.must_resume in device_suspend_noirq()
does not take power.child_count into account, but it should do that, so
use pm_runtime_need_not_resume() in it for this purpose and adjust the
comment next to it accordingly.

Fixes: 107d47b2b95e ("PM: sleep: core: Simplify the SMART_SUSPEND flag handling")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/3353728.44csPzL39Z@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c    | 13 ++++++-------
 drivers/base/power/runtime.c |  2 +-
 include/linux/pm_runtime.h   |  2 ++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 9c5a5f4dba5a6..49728cb628c19 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1236,14 +1236,13 @@ static int __device_suspend_noirq(struct device *dev, pm_message_t state, bool a
 	dev->power.is_noirq_suspended = true;
 
 	/*
-	 * Skipping the resume of devices that were in use right before the
-	 * system suspend (as indicated by their PM-runtime usage counters)
-	 * would be suboptimal.  Also resume them if doing that is not allowed
-	 * to be skipped.
+	 * Devices must be resumed unless they are explicitly allowed to be left
+	 * in suspend, but even in that case skipping the resume of devices that
+	 * were in use right before the system suspend (as indicated by their
+	 * runtime PM usage counters and child counters) would be suboptimal.
 	 */
-	if (atomic_read(&dev->power.usage_count) > 1 ||
-	    !(dev_pm_test_driver_flags(dev, DPM_FLAG_MAY_SKIP_RESUME) &&
-	      dev->power.may_skip_resume))
+	if (!(dev_pm_test_driver_flags(dev, DPM_FLAG_MAY_SKIP_RESUME) &&
+	      dev->power.may_skip_resume) || !pm_runtime_need_not_resume(dev))
 		dev->power.must_resume = true;
 
 	if (dev->power.must_resume)
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 14088b5adb556..bb68cba4d85a9 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1840,7 +1840,7 @@ void pm_runtime_drop_link(struct device_link *link)
 	pm_request_idle(link->supplier);
 }
 
-static bool pm_runtime_need_not_resume(struct device *dev)
+bool pm_runtime_need_not_resume(struct device *dev)
 {
 	return atomic_read(&dev->power.usage_count) <= 1 &&
 		(atomic_read(&dev->power.child_count) == 0 ||
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 9a8151a2bdea6..b79a1a20d0d9c 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -66,6 +66,7 @@ static inline bool queue_pm_work(struct work_struct *work)
 
 extern int pm_generic_runtime_suspend(struct device *dev);
 extern int pm_generic_runtime_resume(struct device *dev);
+extern bool pm_runtime_need_not_resume(struct device *dev);
 extern int pm_runtime_force_suspend(struct device *dev);
 extern int pm_runtime_force_resume(struct device *dev);
 
@@ -254,6 +255,7 @@ static inline bool queue_pm_work(struct work_struct *work) { return false; }
 
 static inline int pm_generic_runtime_suspend(struct device *dev) { return 0; }
 static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
+static inline bool pm_runtime_need_not_resume(struct device *dev) {return true; }
 static inline int pm_runtime_force_suspend(struct device *dev) { return 0; }
 static inline int pm_runtime_force_resume(struct device *dev) { return 0; }
 
-- 
2.39.5



