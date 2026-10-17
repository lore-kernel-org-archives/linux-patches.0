Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D856D4CF489;
	Sat, 17 Oct 2026 15:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252560; cv=none; b=hhz+tkr01fZhH+DxZtziXAcuZRmVCesICd5AeyFxs2WESf4ACtgDDrCbb8HfNMiXMksE/sS2cM8+Fm/W/8DgBSTCpohyhCgJS7hJTDd8OuyG6cEi4HROik1vw6eWhtpa3RRo2LHmfWA++Bx2SXdTHbPp8dTnxa9VWhNzbt7bobk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252560; c=relaxed/simple;
	bh=hz40vfn6WzdA+gCGykIQ5uXWv9p9k+tsFUrkVG1c1Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZU15+HKgmtEHGVH6uAthtmswFUPrBKUDgtsgstbXv9+//AOS+eKprKx3MckrAcQ6yCSbJeUijPLYq2l6rs/yDpjjCHwwgkd8epWsNvpf5eoca2qyEkNIyp6nB7Fck23pW5lZD2pHJSgsoWW3gq+yUY0iPPuy35e8yLaHBeNdj3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eovym1GN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eovym1GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E447E1F000C4;
	Sat, 17 Oct 2026 15:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252559;
	bh=9tGeVCF2isDcyKF2ZgpOrVJsSVpGE2Ct/C8tOduFyvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eovym1GNlZfqbOMcKo93y5e3IDgGMwSv9BtX6xpPVK3Ii61UnuTAA0D5fJpNHujJa
	 DF/WszGkCitz+tp8jZA+QtKXgFgy3HE1Fm3A5gEQKN8KlTQQwhSxzr7Ukb09azxf0y
	 PldI+4jHlMVb4KFoEf5wqHMGCf6tlAnRz+9wUxfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 05/52] PCI: dwc: Return -EIO from dw_pcie_wait_for_link() if device is not active
Date: Sat, 17 Oct 2026 17:54:06 +0200
Message-ID: <20261017155105.022848083@linuxfoundation.org>
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

[ Upstream commit 01d16b8afb7afcc17f999f8b4a9b9cfe6c6fae71 ]

There are cases where the PCIe device would be physically connected to the
bus, but the device firmware might not be active. So the LTSSM will
get stuck in POLL.{Active/Compliance} states.

This behavior is common with endpoint devices controlled by the PCI
Endpoint framework, where the device will wait for the user to start its
operation through configfs.

For those cases, print the relevant log and return -EIO to indicate that
the device is present, but not active. This will allow the callers to skip
the failure as the device might become active in the future.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260120-pci-dwc-suspend-rework-v4-2-2f32d5082549@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 8635d8921d9b3..a77d7cde4524b 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -696,8 +696,9 @@ void dw_pcie_disable_atu(struct dw_pcie *pci, u32 dir, int index)
  * dw_pcie_wait_for_link - Wait for the PCIe link to be up
  * @pci: DWC instance
  *
- * Returns: 0 if link is up, -ENODEV if device is not found, -ETIMEDOUT if the
- * link fails to come up for other reasons.
+ * Returns: 0 if link is up, -ENODEV if device is not found, -EIO if the device
+ * is found but not active and -ETIMEDOUT if the link fails to come up for other
+ * reasons.
  */
 int dw_pcie_wait_for_link(struct dw_pcie *pci)
 {
@@ -722,6 +723,16 @@ int dw_pcie_wait_for_link(struct dw_pcie *pci)
 		    ltssm == DW_PCIE_LTSSM_DETECT_ACT) {
 			dev_info(pci->dev, "Device not found\n");
 			return -ENODEV;
+
+		/*
+		 * If the link is in POLL.{Active/Compliance} state, then the
+		 * device is found to be connected to the bus, but it is not
+		 * active i.e., the device firmware might not yet initialized.
+		 */
+		} else if (ltssm == DW_PCIE_LTSSM_POLL_ACTIVE ||
+			   ltssm == DW_PCIE_LTSSM_POLL_COMPLIANCE) {
+			dev_info(pci->dev, "Device found, but not active\n");
+			return -EIO;
 		}
 
 		dev_info(pci->dev, "Phy link never came up\n");
-- 
2.53.0



