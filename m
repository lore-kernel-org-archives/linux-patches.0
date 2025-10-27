Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57BB31C584;
	Mon, 27 Oct 2025 19:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592533; cv=none; b=UmJZ0FKyLxgHjtVqEZm7+ADG+1pYvfYjgm8/p35lQvrFYLP7b0AY6io7Nu+7gmXlMWJGr0h+ZAb3OsLLwt5ef2ZPJ6R0DtrqzCNbY+KABhlICqGHY4EeyuKcFr9knuJZwlspoRNAghZ9izuujbrPOoeakDAcpItyQkaPJQB/2HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592533; c=relaxed/simple;
	bh=C4NQcQwkm1JgJsDMFGRjuF5ZO08Ie5K3tbo/FWOh5Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LxYvlC+ueLeJARc/nUMNwUhYZaJDWo6Y9U8PyGIBSoBe2bd106Bor5zwQyMft9aqEQQyEamopYLdP2rZyhuN2TMtVHsPt3Kc9HAt+/UGj8lvSOlXELFYakiiBUvbrWR2pq0feUr8wNOI9XOkkagibd5BnR2AJorxJA6iAxzb9bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ov3oiRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ov3oiRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C98C4CEF1;
	Mon, 27 Oct 2025 19:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592533;
	bh=C4NQcQwkm1JgJsDMFGRjuF5ZO08Ie5K3tbo/FWOh5Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ov3oiRw6JaeTm+A5wwKLFswn3WommC/kV+WXMRA/ZNr6zca+ldYSYEXtyds5sG9O
	 c/8NPT9vmaCi8ri5N3NkA4wXI3JcExVj4QtqFw7Z0LcriHII1Rb+eJxwgcdbM/K4TL
	 sNqNkoyc7JN2IbXdFIXhg+dwsiaArPmX2MOtx0js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <csokas.bence@prolan.hu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/157] PM: runtime: Add new devm functions
Date: Mon, 27 Oct 2025 19:36:22 +0100
Message-ID: <20251027183504.493954504@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bence Csókás <csokas.bence@prolan.hu>

[ Upstream commit 73db799bf5efc5a04654bb3ff6c9bf63a0dfa473 ]

Add `devm_pm_runtime_set_active_enabled()` and
`devm_pm_runtime_get_noresume()` for simplifying
common cases in drivers.

Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
Link: https://patch.msgid.link/20250327195928.680771-3-csokas.bence@prolan.hu
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 0792c1984a45 ("iio: imu: inv_icm42600: Simplify pm_runtime setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |   44 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm_runtime.h   |    4 +++
 2 files changed, 48 insertions(+)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1512,6 +1512,32 @@ out:
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
@@ -1534,6 +1560,24 @@ int devm_pm_runtime_enable(struct device
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
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -95,7 +95,9 @@ extern void pm_runtime_new_link(struct d
 extern void pm_runtime_drop_link(struct device_link *link);
 extern void pm_runtime_release_supplier(struct device_link *link);
 
+int devm_pm_runtime_set_active_enabled(struct device *dev);
 extern int devm_pm_runtime_enable(struct device *dev);
+int devm_pm_runtime_get_noresume(struct device *dev);
 
 /**
  * pm_runtime_get_if_in_use - Conditionally bump up runtime PM usage counter.
@@ -292,7 +294,9 @@ static inline void __pm_runtime_disable(
 static inline void pm_runtime_allow(struct device *dev) {}
 static inline void pm_runtime_forbid(struct device *dev) {}
 
+static inline int devm_pm_runtime_set_active_enabled(struct device *dev) { return 0; }
 static inline int devm_pm_runtime_enable(struct device *dev) { return 0; }
+static inline int devm_pm_runtime_get_noresume(struct device *dev) { return 0; }
 
 static inline void pm_suspend_ignore_children(struct device *dev, bool enable) {}
 static inline void pm_runtime_get_noresume(struct device *dev) {}


