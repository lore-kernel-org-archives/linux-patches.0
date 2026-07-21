Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A9740926D;
	Tue, 21 Jul 2026 18:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660144; cv=none; b=nl7FsPdtdUHy2ixZJqhsGIkcD1xbevECZa1fYWBbcN8sktzEZzRL/bVup5+cU/DGU5jC8I+ONFvqDFgmvT0ounoRc7ZB9S2WuC0uQll5v/LXngculIs9ULum79pV4NY86VXt9r0UnKRKYm+WJOvAs+7w7tIC/NI1Boqbqea2Pww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660144; c=relaxed/simple;
	bh=/6+re1FviP6PThHgy3nxelotJUbW3p67Z9qSjCjiX+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueZBoRr0nu6QMkmSBjFCQNqpJ9nCHV1fv9YK4qeyzWxlaBQ/+cY3EYXXe16h27aHsauAbCDwRwoAGcA2UtFOLE6K1MRkZoYX/iuqS8Xh5pKdN8Td42le/FETMpeFo5aAJtD9Pa3zFiWAFVQeVJLAhI1WRCNmH2YUfPCQyc6tFKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yipObuP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yipObuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994471F000E9;
	Tue, 21 Jul 2026 18:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660143;
	bh=IuccSENtN+r+5BVJXv9NWqG7XKVkDudj0rAlAOYD9EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yipObuPbPqPuCkbNkmwexSEFNRUU5Vru6JhdWrRiXc5+4D6ObDest7fm6wjykoS3
	 uZFT/EMOLfAfFnlJYRW4auLQJ/GL3tCUNWs4zDXjsHJYfrMQaw763t3snAniyI0Flp
	 dpOoXocIA7gKgtU56kCIFzqog8sz18fA3qWfrJnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0866/2077] PCI: qcom: Set max OPP before DBI access during resume
Date: Tue, 21 Jul 2026 17:08:59 +0200
Message-ID: <20260721152613.215183086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <qiang.yu@oss.qualcomm.com>

[ Upstream commit 5dc31cd4a91a7f006d23efa97a5594a7e3ac7790 ]

During resume, qcom_pcie_icc_opp_update() may access DBI registers before
the OPP votes are restored, triggering NoC errors.

Set the PCIe controller to the maximum OPP first in resume_noirq(), then
proceed with link/DBI accesses. The OPP is later updated again based on
the actual link bandwidth requirements.

Introduce a helper to reuse the max-OPP setup code and share it with
probe().

Fixes: 5b6272e0efd5 ("PCI: qcom: Add OPP support to scale performance")
Signed-off-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
[mani: commit log and error log rewording]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260416-setmaxopp-v1-1-6a74e2d945a0@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 42 ++++++++++++++++----------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 7d8eaef436efec..8604aa564dce67 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1613,6 +1613,22 @@ static void qcom_pcie_icc_opp_update(struct qcom_pcie *pcie)
 	}
 }
 
+static int qcom_pcie_set_max_opp(struct device *dev)
+{
+	unsigned long max_freq = ULONG_MAX;
+	struct dev_pm_opp *opp;
+	int ret;
+
+	opp = dev_pm_opp_find_freq_floor(dev, &max_freq);
+	if (IS_ERR(opp))
+		return PTR_ERR(opp);
+
+	ret = dev_pm_opp_set_opp(dev, opp);
+	dev_pm_opp_put(opp);
+
+	return ret;
+}
+
 static int qcom_pcie_link_transition_count(struct seq_file *s, void *data)
 {
 	struct qcom_pcie *pcie = (struct qcom_pcie *)dev_get_drvdata(s->private);
@@ -1851,9 +1867,7 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	struct qcom_pcie_perst *perst, *tmp_perst;
 	struct qcom_pcie_port *port, *tmp_port;
 	const struct qcom_pcie_cfg *pcie_cfg;
-	unsigned long max_freq = ULONG_MAX;
 	struct device *dev = &pdev->dev;
-	struct dev_pm_opp *opp;
 	struct qcom_pcie *pcie;
 	struct dw_pcie_rp *pp;
 	struct resource *res;
@@ -1957,21 +1971,9 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	 * probe(), OPP will be updated using qcom_pcie_icc_opp_update().
 	 */
 	if (!ret) {
-		opp = dev_pm_opp_find_freq_floor(dev, &max_freq);
-		if (IS_ERR(opp)) {
-			ret = PTR_ERR(opp);
-			dev_err_probe(pci->dev, ret,
-				      "Unable to find max freq OPP\n");
-			goto err_pm_runtime_put;
-		} else {
-			ret = dev_pm_opp_set_opp(dev, opp);
-		}
-
-		dev_pm_opp_put(opp);
+		ret = qcom_pcie_set_max_opp(dev);
 		if (ret) {
-			dev_err_probe(pci->dev, ret,
-				      "Failed to set OPP for freq %lu\n",
-				      max_freq);
+			dev_err_probe(dev, ret, "Failed to set max OPP\n");
 			goto err_pm_runtime_put;
 		}
 
@@ -2106,6 +2108,14 @@ static int qcom_pcie_resume_noirq(struct device *dev)
 		return 0;
 
 	if (pm_suspend_target_state != PM_SUSPEND_MEM) {
+		if (pcie->use_pm_opp) {
+			ret = qcom_pcie_set_max_opp(dev);
+			if (ret) {
+				dev_err(dev, "Failed to set max OPP: %d\n", ret);
+				return ret;
+			}
+		}
+
 		ret = icc_enable(pcie->icc_cpu);
 		if (ret) {
 			dev_err(dev, "Failed to enable CPU-PCIe interconnect path: %d\n", ret);
-- 
2.53.0



