Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48481524A0;
	Wed, 21 Feb 2024 14:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525804; cv=none; b=hvojaRQ08ydgyoLiePi7t3juZSVuPkoRx08bpBULUno0V+JAKPFoAkcwYM6natPKdK9TJ18FTS41kcnSWXRVDhv/Q0ssEtOZXGiVJQA7ICaWeeJnuwmr6Wrrv87W6+IO0U9Ngay4Tlnb8JcKrrVKXbTN8UMhcykjV8GCftUX4Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525804; c=relaxed/simple;
	bh=X74gGkxmoqDvc3PwncXRdMnuzHWiGXhBpAWc4CRsMTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoFmajbu/ULvBHJNzMchurM6KxKchrn0Kw2NwqnATUyS4VjmeU7cxFD4YA6jYAN2vEXtb9nswVU62WyP2F3DrcxXw8aDMu0lCgFMxM75mAmMZPdHNOabIHfTgVuiXP7SDEFQPPoXg/fiYa26ojKgGHFWbbcwIx0bNI/c21bRSKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFeCak8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFeCak8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C088AC433C7;
	Wed, 21 Feb 2024 14:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525804;
	bh=X74gGkxmoqDvc3PwncXRdMnuzHWiGXhBpAWc4CRsMTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFeCak8oneDuvLfHJUun3RppjeFG5Rq4Hfk1ZIVdTTUh3KbxsPYWbuoPbWhbVvmDz
	 XkyRD5MaGiUv72cTB4IpGsCQB04SaRQn/u84nobAHdGFux31NOMEi1j55Ai6/VTdOB
	 o11te0nyB6lDjWHZVeIem9Pd+xQ34sBp7CuaqdQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.4 259/267] PM: runtime: add devm_pm_runtime_enable helper
Date: Wed, 21 Feb 2024 14:10:00 +0100
Message-ID: <20240221125948.377864735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1461,6 +1461,23 @@ void pm_runtime_enable(struct device *de
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
@@ -64,6 +64,8 @@ static inline int pm_runtime_get_if_in_u
 	return pm_runtime_get_if_active(dev, false);
 }
 
+extern int devm_pm_runtime_enable(struct device *dev);
+
 static inline void pm_suspend_ignore_children(struct device *dev, bool enable)
 {
 	dev->power.ignore_children = enable;
@@ -160,6 +162,8 @@ static inline void __pm_runtime_disable(
 static inline void pm_runtime_allow(struct device *dev) {}
 static inline void pm_runtime_forbid(struct device *dev) {}
 
+static inline int devm_pm_runtime_enable(struct device *dev) { return 0; }
+
 static inline void pm_suspend_ignore_children(struct device *dev, bool enable) {}
 static inline void pm_runtime_get_noresume(struct device *dev) {}
 static inline void pm_runtime_put_noidle(struct device *dev) {}


