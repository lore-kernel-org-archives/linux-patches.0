Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA569349CFF;
	Sat, 12 Sep 2026 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223086; cv=none; b=ptWDkPIRdUjltBzap/l0BseaSVN59P7eJOTBaE/xg3Fv7Z3M4xtUydAIp/igK2f2sCrh8m4i1LeRyM4TXgcrN/zaysXFrsnM7KfltwETT8NrdXEXkcHubmJkDO6dOYoWk/rr9tGZHaBMgS1AAoIuuTkzMhMWcp1xui5bQJR96Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223086; c=relaxed/simple;
	bh=z1kwUpPEFLcQ3e0+f5NItgIS3sBGTwqw7h1LAm2hi+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u59wwh481MvFQF9JtfqiuKZT0ZNx0kuz2zqBf3eWRPM/yU4ZmEX3toUwJpqLgL+WABZYQI6PVzlTG+fbj6y8vnlkyyk7u29rJw9CToWVj8gx/iM02egVkpwF4DZwcdVuHpM5YcQus9fwGN9fKJiA37vq9IEFf7CMGqFOWwnPQ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3rcgMsS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3rcgMsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028251F00893;
	Sat, 12 Sep 2026 14:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223082;
	bh=BnRQMJYnMActymP2WBg+X60ilApo50VnPcOIimt9Iyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3rcgMsSjxpCp1G+Bz1UtSZAu+rVCt0Pv+vE43GNlTOyylubDgb0JlpuhgrmPfaui
	 SEUjM3Zvc5TEZZoReHHP271VE6nek4ZWdK/MMW02pMeMWgTMEkzL1kI33vk1r8xvnm
	 pn0LY1QzND5xhcrcaX8T4HrqHHecfNQEmxVU9oR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0715/1424] soc: qcom: rpmh-rsc: manage PM notifiers with devres
Date: Sat, 12 Sep 2026 08:52:27 +0200
Message-ID: <20260912065623.307150605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 75e918aa876440d8ad559a11d6ab87bddb1ed79a ]

rpmh_rsc_probe() registers CPU PM or genpd notifiers before populating
child devices. If child population fails, the CPU PM notifier path is not
unwound and the genpd path needs open-coded cleanup.

Use devm_pm_runtime_enable() for the genpd path and
devm_add_action_or_reset() for both notifier registrations. This makes
probe failure and driver detach use the same cleanup model while keeping
devm_of_platform_populate() responsible for child devices.

Fixes: 25092e6100ac ("soc: qcom: rpmh-rsc: Attach RSC to cluster PM domain")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623015501.31129-1-pengpeng@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index d0ec42ec0d041..2f1336af77949 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -944,17 +944,30 @@ static int rpmh_rsc_pd_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
+static void rpmh_rsc_pd_detach(void *data)
+{
+	dev_pm_genpd_remove_notifier(data);
+}
+
 static int rpmh_rsc_pd_attach(struct rsc_drv *drv, struct device *dev)
 {
 	int ret;
 
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
+
 	drv->genpd_nb.notifier_call = rpmh_rsc_pd_callback;
 	ret = dev_pm_genpd_add_notifier(dev, &drv->genpd_nb);
 	if (ret)
-		pm_runtime_disable(dev);
+		return ret;
 
-	return ret;
+	return devm_add_action_or_reset(dev, rpmh_rsc_pd_detach, dev);
+}
+
+static void rpmh_rsc_cpu_pm_unregister(void *data)
+{
+	cpu_pm_unregister_notifier(data);
 }
 
 static int rpmh_probe_tcs_config(struct platform_device *pdev, struct rsc_drv *drv)
@@ -1110,7 +1123,15 @@ static int rpmh_rsc_probe(struct platform_device *pdev)
 				return ret;
 		} else {
 			drv->rsc_pm.notifier_call = rpmh_rsc_cpu_pm_callback;
-			cpu_pm_register_notifier(&drv->rsc_pm);
+			ret = cpu_pm_register_notifier(&drv->rsc_pm);
+			if (ret)
+				return ret;
+
+			ret = devm_add_action_or_reset(&pdev->dev,
+						       rpmh_rsc_cpu_pm_unregister,
+						       &drv->rsc_pm);
+			if (ret)
+				return ret;
 		}
 	}
 
@@ -1125,13 +1146,7 @@ static int rpmh_rsc_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, drv);
 	drv->dev = &pdev->dev;
 
-	ret = devm_of_platform_populate(&pdev->dev);
-	if (ret && pdev->dev.pm_domain) {
-		dev_pm_genpd_remove_notifier(&pdev->dev);
-		pm_runtime_disable(&pdev->dev);
-	}
-
-	return ret;
+	return devm_of_platform_populate(&pdev->dev);
 }
 
 static const struct of_device_id rpmh_drv_match[] = {
-- 
2.53.0



