Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621928031F;
	Tue, 27 May 2025 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364988; cv=none; b=SA2CF6Mhf0eyA49tPqmZWiBIKluEYiECuif76tJvtBPW20SWqMz91P6CRk/yTcMm73byHMtMFq6M/5zhbpiR8a1SCiQ85AagKKbEkFCb4gqciYmU7I6luQu/Em18nA6yjh59vWv4N2eEOEMhIIj1XZBTiBLXt7DLySbXUv8FJks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364988; c=relaxed/simple;
	bh=ZBMlC8GQK9hJb4B/hd7GN/4SCAAwIzM8ba3WDw61YEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gvx8ZA82BSq+D2sresdlnbpjTGpw4UR4G2S5qAwSJkNbjr8+zwmlyrq5YupsiloLOjAaX4GBPtXu/TsORdwRdW+M29hV4tLXaOLWDfyWFaAeUoKbIjuyLJvszf8SwguFigfqyAVJOdZFWalIG1tZJtXFM13oPsjQDYcm/IpnG9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOuzuNK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOuzuNK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF21C4CEE9;
	Tue, 27 May 2025 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364988;
	bh=ZBMlC8GQK9hJb4B/hd7GN/4SCAAwIzM8ba3WDw61YEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOuzuNK2WcSuwcRk/OWVreQ/fI9q270pTmTyPaYv/S4NzsE7IlFDufV7ulpOZYyXl
	 KoR1LYYGbJLMdejpc2lsOfHruwrNOVnN4CC/F9PzfJWqkuaF+l5w6ZSeQ5Jt0GcXVv
	 vp0579/CKSBA79C5feQK+4iXmQEJZy8cQQU8Agjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matti=20Lehtim=C3=A4ki?= <matti.lehtimaki@gmail.com>,
	Luca Weiss <luca@lucaweiss.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/626] remoteproc: qcom_wcnss: Handle platforms with only single power domain
Date: Tue, 27 May 2025 18:22:04 +0200
Message-ID: <20250527162454.403743040@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Lehtimäki <matti.lehtimaki@gmail.com>

[ Upstream commit 65991ea8a6d1e68effdc01d95ebe39f1653f7b71 ]

Both MSM8974 and MSM8226 have only CX as power domain with MX & PX being
handled as regulators. Handle this case by reodering pd_names to have CX
first, and handling that the driver core will already attach a single
power domain internally.

Signed-off-by: Matti Lehtimäki <matti.lehtimaki@gmail.com>
[luca: minor changes]
Signed-off-by: Luca Weiss <luca@lucaweiss.eu>
Link: https://lore.kernel.org/r/20250206-wcnss-singlepd-v2-2-9a53ee953dee@lucaweiss.eu
[bjorn: Added missing braces to else after multi-statement if]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index a7bb9da27029d..735d373a9f636 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -117,10 +117,10 @@ static const struct wcnss_data pronto_v1_data = {
 	.pmu_offset = 0x1004,
 	.spare_offset = 0x1088,
 
-	.pd_names = { "mx", "cx" },
+	.pd_names = { "cx", "mx" },
 	.vregs = (struct wcnss_vreg_info[]) {
-		{ "vddmx", 950000, 1150000, 0 },
 		{ "vddcx", .super_turbo = true},
+		{ "vddmx", 950000, 1150000, 0 },
 		{ "vddpx", 1800000, 1800000, 0 },
 	},
 	.num_pd_vregs = 2,
@@ -131,10 +131,10 @@ static const struct wcnss_data pronto_v2_data = {
 	.pmu_offset = 0x1004,
 	.spare_offset = 0x1088,
 
-	.pd_names = { "mx", "cx" },
+	.pd_names = { "cx", "mx" },
 	.vregs = (struct wcnss_vreg_info[]) {
-		{ "vddmx", 1287500, 1287500, 0 },
 		{ "vddcx", .super_turbo = true },
+		{ "vddmx", 1287500, 1287500, 0 },
 		{ "vddpx", 1800000, 1800000, 0 },
 	},
 	.num_pd_vregs = 2,
@@ -397,8 +397,17 @@ static irqreturn_t wcnss_stop_ack_interrupt(int irq, void *dev)
 static int wcnss_init_pds(struct qcom_wcnss *wcnss,
 			  const char * const pd_names[WCNSS_MAX_PDS])
 {
+	struct device *dev = wcnss->dev;
 	int i, ret;
 
+	/* Handle single power domain */
+	if (dev->pm_domain) {
+		wcnss->pds[0] = dev;
+		wcnss->num_pds = 1;
+		pm_runtime_enable(dev);
+		return 0;
+	}
+
 	for (i = 0; i < WCNSS_MAX_PDS; i++) {
 		if (!pd_names[i])
 			break;
@@ -418,8 +427,15 @@ static int wcnss_init_pds(struct qcom_wcnss *wcnss,
 
 static void wcnss_release_pds(struct qcom_wcnss *wcnss)
 {
+	struct device *dev = wcnss->dev;
 	int i;
 
+	/* Handle single power domain */
+	if (wcnss->num_pds == 1 && dev->pm_domain) {
+		pm_runtime_disable(dev);
+		return;
+	}
+
 	for (i = 0; i < wcnss->num_pds; i++)
 		dev_pm_domain_detach(wcnss->pds[i], false);
 }
@@ -437,10 +453,13 @@ static int wcnss_init_regulators(struct qcom_wcnss *wcnss,
 	 * the regulators for the power domains. For old device trees we need to
 	 * reserve extra space to manage them through the regulator interface.
 	 */
-	if (wcnss->num_pds)
-		info += num_pd_vregs;
-	else
+	if (wcnss->num_pds) {
+		info += wcnss->num_pds;
+		/* Handle single power domain case */
+		num_vregs += num_pd_vregs - wcnss->num_pds;
+	} else {
 		num_vregs += num_pd_vregs;
+	}
 
 	bulk = devm_kcalloc(wcnss->dev,
 			    num_vregs, sizeof(struct regulator_bulk_data),
-- 
2.39.5



