Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622B22EE266;
	Tue, 17 Jun 2025 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177861; cv=none; b=QX5aurizska0wKivOzJtX/6hTFa0OAgfQbECh+Eo5WXAPmAPgI2Rw8RNbNq7BUzUsdJFaAWpn4ASFEzagl2LB31v7hR0WYzB1Bly6t+bGoeHk9/OcRHyMxOztBq7u8qgE2j1tUty6jGwVRW40MaxwlShjITt+pqgVlzjb2/jDKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177861; c=relaxed/simple;
	bh=/FcBhdOiUYV8RNXiDevVrSVss8AyIOLaXyb2yj+JCV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArDGeb6gi0jKmSJVgY257hKPOUAxXYCabtDHQqtVKoJzTJiWC562dTWwRd4+zJhpummR2XgoE+TowKjQW8Wo8LmCkUbdTYScczSnmiF5WbR6xGxqnPvkUN2FK5nJgJLY7ZHRYnc+jGoB/rMnK720oSDW3AbYHeh4gcrx4txdDqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o29xFmQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o29xFmQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E5AC4CEE3;
	Tue, 17 Jun 2025 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177861;
	bh=/FcBhdOiUYV8RNXiDevVrSVss8AyIOLaXyb2yj+JCV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o29xFmQAii5Q02AkEPXgWU9PMPwR163qipJQLi6x7tvvnqhMI4Wkapa4BszA01/5H
	 OsWovT3xKfxSvLa539PCRe3ESmSBDo6cSDlotXcyu0F00KuyhzChhWbUm1RkdZ9LwO
	 QkIEVBk2phQDWJb2eBYwYjn1qk8kT08KBdcncV8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 407/512] pmdomain: core: Introduce dev_pm_genpd_rpm_always_on()
Date: Tue, 17 Jun 2025 17:26:13 +0200
Message-ID: <20250617152436.068025031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit cd3fa304ba5c93ce57b9b55b3cd893af2be96527 ]

For some usecases a consumer driver requires its device to remain power-on
from the PM domain perspective during runtime. Using dev PM qos along with
the genpd governors, doesn't work for this case as would potentially
prevent the device from being runtime suspended too.

To support these usecases, let's introduce dev_pm_genpd_rpm_always_on() to
allow consumers drivers to dynamically control the behaviour in genpd for a
device that is attached to it.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1738736156-119203-4-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 08f959759e1e ("mmc: sdhci-of-dwcmshc: add PD workaround on RK3576")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/core.c   | 35 +++++++++++++++++++++++++++++++++++
 include/linux/pm_domain.h |  7 +++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index 05913e9fe0821..8b1f894f5e790 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -697,6 +697,37 @@ bool dev_pm_genpd_get_hwmode(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dev_pm_genpd_get_hwmode);
 
+/**
+ * dev_pm_genpd_rpm_always_on() - Control if the PM domain can be powered off.
+ *
+ * @dev: Device for which the PM domain may need to stay on for.
+ * @on: Value to set or unset for the condition.
+ *
+ * For some usecases a consumer driver requires its device to remain power-on
+ * from the PM domain perspective during runtime. This function allows the
+ * behaviour to be dynamically controlled for a device attached to a genpd.
+ *
+ * It is assumed that the users guarantee that the genpd wouldn't be detached
+ * while this routine is getting called.
+ *
+ * Return: Returns 0 on success and negative error values on failures.
+ */
+int dev_pm_genpd_rpm_always_on(struct device *dev, bool on)
+{
+	struct generic_pm_domain *genpd;
+
+	genpd = dev_to_genpd_safe(dev);
+	if (!genpd)
+		return -ENODEV;
+
+	genpd_lock(genpd);
+	dev_gpd_data(dev)->rpm_always_on = on;
+	genpd_unlock(genpd);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dev_pm_genpd_rpm_always_on);
+
 static int _genpd_power_on(struct generic_pm_domain *genpd, bool timed)
 {
 	unsigned int state_idx = genpd->state_idx;
@@ -868,6 +899,10 @@ static int genpd_power_off(struct generic_pm_domain *genpd, bool one_dev_on,
 		if (!pm_runtime_suspended(pdd->dev) ||
 			irq_safe_dev_in_sleep_domain(pdd->dev, genpd))
 			not_suspended++;
+
+		/* The device may need its PM domain to stay powered on. */
+		if (to_gpd_data(pdd)->rpm_always_on)
+			return -EBUSY;
 	}
 
 	if (not_suspended > 1 || (not_suspended == 1 && !one_dev_on))
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index cf4b11be37097..c6716f474ba45 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -251,6 +251,7 @@ struct generic_pm_domain_data {
 	unsigned int default_pstate;
 	unsigned int rpm_pstate;
 	bool hw_mode;
+	bool rpm_always_on;
 	void *data;
 };
 
@@ -283,6 +284,7 @@ ktime_t dev_pm_genpd_get_next_hrtimer(struct device *dev);
 void dev_pm_genpd_synced_poweroff(struct device *dev);
 int dev_pm_genpd_set_hwmode(struct device *dev, bool enable);
 bool dev_pm_genpd_get_hwmode(struct device *dev);
+int dev_pm_genpd_rpm_always_on(struct device *dev, bool on);
 
 extern struct dev_power_governor simple_qos_governor;
 extern struct dev_power_governor pm_domain_always_on_gov;
@@ -366,6 +368,11 @@ static inline bool dev_pm_genpd_get_hwmode(struct device *dev)
 	return false;
 }
 
+static inline int dev_pm_genpd_rpm_always_on(struct device *dev, bool on)
+{
+	return -EOPNOTSUPP;
+}
+
 #define simple_qos_governor		(*(struct dev_power_governor *)(NULL))
 #define pm_domain_always_on_gov		(*(struct dev_power_governor *)(NULL))
 #endif
-- 
2.39.5



