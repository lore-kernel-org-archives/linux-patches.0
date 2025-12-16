Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACBD2459D7;
	Tue, 16 Dec 2025 11:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883845; cv=none; b=OtlF0VFSpcbwV2uqPzrxaQXR4uKvIacJ/qDJTtnjTwjB4fc0umVHoqrC8cdKBrYyN84/kku72LcuThjl6FMwMIr6+ikb5ZSYp5QHfBBXOvoyhHe5uYcysRtEfsUzp7mLDEM4/pQUElScJlXIsUNzkMDycu7Tb/jzmfbIWwsfRGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883845; c=relaxed/simple;
	bh=Q8WLLTcDuTsosWd6LV5cT8tgr5DXhXeENHrUhJQuNJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYh23F4UrVJb/3FPvIdyf7Zwrg++r/hY+rs6pJ9Oh3GjYjaYZCTwOGDlGXwqnoGoC8nNUmSrDuZQBacejNsSJ0zTu9D0Qc3MLpNnzETV0nNfDDswoGDmgvw1EO68j/o1IcrLvi+k3T/UhGJVbUQdITcRBwsX8Lbr/r+4WOiLJGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHWk/djr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHWk/djr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDF6C4CEF1;
	Tue, 16 Dec 2025 11:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883844;
	bh=Q8WLLTcDuTsosWd6LV5cT8tgr5DXhXeENHrUhJQuNJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHWk/djrb77P8+8/0cdxUC1RxMS0Dt1zT5cULXbvl+xw9bdtJnTAN2MHVL+siRNMk
	 4FT9AUU3dmkkqAUM0Klb3nHLG5WSDE8f10z51YvpIk4RaQXPH7JbrsRmjWm7/cHtt7
	 9om/1IPDINXi8KbeYAxxY2ioiE7IJNU8AAWptx00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/354] clk: renesas: cpg-mssr: Add missing 1ms delay into reset toggle callback
Date: Tue, 16 Dec 2025 12:09:44 +0100
Message-ID: <20251216111321.532625638@linuxfoundation.org>
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

[ Upstream commit 62abfd7bedc2b3d86d4209a4146f9d2b5ae21fab ]

R-Car V4H Reference Manual R19UH0186EJ0130 Rev.1.30 Apr. 21, 2025 page
583 Figure 9.3.1(a) Software Reset flow (A) as well as flow (B) / (C)
indicate after reset has been asserted by writing a matching reset bit
into register SRCR, it is mandatory to wait 1ms.

This 1ms delay is documented on R-Car V4H and V4M, it is currently
unclear whether S4 is affected as well.  This patch does apply the extra
delay on R-Car S4 as well.

Fix the reset driver to respect the additional delay when toggling
resets.  Drivers which use separate reset_control_(de)assert() must
assure matching delay in their driver code.

Fixes: 0ab55cf18341 ("clk: renesas: cpg-mssr: Add support for R-Car V4H")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250918030552.331389-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 112ed81f648ee..ecb7e2024d589 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -630,8 +630,15 @@ static int cpg_mssr_reset(struct reset_controller_dev *rcdev,
 	/* Reset module */
 	writel(bitmask, priv->base + priv->reset_regs[reg]);
 
-	/* Wait for at least one cycle of the RCLK clock (@ ca. 32 kHz) */
-	udelay(35);
+	/*
+	 * On R-Car Gen4, delay after SRCR has been written is 1ms.
+	 * On older SoCs, delay after SRCR has been written is 35us
+	 * (one cycle of the RCLK clock @ ca. 32 kHz).
+	 */
+	if (priv->reg_layout == CLK_REG_LAYOUT_RCAR_GEN4)
+		usleep_range(1000, 2000);
+	else
+		usleep_range(35, 1000);
 
 	/* Release module from reset state */
 	writel(bitmask, priv->base + priv->reset_clear_regs[reg]);
-- 
2.51.0



