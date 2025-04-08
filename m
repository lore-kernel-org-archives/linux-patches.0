Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5305B227EBD;
	Tue,  8 Apr 2025 11:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112613; cv=none; b=sa+9LZffmtIJpDHzo6DMg6vtlGuV7arsrLCY5gLUB2HJ6SDSHGWe+qMu31BRIkU5F1JSTVxUb45aQZByGsxgGqR3gNXEtAUdHZxhurF7ufTh8jy0gndpzo/l6ie6zF3Ke7mLY3wSmkv3GSH3rmqFed202vuTdR4765qAzJE/Kls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112613; c=relaxed/simple;
	bh=ZewiOQJBgIOHgEuDVVjUbc/MK21jDn/la3EEHbFiFDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbG7QhOFr/p3c9YFLkZVkwhz+j0msxweLaCCYH9HuT9nscwKCHiSMS5sbY4ZHSWgZgVwZo/1hrT8Gb6PhvICtUWQfI83/myxadgCW/mDTJ/Wjq2Z9D5Q3JZBQmfGMtwxIZt4p4j7UzjxxIw2p8Qn2gL1YWDqoY6ovGaqkszX0dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLxsYXgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLxsYXgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5A4C4CEE5;
	Tue,  8 Apr 2025 11:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112613;
	bh=ZewiOQJBgIOHgEuDVVjUbc/MK21jDn/la3EEHbFiFDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLxsYXgbrYSF0g/0l2innypOkmmdcQWzb+72AO0RtjZkHQhF2wyX5WDAqOvMyf9Dy
	 8gWnNLukJRfhyMDgSzaLlJLbHAKDNBMN2+qhSra/0Z+JCtsJOr2pFK14q8R9YzpYrz
	 hv6Hn8bKCleFaKfoc0Q7leroO5+k35pOKftpMKys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/279] PM: sleep: Adjust check before setting power.must_resume
Date: Tue,  8 Apr 2025 12:48:37 +0200
Message-ID: <20250408104829.958001180@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 185ea0d93a5e5..8586651320901 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1239,14 +1239,13 @@ static int __device_suspend_noirq(struct device *dev, pm_message_t state, bool a
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
index 6699096ff2fa6..edee7f1af1cec 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1809,7 +1809,7 @@ void pm_runtime_drop_link(struct device_link *link)
 	pm_request_idle(link->supplier);
 }
 
-static bool pm_runtime_need_not_resume(struct device *dev)
+bool pm_runtime_need_not_resume(struct device *dev)
 {
 	return atomic_read(&dev->power.usage_count) <= 1 &&
 		(atomic_read(&dev->power.child_count) == 0 ||
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 9a10b6bac4a71..ed01ae76e2fa5 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -46,6 +46,7 @@ static inline bool queue_pm_work(struct work_struct *work)
 
 extern int pm_generic_runtime_suspend(struct device *dev);
 extern int pm_generic_runtime_resume(struct device *dev);
+extern bool pm_runtime_need_not_resume(struct device *dev);
 extern int pm_runtime_force_suspend(struct device *dev);
 extern int pm_runtime_force_resume(struct device *dev);
 
@@ -234,6 +235,7 @@ static inline bool queue_pm_work(struct work_struct *work) { return false; }
 
 static inline int pm_generic_runtime_suspend(struct device *dev) { return 0; }
 static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
+static inline bool pm_runtime_need_not_resume(struct device *dev) {return true; }
 static inline int pm_runtime_force_suspend(struct device *dev) { return 0; }
 static inline int pm_runtime_force_resume(struct device *dev) { return 0; }
 
-- 
2.39.5



