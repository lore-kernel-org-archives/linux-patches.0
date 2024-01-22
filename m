Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AF46A354;
	Tue, 23 Jan 2024 02:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975350; cv=none; b=tTt09PKwEiOKMN8zJeoB2EsI/LhE0d33RcM8iWLgyMW0cZxxMYlThbPhffxUmPh7lKIOl0L16D5sEArVlHOAxdYRcdH1tEoUwlVgQNiQ3Y509qNpAopsF4tkxt3gHu83cjbtCksq2TDNWajN+KkT+hr1D+EDTPtdjTNYL3p0Bl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975350; c=relaxed/simple;
	bh=fjYN60atLbsyutMG5sOWPs99csFJGyHrXneY7lpUkTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzq7YxumHa+ssuy3BzDLBYTfs0D1NTce3P40Ike5agcja6+kTVz1zzaTCUrevqi5vMw8kyH+BOyVbIDmsVw4PwQQfYUnYq7RwthucfusOeG0MxztQVnj9pMxc3AoFiHd5kyVxpGXmS0hM5HtyStnNSeyZGu4DDtD9MGf+T5FbnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zp5Zt9gG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zp5Zt9gG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320E1C433C7;
	Tue, 23 Jan 2024 02:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975350;
	bh=fjYN60atLbsyutMG5sOWPs99csFJGyHrXneY7lpUkTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zp5Zt9gG4+wSdzGWqFMugg15W9pVuVZZ9jJ/WeEB8nqBX6sMJOm2CuWgJhFZ3/gck
	 Xjw0UngM1O6ASswJdFiSpd8R6yskZzPLTkcozzpCFjmzIG+9n1j1ZC4+Mr7uip/B7l
	 NyTulOe4xX68jJO6i2ts612q1aXP/P5EqjGnf63M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 312/583] clk: qcom: gcc-sm8550: use collapse-voting for PCIe GDSCs
Date: Mon, 22 Jan 2024 15:56:03 -0800
Message-ID: <20240122235821.573464826@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 7e77a39265293ea4f05e20fff180755503c49918 ]

The PCIe GDSCs can be shared with other masters and should use the APCS
collapse-vote register when updating the power state.

This is specifically also needed to be able to disable power domains
that have been enabled by boot firmware using the vote register.

Following other recent Qualcomm platforms, describe this register and
the corresponding mask for the PCIe (and _phy) GDSCs.

Fixes: 955f2ea3b9e9 ("clk: qcom: Add GCC driver for SM8550")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-5-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8550.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sm8550.c b/drivers/clk/qcom/gcc-sm8550.c
index a16d07426b71..73bda0d03aa7 100644
--- a/drivers/clk/qcom/gcc-sm8550.c
+++ b/drivers/clk/qcom/gcc-sm8550.c
@@ -2998,6 +2998,8 @@ static struct clk_branch gcc_video_axi1_clk = {
 
 static struct gdsc pcie_0_gdsc = {
 	.gdscr = 0x6b004,
+	.collapse_ctrl = 0x52020,
+	.collapse_mask = BIT(0),
 	.pd = {
 		.name = "pcie_0_gdsc",
 	},
@@ -3007,6 +3009,8 @@ static struct gdsc pcie_0_gdsc = {
 
 static struct gdsc pcie_0_phy_gdsc = {
 	.gdscr = 0x6c000,
+	.collapse_ctrl = 0x52020,
+	.collapse_mask = BIT(3),
 	.pd = {
 		.name = "pcie_0_phy_gdsc",
 	},
@@ -3016,6 +3020,8 @@ static struct gdsc pcie_0_phy_gdsc = {
 
 static struct gdsc pcie_1_gdsc = {
 	.gdscr = 0x8d004,
+	.collapse_ctrl = 0x52020,
+	.collapse_mask = BIT(1),
 	.pd = {
 		.name = "pcie_1_gdsc",
 	},
@@ -3025,6 +3031,8 @@ static struct gdsc pcie_1_gdsc = {
 
 static struct gdsc pcie_1_phy_gdsc = {
 	.gdscr = 0x8e000,
+	.collapse_ctrl = 0x52020,
+	.collapse_mask = BIT(4),
 	.pd = {
 		.name = "pcie_1_phy_gdsc",
 	},
-- 
2.43.0



