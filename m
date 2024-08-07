Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E833A1C4;
	Wed,  7 Aug 2024 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043328; cv=none; b=lV81Jryvc9soR+awIZkK2wwVvgeiX6qYzatqwvF3tfQPWQRnh/RiI3mLGH/Ae5vXvkZf8s7wuVNUxUAZlr4deA/uCXdXc0EgLSfIJLgdVR49XaOwj6a76l8w2MGC+xt/fUNpZYOvtauKmeEW8JC3k2MsQNXGZAbwX/VFOjwkYC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043328; c=relaxed/simple;
	bh=gnFzgdRtlEYCJ/ebGUaYnzZ75YGivHMVFjK9Be5qj5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0inEDTTDvBwDgxEopsXuF7BQjaKZgmsKL1Gh0BwQcfyL3YAVzb1robK4+HOFPCexjQTn0rLbuD0DYaXOISYCEugossgPS2aCP5KGaPTKhzZLAuigbPfeHO3nhSpPwUcsGsA9at15zdd7XY+vhpk61JRLI78LPVW+ZMkUbZuTWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oazpw+2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oazpw+2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0605FC32781;
	Wed,  7 Aug 2024 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043328;
	bh=gnFzgdRtlEYCJ/ebGUaYnzZ75YGivHMVFjK9Be5qj5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oazpw+2DuxanFyvnzS7F8hnZYb8YUifjPVTLHU4QVkcEZvSzgPzJrYT99oN5D9cAx
	 tg0sILMTXVtwAlrUYYT/qRBieo6Ze8qZPvVbur1v4SlBJ8+5/j6qK+sobHaxIe3Mv1
	 0F/M8rITT+TGBxcKFtREoaCkXS6XdQ3oE47nahiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/121] cpufreq: qcom-nvmem: Simplify driver data allocation
Date: Wed,  7 Aug 2024 16:59:13 +0200
Message-ID: <20240807150020.048267689@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 84d7033e5efe8..03586fee15aac 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -40,10 +40,14 @@ struct qcom_cpufreq_match_data {
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
@@ -243,42 +247,32 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
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
@@ -304,9 +298,9 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
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
@@ -325,11 +319,7 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
 
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
 
@@ -341,10 +331,7 @@ static void qcom_cpufreq_remove(struct platform_device *pdev)
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



