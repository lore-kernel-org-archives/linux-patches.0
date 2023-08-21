Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228601170E
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9928DC433C8;
	Mon, 21 Aug 2023 19:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647485;
	bh=k37WndKbNUeOeDSGMkshATlh3pPCBoy9xSJEupg7dTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABLtaX+NqwD0vqBomJE3pW1G4aZq3WCAaqgZIExpNLkYGhXMFtuRYDV/XekTSZK2j
	 Bb+rddq3N/TfJP/KUpxvyJzWlijwwjxBqgK+Vy9qaR1FX57iUczxVmWvyME2VXMRqv
	 mI7ke4NqKi8WSx9wu7b9y8RkQUPRHyOrvCQa1pkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/194] cpuidle: psci: Move enabling OSI mode after power domains creation
Date: Mon, 21 Aug 2023 21:39:42 +0200
Message-ID: <20230821194122.843293083@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maulik Shah <quic_mkshah@quicinc.com>

[ Upstream commit 12acb348fa4528a4203edf1cce7a3be2c9af2279 ]

A switch from OSI to PC mode is only possible if all CPUs other than the
calling one are OFF, either through a call to CPU_OFF or not yet booted.

Currently OSI mode is enabled before power domains are created. In cases
where CPUidle states are not using hierarchical CPU topology the bail out
path tries to switch back to PC mode which gets denied by firmware since
other CPUs are online at this point and creates inconsistent state as
firmware is in OSI mode and Linux in PC mode.

This change moves enabling OSI mode after power domains are created,
this would makes sure that hierarchical CPU topology is used before
switching firmware to OSI mode.

Cc: stable@vger.kernel.org
Fixes: 70c179b49870 ("cpuidle: psci: Allow PM domain to be initialized even if no OSI mode")
Signed-off-by: Maulik Shah <quic_mkshah@quicinc.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-psci-domain.c | 39 +++++++++------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-psci-domain.c b/drivers/cpuidle/cpuidle-psci-domain.c
index 1fca250d5dece..f5d4359555d77 100644
--- a/drivers/cpuidle/cpuidle-psci-domain.c
+++ b/drivers/cpuidle/cpuidle-psci-domain.c
@@ -117,20 +117,6 @@ static void psci_pd_remove(void)
 	}
 }
 
-static bool psci_pd_try_set_osi_mode(void)
-{
-	int ret;
-
-	if (!psci_has_osi_support())
-		return false;
-
-	ret = psci_set_osi_mode(true);
-	if (ret)
-		return false;
-
-	return true;
-}
-
 static void psci_cpuidle_domain_sync_state(struct device *dev)
 {
 	/*
@@ -149,15 +135,12 @@ static int psci_cpuidle_domain_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *node;
-	bool use_osi;
+	bool use_osi = psci_has_osi_support();
 	int ret = 0, pd_count = 0;
 
 	if (!np)
 		return -ENODEV;
 
-	/* If OSI mode is supported, let's try to enable it. */
-	use_osi = psci_pd_try_set_osi_mode();
-
 	/*
 	 * Parse child nodes for the "#power-domain-cells" property and
 	 * initialize a genpd/genpd-of-provider pair when it's found.
@@ -167,33 +150,37 @@ static int psci_cpuidle_domain_probe(struct platform_device *pdev)
 			continue;
 
 		ret = psci_pd_init(node, use_osi);
-		if (ret)
-			goto put_node;
+		if (ret) {
+			of_node_put(node);
+			goto exit;
+		}
 
 		pd_count++;
 	}
 
 	/* Bail out if not using the hierarchical CPU topology. */
 	if (!pd_count)
-		goto no_pd;
+		return 0;
 
 	/* Link genpd masters/subdomains to model the CPU topology. */
 	ret = dt_idle_pd_init_topology(np);
 	if (ret)
 		goto remove_pd;
 
+	/* let's try to enable OSI. */
+	ret = psci_set_osi_mode(use_osi);
+	if (ret)
+		goto remove_pd;
+
 	pr_info("Initialized CPU PM domain topology using %s mode\n",
 		use_osi ? "OSI" : "PC");
 	return 0;
 
-put_node:
-	of_node_put(node);
 remove_pd:
+	dt_idle_pd_remove_topology(np);
 	psci_pd_remove();
+exit:
 	pr_err("failed to create CPU PM domains ret=%d\n", ret);
-no_pd:
-	if (use_osi)
-		psci_set_osi_mode(false);
 	return ret;
 }
 
-- 
2.40.1



