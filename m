Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A790E3382CB;
	Sat, 12 Sep 2026 19:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242116; cv=none; b=T+ESzn9IZBkx9zjwQzHtyHdkuNPl9WzoQm9P0YKLsPZTkebuJ+uw5tA8zpN5KpDGJbQ8ejvual2km+TXRlNYA09QA/rkoq8E/qTr4tLd1k4ENU7U0Q85/wX20jXWAjCRfe7+qOZqRtVekumWjW7yCWdShkExjItEEg2LDTcCdNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242116; c=relaxed/simple;
	bh=po3HLJmPZuAEIaduN6v5C3yyYjORu1czOPr/h12TOwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFPFlMRzw5ROIOZfeU7+bp7i+vtox2Kt2wfCxi4IJKDUWyMYfH+5zFAluytAoJp1t59YJacI7ZOYaRD73SsZqjR3+9hMEGBRurOXvkRv5YbBF153UlOnik2Q6EEu9CptX8XBAdBQ+LPwXqZX+vHiXbTa/dGw5SpDiCT7+DbaVpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEW6NCOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEW6NCOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0473D1F000FF;
	Sat, 12 Sep 2026 19:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242115;
	bh=bePpccrOJuKppBFDfZsDGO3F/nZpoEYDSgeVBG9Prn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEW6NCORiBVKt9Xg3boW3gcpMK5X0j7O1IxcRg+8xXuIxiYiD7ZFYu/ZAD7KRKhHD
	 bj2KX+Ca9AdteC5I84IUXovzBihPzPQY4L/+3wQGsJv8eE03xkmYYVvvs6z1mUdbo7
	 5WjwBXT4DJeo7qxZyVIYU6ciTm48W83SxIYRkmDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 248/798] clk: qcom: gcc-msm8916: Fix enable_reg for gcc_blsp1_sleep_clk
Date: Sat, 12 Sep 2026 08:57:56 +0200
Message-ID: <20260912065522.842873989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1539,9 +1539,10 @@ static struct clk_branch gcc_blsp1_ahb_c
 
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
 			.parent_names = (const char *[]){


