Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9613590AB;
	Tue, 16 Dec 2025 12:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887721; cv=none; b=ru/aX/6thcQbls3w7+oU4jK8TQ5H0H4rEeBt1nbCR8SVsFOzaRXfKaXjWLkjz3hThU+M4XV7lFxPXzv+p1B/KSNXo6liFracpzo8RrLTFbLBdoIN/rKGSPaJ4tmHnK1Bg/KEVPqs+glua9AKn+7/euTYMEeV2gCUaRuVgI5DUEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887721; c=relaxed/simple;
	bh=OzDtLYZXxwBFTUhu1BTufURPTQ3Qy80/VrBwiic9eEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjnzqLWmEV23Y5IDiWzYem9ludyrYaPpjPBL1o1HLU2YVGs92bgdKkyBLriNPJU/rmThTY1gBJLxHcID6GrjdsYvtYR1KRoWLlbVqlGWEfx0mZvQYG150ZskaPGgO2xk+m9v6stILau21wCV+BAsxgg+xb0GXXO/VaHZCp3quYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqUkIH78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqUkIH78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0111C4CEF1;
	Tue, 16 Dec 2025 12:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887721;
	bh=OzDtLYZXxwBFTUhu1BTufURPTQ3Qy80/VrBwiic9eEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqUkIH78NVnKiyX95OOqbxkCd951kzV5Ue0ooCUi5AuoYXUk8PLzF+ZQGfT6//Hog
	 52CCJuihLEID+pPl/zbT472fb2Q/obCTh3Bda2MjzoWjJI0alBKJw5cbFKiimyzC8A
	 MsLdScxt/5oQ8qUk9UvXwESxuqZ8QrM5UHmFkb3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 274/614] PCI: keystone: Exit ks_pcie_probe() for invalid mode
Date: Tue, 16 Dec 2025 12:10:41 +0100
Message-ID: <20251216111411.302612746@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index eb00aa3807220..25b8193ffbcf1 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1337,6 +1337,8 @@ static int ks_pcie_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(dev, "INVALID device type %d\n", mode);
+		ret = -EINVAL;
+		goto err_get_sync;
 	}
 
 	ks_pcie_enable_error_irq(ks_pcie);
-- 
2.51.0



