Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6681415696E;
	Tue,  3 Dec 2024 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239154; cv=none; b=DAhOI0D9M781MVSr2cY4InCvUlRQZHCtXwxoBXxqGGyFGTwK8OfNGRtD2Te0iNeZimVcit/oTBdZ0PVF91X8bJJPr6daq7TBpHcuaqJByZcHLZEx6rT75Lfp76em1RRpZ2LTNGgOuIlrsbtDryfcBuBZF8XsOv3EuykYRAxE7Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239154; c=relaxed/simple;
	bh=rQSnjqVof/LC5nPW5Efw+DuW6OALxO9K5nNfqoyFjRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sa7qPbMbJDdCO6WmPT6QSbFnuLOejK3mYc93D+W+tiXPNRSTCvKfkNu9qDsO9K+2As5RxWKmq2/e0kxH0rCqsLjDprAk0V/ccKZ9/d7zEpUm5xCPJE0rJYotT++BfeTYfaq1RGsQAkDu3wniJPzMOXomKJ18wlJEmmgu8Fp0vew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyUhQe9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyUhQe9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB27EC4CECF;
	Tue,  3 Dec 2024 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239154;
	bh=rQSnjqVof/LC5nPW5Efw+DuW6OALxO9K5nNfqoyFjRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyUhQe9TmebqpGO5kmMTRMrkeB6bgyM7rnEt6+xsv4iB6H62v7biF6SaStIQjCmch
	 /FrP+W+iy2k36ZhIfODaYdbvL+NXl8txywXn6DzUFNMF1EOv64pdeTcT008Jechrei
	 DFcL2Cr7M+38fD6LkHtR9X726OGwxWI6UIfVICPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 520/817] PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds
Date: Tue,  3 Dec 2024 15:41:32 +0100
Message-ID: <20241203144016.191221228@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d37e43dbc30b8..9a0e760e4b523 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -538,15 +538,14 @@ static int j721e_pcie_probe(struct platform_device *pdev)
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
 
@@ -637,15 +636,14 @@ static int j721e_pcie_resume_noirq(struct device *dev)
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



