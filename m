Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FA42E62A4;
	Tue, 15 Jul 2025 13:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586960; cv=none; b=WvoqBhHbq56bVy1xLzLqKLBwHROJcHW+OeY+tieWKoEuliDV+CkuIkKzaP62Ses1CE770xENP0NStjhHJ5avKGAlur5MbDH1FKiJU3hIeAhkq6Og6PcH/NeF9r91UphWb01JvTBqLfq1NLk+sfXvF5dKXMtd6KfhxCXUkNSJ9ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586960; c=relaxed/simple;
	bh=gDSpDJlSyB1HDaFhWfFjifMoXcwTpz1IUHda0H9z4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmRUyZF8sWX+0+ZdD2TC7D6S7LuppCyg/DL+KK0YWbhfbCni1y+k3tewPEtzp5L4J039OiarXdmU2Uzz60PBXkDrJlsVjCRgZxCgce+LIiaJYxk32z9NSumcz4uogFs5irNwl3jAd9t81IqPItMmZnaB5+iLGrW4sfZl/MrAo4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQ7Zro7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQ7Zro7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2ABC4CEE3;
	Tue, 15 Jul 2025 13:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586960;
	bh=gDSpDJlSyB1HDaFhWfFjifMoXcwTpz1IUHda0H9z4H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQ7Zro7gxzE8ftrcfqHhaLdZifnlJjcNgeS8cz+DIFy3b61El736AZMYluTRm5OIe
	 de319JvofYdeV+bsGc06edfN/cbPphoWsKGVHfYQi37uiy0qIM9p1cvq9yx4Y3hSDu
	 O+CYwKRLn1JUruy8AGOlveRdmBybwy77zyd/Fjwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.15 113/192] clk: imx: Fix an out-of-bounds access in dispmix_csr_clk_dev_data
Date: Tue, 15 Jul 2025 15:13:28 +0200
Message-ID: <20250715130819.423085359@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit aacc875a448d363332b9df0621dde6d3a225ea9f upstream.

When num_parents is 4, __clk_register() occurs an out-of-bounds
when accessing parent_names member. Use ARRAY_SIZE() instead of
hardcode number here.

 BUG: KASAN: global-out-of-bounds in __clk_register+0x1844/0x20d8
 Read of size 8 at addr ffff800086988e78 by task kworker/u24:3/59
  Hardware name: NXP i.MX95 19X19 board (DT)
  Workqueue: events_unbound deferred_probe_work_func
  Call trace:
    dump_backtrace+0x94/0xec
    show_stack+0x18/0x24
    dump_stack_lvl+0x8c/0xcc
    print_report+0x398/0x5fc
    kasan_report+0xd4/0x114
    __asan_report_load8_noabort+0x20/0x2c
    __clk_register+0x1844/0x20d8
    clk_hw_register+0x44/0x110
    __clk_hw_register_mux+0x284/0x3a8
    imx95_bc_probe+0x4f4/0xa70

Fixes: 5224b189462f ("clk: imx: add i.MX95 BLK CTL clk driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Link: https://lore.kernel.org/r/20250619062108.2016511-1-xiaolei.wang@windriver.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/imx/clk-imx95-blk-ctl.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/clk/imx/clk-imx95-blk-ctl.c
+++ b/drivers/clk/imx/clk-imx95-blk-ctl.c
@@ -219,11 +219,15 @@ static const struct imx95_blk_ctl_dev_da
 	.clk_reg_offset = 0,
 };
 
+static const char * const disp_engine_parents[] = {
+	"videopll1", "dsi_pll", "ldb_pll_div7"
+};
+
 static const struct imx95_blk_ctl_clk_dev_data dispmix_csr_clk_dev_data[] = {
 	[IMX95_CLK_DISPMIX_ENG0_SEL] = {
 		.name = "disp_engine0_sel",
-		.parent_names = (const char *[]){"videopll1", "dsi_pll", "ldb_pll_div7", },
-		.num_parents = 4,
+		.parent_names = disp_engine_parents,
+		.num_parents = ARRAY_SIZE(disp_engine_parents),
 		.reg = 0,
 		.bit_idx = 0,
 		.bit_width = 2,
@@ -232,8 +236,8 @@ static const struct imx95_blk_ctl_clk_de
 	},
 	[IMX95_CLK_DISPMIX_ENG1_SEL] = {
 		.name = "disp_engine1_sel",
-		.parent_names = (const char *[]){"videopll1", "dsi_pll", "ldb_pll_div7", },
-		.num_parents = 4,
+		.parent_names = disp_engine_parents,
+		.num_parents = ARRAY_SIZE(disp_engine_parents),
 		.reg = 0,
 		.bit_idx = 2,
 		.bit_width = 2,


