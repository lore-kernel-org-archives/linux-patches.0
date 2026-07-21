Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3759335DA40;
	Tue, 21 Jul 2026 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662387; cv=none; b=lrE8A4MNWx/TuYK+63F8pvaPRPywOx05xvXq68I+/hpmGN16Fu7rrafitc3LQoy9yHgdfDlLF7SHxjfnSOfL5ZmYfiz/zatfrYx9MJlXwejv6vBihB8uxcahn6PQwgSjWExXdS4DAmMvQbl+NREtAvlufqy5tJfRLf97YS3eY7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662387; c=relaxed/simple;
	bh=2I/s97JDKT4QCTZ2PiXzdGr7EanQN0BLEqKbxYMktP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ednEtKEcPxHy7l6cWYupcA0XZT1sgVwV2Zs49UC5GZnrVrR6KbMfSyDG0SLFGVfKyTUGDwjiVTneZaN8wGa+BdnhLeWi6V3/5txr0TLNCmuRiwdomsVHFHZ+OeW7Mh+/KHjgc9HTx0HRwT55X4nlNkXTnpsIDYPX6E9KG20w/CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mmq0dIq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mmq0dIq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2C01F000E9;
	Tue, 21 Jul 2026 19:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662386;
	bh=0q6l5c/hYjOmrCs3FJFk8JAivI6ikGrPSeOfOmsBX3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mmq0dIq76GWYYnPeyY2L1DB/FfarZyIymcbVHFNq6RVIe7RkQrUPlhsGNWv/crczN
	 Fj2YSN3E3JOhSWTg2D5356ffQfVgvBUUjSvDv1uM6p6qUkfytFfuTlZcanvYaoNshH
	 2XjXBHV0fTf1wvtnULxar0LYblPcx6cIhqTPXoo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0426/1276] PCI: qcom: Set max OPP before DBI access during resume
Date: Tue, 21 Jul 2026 17:14:29 +0200
Message-ID: <20260721152455.637241543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 5d27cd149f5120..533782940f2e21 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1508,6 +1508,22 @@ static void qcom_pcie_icc_opp_update(struct qcom_pcie *pcie)
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
@@ -1573,9 +1589,7 @@ static irqreturn_t qcom_pcie_global_irq_thread(int irq, void *data)
 static int qcom_pcie_probe(struct platform_device *pdev)
 {
 	const struct qcom_pcie_cfg *pcie_cfg;
-	unsigned long max_freq = ULONG_MAX;
 	struct device *dev = &pdev->dev;
-	struct dev_pm_opp *opp;
 	struct qcom_pcie *pcie;
 	struct dw_pcie_rp *pp;
 	struct resource *res;
@@ -1658,21 +1672,9 @@ static int qcom_pcie_probe(struct platform_device *pdev)
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
 
@@ -1803,6 +1805,14 @@ static int qcom_pcie_resume_noirq(struct device *dev)
 	int ret;
 
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



