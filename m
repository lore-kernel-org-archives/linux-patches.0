Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A09281357;
	Wed, 25 Feb 2026 01:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984043; cv=none; b=JwSA248/oPYzsxxmnxHQZ2qGr72K2tZvy4xZAIYjy735omQTcZS8t4CDkr8zrdV1k5JZjLj2kNatSDAsMjmVHEcUBneEmhoDaEulbzqFW6X1YUGNVGpyPU/tJFxxgliqHmSquz7OYnPO5WRvZi7WuUdD2RtqFDnv+hP9GACIwyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984043; c=relaxed/simple;
	bh=smSHnupjDVKXrQdNWBSfk1PCtc+7SOTV5h6jYnNSMOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irOI9Y+t0oEg5v6rq9Wmrkl9vEr+5EOepHpLL34JZe/iyfzLUAwXsWg7PBUhSh+6iFNllK0kI2WItnHn9W1PSZp/MSYFwxvdxeGbZqA/f7DVf6hioE11h1HMpNzV8FBJ9ww0jHL/O8uPsYkyycgbaalnoJ6/3d/Gx8giit0DUzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZ2FT4iO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZ2FT4iO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5847C116D0;
	Wed, 25 Feb 2026 01:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984042;
	bh=smSHnupjDVKXrQdNWBSfk1PCtc+7SOTV5h6jYnNSMOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZ2FT4iOuisOKBTcDNjlMYxJ63XPGeqNImg5Dnv6z1p+uSBt9DQMUKjceLIgaNhuy
	 awcc9YhucQ2FM8CKkt26mlr1VbdOCnYMn2/2EW8aB0FoVozxOp72HjNZmAbbK/gDJS
	 qeHfG2qcxX1htejp4vfcpQQsSQ9efWBtYrs2VCj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Han Gao <gaohan@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 243/641] PCI: sophgo: Disable L0s and L1 on Sophgo 2044 PCIe Root Ports
Date: Tue, 24 Feb 2026 17:19:29 -0800
Message-ID: <20260225012354.757324035@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



