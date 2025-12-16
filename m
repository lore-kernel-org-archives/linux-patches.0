Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49D62459D7;
	Tue, 16 Dec 2025 11:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883858; cv=none; b=LiTLYMnjd0kEHAHmduEDc48uL+i3APHwfNr1clGugHIBUK8mqB7HrmzK/ZifHi0kgTgLmSygX4aRM//W8/9Wntq213eQ1snpEv7HIy8wwFlweoTw6zdmTYo0oXNI5QifvW5qz88sjTcymUclydADTkzBrZuvgQfRJVvNgkmq7Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883858; c=relaxed/simple;
	bh=F5HLs4RDVaDnfVBSl3yAQ/kAROpjXhO8tib12avtf7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpRIzA2sni0LoPyrvdpQxazi8AluK39B4WqoMXLLTgPl41qkWY5o88lePSY4eNDKDsgB9QZpkN18xc7gB6HeiJiIIR75bZi//6Gh3lgtlHt+QbrtXrCVwSJjYj9NBffWg8sYVPJyRgohxusNK3o8elSUWB2uln9lIRI8IWuGTbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXfVOZKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXfVOZKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BF8C4CEF1;
	Tue, 16 Dec 2025 11:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883858;
	bh=F5HLs4RDVaDnfVBSl3yAQ/kAROpjXhO8tib12avtf7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXfVOZKma6vZ8z9hj/pLX0Mn/b7OPG2WRFmVdeq3JSGdCSY6opaKIDA0LS4cQravu
	 e+EB1ApnTsZxfIR7BnqbFrhoLc4oBqn+TkJ+YpctQIip0jNxHxPb3ySg/5I2UIFsmi
	 7Ls5JzRCMvwb7HEu05MOwaqJNmz55oiKgYqI/7mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/354] clk: renesas: cpg-mssr: Read back reset registers to assure values latched
Date: Tue, 16 Dec 2025 12:09:47 +0100
Message-ID: <20251216111321.642222447@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit b91401af6c00ffab003698bfabd4c166df30748b ]

On R-Car V4H, the PCIEC controller DBI read would generate an SError in
case the controller reset is released by writing SRSTCLR register first,
and immediately afterward reading some PCIEC controller DBI register.
The issue triggers in rcar_gen4_pcie_additional_common_init() on
dw_pcie_readl_dbi(dw, PCIE_PORT_LANE_SKEW), which on V4H is the first
read after reset_control_deassert(dw->core_rsts[DW_PCIE_PWR_RST].rstc).

The reset controller which contains the SRSTCLR register and the PCIEC
controller which contains the DBI register share the same root access
bus, but the bus then splits into separate segments before reaching each
IP.  Even if the SRSTCLR write access was posted on the bus before the
DBI read access, it seems the DBI read access may reach the PCIEC
controller before the SRSTCLR write completed, and trigger the SError.

Mitigate the issue by adding a dummy SRSTCLR read, which assures the
SRSTCLR write completes fully and is latched into the reset controller,
before the PCIEC DBI read access can occur.

Fixes: 0ab55cf18341 ("clk: renesas: cpg-mssr: Add support for R-Car V4H")
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250922162113.113223-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 46 ++++++++++++--------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 291a01778aa48..e0f0dc8c0e56d 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -615,18 +615,32 @@ static int __init cpg_mssr_add_clk_domain(struct device *dev,
 
 #define rcdev_to_priv(x)	container_of(x, struct cpg_mssr_priv, rcdev)
 
-static int cpg_mssr_reset(struct reset_controller_dev *rcdev,
-			  unsigned long id)
+static int cpg_mssr_reset_operate(struct reset_controller_dev *rcdev,
+				  const char *func, bool set, unsigned long id)
 {
 	struct cpg_mssr_priv *priv = rcdev_to_priv(rcdev);
 	unsigned int reg = id / 32;
 	unsigned int bit = id % 32;
+	const u16 off = set ? priv->reset_regs[reg] : priv->reset_clear_regs[reg];
 	u32 bitmask = BIT(bit);
 
-	dev_dbg(priv->dev, "reset %u%02u\n", reg, bit);
+	if (func)
+		dev_dbg(priv->dev, "%s %u%02u\n", func, reg, bit);
+
+	writel(bitmask, priv->pub.base0 + off);
+	readl(priv->pub.base0 + off);
+	barrier_data(priv->pub.base0 + off);
+
+	return 0;
+}
+
+static int cpg_mssr_reset(struct reset_controller_dev *rcdev,
+			  unsigned long id)
+{
+	struct cpg_mssr_priv *priv = rcdev_to_priv(rcdev);
 
 	/* Reset module */
-	writel(bitmask, priv->pub.base0 + priv->reset_regs[reg]);
+	cpg_mssr_reset_operate(rcdev, "reset", true, id);
 
 	/*
 	 * On R-Car Gen4, delay after SRCR has been written is 1ms.
@@ -639,36 +653,18 @@ static int cpg_mssr_reset(struct reset_controller_dev *rcdev,
 		usleep_range(35, 1000);
 
 	/* Release module from reset state */
-	writel(bitmask, priv->pub.base0 + priv->reset_clear_regs[reg]);
-
-	return 0;
+	return cpg_mssr_reset_operate(rcdev, NULL, false, id);
 }
 
 static int cpg_mssr_assert(struct reset_controller_dev *rcdev, unsigned long id)
 {
-	struct cpg_mssr_priv *priv = rcdev_to_priv(rcdev);
-	unsigned int reg = id / 32;
-	unsigned int bit = id % 32;
-	u32 bitmask = BIT(bit);
-
-	dev_dbg(priv->dev, "assert %u%02u\n", reg, bit);
-
-	writel(bitmask, priv->pub.base0 + priv->reset_regs[reg]);
-	return 0;
+	return cpg_mssr_reset_operate(rcdev, "assert", true, id);
 }
 
 static int cpg_mssr_deassert(struct reset_controller_dev *rcdev,
 			     unsigned long id)
 {
-	struct cpg_mssr_priv *priv = rcdev_to_priv(rcdev);
-	unsigned int reg = id / 32;
-	unsigned int bit = id % 32;
-	u32 bitmask = BIT(bit);
-
-	dev_dbg(priv->dev, "deassert %u%02u\n", reg, bit);
-
-	writel(bitmask, priv->pub.base0 + priv->reset_clear_regs[reg]);
-	return 0;
+	return cpg_mssr_reset_operate(rcdev, "deassert", false, id);
 }
 
 static int cpg_mssr_status(struct reset_controller_dev *rcdev,
-- 
2.51.0



