Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1AA4CF489;
	Sat, 17 Oct 2026 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252557; cv=none; b=LspUcC5l28saYSobg+svhWhQzMLOo+OkIcE8lp0BPi6fGEbMHjyoJySNyQcaxuU1IyfTZqYswOOP70BXr2nxjzFUWylQQ9U4z0pL8r7zoRePv1c0cfweJ0On0zj5M6vGHD7YrgGjqDN/gwtN5a03EVgyXpidld1iJQOithWyH8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252557; c=relaxed/simple;
	bh=jcGvB7bTfSg1ZQNG6wPHXv3Iup6WUCCywW7CaVFfWtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9bg3zSSUaPwcC9KDFx7E27Oyf4RxiIGnMaC6AlcBadhHD0n3tZ69mMekKbRDz7MRCmonSsTzYz/k+GKQyAbHBkVBpW7RFs6jBrI5RFm2n9ubbBtNcWnPbw/7VwxiAwulA+eUK86JhFZj06Z+ZpI4WmgGzRjr94uJzWFPSX/LXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fk1PGVqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fk1PGVqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B5D1F000C4;
	Sat, 17 Oct 2026 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252556;
	bh=kGQrt1JKP70y+PmWt/IX54yVw6KJDjz8IkS+PeFcgRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fk1PGVqfSYx8rM0YwhW+ZR99wEr8gR5K0uhO7U5jYwyhzHOCqGREI7O/xk2Ou+unY
	 OVaJXAvsRQCSnZoOIamu7QZmJB8quOOQrSk7Rab70zcxguBJF7pJhfqPYGixitt5Xe
	 z8Gn5XGAF67Bk77XBKk0TuJt+sbO8m++YDuy4AhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 04/52] PCI: dwc: Return -ENODEV from dw_pcie_wait_for_link() if device is not found
Date: Sat, 17 Oct 2026 17:54:05 +0200
Message-ID: <20261017155104.986314085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 1bcf245c837bc66fdaddea222bab9eb5c978a9d7 ]

The dw_pcie_wait_for_link() function waits up to 1 second for the PCIe link
to come up and returns -ETIMEDOUT for all failures without distinguishing
cases where no device is present on the bus. But the callers may want to
just skip the failure if the device is not found on the bus and handle
failure for other reasons.

So after timeout, if the LTSSM is in Detect.Quiet or Detect.Active state,
return -ENODEV to indicate the callers that the device is not found on the
bus and return -ETIMEDOUT otherwise.

Also add kernel doc to document the parameter and return values.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Tested-by: Richard Zhu <hongxing.zhu@nxp.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260120-pci-dwc-suspend-rework-v4-1-2f32d5082549@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 2c1dd6ffa27db..8635d8921d9b3 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -692,9 +692,16 @@ void dw_pcie_disable_atu(struct dw_pcie *pci, u32 dir, int index)
 	dw_pcie_writel_atu(pci, dir, index, PCIE_ATU_REGION_CTRL2, 0);
 }
 
+/**
+ * dw_pcie_wait_for_link - Wait for the PCIe link to be up
+ * @pci: DWC instance
+ *
+ * Returns: 0 if link is up, -ENODEV if device is not found, -ETIMEDOUT if the
+ * link fails to come up for other reasons.
+ */
 int dw_pcie_wait_for_link(struct dw_pcie *pci)
 {
-	u32 offset, val;
+	u32 offset, val, ltssm;
 	int retries;
 
 	/* Check if the link is up or not */
@@ -706,6 +713,17 @@ int dw_pcie_wait_for_link(struct dw_pcie *pci)
 	}
 
 	if (retries >= PCIE_LINK_WAIT_MAX_RETRIES) {
+		/*
+		 * If the link is in Detect.Quiet or Detect.Active state, it
+		 * indicates that no device is detected.
+		 */
+		ltssm = dw_pcie_get_ltssm(pci);
+		if (ltssm == DW_PCIE_LTSSM_DETECT_QUIET ||
+		    ltssm == DW_PCIE_LTSSM_DETECT_ACT) {
+			dev_info(pci->dev, "Device not found\n");
+			return -ENODEV;
+		}
+
 		dev_info(pci->dev, "Phy link never came up\n");
 		return -ETIMEDOUT;
 	}
-- 
2.53.0



