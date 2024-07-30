Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C581A6192;
	Tue, 30 Jul 2024 17:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359122; cv=none; b=TBaH7Ahdo6tO4dVwc26rLzA30uoIA/JmTD+lzIjvz9iPeuQzPkUgFznwPCaD9B5GHWbuJbo4CzWv6GdZcfQ8dfKYzrUaPqoipSMQAuicKKDlczZc6sxzlWafAjpKvwyyyyVx65YSca5AZEMZ1emt+IxSXjDUmLMtgmsFMyshWIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359122; c=relaxed/simple;
	bh=0mMNhhV2yLkyB2d4n7+JLYQpxeuoEKypw5Sc30jSm/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPBHjJiITadKrD5NLtbqBXOuNweSAWNZKVzidTd5yuwiyEmHgCnDLtHTxgQOeQj5IduV9ICCJzh4tpMrjImspPPE31EC3zDIn0vDcFat9XrUuXJdbOR0PUIk8qVKePLlO5rF9oQtu5/0m8ZHjEOiTuH9H8HnprMfh9xE+7Nkkxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liGIdMlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liGIdMlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B285AC32782;
	Tue, 30 Jul 2024 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359122;
	bh=0mMNhhV2yLkyB2d4n7+JLYQpxeuoEKypw5Sc30jSm/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liGIdMljXIMLFd1h4Szb7CPVHI48tJW/uJCYq0/PTRdOOieqF90hha/+4VrBlU4QT
	 IJZYetdaSAkv+vDI0mn9V3DoVQvoNPxWZGm9CdVZBxG1Eci6sNhduK6gAPpzav1VXa
	 yIOCYNhu9wcb/JEkj1MdrJfpn35ioNkKjjdwReTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 436/809] clk: qcom: gcc-x1e80100: Fix halt_check for all pipe clocks
Date: Tue, 30 Jul 2024 17:45:12 +0200
Message-ID: <20240730151741.924118717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit f27e42c7d3ff8ddfc57273efd1e8642ea89bad90 ]

In case of all pipe clocks, there is a QMP PHY clock that is feeding them.
If, for whatever reason, the clock from the PHY is not enabled, halt bit
will not get set, and the clock controller driver will assume the clock
is stuck in a specific state. The way this is supposed to be properly
fixed is to defer the checking of the halt bit until after the PHY clock
has been initialized, but doing so complicates the clock controller
driver. In fact, since these pipe clocks are consumed by the PHY, while
the PHY is also the one providing the source, if clock gets stuck, the PHY
driver would be to blame. So instead of checking the halt bit in here,
just skip it and assume the PHY driver is handling the source clock
correctly.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20240628-x1e80100-clk-gcc-fix-halt-check-for-usb-phy-pipe-clks-v2-1-db3be54b1143@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 44 ++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 1404017be9180..7b6c1eb6a61d4 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -2812,7 +2812,7 @@ static struct clk_branch gcc_pcie_0_mstr_axi_clk = {
 
 static struct clk_branch gcc_pcie_0_pipe_clk = {
 	.halt_reg = 0xa0044,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52010,
 		.enable_mask = BIT(25),
@@ -2901,7 +2901,7 @@ static struct clk_branch gcc_pcie_1_mstr_axi_clk = {
 
 static struct clk_branch gcc_pcie_1_pipe_clk = {
 	.halt_reg = 0x2c044,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52020,
 		.enable_mask = BIT(30),
@@ -2990,7 +2990,7 @@ static struct clk_branch gcc_pcie_2_mstr_axi_clk = {
 
 static struct clk_branch gcc_pcie_2_pipe_clk = {
 	.halt_reg = 0x13044,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52020,
 		.enable_mask = BIT(23),
@@ -3110,7 +3110,7 @@ static struct clk_branch gcc_pcie_3_phy_rchng_clk = {
 
 static struct clk_branch gcc_pcie_3_pipe_clk = {
 	.halt_reg = 0x58050,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52020,
 		.enable_mask = BIT(3),
@@ -3235,7 +3235,7 @@ static struct clk_branch gcc_pcie_4_phy_rchng_clk = {
 
 static struct clk_branch gcc_pcie_4_pipe_clk = {
 	.halt_reg = 0x6b044,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52008,
 		.enable_mask = BIT(4),
@@ -3360,7 +3360,7 @@ static struct clk_branch gcc_pcie_5_phy_rchng_clk = {
 
 static struct clk_branch gcc_pcie_5_pipe_clk = {
 	.halt_reg = 0x2f044,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52018,
 		.enable_mask = BIT(17),
@@ -3498,7 +3498,7 @@ static struct clk_branch gcc_pcie_6a_phy_rchng_clk = {
 
 static struct clk_branch gcc_pcie_6a_pipe_clk = {
 	.halt_reg = 0x31050,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52018,
 		.enable_mask = BIT(26),
@@ -3636,7 +3636,7 @@ static struct clk_branch gcc_pcie_6b_phy_rchng_clk = {
 
 static struct clk_branch gcc_pcie_6b_pipe_clk = {
 	.halt_reg = 0x8d050,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52000,
 		.enable_mask = BIT(30),
@@ -5109,7 +5109,7 @@ static struct clk_branch gcc_usb3_mp_phy_com_aux_clk = {
 
 static struct clk_branch gcc_usb3_mp_phy_pipe_0_clk = {
 	.halt_reg = 0x17290,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x17290,
 		.enable_mask = BIT(0),
@@ -5122,7 +5122,7 @@ static struct clk_branch gcc_usb3_mp_phy_pipe_0_clk = {
 
 static struct clk_branch gcc_usb3_mp_phy_pipe_1_clk = {
 	.halt_reg = 0x17298,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x17298,
 		.enable_mask = BIT(0),
@@ -5186,7 +5186,7 @@ static struct clk_regmap_mux gcc_usb3_prim_phy_pipe_clk_src = {
 
 static struct clk_branch gcc_usb3_prim_phy_pipe_clk = {
 	.halt_reg = 0x39068,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.hwcg_reg = 0x39068,
 	.hwcg_bit = 1,
 	.clkr = {
@@ -5257,7 +5257,7 @@ static struct clk_regmap_mux gcc_usb3_sec_phy_pipe_clk_src = {
 
 static struct clk_branch gcc_usb3_sec_phy_pipe_clk = {
 	.halt_reg = 0xa1068,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.hwcg_reg = 0xa1068,
 	.hwcg_bit = 1,
 	.clkr = {
@@ -5327,7 +5327,7 @@ static struct clk_regmap_mux gcc_usb3_tert_phy_pipe_clk_src = {
 
 static struct clk_branch gcc_usb3_tert_phy_pipe_clk = {
 	.halt_reg = 0xa2068,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.hwcg_reg = 0xa2068,
 	.hwcg_bit = 1,
 	.clkr = {
@@ -5405,7 +5405,7 @@ static struct clk_branch gcc_usb4_0_master_clk = {
 
 static struct clk_branch gcc_usb4_0_phy_p2rr2p_pipe_clk = {
 	.halt_reg = 0x9f0d8,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x9f0d8,
 		.enable_mask = BIT(0),
@@ -5418,7 +5418,7 @@ static struct clk_branch gcc_usb4_0_phy_p2rr2p_pipe_clk = {
 
 static struct clk_branch gcc_usb4_0_phy_pcie_pipe_clk = {
 	.halt_reg = 0x9f048,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52010,
 		.enable_mask = BIT(19),
@@ -5457,7 +5457,7 @@ static struct clk_branch gcc_usb4_0_phy_rx1_clk = {
 
 static struct clk_branch gcc_usb4_0_phy_usb_pipe_clk = {
 	.halt_reg = 0x9f0a4,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.hwcg_reg = 0x9f0a4,
 	.hwcg_bit = 1,
 	.clkr = {
@@ -5582,7 +5582,7 @@ static struct clk_branch gcc_usb4_1_master_clk = {
 
 static struct clk_branch gcc_usb4_1_phy_p2rr2p_pipe_clk = {
 	.halt_reg = 0x2b0d8,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x2b0d8,
 		.enable_mask = BIT(0),
@@ -5595,7 +5595,7 @@ static struct clk_branch gcc_usb4_1_phy_p2rr2p_pipe_clk = {
 
 static struct clk_branch gcc_usb4_1_phy_pcie_pipe_clk = {
 	.halt_reg = 0x2b048,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52028,
 		.enable_mask = BIT(0),
@@ -5634,7 +5634,7 @@ static struct clk_branch gcc_usb4_1_phy_rx1_clk = {
 
 static struct clk_branch gcc_usb4_1_phy_usb_pipe_clk = {
 	.halt_reg = 0x2b0a4,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.hwcg_reg = 0x2b0a4,
 	.hwcg_bit = 1,
 	.clkr = {
@@ -5759,7 +5759,7 @@ static struct clk_branch gcc_usb4_2_master_clk = {
 
 static struct clk_branch gcc_usb4_2_phy_p2rr2p_pipe_clk = {
 	.halt_reg = 0x110d8,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x110d8,
 		.enable_mask = BIT(0),
@@ -5772,7 +5772,7 @@ static struct clk_branch gcc_usb4_2_phy_p2rr2p_pipe_clk = {
 
 static struct clk_branch gcc_usb4_2_phy_pcie_pipe_clk = {
 	.halt_reg = 0x11048,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52028,
 		.enable_mask = BIT(1),
@@ -5811,7 +5811,7 @@ static struct clk_branch gcc_usb4_2_phy_rx1_clk = {
 
 static struct clk_branch gcc_usb4_2_phy_usb_pipe_clk = {
 	.halt_reg = 0x110a4,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.hwcg_reg = 0x110a4,
 	.hwcg_bit = 1,
 	.clkr = {
-- 
2.43.0



