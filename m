Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC172F2358;
	Tue, 17 Jun 2025 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175530; cv=none; b=FOZplAoRP8wofHciIqjMkov+lj9Jm4BkIZS5VEFa/ZkhR+Grw+FNqA+vnFc/uTKsOp7ld4eLofVIKPuvKeaxT4Ja1FO7EVsIbXWU+VJqHwC+h6hGxSI0mcuOUwrJ0G9OktHd9NFwbPArSgTaNH33kuD4Lys4dm4fzfjoBdPlIWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175530; c=relaxed/simple;
	bh=Ie3hSuRrrBycS1tA6TLT4ei7YYKRDbfV/sFHq0Yppk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EKrAfla4+oSVE92E/OZG5moeo9JjkzqEnQzpJXh3BUdcXpUGAw4CvzAhf6qbybH+PgJs0qxGkoNtVREFEpLDwsMqBsoZJf9JbixKob/sGDNUK1K/2kQPSQ4H1Ur8TaB4LboPpZEFP2op3qLjsUucY9rydF7yXM8ZunKw9ATyV00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWowq5Sh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWowq5Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656B1C4CEE3;
	Tue, 17 Jun 2025 15:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175529;
	bh=Ie3hSuRrrBycS1tA6TLT4ei7YYKRDbfV/sFHq0Yppk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWowq5ShAAqAVHL6V8Bmb69XBhaOcx6GP5WNjKLP6ox7lSug9BCPU4Hr/96n7cUB5
	 WffnyoT1VYMkqoaxowdOWD5C6qKp0sZ/WvvWepLgSSFJF0CspCHjKy4aGLnYFnOnvB
	 QAJoQTj/77TQLOqjywzM04DtPVUynP3LQwgjmCOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <csokas.bence@prolan.hu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 074/780] PM: runtime: Add new devm functions
Date: Tue, 17 Jun 2025 17:16:22 +0200
Message-ID: <20250617152454.526110139@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bence Csókás <csokas.bence@prolan.hu>

[ Upstream commit 73db799bf5efc5a04654bb3ff6c9bf63a0dfa473 ]

Add `devm_pm_runtime_set_active_enabled()` and
`devm_pm_runtime_get_noresume()` for simplifying
common cases in drivers.

Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
Link: https://patch.msgid.link/20250327195928.680771-3-csokas.bence@prolan.hu
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 8856eafcc05e ("spi: atmel-quadspi: Fix unbalanced pm_runtime by using devm_ API")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 44 ++++++++++++++++++++++++++++++++++++
 include/linux/pm_runtime.h   |  4 ++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 0e127b0329c00..205a4f8828b0a 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1568,6 +1568,32 @@ void pm_runtime_enable(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(pm_runtime_enable);
 
+static void pm_runtime_set_suspended_action(void *data)
+{
+	pm_runtime_set_suspended(data);
+}
+
+/**
+ * devm_pm_runtime_set_active_enabled - set_active version of devm_pm_runtime_enable.
+ *
+ * @dev: Device to handle.
+ */
+int devm_pm_runtime_set_active_enabled(struct device *dev)
+{
+	int err;
+
+	err = pm_runtime_set_active(dev);
+	if (err)
+		return err;
+
+	err = devm_add_action_or_reset(dev, pm_runtime_set_suspended_action, dev);
+	if (err)
+		return err;
+
+	return devm_pm_runtime_enable(dev);
+}
+EXPORT_SYMBOL_GPL(devm_pm_runtime_set_active_enabled);
+
 static void pm_runtime_disable_action(void *data)
 {
 	pm_runtime_dont_use_autosuspend(data);
@@ -1590,6 +1616,24 @@ int devm_pm_runtime_enable(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(devm_pm_runtime_enable);
 
+static void pm_runtime_put_noidle_action(void *data)
+{
+	pm_runtime_put_noidle(data);
+}
+
+/**
+ * devm_pm_runtime_get_noresume - devres-enabled version of pm_runtime_get_noresume.
+ *
+ * @dev: Device to handle.
+ */
+int devm_pm_runtime_get_noresume(struct device *dev)
+{
+	pm_runtime_get_noresume(dev);
+
+	return devm_add_action_or_reset(dev, pm_runtime_put_noidle_action, dev);
+}
+EXPORT_SYMBOL_GPL(devm_pm_runtime_get_noresume);
+
 /**
  * pm_runtime_forbid - Block runtime PM of a device.
  * @dev: Device to handle.
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 7fb5a459847ef..756b842dcd309 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -96,7 +96,9 @@ extern void pm_runtime_new_link(struct device *dev);
 extern void pm_runtime_drop_link(struct device_link *link);
 extern void pm_runtime_release_supplier(struct device_link *link);
 
+int devm_pm_runtime_set_active_enabled(struct device *dev);
 extern int devm_pm_runtime_enable(struct device *dev);
+int devm_pm_runtime_get_noresume(struct device *dev);
 
 /**
  * pm_suspend_ignore_children - Set runtime PM behavior regarding children.
@@ -294,7 +296,9 @@ static inline bool pm_runtime_blocked(struct device *dev) { return true; }
 static inline void pm_runtime_allow(struct device *dev) {}
 static inline void pm_runtime_forbid(struct device *dev) {}
 
+static inline int devm_pm_runtime_set_active_enabled(struct device *dev) { return 0; }
 static inline int devm_pm_runtime_enable(struct device *dev) { return 0; }
+static inline int devm_pm_runtime_get_noresume(struct device *dev) { return 0; }
 
 static inline void pm_suspend_ignore_children(struct device *dev, bool enable) {}
 static inline void pm_runtime_get_noresume(struct device *dev) {}
-- 
2.39.5



