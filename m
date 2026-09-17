Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144704FD7AC;
	Thu, 17 Sep 2026 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667255; cv=none; b=dszBIPKbk6zFnp7K7r+LdggTKJsCKKrX+Xi8k2D48b4jr3HrRcltfkJztNYEdeFnug9M3tfDaZVmhUYmnW5dRnvWDTbXPGuQqXDwPGErrYicpWoIM+pLs+6xKaputdW5niZFUxErGqWNPUpipx1cxtvArecZfbWPhHWYfPoX88E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667255; c=relaxed/simple;
	bh=Uw42tngNDEfLV1g45jHT/7HiumW4J3evbHGrHNmdKfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T030mnEoCWMT8TGZKKV0aLI/qQ38LaKFOym8jGx+6wpy2Lj8138p9YXLhdRqS4AVcrfuUYJ776PBEhj76nbnue+auLHqp8jWnHShwg3LN4ZSLhrQ32z3hdeiF4x1W2UJuu2aFCY4OOCypSsGcLf/Pl1a3vU9m4OVzigeoYjW3Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMmGXelW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMmGXelW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BC61F000FF;
	Thu, 17 Sep 2026 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667253;
	bh=rEUfHQ6FJpB4ERnWmNSXlQuxAGMbsMihR/4ou1uWeSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMmGXelWjDB53uKdZXCOOaeE30+K80sjoNQF5Bsk98l4zCpRdL0OW8y2JOX0woWBU
	 BHqWNOhUKgF4TaEm3W7gIUjX7kdaTumRDsYGnHNVCSSTNq/CTBWVb9I9ZPyKaVz9xU
	 JPqx+EnXnU05JQ8jcJ1nbeYBk+L8Nv0nlY/FBf/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0031/1102] spi: spi-qcom-qspi: Fix incomplete error handling in runtime PM
Date: Thu, 17 Sep 2026 15:59:34 +0100
Message-ID: <20260917151540.221686246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit d283d5d4d9f6d081ddb65e371be26fffeb611c42 ]

The runtime PM functions had incomplete error handling that could leave the
system in an inconsistent state. If any operation failed midway through
suspend or resume, some resources would be left in the wrong state while
others were already changed, leading to potential clock/power imbalances.

Reorder the suspend/resume sequences to avoid brownout risk by ensuring the
performance state is set appropriately before clocks are enabled and clocks
are disabled before dropping the performance state.

Fix by adding proper error checking for all operations and using goto-based
cleanup to ensure all successfully acquired resources are properly released
on any error.

Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260429-spi-nor-v5-2-993016c9711e@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qcom-qspi.c | 44 ++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-qcom-qspi.c b/drivers/spi/spi-qcom-qspi.c
index 591fdd2ec7b85..0a2ac4bba2b94 100644
--- a/drivers/spi/spi-qcom-qspi.c
+++ b/drivers/spi/spi-qcom-qspi.c
@@ -820,20 +820,34 @@ static int __maybe_unused qcom_qspi_runtime_suspend(struct device *dev)
 	struct qcom_qspi *ctrl = spi_controller_get_devdata(host);
 	int ret;
 
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(dev, 0);
 	clk_bulk_disable_unprepare(QSPI_NUM_CLKS, ctrl->clks);
 
 	ret = icc_disable(ctrl->icc_path_cpu_to_qspi);
 	if (ret) {
 		dev_err_ratelimited(ctrl->dev, "%s: ICC disable failed for cpu: %d\n",
 			__func__, ret);
-		return ret;
+		goto err_enable_clk;
 	}
 
-	pinctrl_pm_select_sleep_state(dev);
+	ret = pinctrl_pm_select_sleep_state(dev);
+	if (ret)
+		goto err_enable_icc;
+
+	/* Drop the performance state vote */
+	ret = dev_pm_opp_set_rate(dev, 0);
+	if (ret)
+		goto err_select_default_state;
 
 	return 0;
+
+err_select_default_state:
+	pinctrl_pm_select_default_state(dev);
+err_enable_icc:
+	icc_enable(ctrl->icc_path_cpu_to_qspi);
+err_enable_clk:
+	if (clk_bulk_prepare_enable(QSPI_NUM_CLKS, ctrl->clks))
+		dev_err_ratelimited(ctrl->dev, "Failed to re-enable clocks\n");
+	return ret;
 }
 
 static int __maybe_unused qcom_qspi_runtime_resume(struct device *dev)
@@ -842,20 +856,34 @@ static int __maybe_unused qcom_qspi_runtime_resume(struct device *dev)
 	struct qcom_qspi *ctrl = spi_controller_get_devdata(host);
 	int ret;
 
-	pinctrl_pm_select_default_state(dev);
+	ret = dev_pm_opp_set_rate(dev, ctrl->last_speed * 4);
+	if (ret)
+		return ret;
+
+	ret = pinctrl_pm_select_default_state(dev);
+	if (ret)
+		goto err_opp_set_rate_zero;
 
 	ret = icc_enable(ctrl->icc_path_cpu_to_qspi);
 	if (ret) {
 		dev_err_ratelimited(ctrl->dev, "%s: ICC enable failed for cpu: %d\n",
 			__func__, ret);
-		return ret;
+		goto err_select_sleep_state;
 	}
 
 	ret = clk_bulk_prepare_enable(QSPI_NUM_CLKS, ctrl->clks);
 	if (ret)
-		return ret;
+		goto err_disable_icc;
 
-	return dev_pm_opp_set_rate(dev, ctrl->last_speed * 4);
+	return 0;
+
+err_disable_icc:
+	icc_disable(ctrl->icc_path_cpu_to_qspi);
+err_select_sleep_state:
+	pinctrl_pm_select_sleep_state(dev);
+err_opp_set_rate_zero:
+	dev_pm_opp_set_rate(dev, 0);
+	return ret;
 }
 
 static int __maybe_unused qcom_qspi_suspend(struct device *dev)
-- 
2.53.0



