Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5928918DB2A;
	Wed, 25 Feb 2026 01:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983176; cv=none; b=SXAIRvJdf0KSqXGUYgySC9n/FMZy0Jicupr8dQQnjh66edOGLpgDBm/uQiOD6XlvCsGEPnFXLeMJxDYmEGe9Mqaeiwe99ctxapDyQSLt33OHHKef2/VpdY/MfHO1L2ZdV8Hh48PYjIsm3DuPHCXKUVLq0PEeS0B11rVv+4F0Mtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983176; c=relaxed/simple;
	bh=f0uM4oO8tFMz3BE708jldQeZpbPqVkJ3xZeUU8a+Hik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7jnb6T+TPlrM5C+avXPHJ+foOshBMGCed6MtExgylPsVJWj7Jh2itcjOSUTxf+aLmtkJjDh8cTK7l6ERQyf/UmZYDWQFLKvcRpAsxSOi6iVvFJZtXDcfsOtTU4jNGG49L9KuL4YqEoSqa155SVqG3NdHRcbh+8aqxWxnEy6O9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyccA5Sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyccA5Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1679CC116D0;
	Wed, 25 Feb 2026 01:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983176;
	bh=f0uM4oO8tFMz3BE708jldQeZpbPqVkJ3xZeUU8a+Hik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyccA5SwYyEJsjnQdRZH/e+YbcF8X0/Jf5YcLTuU8LDJzONGMe+V6fy4QcAjTIImj
	 /1FrH9nZZAERwv/KDUbu/5WHWWvoIcZF2QwGihk+qN7s5QJJm2S+7I6SdEbwNhZSBc
	 Kv8Sk2qKpTcHDRwyKfpipZ0A2iICG7h+QYH+GVhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Han Gao <gaohan@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 328/781] PCI: sophgo: Disable L0s and L1 on Sophgo 2044 PCIe Root Ports
Date: Tue, 24 Feb 2026 17:17:17 -0800
Message-ID: <20260225012407.748953155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit 613f3255a35a95f52575dd8c60b7ac9d711639ce ]

Sophgo 2044 Root Ports advertise L0 and L1 capabilities without supporting
them. Since commit f3ac2ff14834 ("PCI/ASPM: Enable all ClockPM and ASPM
states for devicetree platforms") force enabled ASPM on all device tree
platforms, the issue became evident and the SG2044 Root Port started
breaking.

Hence, disable the L0s and L1 capabilities in the LINKCAP register for the
SG2044 Root Ports, so that these states won't get enabled.

Fixes: 467d9c0348d6 ("PCI: dwc: Add Sophgo SG2044 PCIe controller driver in Root Complex mode")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
[mani: reworded description and corrected fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Han Gao <gaohan@iscas.ac.cn>
Link: https://patch.msgid.link/20260109040756.731169-1-inochiama@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-sophgo.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-sophgo.c b/drivers/pci/controller/dwc/pcie-sophgo.c
index ad4baaa34ffa1..044088898819e 100644
--- a/drivers/pci/controller/dwc/pcie-sophgo.c
+++ b/drivers/pci/controller/dwc/pcie-sophgo.c
@@ -161,6 +161,22 @@ static void sophgo_pcie_msi_enable(struct dw_pcie_rp *pp)
 	raw_spin_unlock_irqrestore(&pp->lock, flags);
 }
 
+static void sophgo_pcie_disable_l0s_l1(struct dw_pcie_rp *pp)
+{
+	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
+	u32 offset, val;
+
+	offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+
+	dw_pcie_dbi_ro_wr_en(pci);
+
+	val = dw_pcie_readl_dbi(pci, PCI_EXP_LNKCAP + offset);
+	val &= ~(PCI_EXP_LNKCAP_ASPM_L0S | PCI_EXP_LNKCAP_ASPM_L1);
+	dw_pcie_writel_dbi(pci, PCI_EXP_LNKCAP + offset, val);
+
+	dw_pcie_dbi_ro_wr_dis(pci);
+}
+
 static int sophgo_pcie_host_init(struct dw_pcie_rp *pp)
 {
 	int irq;
@@ -171,6 +187,8 @@ static int sophgo_pcie_host_init(struct dw_pcie_rp *pp)
 
 	irq_set_chained_handler_and_data(irq, sophgo_pcie_intx_handler, pp);
 
+	sophgo_pcie_disable_l0s_l1(pp);
+
 	sophgo_pcie_msi_enable(pp);
 
 	return 0;
-- 
2.51.0



