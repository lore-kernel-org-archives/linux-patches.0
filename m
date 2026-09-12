Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DCD349CE2;
	Sat, 12 Sep 2026 19:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242426; cv=none; b=VNBlCnI7NJclp1ox4UMOkvXOP4Cyx3AGGGWj7Kh24Vq/ceYnPzMvxqlggc7drv6AriD10+Bp0P4XmGUCPBmBEkEJut1P8RYplRCC0ylqWmD9P8jeXs6oqsjV2yUayCZSDJYMY8V9n2laH0vKMXwUw8zA+V91vFjgztFTDSpRHNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242426; c=relaxed/simple;
	bh=NLX/OWFra/w0vZ2hn5B18v6uXYgQlKGDwPoyNhN3zjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXGGJ9UPwlA72SJit/k5VA4ncdivZKuykx5oIOZoIdatN/txTpeJkqxlko/3Emjzd3BdLi0EHtv/R0PSA1nFhvPHg1JOr6cB9TzoEB6u2IJmtH0iaYVRjdo+OW6UZpOqKpD4TZFAV23WLNivcksAw8gJw8wrI0HGtG/ilKt9DX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cR68IX+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cR68IX+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C5A1F000FF;
	Sat, 12 Sep 2026 19:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242425;
	bh=QV8SDxEvBVJJ9juBGSNe7CvrO0mj2F91sqWA9Eujbg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cR68IX+wvl5NpILm/4OzQ8/41eU+duiDpK8T7LEe4/41dtCwwH/EBdhrfr2/ZDaHI
	 6A/FxgE2FTDe4lJnmakKA+M3UvOeIO8iRSiVXdi4YdH4dytiVB6reA6g1biRjkcXQ+
	 fCjTs6RkKFcitRvqqT15c6avet7cYPf5iWZjO8eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 399/798] clk: qcom: gdsc: enable optional power domain support
Date: Sat, 12 Sep 2026 09:00:27 +0200
Message-ID: <20260912065526.293155251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1b771839de054710e1e015b10e29a4d04c41f54b ]

On sm8250 dispcc and videocc registers are powered up by the MMCX power
domain. Currently we use a regulator to enable this domain on demand,
however this has some consequences, as genpd code is not reentrant.

Make gdsc code also use pm_runtime calls to ensure that registers are
accessible during the gdsc_enable/gdsc_disable operations.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210829154757.784699-6-dmitry.baryshkov@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 86b23609d5e1 ("clk: qcom: gdsc: tear down per-domain genpds in gdsc_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 51 ++++++++++++++++++++++++++++++++++++++---
 drivers/clk/qcom/gdsc.h |  2 ++
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 8282f27647168..6db451fb77974 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/ktime.h>
 #include <linux/pm_domain.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset-controller.h>
@@ -55,6 +56,22 @@ enum gdsc_status {
 	GDSC_ON
 };
 
+static int gdsc_pm_runtime_get(struct gdsc *sc)
+{
+	if (!sc->dev)
+		return 0;
+
+	return pm_runtime_resume_and_get(sc->dev);
+}
+
+static int gdsc_pm_runtime_put(struct gdsc *sc)
+{
+	if (!sc->dev)
+		return 0;
+
+	return pm_runtime_put_sync(sc->dev);
+}
+
 /* Returns 1 if GDSC status is status, 0 if not, and < 0 on error */
 static int gdsc_check_status(struct gdsc *sc, enum gdsc_status status)
 {
@@ -244,9 +261,8 @@ static void gdsc_retain_ff_on(struct gdsc *sc)
 	regmap_update_bits(sc->regmap, sc->gdscr, mask, mask);
 }
 
-static int gdsc_enable(struct generic_pm_domain *domain)
+static int _gdsc_enable(struct gdsc *sc)
 {
-	struct gdsc *sc = domain_to_gdsc(domain);
 	int ret;
 
 	if (sc->pwrsts == PWRSTS_ON)
@@ -302,11 +318,22 @@ static int gdsc_enable(struct generic_pm_domain *domain)
 	return 0;
 }
 
-static int gdsc_disable(struct generic_pm_domain *domain)
+static int gdsc_enable(struct generic_pm_domain *domain)
 {
 	struct gdsc *sc = domain_to_gdsc(domain);
 	int ret;
 
+	ret = gdsc_pm_runtime_get(sc);
+	if (ret)
+		return ret;
+
+	return _gdsc_enable(sc);
+}
+
+static int _gdsc_disable(struct gdsc *sc)
+{
+	int ret;
+
 	if (sc->pwrsts == PWRSTS_ON)
 		return gdsc_assert_reset(sc);
 
@@ -341,6 +368,18 @@ static int gdsc_disable(struct generic_pm_domain *domain)
 	return 0;
 }
 
+static int gdsc_disable(struct generic_pm_domain *domain)
+{
+	struct gdsc *sc = domain_to_gdsc(domain);
+	int ret;
+
+	ret = _gdsc_disable(sc);
+
+	gdsc_pm_runtime_put(sc);
+
+	return ret;
+}
+
 static int gdsc_init(struct gdsc *sc)
 {
 	u32 mask, val;
@@ -469,6 +508,8 @@ int gdsc_register(struct gdsc_desc *desc,
 	for (i = 0; i < num; i++) {
 		if (!scs[i])
 			continue;
+		if (pm_runtime_enabled(dev))
+			scs[i]->dev = dev;
 		scs[i]->regmap = regmap;
 		scs[i]->rcdev = rcdev;
 		ret = gdsc_init(scs[i]);
@@ -483,6 +524,8 @@ int gdsc_register(struct gdsc_desc *desc,
 			continue;
 		if (scs[i]->parent)
 			pm_genpd_add_subdomain(scs[i]->parent, &scs[i]->pd);
+		else if (!IS_ERR_OR_NULL(dev->pm_domain))
+			pm_genpd_add_subdomain(pd_to_genpd(dev->pm_domain), &scs[i]->pd);
 	}
 
 	return of_genpd_add_provider_onecell(dev->of_node, data);
@@ -501,6 +544,8 @@ void gdsc_unregister(struct gdsc_desc *desc)
 			continue;
 		if (scs[i]->parent)
 			pm_genpd_remove_subdomain(scs[i]->parent, &scs[i]->pd);
+		else if (!IS_ERR_OR_NULL(dev->pm_domain))
+			pm_genpd_remove_subdomain(pd_to_genpd(dev->pm_domain), &scs[i]->pd);
 	}
 	of_genpd_del_provider(dev->of_node);
 }
diff --git a/drivers/clk/qcom/gdsc.h b/drivers/clk/qcom/gdsc.h
index 762f1b5e1ec51..ad313d7210bd3 100644
--- a/drivers/clk/qcom/gdsc.h
+++ b/drivers/clk/qcom/gdsc.h
@@ -28,6 +28,7 @@ struct reset_controller_dev;
  * @resets: ids of resets associated with this gdsc
  * @reset_count: number of @resets
  * @rcdev: reset controller
+ * @dev: the device holding the GDSC, used for pm_runtime calls
  */
 struct gdsc {
 	struct generic_pm_domain	pd;
@@ -64,6 +65,7 @@ struct gdsc {
 
 	const char 			*supply;
 	struct regulator		*rsupply;
+	struct device			*dev;
 };
 
 struct gdsc_desc {
-- 
2.53.0



