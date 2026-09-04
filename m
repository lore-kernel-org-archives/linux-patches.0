Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241A126AC3;
	Fri,  4 Sep 2026 05:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499741; cv=none; b=RXNW3HuIFYeuJYLOaRxKSIDwIF4b4sGmB0KTnyRIw5dgWDjJiTs+SAsv+TPeHuRSpidb55v3ATttnqCmxeCuzEQh3n0Vw8uDKHpshk5KHYnDrSSZ92bM8O5woyVA8vV7sUo2M4X5Xm72wuc6Ln90JmPZZG5c0nS5GlnXO+yLGgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499741; c=relaxed/simple;
	bh=SuI0mtXaqWxyZOgbTymJ3q5KAbSzYTffjCdL0AoxKmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pscsq1x2L9CRuTR7vtVZpaN0YuHEBoEEB3Xw7YTyCUHc7HFpcDNWu8jloR6CdrHOjTsUZtUcPtwhZ/aJtf8OOf6VSIJxLz8l9RRUOWXz0Hf917SUDR2lLGWvb+q52r52F5SgH4d6hH77vc19+M8P2xT61nRy4XXII1DzxKJVASo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdlRDZr9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdlRDZr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F81F1F00A3D;
	Fri,  4 Sep 2026 05:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499740;
	bh=Jvk3P2YIx2xzogpIeKhZj3w09xcokDwLL3VW7MIGwvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WdlRDZr9mBqODzLJBv8szBBejsWoNPTdLPeu7McTPj9GY+WNHrhiajQgYxzLA4i5F
	 O+MD+u+7BMZVVQrnFRLtfrg086yXKs3wQQRGaAzBxVARukXOFMnwwlanAjgbVQ2QQg
	 zDmHk0OE9JybL4CHR9R84xaYK1eJb4efsn6EmZFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 7.2 523/713] PCI: starfive: Fix resource leaks on error paths in host_init()
Date: Fri,  4 Sep 2026 06:58:11 +0200
Message-ID: <20260904045815.543608405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Tariq <alitariq45892@gmail.com>

commit 22877a061f81c5d58041e384b3131684bec636b9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/plda/pcie-starfive.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/plda/pcie-starfive.c b/drivers/pci/controller/plda/pcie-starfive.c
index 298036c3e7f9..628f8c8d6747 100644
--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -304,12 +304,14 @@ static int starfive_pcie_host_init(struct plda_pcie_rp *plda)
 
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
@@ -379,6 +381,13 @@ static int starfive_pcie_host_init(struct plda_pcie_rp *plda)
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
-- 
2.55.0



