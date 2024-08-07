Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937ED374CC;
	Wed,  7 Aug 2024 15:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043556; cv=none; b=rKRZgXhJFuFRqe//aiid5aOc2tnKM3mUv8tg7eotR9FL1ZLEN5MZQGOIOhgeGP0LoCVjctoxqiDFAQtl+C8DxQwgcSPp6HEx/D6Vm21Bf7rnoM5l0cANKJ3AwQartTYMmtEgaLbHXZ+soE6PhzA+2EpCtUZRBE4FlwB8fz9lUDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043556; c=relaxed/simple;
	bh=Im2eOhP1EyDjF6ibj5IkMf797K3/q4Z8+fR4NvCG2ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f46i1K72WVq62CCZoJZHH20jdRfPK6ZaBAscPR22QXbJwBsgtxVW/J1c/BfDv3wCgJ0lzFELaTlWt4oz6VGrL1Cw8nZDZvBK4PXTuUtwRDQPYjOWSK6/d2/jiP2FsxGbKy/NUu/486yL28HkB3kfIao0AGnOdXaaTvgHqxJBmFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yK+sFJL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yK+sFJL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFC0C32781;
	Wed,  7 Aug 2024 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043556;
	bh=Im2eOhP1EyDjF6ibj5IkMf797K3/q4Z8+fR4NvCG2ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yK+sFJL+YvYlzWcgg1HnLot5Ggw6PUjJfKfRcwAHnSpPfeB82okhuVEUMetIHVYSM
	 jqqqrRrbk3OViYZdB86IMvmhwZ1lXfu0vA3AHyQPowIgmOckdPkJBj1XkRw+jUTvqg
	 5aqdS66H0V+JkbUFQHuKFiUcY8uaZfZZrxkZ/T48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/86] cpufreq: qcom-nvmem: Simplify driver data allocation
Date: Wed,  7 Aug 2024 16:59:53 +0200
Message-ID: <20240807150039.709751835@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit 2a5d46c3ad6b0e62d2b04356ad999d504fb564e0 ]

Simplify the allocation and cleanup of driver data by using devm
together with a flexible array. Prepare for adding additional per-CPU
data by defining a struct qcom_cpufreq_drv_cpu instead of storing the
opp_tokens directly.

Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: d01c84b97f19 ("cpufreq: qcom-nvmem: fix memory leaks in probe error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c | 49 ++++++++++------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-nvmem.c b/drivers/cpufreq/qcom-cpufreq-nvmem.c
index 91634b84baa87..983991c0afd5c 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -53,10 +53,14 @@ struct qcom_cpufreq_match_data {
 	const char **genpd_names;
 };
 
+struct qcom_cpufreq_drv_cpu {
+	int opp_token;
+};
+
 struct qcom_cpufreq_drv {
-	int *opp_tokens;
 	u32 versions;
 	const struct qcom_cpufreq_match_data *data;
+	struct qcom_cpufreq_drv_cpu cpus[];
 };
 
 static struct platform_device *cpufreq_dt_pdev, *cpufreq_pdev;
@@ -284,42 +288,32 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	drv = kzalloc(sizeof(*drv), GFP_KERNEL);
+	drv = devm_kzalloc(&pdev->dev, struct_size(drv, cpus, num_possible_cpus()),
+		           GFP_KERNEL);
 	if (!drv)
 		return -ENOMEM;
 
 	match = pdev->dev.platform_data;
 	drv->data = match->data;
-	if (!drv->data) {
-		ret = -ENODEV;
-		goto free_drv;
-	}
+	if (!drv->data)
+		return -ENODEV;
 
 	if (drv->data->get_version) {
 		speedbin_nvmem = of_nvmem_cell_get(np, NULL);
-		if (IS_ERR(speedbin_nvmem)) {
-			ret = dev_err_probe(cpu_dev, PTR_ERR(speedbin_nvmem),
-					    "Could not get nvmem cell\n");
-			goto free_drv;
-		}
+		if (IS_ERR(speedbin_nvmem))
+			return dev_err_probe(cpu_dev, PTR_ERR(speedbin_nvmem),
+					     "Could not get nvmem cell\n");
 
 		ret = drv->data->get_version(cpu_dev,
 							speedbin_nvmem, &pvs_name, drv);
 		if (ret) {
 			nvmem_cell_put(speedbin_nvmem);
-			goto free_drv;
+			return ret;
 		}
 		nvmem_cell_put(speedbin_nvmem);
 	}
 	of_node_put(np);
 
-	drv->opp_tokens = kcalloc(num_possible_cpus(), sizeof(*drv->opp_tokens),
-				  GFP_KERNEL);
-	if (!drv->opp_tokens) {
-		ret = -ENOMEM;
-		goto free_drv;
-	}
-
 	for_each_possible_cpu(cpu) {
 		struct dev_pm_opp_config config = {
 			.supported_hw = NULL,
@@ -345,9 +339,9 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
 		}
 
 		if (config.supported_hw || config.genpd_names) {
-			drv->opp_tokens[cpu] = dev_pm_opp_set_config(cpu_dev, &config);
-			if (drv->opp_tokens[cpu] < 0) {
-				ret = drv->opp_tokens[cpu];
+			drv->cpus[cpu].opp_token = dev_pm_opp_set_config(cpu_dev, &config);
+			if (drv->cpus[cpu].opp_token < 0) {
+				ret = drv->cpus[cpu].opp_token;
 				dev_err(cpu_dev, "Failed to set OPP config\n");
 				goto free_opp;
 			}
@@ -366,11 +360,7 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
 
 free_opp:
 	for_each_possible_cpu(cpu)
-		dev_pm_opp_clear_config(drv->opp_tokens[cpu]);
-	kfree(drv->opp_tokens);
-free_drv:
-	kfree(drv);
-
+		dev_pm_opp_clear_config(drv->cpus[cpu].opp_token);
 	return ret;
 }
 
@@ -382,10 +372,7 @@ static void qcom_cpufreq_remove(struct platform_device *pdev)
 	platform_device_unregister(cpufreq_dt_pdev);
 
 	for_each_possible_cpu(cpu)
-		dev_pm_opp_clear_config(drv->opp_tokens[cpu]);
-
-	kfree(drv->opp_tokens);
-	kfree(drv);
+		dev_pm_opp_clear_config(drv->cpus[cpu].opp_token);
 }
 
 static struct platform_driver qcom_cpufreq_driver = {
-- 
2.43.0



