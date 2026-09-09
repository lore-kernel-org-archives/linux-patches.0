Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC10B579814;
	Wed,  9 Sep 2026 14:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964707; cv=none; b=djnNwgY44n18K3CG79DS/d78n4a0qAfKx8/vkFBdmsLCVSXk1m9iIYhtiO7uuAzMx7kMlnlO5FArr351nGL66rPOVtyogttg52fXcczIsjGe88W5gX/8US3ec19AN8QP2hDFGV0LQOooXjfl33dIJhxdER7hCwEz4cHS8YQqdUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964707; c=relaxed/simple;
	bh=uMWy/FNcGGaL/HgYfWs4Yez58y4p5G49R9hI9Z00JJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6uivmt2cnirnbx6FrKTX1Eo583fZFFLWMiITJ8ZK/kgcuoAnQ7q5WDCnJcPyeXfqcCEhE8BQ+RCuXHggq2sKZV9txnDB2XIS4FGySaQ+EkUCMfajTjeBZPvK7/bKnTA9tM1UmGFpQZ01l74MbNmtUnTL5NJhVPgpLpe4pHFkhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UukPOpOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UukPOpOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70831F00A3A;
	Wed,  9 Sep 2026 14:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964705;
	bh=3faAgOwU02aX/dHXecjg8+d6gEn99ZvSI7r8f1utX0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UukPOpOFCqWYKoNlRmGhahfRaPrTPG1MUaXc/1ZVFgeCwlJlGv5sQv5mbPqtSmqYu
	 U6WzilInORGZ2NI/G1C5Iyvzw0lq58dyqIi7eD+rLNEzRI0GSkOwKxs7gcTZ+YtERa
	 7r0OcpStKddWLit8uBSvgkWG/hEmYpJaZZGAXxjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 513/583] PCI: starfive: Fix resource leaks on error paths in host_init()
Date: Wed,  9 Sep 2026 15:43:18 +0200
Message-ID: <20260909134255.511327659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Ali Tariq <alitariq45892@gmail.com>

[ Upstream commit 22877a061f81c5d58041e384b3131684bec636b9 ]

starfive_pcie_host_init() acquires the PHY, clocks/resets, and an
optional regulator in sequence, but does not correctly unwind these
resources when a later step fails.

If starfive_pcie_clk_rst_init() fails after the PHY has already been
successfully enabled, the function returns directly without disabling
the PHY, leaking it and leaving it powered.

If regulator_enable() fails for the optional vpcie3v3 regulator, the
failure is only logged; the function falls through and returns
success, leaving the driver believing the regulator is enabled while
continuing to configure PCIe hardware that may be unpowered. This
also leaves the clocks and PHY enabled with nothing to clean them up.

Disable the PHY on the clk/reset failure path, and disable the
clocks/resets and PHY, then return the error, if the regulator fails
to enable.

Build-tested and boot-tested on StarFive VisionFive 2 v1.2A

Fixes: 05a75df4182e ("PCI: starfive: Use regulator APIs to control the 3v3 power supply of PCIe slots")
Fixes: 39b91eb40c6a ("PCI: starfive: Add JH7110 PCIe controller")
Signed-off-by: Ali Tariq <alitariq45892@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260716102053.185276-1-alitariq45892@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/plda/pcie-starfive.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -304,12 +304,14 @@ static int starfive_pcie_host_init(struc
 
 	ret = starfive_pcie_clk_rst_init(pcie);
 	if (ret)
-		return ret;
+		goto err_disable_phy;
 
 	if (pcie->vpcie3v3) {
 		ret = regulator_enable(pcie->vpcie3v3);
-		if (ret)
+		if (ret) {
 			dev_err_probe(dev, ret, "failed to enable vpcie3v3 regulator\n");
+			goto err_clk_rst;
+		}
 	}
 
 	if (pcie->reset_gpio)
@@ -379,6 +381,13 @@ static int starfive_pcie_host_init(struc
 		dev_info(dev, "port link down\n");
 
 	return 0;
+
+err_clk_rst:
+	starfive_pcie_clk_rst_deinit(pcie);
+err_disable_phy:
+	starfive_pcie_disable_phy(pcie);
+
+	return ret;
 }
 
 static const struct plda_pcie_host_ops sf_host_ops = {


