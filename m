Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF93B53A7;
	Fri,  6 Dec 2024 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497697; cv=none; b=eqgDuclg3eG2tvmyJswox975kayLbvGUen+WbB+VWFU52ycca0CpMmmQIR6G8hd80RC+bry+JVzIXWj7B/l0e4PxtnHVNm4HLqU7ty83/i8NpoFsPsy6JeoUT85M7I/b0LabL4PzhAoQJz1VBjfAmHEupD1EKx7j5fndKUxyB9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497697; c=relaxed/simple;
	bh=rwdleYKYcjXOxF5dXW+heraXgOuzK58KgOX9yvFTkSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oS0XF1fbNhHzfSEaoKNfyGx8xzHa/ULSPRJcGuRe7lmcyBtXJNK1vreH1ubDdL+ogBL9Rxh0eMapie6N/OOz/fEMEpt3N4jssfk5u2YMIR57bAxI0WklegTqilXBPwKIpTez9047js595lgO2kpOI2DUaXfHWiFST2RCpgHJOJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmJL+fTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmJL+fTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDF1C4CED1;
	Fri,  6 Dec 2024 15:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497697;
	bh=rwdleYKYcjXOxF5dXW+heraXgOuzK58KgOX9yvFTkSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmJL+fTYqRsAhCmq9t9j3k9wzfkQ5vevIGDqaHoElNDJ/j/5uGzqty14FYSNy/Lc+
	 G3ECI/k+P/ZjntjryiJRNcLJ2rQxJADdAII4uOYaViGsFKbCaMLusurrYpwCA+ZF5f
	 mdeUWX48LWH3ET3nHFDON22vRootZvCz5MorfMf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 366/676] PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds
Date: Fri,  6 Dec 2024 15:33:05 +0100
Message-ID: <20241206143707.643942620@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 212b11c3145d8..f76a358e2b5b6 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -516,15 +516,14 @@ static int j721e_pcie_probe(struct platform_device *pdev)
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
 
@@ -615,15 +614,14 @@ static int j721e_pcie_resume_noirq(struct device *dev)
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



