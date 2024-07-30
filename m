Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318CA1A6192;
	Tue, 30 Jul 2024 16:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357683; cv=none; b=XL98k0BFkmmaOAA+vaNYhwvTp9qNtQZ7GGW0HvUZzFCdnr3qxqoP5eNFIi6/SlvVmNXx9/BIhqBC700TPcknDy6myJWEr2LLh5KQG1a4kiRs6+Xehpfgd0tnAB3R1Od+9RTdQtZLF6+/dsIN1T67VUqRjU8xV8fE9BQzBIWEC/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357683; c=relaxed/simple;
	bh=4qhnkMyQ2Ty1XZEItvlUcHfF/hgjNbZp+1aSqE0wvzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbqPB+m6dYR3l3+2KK3ogE6LDip8oX3GOmf0g1QZVehF9ITf7SrJMlXQw5TZ3fl6XDb1ZEpXkuYWzLjNE7ViIQGmhlnbBUGj3GYV6v5mYm1arz0EC6I76sATM094geZc7dfwph1p5NTqOOyN21HoFsCXJJS79pMo7X1EV/tDJhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qGPMHw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qGPMHw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC2DC4AF0E;
	Tue, 30 Jul 2024 16:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357683;
	bh=4qhnkMyQ2Ty1XZEItvlUcHfF/hgjNbZp+1aSqE0wvzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qGPMHw1i/pcgg4iroT7QTjDa3kmaV0/QT4twlPR88Eab6Rw6YTuxZUcWwLbA15r1
	 0aUPqw/IdjnDfBg1sANQI0rbu4hQC7smZrZkkWTnDj+2jTEsirDGnHDXsTmyuuDkB4
	 wtrq5x2ufxMwiA1o1zRjM+RuztsiilCn6Sh5itkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/568] clk: qcom: gcc-sa8775p: Update the GDSC wait_val fields and flags
Date: Tue, 30 Jul 2024 17:46:13 +0200
Message-ID: <20240730151650.271847023@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit be208c0ccf7d861fc6109ca06c1a773512739af9 ]

Update the GDSC wait_val fields as per the default hardware values as
otherwise they would lead to GDSC FSM state to be stuck and causing
failures to power on/off. Also add the GDSC flags as applicable and
add support to control PCIE GDSC's using collapse vote registers.

Fixes: 08c51ceb12f7 ("clk: qcom: add the GCC driver for sa8775p")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20240612-sa8775p-v2-gcc-gpucc-fixes-v2-2-adcc756a23df@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sa8775p.c | 40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sa8775p.c b/drivers/clk/qcom/gcc-sa8775p.c
index 8171d23c96e64..a54438205698c 100644
--- a/drivers/clk/qcom/gcc-sa8775p.c
+++ b/drivers/clk/qcom/gcc-sa8775p.c
@@ -4305,74 +4305,114 @@ static struct clk_branch gcc_video_axi1_clk = {
 
 static struct gdsc pcie_0_gdsc = {
 	.gdscr = 0xa9004,
+	.collapse_ctrl = 0x4b104,
+	.collapse_mask = BIT(0),
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "pcie_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc pcie_1_gdsc = {
 	.gdscr = 0x77004,
+	.collapse_ctrl = 0x4b104,
+	.collapse_mask = BIT(1),
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "pcie_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc ufs_card_gdsc = {
 	.gdscr = 0x81004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ufs_card_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc ufs_phy_gdsc = {
 	.gdscr = 0x83004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ufs_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc usb20_prim_gdsc = {
 	.gdscr = 0x1c004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "usb20_prim_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc usb30_prim_gdsc = {
 	.gdscr = 0x1b004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "usb30_prim_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc usb30_sec_gdsc = {
 	.gdscr = 0x2f004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "usb30_sec_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc emac0_gdsc = {
 	.gdscr = 0xb6004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "emac0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct gdsc emac1_gdsc = {
 	.gdscr = 0xb4004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "emac1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
 static struct clk_regmap *gcc_sa8775p_clocks[] = {
-- 
2.43.0



