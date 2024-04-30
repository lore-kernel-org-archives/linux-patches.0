Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6731412EBE8;
	Tue, 30 Apr 2024 11:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475655; cv=none; b=nfF2sXvd8ZkY2kDep4Eit6oEl7pmOr13ylMMswuhvXonnNOfWpWWq1OYlux/3YDkCSGHhu11ySvDvNa81/5gQNrTBAF1S80ckv+c/+OIR9bgsZ5jow2r41OchxsrnHeKAMYt/Cwkjdn01wppCS/px1cuqq13T00S+S7HFY/3nw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475655; c=relaxed/simple;
	bh=dJEbUlXroSbfTZwJizSqMqyfwvKwjtK2slvIWPWd0pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQhGB3t8XBB3ESh2kAGA3greFhwidzpcXfAO/9dhCEpKpq4OHbNojiroLWx52Vxuh/aZZGtk1+l0bmQYCAZ4yx6jQqvM9Il5wdKAScHToFG2j4HIrwfz5sRpqhcn4pG2nvbFc/Zcz7FZQf2hVhJX/d6DfMJrkE1OrM2srmKhpak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ysdw0rM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ysdw0rM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E5CC4AF1C;
	Tue, 30 Apr 2024 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475655;
	bh=dJEbUlXroSbfTZwJizSqMqyfwvKwjtK2slvIWPWd0pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Ysdw0rMDHG5BJEDCGVdDwOekZHxP9t1IjT9ZAXvTOtMpjeS/lMH/8NQO0MvcejFd
	 8aAKcA8gfEVtdQwwK8x/wXF3Eg3h4lOI6TN4pRds7bsFJ35M5AhhX7dML/ZaH03IXi
	 pnHvK+dvZzNkIbzTv4yiYzcIiBApqLw1I7x/fYkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mantas Pucka <mantas@8devices.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 124/186] mmc: sdhci-msm: pervent access to suspended controller
Date: Tue, 30 Apr 2024 12:39:36 +0200
Message-ID: <20240430103101.632586770@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
@@ -2694,6 +2694,11 @@ static __maybe_unused int sdhci_msm_runt
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
@@ -2708,6 +2713,7 @@ static __maybe_unused int sdhci_msm_runt
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
+	unsigned long flags;
 	int ret;
 
 	ret = clk_bulk_prepare_enable(ARRAY_SIZE(msm_host->bulk_clks),
@@ -2726,7 +2732,15 @@ static __maybe_unused int sdhci_msm_runt
 
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


