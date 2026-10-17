Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86813C7E19;
	Sat, 17 Oct 2026 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255324; cv=none; b=pbSx17yXVRsUUYsbKG3mmv9ORGaoOUjQqzaYGF3QzidB+htcJn0s/sbV+0DvSWGPFMu4HsFbozRKECO22XI5fBws2CL2rz+8kft1oXurHbw6Q4inwborZ3xdq5aByBLT4LaUdUADBzJTCpAFKUA9RmLCBnkAQ696iebljeVp4hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255324; c=relaxed/simple;
	bh=QRYs872Adktt68QE/NG05JTHyL5GVqXzGBw84TtVZkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ct5xE2u89Sl5jAOVgWk6rt2ZVmpx/nJdX1s5KyRMEHRywdtpbF5dWBZF7AB2S16Xm5v14YikXosgz0By1eFHGRpDb7ZiWbANJX8jKd/zq5CnAC8bXul1T2yCjLKl2nP/o4DC9heXNa0r5wmu643EeYQy0t5KugRYeN/OCb+KugI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7ybGhE7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7ybGhE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BD41F000C4;
	Sat, 17 Oct 2026 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255323;
	bh=cCUeGLbQrz1ApeLY1gV8BOEBjqjnrbjDlhM+XeC/Zjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7ybGhE7xrHLdzMqDB5/tFgSKXpO0ay5ATEp28WVI1aGheNCX2tcMEB1wDZLL34Qv
	 CpREWMGW/aw+nwcdP+Kp8IRhaEjNjxMOybep5IcmX/3z7yopHf9ixxyRCJ/x9mGTci
	 QeHQ1BLXoZnPcQK8v3tuJCb68rq8dE2XwjhphKJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 737/869] PM: runtime: Introduce pm_runtime_blocked()
Date: Sat, 17 Oct 2026 17:59:38 +0200
Message-ID: <20261017160055.842213274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 758cc55ce3d5d79e8f98adbd03ad2cd29133af33 ]

Introduce a new helper function called pm_runtime_blocked()
for checking the power.last_status value indicating whether or not
enabling runtime PM for the given device has been blocked (which
happens in the "prepare" phase of system-wide suspend if runtime
PM is disabled for the given device at that point).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/4632087.LvFx2qVVIh@rjwysocki.net
Stable-dep-of: 36d74f17e03f ("driver core: Avoid warning when removing a device while its supplier is unbinding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 17 +++++++++++++++++
 include/linux/pm_runtime.h   |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 8f01b394ea3be..d189d88937753 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1590,6 +1590,23 @@ int devm_pm_runtime_set_active_enabled(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(devm_pm_runtime_set_active_enabled);
 
+bool pm_runtime_blocked(struct device *dev)
+{
+	bool ret;
+
+	/*
+	 * dev->power.last_status is a bit field, so in case it is updated via
+	 * RMW, read it under the spin lock.
+	 */
+	spin_lock_irq(&dev->power.lock);
+
+	ret = dev->power.last_status == RPM_BLOCKED;
+
+	spin_unlock_irq(&dev->power.lock);
+
+	return ret;
+}
+
 static void pm_runtime_disable_action(void *data)
 {
 	pm_runtime_dont_use_autosuspend(data);
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index c52125d990bf6..41db4d628d25e 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -82,6 +82,7 @@ extern void pm_runtime_block_if_disabled(struct device *dev);
 extern void pm_runtime_unblock(struct device *dev);
 extern void pm_runtime_enable(struct device *dev);
 extern void __pm_runtime_disable(struct device *dev, bool check_resume);
+extern bool pm_runtime_blocked(struct device *dev);
 extern void pm_runtime_allow(struct device *dev);
 extern void pm_runtime_forbid(struct device *dev);
 extern void pm_runtime_no_callbacks(struct device *dev);
@@ -281,6 +282,7 @@ static inline void pm_runtime_block_if_disabled(struct device *dev) {}
 static inline void pm_runtime_unblock(struct device *dev) {}
 static inline void pm_runtime_enable(struct device *dev) {}
 static inline void __pm_runtime_disable(struct device *dev, bool c) {}
+static inline bool pm_runtime_blocked(struct device *dev) { return true; }
 static inline void pm_runtime_allow(struct device *dev) {}
 static inline void pm_runtime_forbid(struct device *dev) {}
 
-- 
2.53.0



