Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215976A352;
	Mon,  8 Apr 2024 13:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582761; cv=none; b=BFjgK0tDmQm4upK0mAdK4eq8sduELgd7Qg/j+p5AOwzGcvZnvHhZEVymm4dYo6nASeepU8b/47QZ7/G1O7uqcAuGQs9KUcVbnCUOCJRuqObRrZiZnSam2SVeJHjgirDS2fvmst4DLya8VAkvmDC3TJX9dm71CM50X4c2qlzI4E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582761; c=relaxed/simple;
	bh=aJI3m2tCnm8sUYbtaRPspgOx7SRV0FQaVVjCAV2iO/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqSm2EwO3UDp4gMxbVl7Jc9HaM8IAW1XcDzDAMIxvrF68Wnq0ITJIXJIxXBbz2Ti1QlwAmh0ddWqS29DnmsNeB6SqGpxEdoIevxiV+madrKeocRkqd8NrHQSLvF8xwQOCTGiyoPISgUlN7aH3yXCquwhfz846Slk0L8/MvpaZ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJG9znIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJG9znIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF6BC433C7;
	Mon,  8 Apr 2024 13:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582761;
	bh=aJI3m2tCnm8sUYbtaRPspgOx7SRV0FQaVVjCAV2iO/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJG9znIOjhCoEirsAAmrgu0m5cmkMDVY8sSf43x+TWR7w4mwpEkIpvv957QoFESt/
	 ME3hDUD9TjGlNweRqPsANCGok/BTyEyrEI56kNLou7NcWgWZitqiXRyqJ20YvqHS9D
	 X5stLRhVcL6RhQx/N4Jp+MmBMnyrc+8VsM7KwHK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duanqiang Wen <duanqiangwen@net-swift.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 103/273] net: txgbe: fix i2c dev name cannot match clkdev
Date: Mon,  8 Apr 2024 14:56:18 +0200
Message-ID: <20240408125312.508501435@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duanqiang Wen <duanqiangwen@net-swift.com>

commit c644920ce9220d83e070f575a4df711741c07f07 upstream.

txgbe clkdev shortened clk_name, so i2c_dev info_name
also need to shorten. Otherwise, i2c_dev cannot initialize
clock.

Fixes: e30cef001da2 ("net: txgbe: fix clk_name exceed MAX_DEV_ID limits")
Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
Link: https://lore.kernel.org/r/20240402021843.126192-1-duanqiangwen@net-swift.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -20,6 +20,8 @@
 #include "txgbe_phy.h"
 #include "txgbe_hw.h"
 
+#define TXGBE_I2C_CLK_DEV_NAME "i2c_dw"
+
 static int txgbe_swnodes_register(struct txgbe *txgbe)
 {
 	struct txgbe_nodes *nodes = &txgbe->nodes;
@@ -556,8 +558,8 @@ static int txgbe_clock_register(struct t
 	char clk_name[32];
 	struct clk *clk;
 
-	snprintf(clk_name, sizeof(clk_name), "i2c_dw.%d",
-		 pci_dev_id(pdev));
+	snprintf(clk_name, sizeof(clk_name), "%s.%d",
+		 TXGBE_I2C_CLK_DEV_NAME, pci_dev_id(pdev));
 
 	clk = clk_register_fixed_rate(NULL, clk_name, NULL, 0, 156250000);
 	if (IS_ERR(clk))
@@ -619,7 +621,7 @@ static int txgbe_i2c_register(struct txg
 
 	info.parent = &pdev->dev;
 	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_I2C]);
-	info.name = "i2c_designware";
+	info.name = TXGBE_I2C_CLK_DEV_NAME;
 	info.id = pci_dev_id(pdev);
 
 	info.res = &DEFINE_RES_IRQ(pdev->irq);


