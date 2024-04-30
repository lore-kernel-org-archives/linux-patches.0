Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BBC12C47F;
	Tue, 30 Apr 2024 11:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476554; cv=none; b=HLBYgGz6MzE2nmcDQTxBg0JSU+D7x8vQ+L1snGImg4s5p8zW/wOeNbilqyXHFxfwutkuTMRT4MgIsVHx6+bcSFA7m/x8pgvKRYXFJ9ZvlqBVFJDCpEfYIavMDUumry6xNoDTBNnerXYSlFqHz42/hAN/hERiHN00W5u232yznfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476554; c=relaxed/simple;
	bh=nq8MCJzL3asmNbi7Pr0Eb3lj2o3Orkj9Wzhr8YaRNow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3/OG/hBAko4VNoOzParYWvX36J7tgfVV45YM+cnhx4sLUZljUtpc/4qh6aT27YsgE1Wf03BS8AKn6y+3fPA0FkAk3uHf/grgUFetM7jixj8FpCLFB4PUgyewrzhJtLvMnAnYc4IbJZKm735D0BeuaFoGPbqPhe851PbkRQvBkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgZEJHhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgZEJHhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5067C2BBFC;
	Tue, 30 Apr 2024 11:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476554;
	bh=nq8MCJzL3asmNbi7Pr0Eb3lj2o3Orkj9Wzhr8YaRNow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgZEJHhM45K9MfD3dlTfsyFGr4qMDnpGGAvod4abNuCO+EPKA3dsrnCDdMXMgoe7u
	 NbrRiC+lRT5rBragFtLfcL1LqwSWRMKsH38VuMKnD3ExFziLPr2xYSjYD1oFTcbwmT
	 NtrZyxKXdjTaRCszQixRKeVRe1DI/QzdoCkKUEdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mantas Pucka <mantas@8devices.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 069/110] mmc: sdhci-msm: pervent access to suspended controller
Date: Tue, 30 Apr 2024 12:40:38 +0200
Message-ID: <20240430103049.604435951@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Mantas Pucka <mantas@8devices.com>

commit f8def10f73a516b771051a2f70f2f0446902cb4f upstream.

Generic sdhci code registers LED device and uses host->runtime_suspended
flag to protect access to it. The sdhci-msm driver doesn't set this flag,
which causes a crash when LED is accessed while controller is runtime
suspended. Fix this by setting the flag correctly.

Cc: stable@vger.kernel.org
Fixes: 67e6db113c90 ("mmc: sdhci-msm: Add pm_runtime and system PM support")
Signed-off-by: Mantas Pucka <mantas@8devices.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240321-sdhci-mmc-suspend-v1-1-fbc555a64400@8devices.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-msm.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -2831,6 +2831,11 @@ static __maybe_unused int sdhci_msm_runt
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+	host->runtime_suspended = true;
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	/* Drop the performance vote */
 	dev_pm_opp_set_rate(dev, 0);
@@ -2845,6 +2850,7 @@ static __maybe_unused int sdhci_msm_runt
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
+	unsigned long flags;
 	int ret;
 
 	ret = clk_bulk_prepare_enable(ARRAY_SIZE(msm_host->bulk_clks),
@@ -2863,7 +2869,15 @@ static __maybe_unused int sdhci_msm_runt
 
 	dev_pm_opp_set_rate(dev, msm_host->clk_rate);
 
-	return sdhci_msm_ice_resume(msm_host);
+	ret = sdhci_msm_ice_resume(msm_host);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&host->lock, flags);
+	host->runtime_suspended = false;
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return ret;
 }
 
 static const struct dev_pm_ops sdhci_msm_pm_ops = {


