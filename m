Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8F74F218;
	Thu, 12 Dec 2024 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017668; cv=none; b=CbH1+ily3akQIjcgdmSMAFQOGVNB80wfpz0q5yU3kcANYHZkImodLIjWf/dpT/iBCAg1C4QBztucA2R82JMUo9v3ZHqI6yBQbNX6LA/qAoCioHF6JhnshFpMm6di7fRfrdah6+ewvU0GHK33JI+ZP/UONrLezYocqguieuu+BM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017668; c=relaxed/simple;
	bh=MNDEOSLm6RPmu5rsa8IP8lXLv9icFZqp6habJQP3nO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNHgFmtS9C/5jNAzL3sMT23UGStSfZlzy93S8DqUri5MPXz2Rs4640aZ3BHnnNKeSPY2y0SCi8Vl+rXPI33hRGqJ0FSW8KBMaB3YoGCXEYkJK9qv6Xi8zSxp5VBe6Exi16b6KRBkUTWdTMqkfbl+nSuOxyBfSvF1iuDGxeuVJHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wS4wN4FT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wS4wN4FT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE8BC4CECE;
	Thu, 12 Dec 2024 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017668;
	bh=MNDEOSLm6RPmu5rsa8IP8lXLv9icFZqp6habJQP3nO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wS4wN4FTOVsqikK03zZK1M9wBRhgJZk5adgtyN5yah9yK1s9XudrTnEK4NOahOSRG
	 mRaHATkByfFT1meMZfVXR+UmJk+NWYz3f42wHe9Jrxs4u/haKBelGE3w9NJlHzcyL4
	 A+sPPUfgNOXHs3bD0EcBF1KdF8Sh6chD2IE0U/3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/356] soc: fsl: cpm1: qmc: Introduce qmc_{init,exit}_xcc() and their CPM1 version
Date: Thu, 12 Dec 2024 15:56:37 +0100
Message-ID: <20241212144247.707447945@linuxfoundation.org>
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

[ Upstream commit de5fdb7d14b34f7fea930f2d72cf0241ec679e72 ]

Current code handles the CPM1 version of QMC and initialize the QMC used
SCC. The QUICC Engine (QE) version uses an UCC (Unified Communication
Controllers) instead of the SCC (Serial Communication Controllers) used
in the CPM1 version. These controllers serve the same purpose and are
used in the same way but their inializations are slightly different.

In order to prepare the support for QE version of QMC, introduce
qmc_init_xcc() to initialize theses controllers (UCC in QE and SCC in
CPM1) and isolate the CPM1 specific SCC initialization in a specific
function.

Also introduce qmc_exit_xcc() for consistency to revert operations done
in qmc_init_xcc().

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20240808071132.149251-28-herve.codina@bootlin.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Stable-dep-of: cb3daa51db81 ("soc: fsl: cpm1: qmc: Set the ret error code on platform_get_irq() failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qmc.c | 66 +++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/soc/fsl/qe/qmc.c b/drivers/soc/fsl/qe/qmc.c
index f2bda8658e034..9fa75effcfc06 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -1293,6 +1293,41 @@ static int qmc_init_resources(struct qmc *qmc, struct platform_device *pdev)
 	return qmc_cpm1_init_resources(qmc, pdev);
 }
 
+static int qmc_cpm1_init_scc(struct qmc *qmc)
+{
+	u32 val;
+	int ret;
+
+	/* Connect the serial (SCC) to TSA */
+	ret = tsa_serial_connect(qmc->tsa_serial);
+	if (ret)
+		return dev_err_probe(qmc->dev, ret, "Failed to connect TSA serial\n");
+
+	/* Init GMSR_H and GMSR_L registers */
+	val = SCC_GSMRH_CDS | SCC_GSMRH_CTSS | SCC_GSMRH_CDP | SCC_GSMRH_CTSP;
+	qmc_write32(qmc->scc_regs + SCC_GSMRH, val);
+
+	/* enable QMC mode */
+	qmc_write32(qmc->scc_regs + SCC_GSMRL, SCC_GSMRL_MODE_QMC);
+
+	/* Disable and clear interrupts */
+	qmc_write16(qmc->scc_regs + SCC_SCCM, 0x0000);
+	qmc_write16(qmc->scc_regs + SCC_SCCE, 0x000F);
+
+	return 0;
+}
+
+static int qmc_init_xcc(struct qmc *qmc)
+{
+	return qmc_cpm1_init_scc(qmc);
+}
+
+static void qmc_exit_xcc(struct qmc *qmc)
+{
+	/* Disconnect the serial from TSA */
+	tsa_serial_disconnect(qmc->tsa_serial);
+}
+
 static int qmc_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -1378,29 +1413,18 @@ static int qmc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	/* Connect the serial (SCC) to TSA */
-	ret = tsa_serial_connect(qmc->tsa_serial);
-	if (ret) {
-		dev_err(qmc->dev, "Failed to connect TSA serial\n");
+	/* Init SCC */
+	ret = qmc_init_xcc(qmc);
+	if (ret)
 		return ret;
-	}
 
-	/* Init GMSR_H and GMSR_L registers */
-	qmc_write32(qmc->scc_regs + SCC_GSMRH,
-		    SCC_GSMRH_CDS | SCC_GSMRH_CTSS | SCC_GSMRH_CDP | SCC_GSMRH_CTSP);
-
-	/* enable QMC mode */
-	qmc_write32(qmc->scc_regs + SCC_GSMRL, SCC_GSMRL_MODE_QMC);
-
-	/* Disable and clear interrupts,  set the irq handler */
-	qmc_write16(qmc->scc_regs + SCC_SCCM, 0x0000);
-	qmc_write16(qmc->scc_regs + SCC_SCCE, 0x000F);
+	/* Set the irq handler */
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		goto err_tsa_serial_disconnect;
+		goto err_exit_xcc;
 	ret = devm_request_irq(qmc->dev, irq, qmc_irq_handler, 0, "qmc", qmc);
 	if (ret < 0)
-		goto err_tsa_serial_disconnect;
+		goto err_exit_xcc;
 
 	/* Enable interrupts */
 	qmc_write16(qmc->scc_regs + SCC_SCCM,
@@ -1420,8 +1444,8 @@ static int qmc_probe(struct platform_device *pdev)
 err_disable_intr:
 	qmc_write16(qmc->scc_regs + SCC_SCCM, 0);
 
-err_tsa_serial_disconnect:
-	tsa_serial_disconnect(qmc->tsa_serial);
+err_exit_xcc:
+	qmc_exit_xcc(qmc);
 	return ret;
 }
 
@@ -1435,8 +1459,8 @@ static void qmc_remove(struct platform_device *pdev)
 	/* Disable interrupts */
 	qmc_write16(qmc->scc_regs + SCC_SCCM, 0);
 
-	/* Disconnect the serial from TSA */
-	tsa_serial_disconnect(qmc->tsa_serial);
+	/* Exit SCC */
+	qmc_exit_xcc(qmc);
 }
 
 static const struct of_device_id qmc_id_table[] = {
-- 
2.43.0



