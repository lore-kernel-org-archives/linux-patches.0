Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E9F26AC1;
	Sun,  1 Sep 2024 17:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210440; cv=none; b=gJNqFs904s0/OBZkKhTPurIeEfChlpDrmRU7DXYRvuvMQ3zqL20uu2L6v4YLxheUjHytuqSIjHh7XrVsBroA21uEW4w/M7/JWDl1uQyOB5H1Ib6P3blW8FXFY+B5mRCgi5R3VdO0BbnlFof1KunucJWbqWucjkTuCNWa+VVAw+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210440; c=relaxed/simple;
	bh=fMJFBePvwqIh5NMO1rK13UQNi/kmjQDip0G725C/o1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAEix+2YXs9xIzwFs32qjbzRBc5PVXDuJbn3usaXNc6VoCntJA4BaYsjBndNiCHm20wfLHU2scLadqT3Op2/vEnU+eqxLlLn0TXIrrizA5IdoAIg03cQuFti5+QJUDEq3YOaWmrsHoP2cNng9GIaulOEtjNNVWEUKp38a8hKQHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSmhPuH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSmhPuH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDE6C4CEC3;
	Sun,  1 Sep 2024 17:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210440;
	bh=fMJFBePvwqIh5NMO1rK13UQNi/kmjQDip0G725C/o1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSmhPuH+2Q+Nw+YbaP+6CcipZEbu5sz7/DiABeys2AEDA/GwTCkDg0Bp9YQuak7Yu
	 52rvrvumM3D+K1tXjwIQ/fKaVBtfMmUFABcU2RaWbVmzJ0XSzGPpDj7y0+PI3TYndQ
	 ZucIWIMAopZ7CBlfxMkdJlGFl3jm9NidA37CdHWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/215] PM: core: Add EXPORT[_GPL]_SIMPLE_DEV_PM_OPS macros
Date: Sun,  1 Sep 2024 18:18:22 +0200
Message-ID: <20240901160830.539374448@linuxfoundation.org>
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

[ Upstream commit 0ae101fdd3297b7165755340e05386f1e1379709 ]

These macros are defined conditionally, according to CONFIG_PM:
- if CONFIG_PM is enabled, these macros resolve to
  DEFINE_SIMPLE_DEV_PM_OPS(), and the dev_pm_ops symbol will be
  exported.

- if CONFIG_PM is disabled, these macros will result in a dummy static
  dev_pm_ops to be created with the __maybe_unused flag. The dev_pm_ops
  will then be discarded by the compiler, along with the provided
  callback functions if they are not used anywhere else.

In the second case, the symbol is not exported, which should be
perfectly fine - users of the symbol should all use the pm_ptr() or
pm_sleep_ptr() macro, so the dev_pm_ops marked as "extern" in the
client's code will never be accessed.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 5af9b304bc60 ("phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm.h | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 452c1ed902b75..c3665382b9f8c 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_PM_H
 #define _LINUX_PM_H
 
+#include <linux/export.h>
 #include <linux/list.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
@@ -357,14 +358,42 @@ struct dev_pm_ops {
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
 #endif
 
+#define _DEFINE_DEV_PM_OPS(name, \
+			   suspend_fn, resume_fn, \
+			   runtime_suspend_fn, runtime_resume_fn, idle_fn) \
+const struct dev_pm_ops name = { \
+	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	RUNTIME_PM_OPS(runtime_suspend_fn, runtime_resume_fn, idle_fn) \
+}
+
+#ifdef CONFIG_PM
+#define _EXPORT_DEV_PM_OPS(name, suspend_fn, resume_fn, runtime_suspend_fn, \
+			   runtime_resume_fn, idle_fn, sec) \
+	_DEFINE_DEV_PM_OPS(name, suspend_fn, resume_fn, runtime_suspend_fn, \
+			   runtime_resume_fn, idle_fn); \
+	_EXPORT_SYMBOL(name, sec)
+#else
+#define _EXPORT_DEV_PM_OPS(name, suspend_fn, resume_fn, runtime_suspend_fn, \
+			   runtime_resume_fn, idle_fn, sec) \
+static __maybe_unused _DEFINE_DEV_PM_OPS(__static_##name, suspend_fn, \
+					 resume_fn, runtime_suspend_fn, \
+					 runtime_resume_fn, idle_fn)
+#endif
+
 /*
  * Use this if you want to use the same suspend and resume callbacks for suspend
  * to RAM and hibernation.
+ *
+ * If the underlying dev_pm_ops struct symbol has to be exported, use
+ * EXPORT_SIMPLE_DEV_PM_OPS() or EXPORT_GPL_SIMPLE_DEV_PM_OPS() instead.
  */
 #define DEFINE_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-const struct dev_pm_ops name = { \
-	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-}
+	_DEFINE_DEV_PM_OPS(name, suspend_fn, resume_fn, NULL, NULL, NULL)
+
+#define EXPORT_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
+	_EXPORT_DEV_PM_OPS(name, suspend_fn, resume_fn, NULL, NULL, NULL, "")
+#define EXPORT_GPL_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
+	_EXPORT_DEV_PM_OPS(name, suspend_fn, resume_fn, NULL, NULL, NULL, "_gpl")
 
 /* Deprecated. Use DEFINE_SIMPLE_DEV_PM_OPS() instead. */
 #define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-- 
2.43.0



