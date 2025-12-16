Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E69350A38;
	Tue, 16 Dec 2025 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885747; cv=none; b=MyD+NJbHsiCme3CyxlXXA4e+X+oRpGyZ4y5FxrTB05z5Zv+9oN7ZCZfJubMIlfg28/P+flUyy0Uo84nEbqRCKv3iQFEhT2XndGpNcXDn5D1GKRQ492doVDGOPLj5bDfZVJjWrKJKMmmexCRhpkawbxjoNcs3+NsluxFJ93tLHPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885747; c=relaxed/simple;
	bh=w2rIzQaaapwesd3gLaz47DBv24p4L63MgFDq9zAAnjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0CXVPlqanbj6chsARw9nbjJuzMP9U5yUoA+pt2FiTyMEchxUI3DY8L1XoF3coUY9x8x1MjhszO7bstQvVK/zU5qkfOIGmvff6Ge06L88S1Z2CUdUQrxbTWuSIYtxxOWy0kHTiMVEcANVNGjG+lR5K/Qz3JHwoCwtpHxwOjUxtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrpZULCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrpZULCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D990C4CEF1;
	Tue, 16 Dec 2025 11:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885746;
	bh=w2rIzQaaapwesd3gLaz47DBv24p4L63MgFDq9zAAnjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrpZULCC4SmjRNqp3qWPRSZk33WWfUQzSHQMjrklZCzE0VPX+3AF5LHxwA7T90ryd
	 txKHrJA2NnCybrVbodS3lzlk1Kjcgp+pbUR6oEERAF9ePRQjQspU0IOV0TCSWbQWQ/
	 rtBIsSIaUHupSJEr8cMoU7n0oiDVUDA5tVa0W8hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 232/507] PCI: keystone: Exit ks_pcie_probe() for invalid mode
Date: Tue, 16 Dec 2025 12:11:13 +0100
Message-ID: <20251216111353.907604131@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 95d9c3f0e4546eaec0977f3b387549a8463cd49f ]

Commit under Fixes introduced support for PCIe EP mode on AM654x platforms.
When the mode happens to be either "DW_PCIE_RC_TYPE" or "DW_PCIE_EP_TYPE",
the PCIe Controller is configured accordingly. However, when the mode is
neither of them, an error message is displayed, but the driver probe
succeeds. Since this "invalid" mode is not associated with a functional
PCIe Controller, the probe should fail.

Fix the behavior by exiting "ks_pcie_probe()" with the return value of
"-EINVAL" in addition to displaying the existing error message when the
mode is invalid.

Fixes: 23284ad677a9 ("PCI: keystone: Add support for PCIe EP in AM654x Platforms")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251029080547.1253757-4-s-vadapalli@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 21808a9e51586..ed0f6cf3df6b2 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1338,6 +1338,8 @@ static int ks_pcie_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(dev, "INVALID device type %d\n", mode);
+		ret = -EINVAL;
+		goto err_get_sync;
 	}
 
 	ks_pcie_enable_error_irq(ks_pcie);
-- 
2.51.0



