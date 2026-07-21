Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217B546D541;
	Tue, 21 Jul 2026 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655202; cv=none; b=ax3+xaOwGelRa60/Whp3P1l8lgRZx+HE46OhfVdyI+P/nthoXNIZm56hsEo5sgZ90oLQBXS4yN1t5YXZ7ekWlg6mJIdKKecLxrcUbFHIa97rrGpdbL255kvt1RQfcIVgvDkYVgKTiKE9Lgz+C77qo1IpTjsG01ztCMp73CZUIps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655202; c=relaxed/simple;
	bh=vrL9G9WunWz0VS5zRx7OITjlI9IeKnTpl0Pc3z39A4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRuzzECPd7wNyGIJNeWp0evyynVCo0HkI2GMjNBl6XT3c8XWw1BYu2lCJGZZTkgrxjyCl5hNqq8/GHiBqC+LBGnnYTsJC+jqb4BQSNRdLnCBcf+h79+geoCk+pW4Dhme5PZ2kwoamdwhLiZHq8UZXVmd28C5tVOyO2L6N59x+j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baQ0iMFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baQ0iMFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CAB1F000E9;
	Tue, 21 Jul 2026 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655201;
	bh=tvo0Anq6JPSJ8fmOmYZZ4cLPyS1EJq84HjTUSg7YKKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=baQ0iMFidVso6J2RCIHFVLi1q/zQJ7Xn5RWzEeyVaQBijXl0ouVhoyHPkqcIBmR5W
	 +aEQEGiwUJTL52SVH4h+YiYobcmRELCzG3Qvzv1ewgqw9QzaqYLTefm/db28uYYuYx
	 2on0xsJkIg4GP0gYMETGFUBul4mpU1YQCkFrZfa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 1995/2077] pmdomain: mediatek: Fix possible nullptr KP in HWV cleanup/on-check
Date: Tue, 21 Jul 2026 17:27:48 +0200
Message-ID: <20260721152639.766014786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit a4876f11aa1d076802676e23f8af500706e780e3 upstream.

Should probe fail for HW_VOTER type power domains, this driver was
unconditionally trying to perform cleanup for DIRECT_CTL domains,
but only after checking if the target domain is powered on... with
the DIRECT_CTL scpsys_domain_is_on() code again.

And there's more: the scpsys_domain_is_on() function is also being
unconditionally used in the probe path, for any power domain that
has flag MTK_SCPD_KEEP_DEFAULT_OFF!

This bug was never experienced by anyone because the HWV domains
never failed probe, and because none of those is declared with the
aforementioned flag - but it's still something critical.

In order to fix this, add a check for MTCMOS Type and, based on
that, call the correct functions for an "is on" check, and also
do the same for the cleanup path, calling the correct functions
for the "power off" action.

For the latter, since there's a call to pm_genpd_remove() right
before calling power_off, be cautious and add a variation of the
power off functions (with a _internal suffix) for those to get a
pointer to scpsys_domain instead of one to generic_pm_domain as,
even if that's still working, this is way too much fragile and
would break at some point.

Fixes: 88914db077b6 ("pmdomain: mediatek: Add support for Hardware Voter power domains")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mtk-pm-domains.c |   40 +++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- a/drivers/pmdomain/mediatek/mtk-pm-domains.c
+++ b/drivers/pmdomain/mediatek/mtk-pm-domains.c
@@ -393,9 +393,8 @@ err_infra:
 	return ret;
 };
 
-static int scpsys_hwv_power_off(struct generic_pm_domain *genpd)
+static int scpsys_hwv_power_off_internal(struct scpsys_domain *pd)
 {
-	struct scpsys_domain *pd = container_of(genpd, struct scpsys_domain, genpd);
 	const struct scpsys_hwv_domain_data *hwv = pd->hwv_data;
 	struct scpsys *scpsys = pd->scpsys;
 	u32 val;
@@ -464,6 +463,13 @@ err_infra:
 	return ret;
 };
 
+static int scpsys_hwv_power_off(struct generic_pm_domain *genpd)
+{
+	struct scpsys_domain *pd = container_of(genpd, struct scpsys_domain, genpd);
+
+	return scpsys_hwv_power_off_internal(pd);
+}
+
 static int scpsys_ctl_pwrseq_on(struct scpsys_domain *pd)
 {
 	struct scpsys *scpsys = pd->scpsys;
@@ -694,9 +700,8 @@ err_reg:
 	return ret;
 }
 
-static int scpsys_power_off(struct generic_pm_domain *genpd)
+static int scpsys_power_off_internal(struct scpsys_domain *pd)
 {
-	struct scpsys_domain *pd = container_of(genpd, struct scpsys_domain, genpd);
 	struct scpsys *scpsys = pd->scpsys;
 	bool tmp;
 	int ret;
@@ -737,6 +742,13 @@ static int scpsys_power_off(struct gener
 	return 0;
 }
 
+static int scpsys_power_off(struct generic_pm_domain *genpd)
+{
+	struct scpsys_domain *pd = container_of(genpd, struct scpsys_domain, genpd);
+
+	return scpsys_power_off_internal(pd);
+}
+
 static struct
 generic_pm_domain *scpsys_add_one_domain(struct scpsys *scpsys, struct device_node *node)
 {
@@ -884,7 +896,14 @@ generic_pm_domain *scpsys_add_one_domain
 	 * late_init time.
 	 */
 	if (MTK_SCPD_CAPS(pd, MTK_SCPD_KEEP_DEFAULT_OFF)) {
-		if (scpsys_domain_is_on(pd))
+		bool domain_is_on;
+
+		if (scpsys->soc_data->type == SCPSYS_MTCMOS_TYPE_HW_VOTER)
+			domain_is_on = scpsys_hwv_domain_is_enable_done(pd);
+		else
+			domain_is_on = scpsys_domain_is_on(pd);
+
+		if (domain_is_on)
 			dev_warn(scpsys->dev,
 				 "%pOF: A default off power domain has been ON\n", node);
 	} else {
@@ -973,6 +992,7 @@ err_put_node:
 
 static void scpsys_remove_one_domain(struct scpsys_domain *pd)
 {
+	struct scpsys *scpsys = pd->scpsys;
 	int ret;
 
 	/*
@@ -984,8 +1004,14 @@ static void scpsys_remove_one_domain(str
 		dev_err(pd->scpsys->dev,
 			"failed to remove domain '%s' : %d - state may be inconsistent\n",
 			pd->genpd.name, ret);
-	if (scpsys_domain_is_on(pd))
-		scpsys_power_off(&pd->genpd);
+
+	if (scpsys->soc_data->type == SCPSYS_MTCMOS_TYPE_HW_VOTER) {
+		if (scpsys_hwv_domain_is_enable_done(pd))
+			scpsys_hwv_power_off_internal(pd);
+	} else {
+		if (scpsys_domain_is_on(pd))
+			scpsys_power_off_internal(pd);
+	}
 
 	clk_bulk_put(pd->num_clks, pd->clks);
 	clk_bulk_put(pd->num_subsys_clks, pd->subsys_clks);


