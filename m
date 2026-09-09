Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D708556853C;
	Wed,  9 Sep 2026 13:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962259; cv=none; b=Tr7QRy5dex8TtRT/bx5oMM49h82c6lc3ZCi5XLu7UkuSV4HybxTGTunLsc6P2k47ImVD1zE0yTrJ7CHH9rsfF98P+y26+XdE41bn3ua2b8fh06ovOSuevBKAO8fSfBcE6voRiqCCqvbBFqVoeIZ52RXnGGrAwkX8fiSLOcEIWx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962259; c=relaxed/simple;
	bh=mF7CkR2QLZX6hDghUDU/Zo25uqcM+CNsCWFqIAdb7DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPn7dZ/QfzDOG4bNPMiv00wAIwuUges66VwTXEAeEkxmkunkkn2nbdWZgGzguc95P41/7gPRFHr5IfHCaXI0xk2DWf+zb7NdzJg+UrGRjaEreRPeMZcdkXu5xds6klukEf0+PssMfYYsStfj55Fw1ShAf43bQ7L3RV9QxvAD44Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoamWMEJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoamWMEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003161F00A3E;
	Wed,  9 Sep 2026 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962257;
	bh=sASk+3RheY6ahJzhQuZSLol9sG49OuQ67M6ZvzpY05E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoamWMEJ7YaHd+yHqb9mGllyrFaDurzvNgoEZZVRAib5iTTggal4NobumEAH9MLaL
	 Ajf7VLwX/Fo+BQ0iATmgTGKw4bSrew40wezmD8ul3bI5Z1ObdxfieXR9vNoYAYMSTR
	 wvxMyQUxb5Cmw1SqNA4gjj6DlNa81kSeEko8ZXqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.2 211/556] clk: qcom: gcc-msm8916: Fix enable_reg for gcc_blsp1_sleep_clk
Date: Wed,  9 Sep 2026 15:38:11 +0200
Message-ID: <20260909134237.813270831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit c5339edc6abb601ea10df910ea0b1592fa1016f3 upstream.

According to the APQ8016E TRM, the GCC_BLSP1_SLEEP_CBCR register is
read-only and only has the CLK_OFF bit to check if the clock is running.
This is a shared vote clock, the correct way to enable it is to vote for
BLSP1_SLEEP_CLK_ENA (BIT(9)) in GCC_APCS_CLOCK_BRANCH_ENA_VOTE (0x45004).

Cc: stable@vger.kernel.org
Fixes: 3966fab8b6ab ("clk: qcom: Add MSM8916 Global Clock Controller support")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20260706-qcom-clk-mdm9607-fixes-v2-1-745565101869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-msm8916.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/gcc-msm8916.c
+++ b/drivers/clk/qcom/gcc-msm8916.c
@@ -1589,9 +1589,10 @@ static struct clk_branch gcc_blsp1_ahb_c
 
 static struct clk_branch gcc_blsp1_sleep_clk = {
 	.halt_reg = 0x01004,
+	.halt_check = BRANCH_HALT_VOTED,
 	.clkr = {
-		.enable_reg = 0x01004,
-		.enable_mask = BIT(0),
+		.enable_reg = 0x45004,
+		.enable_mask = BIT(9),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_blsp1_sleep_clk",
 			.parent_data = &(const struct clk_parent_data){


