Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2871126AC1;
	Sun,  1 Sep 2024 17:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210444; cv=none; b=tNZzSdje5ux5wclhM8aUrMloQA5bIjt1V6Sp8iakGu3QNRTrS8YQgsdYuR5rUkxDcG2gctrTjhkOF0YBCPbPlmwlwTuhnYu0ojVwL92nNTMYZ/Vg/6AxGRfqXVUWKQ+BXjQg3qlYPkP9ulJ/Iw5zknK+svLJGinRiqpABgsNEd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210444; c=relaxed/simple;
	bh=+3sKGl6Y/pQZSyVVbJWwSOuBWTpdlWNrF5WfQjyhFWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+tyeuzotHPZSS2JY9DlCv8MvVzuhXbOLVffCN/9Oq5d1f2xJMMaJJm/yDN5ojm20QJW5yc8xop9CEDJ65Dq/59uwQs6EO6niSqK2nEbaVCQeZDI7VRbmKYB+L6BFL6LZAR6Lrp9+biz/2YdSvblJV9yuF4uEsj9ZMr5fAH3eFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM1nCRov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM1nCRov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D37EC4CEC3;
	Sun,  1 Sep 2024 17:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210444;
	bh=+3sKGl6Y/pQZSyVVbJWwSOuBWTpdlWNrF5WfQjyhFWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM1nCRovQKv3RZjU2dFLbefML6vs50Ybit5nBwEwiPaqRq++QuVG6/+MKxI4VVHhF
	 EavDSHSIUMb3iGrstFHQSMOTcxs/goy47kGeSS/raqfUoypNeQpCPMC92UFjhSeTqI
	 yHvaWyIbbMN5f1t9SFzgkyVX6S2duQNQKGmQSbZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/215] PM: runtime: Add DEFINE_RUNTIME_DEV_PM_OPS() macro
Date: Sun,  1 Sep 2024 18:18:23 +0200
Message-ID: <20240901160830.578099360@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 9d8619190031af0a314bee865262d8975473e4dd ]

A lot of drivers create a dev_pm_ops struct with the system sleep
suspend/resume callbacks set to pm_runtime_force_suspend() and
pm_runtime_force_resume().

These drivers can now use the DEFINE_RUNTIME_DEV_PM_OPS() macro, which
will use pm_runtime_force_{suspend,resume}() as the system sleep
callbacks, while having the same dead code removal characteristic that
is already provided by DEFINE_SIMPLE_DEV_PM_OPS().

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 5af9b304bc60 ("phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm.h         |  3 ++-
 include/linux/pm_runtime.h | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index c3665382b9f8c..b8578e1f7c110 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -414,7 +414,8 @@ const struct dev_pm_ops __maybe_unused name = { \
  * .resume_early(), to the same routines as .runtime_suspend() and
  * .runtime_resume(), respectively (and analogously for hibernation).
  *
- * Deprecated. You most likely don't want this macro.
+ * Deprecated. You most likely don't want this macro. Use
+ * DEFINE_RUNTIME_DEV_PM_OPS() instead.
  */
 #define UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
 const struct dev_pm_ops __maybe_unused name = { \
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 7efb105183134..9a10b6bac4a71 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -22,6 +22,20 @@
 					    usage_count */
 #define RPM_AUTO		0x08	/* Use autosuspend_delay */
 
+/*
+ * Use this for defining a set of PM operations to be used in all situations
+ * (system suspend, hibernation or runtime PM).
+ *
+ * Note that the behaviour differs from the deprecated UNIVERSAL_DEV_PM_OPS()
+ * macro, which uses the provided callbacks for both runtime PM and system
+ * sleep, while DEFINE_RUNTIME_DEV_PM_OPS() uses pm_runtime_force_suspend()
+ * and pm_runtime_force_resume() for its system sleep callbacks.
+ */
+#define DEFINE_RUNTIME_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
+	_DEFINE_DEV_PM_OPS(name, pm_runtime_force_suspend, \
+			   pm_runtime_force_resume, suspend_fn, \
+			   resume_fn, idle_fn)
+
 #ifdef CONFIG_PM
 extern struct workqueue_struct *pm_wq;
 
-- 
2.43.0



