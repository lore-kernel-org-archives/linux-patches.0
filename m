Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A8A8F55
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD7FC433C8;
	Sun, 16 Jul 2023 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539950;
	bh=VrZCTbEH8M41kjEkzalOeLtKUjpJlL8fT2tuBrxJxTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjoHF3z/KggVZ2A/b87L15y2a5WnBkohmLrVT0tUbEpIHUhMq5IVZqeHeru72QeN1
	 iSZQ82ZYb+pLT1hmdju7f5/mEh6tGwyqlQUMos4b8h1TsUztwqFn74Gyq4LOjDviPV
	 q2JLw9t9jJrz5CecKK+dpGBIR/kABHvubQanOpaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/591] clk: renesas: rzg2l: Fix CPG_SIPLL5_CLK1 register write
Date: Sun, 16 Jul 2023 21:45:28 +0200
Message-ID: <20230716194928.765400092@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit d1c20885d3b01e6a62e920af4b227abd294d22f3 ]

As per the RZ/G2L HW(Rev.1.30 May2023) manual, there are no "write enable"
bits in the CPG_SIPLL5_CLK1 register.  So fix the CPG_SIPLL5_CLK register
write by removing the "write enable" bits.

Fixes: 1561380ee72f ("clk: renesas: rzg2l: Add FOUTPOSTDIV clk support")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230518152334.514922-1-biju.das.jz@bp.renesas.com
[geert: Remove CPG_SIPLL5_CLK1_*_WEN bit definitions]
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 6 ++----
 drivers/clk/renesas/rzg2l-cpg.h | 3 ---
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 3ff6ecd617565..2c877576c5729 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -600,10 +600,8 @@ static int rzg2l_cpg_sipll5_set_rate(struct clk_hw *hw,
 	}
 
 	/* Output clock setting 1 */
-	writel(CPG_SIPLL5_CLK1_POSTDIV1_WEN | CPG_SIPLL5_CLK1_POSTDIV2_WEN |
-	       CPG_SIPLL5_CLK1_REFDIV_WEN  | (params.pl5_postdiv1 << 0) |
-	       (params.pl5_postdiv2 << 4) | (params.pl5_refdiv << 8),
-	       priv->base + CPG_SIPLL5_CLK1);
+	writel((params.pl5_postdiv1 << 0) | (params.pl5_postdiv2 << 4) |
+	       (params.pl5_refdiv << 8), priv->base + CPG_SIPLL5_CLK1);
 
 	/* Output clock setting, SSCG modulation value setting 3 */
 	writel((params.pl5_fracin << 8), priv->base + CPG_SIPLL5_CLK3);
diff --git a/drivers/clk/renesas/rzg2l-cpg.h b/drivers/clk/renesas/rzg2l-cpg.h
index cecbdf5e4f93a..b33a3e79161b6 100644
--- a/drivers/clk/renesas/rzg2l-cpg.h
+++ b/drivers/clk/renesas/rzg2l-cpg.h
@@ -32,9 +32,6 @@
 #define CPG_SIPLL5_STBY_RESETB_WEN	BIT(16)
 #define CPG_SIPLL5_STBY_SSCG_EN_WEN	BIT(18)
 #define CPG_SIPLL5_STBY_DOWNSPREAD_WEN	BIT(20)
-#define CPG_SIPLL5_CLK1_POSTDIV1_WEN	BIT(16)
-#define CPG_SIPLL5_CLK1_POSTDIV2_WEN	BIT(20)
-#define CPG_SIPLL5_CLK1_REFDIV_WEN	BIT(24)
 #define CPG_SIPLL5_CLK4_RESV_LSB	(0xFF)
 #define CPG_SIPLL5_MON_PLL5_LOCK	BIT(4)
 
-- 
2.39.2



