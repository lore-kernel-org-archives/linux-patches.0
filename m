Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9192DEA6F;
	Fri,  9 Jan 2026 11:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959726; cv=none; b=pLgTnbit3yTZPvQ1jD3YMZe7uIQrN9MMk8Yo4Xd9q2nnUyPT2mQANgKwj2Z6m18ivFiclrhWxeJ8Eaiov6ZR5RB0JOdd4F+voRoqcBF6M/H3WDF1My+q7udk9AEBzvmQW+KpXZVWJeCTNEbUIZy8q2tPEAU55/BbRuhgTgUmCHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959726; c=relaxed/simple;
	bh=4A6U1/DF8RHNNTsnHkN6EBjamHK0Go8oL2P0sdVPaGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhIE+6aq7vqjZYm36+6k2Mzk60l6wZFsGmNaVnQ4UVSd2+MrXpihLXht7nvcnrk00L/RpFL8u7xgHPGZwBme1EC1hymCXddITv3nWY/pG54+THoYC2kLPIVIR3K+wY3fGA+56fFqkASaS+g3u4mLSXwv+cwUuQqrWrM+kKWegVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVwyFi1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVwyFi1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2441CC4CEF1;
	Fri,  9 Jan 2026 11:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959726;
	bh=4A6U1/DF8RHNNTsnHkN6EBjamHK0Go8oL2P0sdVPaGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVwyFi1pWQyoLZ9wSyDwt9c/DAYJym+fanXDFXPTJHywTaZJC3QjlfiCjBZCblHjV
	 i3GyrDTWNd+H1VbToKSs76EyhFBlNr/Br3shaazMAnpzp8Xo2kXn0Y/Useb94FaLWa
	 3J4FZC9ZjHbznZ+RVL9R1EADv+KKaizZFDHxqdxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/737] PCI: keystone: Exit ks_pcie_probe() for invalid mode
Date: Fri,  9 Jan 2026 12:34:53 +0100
Message-ID: <20260109112139.790359881@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9055ce34c636b..7dcb9a9f385ee 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1341,6 +1341,8 @@ static int ks_pcie_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(dev, "INVALID device type %d\n", mode);
+		ret = -EINVAL;
+		goto err_get_sync;
 	}
 
 	ks_pcie_enable_error_irq(ks_pcie);
-- 
2.51.0



