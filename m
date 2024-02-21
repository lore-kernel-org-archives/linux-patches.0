Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D1A78B7C;
	Wed, 21 Feb 2024 14:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524898; cv=none; b=u/Bk6VyKF/bUNPMtGy0Qj3SbhuCxOZtNyUSIJvu+0ba3FrSzi1m8mb8TCR3mvcY9EgF3+jwot2J9+U3uia3ghe/35UCC48cqOT0rUXTG9MAe0jc8CEr4dHjZCzf3RH/Ntq/Q+oKSrAonaYkShrE8hAHfhoiye8ZSJBq8QRIy6o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524898; c=relaxed/simple;
	bh=ETTZJOmTH/NTz/cd3rQ8WuX9TF/E7bjDUtPDf2EuRJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSuK6T663KhoW/0IdCXD3kjGLN7wls1YyFzR3HqCokEAUMciLmuNPxYFv2FXVne24FGOovwLSGF4/xUPU1qg2W7VWV2WH3HKIrBJUFE2h6Ti1Q1yj4IW/K6uXWjKXSokwCuTvcdNLpays6cQKZjNk43np9tobvMsby6RYA1YqgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ay/v77HS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ay/v77HS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C763AC433C7;
	Wed, 21 Feb 2024 14:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524898;
	bh=ETTZJOmTH/NTz/cd3rQ8WuX9TF/E7bjDUtPDf2EuRJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ay/v77HSL4YrTMmKQp2qF0XVg1fp4GSfHG1AjH0W+/7h43ThwoqwB7OJD77fca7SX
	 +frzJK285Fo9woSjXowvu7L5W0099gXP8cYMiJJ5uMNX0EVS5Q5ckFtZ/Jeino3dZH
	 jO2BZjKP7GeDqNG9XoM920IB6ZI47eJWFdWU0T6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.10 374/379] PM: runtime: add devm_pm_runtime_enable helper
Date: Wed, 21 Feb 2024 14:09:13 +0100
Message-ID: <20240221130006.126681301@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b3636a3a2c51715736d3ec45f635ed03191962ce ]

A typical code pattern for pm_runtime_enable() call is to call it in the
_probe function and to call pm_runtime_disable() both from _probe error
path and from _remove function. For some drivers the whole remove
function would consist of the call to pm_remove_disable().

Add helper function to replace this bolierplate piece of code. Calling
devm_pm_runtime_enable() removes the need for calling
pm_runtime_disable() both in the probe()'s error path and in the
remove() function.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210731195034.979084-2-dmitry.baryshkov@linaro.org
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 3d07a411b4fa ("drm/msm/dsi: Use pm_runtime_resume_and_get to prevent refcnt leaks")
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |   17 +++++++++++++++++
 include/linux/pm_runtime.h   |    4 ++++
 2 files changed, 21 insertions(+)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1479,6 +1479,23 @@ void pm_runtime_enable(struct device *de
 }
 EXPORT_SYMBOL_GPL(pm_runtime_enable);
 
+static void pm_runtime_disable_action(void *data)
+{
+	pm_runtime_disable(data);
+}
+
+/**
+ * devm_pm_runtime_enable - devres-enabled version of pm_runtime_enable.
+ * @dev: Device to handle.
+ */
+int devm_pm_runtime_enable(struct device *dev)
+{
+	pm_runtime_enable(dev);
+
+	return devm_add_action_or_reset(dev, pm_runtime_disable_action, dev);
+}
+EXPORT_SYMBOL_GPL(devm_pm_runtime_enable);
+
 /**
  * pm_runtime_forbid - Block runtime PM of a device.
  * @dev: Device to handle.
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -60,6 +60,8 @@ extern void pm_runtime_new_link(struct d
 extern void pm_runtime_drop_link(struct device_link *link);
 extern void pm_runtime_release_supplier(struct device_link *link);
 
+extern int devm_pm_runtime_enable(struct device *dev);
+
 /**
  * pm_runtime_get_if_in_use - Conditionally bump up runtime PM usage counter.
  * @dev: Target device.
@@ -254,6 +256,8 @@ static inline void __pm_runtime_disable(
 static inline void pm_runtime_allow(struct device *dev) {}
 static inline void pm_runtime_forbid(struct device *dev) {}
 
+static inline int devm_pm_runtime_enable(struct device *dev) { return 0; }
+
 static inline void pm_suspend_ignore_children(struct device *dev, bool enable) {}
 static inline void pm_runtime_get_noresume(struct device *dev) {}
 static inline void pm_runtime_put_noidle(struct device *dev) {}


