Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DFF2D7BF;
	Tue,  3 Dec 2024 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238996; cv=none; b=So8rFCiaTvjJ9+WPFc0OYLPyRWDteMNhLlO4yIQrxPYRUQtfuttwr/2s+AGXS9/zslhyak7cktslz2dWD+z6MrZtSOIVS8wZ8w9Lipnwr6kOI3rwePqO2APhwlO9n8Jllc+MiEaiK4uxXl1Y+WpSSmp2xiIJEtTUWPSbR/BX33g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238996; c=relaxed/simple;
	bh=+wKoZpIq0NiIipHBhms2ZsC6xznCqGFPr0T3aJKQyfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGjpiID0FDG6cK79bnUIA/YaN/Ms1LFFzkQxpQQATI7gkDdnYd8tyqYfm01gq+Cy2SpAsGRU9mKxRaO3BwXu/Y+p6cbsla6ylc9ZyvGuYB8DMC1OL9+OWiQoVnyMOQsG97hNMl3OsrB52dEL6WfWdvuWXsMlOxmBzS1tj38zhk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xARo3wgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xARo3wgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CE2C4CECF;
	Tue,  3 Dec 2024 15:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238995;
	bh=+wKoZpIq0NiIipHBhms2ZsC6xznCqGFPr0T3aJKQyfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xARo3wggRhbfIveK5Vxs/awroL3Wgq8uZO/3kcPkV7y1j18YNKADNn48OE+3RkKX1
	 Dlb1G7Y75UPkjrYGUtGW4VQeDBjp/FBPm0SLRuzZnSbgH93q3+i+Z/pR/mGKvVjH0b
	 u28Pua7SFtLRI0JGnbRToAS0yYqjK0AOpxS+b9fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 468/817] clk: en7523: remove REG_PCIE*_{MEM,MEM_MASK} configuration
Date: Tue,  3 Dec 2024 15:40:40 +0100
Message-ID: <20241203144014.140346034@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c31d1cdd7bff1d2c13d435bb9d0c76bfaa332097 ]

REG_PCIE*_MEM and REG_PCIE*_MEM_MASK regs (PBUS_CSR memory region) are not
part of the scu block on the EN7581 SoC and they are used to select the
PCIE ports on the PBUS, so remove this configuration from the clock driver
and set these registers in the PCIE host driver instead.
This patch does not introduce any backward incompatibility since the dts
for EN7581 SoC is not upstream yet.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20241112-clk-en7581-syscon-v2-2-8ada5e394ae4@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: f98eded9e9ab ("clk: en7523: fix estimation of fixed rate for EN7581")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-en7523.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/clk/clk-en7523.c b/drivers/clk/clk-en7523.c
index 22fbea61c3dcc..ec6716844fdcf 100644
--- a/drivers/clk/clk-en7523.c
+++ b/drivers/clk/clk-en7523.c
@@ -31,12 +31,6 @@
 #define   REG_RESET_CONTROL_PCIE1	BIT(27)
 #define   REG_RESET_CONTROL_PCIE2	BIT(26)
 /* EN7581 */
-#define REG_PCIE0_MEM			0x00
-#define REG_PCIE0_MEM_MASK		0x04
-#define REG_PCIE1_MEM			0x08
-#define REG_PCIE1_MEM_MASK		0x0c
-#define REG_PCIE2_MEM			0x10
-#define REG_PCIE2_MEM_MASK		0x14
 #define REG_NP_SCU_PCIC			0x88
 #define REG_NP_SCU_SSTR			0x9c
 #define REG_PCIE_XSI0_SEL_MASK		GENMASK(14, 13)
@@ -415,26 +409,14 @@ static void en7581_pci_disable(struct clk_hw *hw)
 static int en7581_clk_hw_init(struct platform_device *pdev,
 			      void __iomem *np_base)
 {
-	void __iomem *pb_base;
 	u32 val;
 
-	pb_base = devm_platform_ioremap_resource(pdev, 3);
-	if (IS_ERR(pb_base))
-		return PTR_ERR(pb_base);
-
 	val = readl(np_base + REG_NP_SCU_SSTR);
 	val &= ~(REG_PCIE_XSI0_SEL_MASK | REG_PCIE_XSI1_SEL_MASK);
 	writel(val, np_base + REG_NP_SCU_SSTR);
 	val = readl(np_base + REG_NP_SCU_PCIC);
 	writel(val | 3, np_base + REG_NP_SCU_PCIC);
 
-	writel(0x20000000, pb_base + REG_PCIE0_MEM);
-	writel(0xfc000000, pb_base + REG_PCIE0_MEM_MASK);
-	writel(0x24000000, pb_base + REG_PCIE1_MEM);
-	writel(0xfc000000, pb_base + REG_PCIE1_MEM_MASK);
-	writel(0x28000000, pb_base + REG_PCIE2_MEM);
-	writel(0xfc000000, pb_base + REG_PCIE2_MEM_MASK);
-
 	return 0;
 }
 
-- 
2.43.0



