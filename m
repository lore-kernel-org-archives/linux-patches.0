Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CDD2153DF;
	Thu, 12 Dec 2024 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017665; cv=none; b=Jbv4np7qTuVrOJi1UZ4APJHaJbZIUJ3NHKnbUi9nkdBHAUVPALn05O2JG6X4Va7flpnI54xkRH4weqzolhlMbajXGFIoF9TryNGJRuSTlgqiwxNm2jClVPVzc81D5d21zdBp91LEMoIWiNML+PjQ+hs2dTjuD9FB7xgiuCA0IAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017665; c=relaxed/simple;
	bh=1ouPhNZjZP8NVAjRMrqZXY/kDYybr4ue/N+mDUMLMR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AU0vyPzJvjn8GzPxwJ7lLytxNi/AfsQDv2sDKS6WQ7NGF8bs12MlECA74RO7xX6TdBvyeyyBPTsVucSD68okSpehszW8kDMDY7QK2U6LJpFp+D5bOv+uBc23AItxRpikiJeDjckUKzsUe1QrAkGWkPvZnCOAr6XwkoJOXzOUYSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKKBORzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKKBORzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630F4C4CECE;
	Thu, 12 Dec 2024 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017664;
	bh=1ouPhNZjZP8NVAjRMrqZXY/kDYybr4ue/N+mDUMLMR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKKBORzL2E6+eZ/oxHfwENFAUcsK2ijpvl9aSs/WfI6sy5AnsOQCdIUhK8zyFwzDx
	 s5Aw63wcNjwtdTlpxqsVm5Q1VDBzaQEjfoW8S1yTXN/sIxM790TxX578RR4va4Ynpx
	 YB5/tCjCr1qHz/Q1sltGGq/vKEZRM6bYrQWxDLRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/356] soc: fsl: cpm1: qmc: Introduce qmc_init_resource() and its CPM1 version
Date: Thu, 12 Dec 2024 15:56:36 +0100
Message-ID: <20241212144247.667641506@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 727b3ab490a5f5e74fb3f246c9fdfb339d309950 ]

Current code handles the CPM1 version of QMC. Resources initialisations
(i.e. retrieving base addresses and offsets of different parts) will
be slightly different in the QUICC Engine (QE) version. Indeed, in QE
version, some resources need to be allocated and are no more "staticaly"
defined.

In order to prepare the support for QE version, introduce
qmc_init_resource() to initialize those resources and isolate the CPM1
specific operations in a specific function.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20240808071132.149251-27-herve.codina@bootlin.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Stable-dep-of: cb3daa51db81 ("soc: fsl: cpm1: qmc: Set the ret error code on platform_get_irq() failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qmc.c | 47 ++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/soc/fsl/qe/qmc.c b/drivers/soc/fsl/qe/qmc.c
index a5c9cbb99600e..f2bda8658e034 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -1265,11 +1265,38 @@ static irqreturn_t qmc_irq_handler(int irq, void *priv)
 	return IRQ_HANDLED;
 }
 
+static int qmc_cpm1_init_resources(struct qmc *qmc, struct platform_device *pdev)
+{
+	struct resource *res;
+
+	qmc->scc_regs = devm_platform_ioremap_resource_byname(pdev, "scc_regs");
+	if (IS_ERR(qmc->scc_regs))
+		return PTR_ERR(qmc->scc_regs);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "scc_pram");
+	if (!res)
+		return -EINVAL;
+	qmc->scc_pram_offset = res->start - get_immrbase();
+	qmc->scc_pram = devm_ioremap_resource(qmc->dev, res);
+	if (IS_ERR(qmc->scc_pram))
+		return PTR_ERR(qmc->scc_pram);
+
+	qmc->dpram  = devm_platform_ioremap_resource_byname(pdev, "dpram");
+	if (IS_ERR(qmc->dpram))
+		return PTR_ERR(qmc->dpram);
+
+	return 0;
+}
+
+static int qmc_init_resources(struct qmc *qmc, struct platform_device *pdev)
+{
+	return qmc_cpm1_init_resources(qmc, pdev);
+}
+
 static int qmc_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	unsigned int nb_chans;
-	struct resource *res;
 	struct qmc *qmc;
 	int irq;
 	int ret;
@@ -1287,21 +1314,9 @@ static int qmc_probe(struct platform_device *pdev)
 				     "Failed to get TSA serial\n");
 	}
 
-	qmc->scc_regs = devm_platform_ioremap_resource_byname(pdev, "scc_regs");
-	if (IS_ERR(qmc->scc_regs))
-		return PTR_ERR(qmc->scc_regs);
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "scc_pram");
-	if (!res)
-		return -EINVAL;
-	qmc->scc_pram_offset = res->start - get_immrbase();
-	qmc->scc_pram = devm_ioremap_resource(qmc->dev, res);
-	if (IS_ERR(qmc->scc_pram))
-		return PTR_ERR(qmc->scc_pram);
-
-	qmc->dpram  = devm_platform_ioremap_resource_byname(pdev, "dpram");
-	if (IS_ERR(qmc->dpram))
-		return PTR_ERR(qmc->dpram);
+	ret = qmc_init_resources(qmc, pdev);
+	if (ret)
+		return ret;
 
 	/* Parse channels informationss */
 	ret = qmc_of_parse_chans(qmc, np);
-- 
2.43.0



