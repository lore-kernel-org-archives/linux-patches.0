Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156551E009A;
	Tue,  3 Dec 2024 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241756; cv=none; b=P9eWzQKno36BxccDULfN6yhwRfK7xI+ncPfolj92m2dz6OyttfrmTgpHb/cIH2xDLhAhX4WbO3gzZK1Yi1qdfQYt4IUcP3FVsUN7rZjAgyOF1cDyBNZZ1eveS6C3ii4DysGhJGvOyDn+mGdBIIqUjDKhOchrMjtRFQb5tSuZ67o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241756; c=relaxed/simple;
	bh=pbW7YkKVmPdebeADKx2cKBYHGn5QP8tajEHxz2ZzlA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ERCpW+CXL8U/931oiEhePf8pz5WcnXD6GovYLSWGtDs3Ie+li+k/04O/FannCH3+fhKdclQDrkBlKFr2Z+SVTUzMkTqXw0CpGrrriBq8ELhyFzb4T7PQyaordZbH4ylXsMUc5NjH3wB3ZHh/2/taZQHydyISUk910viAF9hrZbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mH0g5m9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mH0g5m9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D660C4CECF;
	Tue,  3 Dec 2024 16:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241755;
	bh=pbW7YkKVmPdebeADKx2cKBYHGn5QP8tajEHxz2ZzlA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mH0g5m9x6rEskhvjYrI8k7QTKdVpnBZ9hoizQvSE1TlJSV0fcTrx+EmuxSWnK9c2R
	 mCPwwkiJIo52o6GUVd/gvkIevrOcG8cvuIw48vSvL28hgbjausEvWZ+tBU9+TvlNPg
	 F5DEFbMhLPPhHliZ0we4gLDOIQbFt+f0ZjEnr4nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 505/826] PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds
Date: Tue,  3 Dec 2024 15:43:52 +0100
Message-ID: <20241203144803.457823627@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 22a9120479a40a56c13c5e473a0100fad2e017c0 ]

According to Section 2.2 of the PCI Express Card Electromechanical
Specification (Revision 5.1), in order to ensure that the power and the
reference clock are stable, PERST# has to be deasserted after a delay of
100 milliseconds (TPVPERL).

Currently, it is being assumed that the power is already stable, which
is not necessarily true.

Hence, change the delay to PCIE_T_PVPERL_MS to guarantee that power and
reference clock are stable.

Fixes: f3e25911a430 ("PCI: j721e: Add TI J721E PCIe driver")
Fixes: f96b69713733 ("PCI: j721e: Use T_PERST_CLK_US macro")
Link: https://lore.kernel.org/r/20241104074420.1862932-1-s-vadapalli@ti.com
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 26 ++++++++++------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 284f2e0e4d261..e091c3e55b5c6 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -572,15 +572,14 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 		pcie->refclk = clk;
 
 		/*
-		 * The "Power Sequencing and Reset Signal Timings" table of the
-		 * PCI Express Card Electromechanical Specification, Revision
-		 * 5.1, Section 2.9.2, Symbol "T_PERST-CLK", indicates PERST#
-		 * should be deasserted after minimum of 100us once REFCLK is
-		 * stable. The REFCLK to the connector in RC mode is selected
-		 * while enabling the PHY. So deassert PERST# after 100 us.
+		 * Section 2.2 of the PCI Express Card Electromechanical
+		 * Specification (Revision 5.1) mandates that the deassertion
+		 * of the PERST# signal should be delayed by 100 ms (TPVPERL).
+		 * This shall ensure that the power and the reference clock
+		 * are stable.
 		 */
 		if (gpiod) {
-			fsleep(PCIE_T_PERST_CLK_US);
+			msleep(PCIE_T_PVPERL_MS);
 			gpiod_set_value_cansleep(gpiod, 1);
 		}
 
@@ -671,15 +670,14 @@ static int j721e_pcie_resume_noirq(struct device *dev)
 			return ret;
 
 		/*
-		 * The "Power Sequencing and Reset Signal Timings" table of the
-		 * PCI Express Card Electromechanical Specification, Revision
-		 * 5.1, Section 2.9.2, Symbol "T_PERST-CLK", indicates PERST#
-		 * should be deasserted after minimum of 100us once REFCLK is
-		 * stable. The REFCLK to the connector in RC mode is selected
-		 * while enabling the PHY. So deassert PERST# after 100 us.
+		 * Section 2.2 of the PCI Express Card Electromechanical
+		 * Specification (Revision 5.1) mandates that the deassertion
+		 * of the PERST# signal should be delayed by 100 ms (TPVPERL).
+		 * This shall ensure that the power and the reference clock
+		 * are stable.
 		 */
 		if (pcie->reset_gpio) {
-			fsleep(PCIE_T_PERST_CLK_US);
+			msleep(PCIE_T_PVPERL_MS);
 			gpiod_set_value_cansleep(pcie->reset_gpio, 1);
 		}
 
-- 
2.43.0



