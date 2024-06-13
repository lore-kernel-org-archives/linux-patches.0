Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5980143C46;
	Thu, 13 Jun 2024 11:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279413; cv=none; b=Hd0J4EGb4uSE9u60bMUdb0bMl0QxnVEUulVQzjrS6AxnnzeiNHIrZukfHifNbD9AAQKkgS+Tp2EYYYbCaACiU4NWDQYaI7AmpkFLdscwWkhCbmWSd9+LsUOCKMoAfDceemMLOTveHaGL2XoD6ydpac0G8KF6oT4YvnEgQ574NHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279413; c=relaxed/simple;
	bh=ubVzlbsdahbfBqyAfiYs3n7uViBlhjqSJLwK6KUDj9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVs3UJcqoYv+awyRixNpiveyUSE0kVs1vElZ7hQG52iTtW231JIymuv77RlbzS0iy2b6Slhu+15jspfYgGIkTphNzS3LWpA6IRf0EFtx1R61MQhL64vvQNTnL7ghIltIGAhc2yDJEL9Ll7YmbxlM87S1Rc9ZY+UqfnRJxlNQVPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3zUqLP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3zUqLP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E49DC2BBFC;
	Thu, 13 Jun 2024 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279413;
	bh=ubVzlbsdahbfBqyAfiYs3n7uViBlhjqSJLwK6KUDj9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3zUqLP2KVpkAbZCoGlFD4Ep8UiStBLvkknRhOPviM4NY/conmjw2XxnPFctVJtAA
	 Jwhhs+X4BX0QvTGQFMthMdL8kkDur9jeTwmgER5IXhyH0739jTA1dGggX8kvCINn33
	 Pirj12LYm90Z6SJNX/N7JvZI2wAjSns4CHXwpELg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 068/157] clk: qcom: apss-ipq-pll: use stromer ops for IPQ5018 to fix boot failure
Date: Thu, 13 Jun 2024 13:33:13 +0200
Message-ID: <20240613113230.053641198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit 5fce38e2a1a97900989d9fedebcf5a4dacdaee30 upstream.

Booting v6.8 results in a hang on various IPQ5018 based boards.
Investigating the problem showed that the hang happens when the
clk_alpha_pll_stromer_plus_set_rate() function tries to write
into the PLL_MODE register of the APSS PLL.

Checking the downstream code revealed that it uses [1] stromer
specific operations for IPQ5018, whereas in the current code
the stromer plus specific operations are used.

The ops in the 'ipq_pll_stromer_plus' clock definition can't be
changed since that is needed for IPQ5332, so add a new alpha pll
clock declaration which uses the correct stromer ops and use this
new clock for IPQ5018 to avoid the boot failure.

Also, change pll_type in 'ipq5018_pll_data' to
CLK_ALPHA_PLL_TYPE_STROMER to better reflect that it is a Stromer
PLL and change the apss_ipq_pll_probe() function accordingly.

1. https://git.codelinaro.org/clo/qsdk/oss/kernel/linux-ipq-5.4/-/blob/NHSS.QSDK.12.4/drivers/clk/qcom/apss-ipq5018.c#L67

Cc: stable@vger.kernel.org
Fixes: 50492f929486 ("clk: qcom: apss-ipq-pll: add support for IPQ5018")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Tested-by: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>
Reviewed-by: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>
Link: https://lore.kernel.org/r/20240315-apss-ipq-pll-ipq5018-hang-v2-1-6fe30ada2009@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/apss-ipq-pll.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/clk/qcom/apss-ipq-pll.c
+++ b/drivers/clk/qcom/apss-ipq-pll.c
@@ -55,6 +55,29 @@ static struct clk_alpha_pll ipq_pll_huay
 	},
 };
 
+static struct clk_alpha_pll ipq_pll_stromer = {
+	.offset = 0x0,
+	/*
+	 * Reuse CLK_ALPHA_PLL_TYPE_STROMER_PLUS register offsets.
+	 * Although this is a bit confusing, but the offset values
+	 * are correct nevertheless.
+	 */
+	.regs = ipq_pll_offsets[CLK_ALPHA_PLL_TYPE_STROMER_PLUS],
+	.flags = SUPPORTS_DYNAMIC_UPDATE,
+	.clkr = {
+		.enable_reg = 0x0,
+		.enable_mask = BIT(0),
+		.hw.init = &(const struct clk_init_data) {
+			.name = "a53pll",
+			.parent_data = &(const struct clk_parent_data) {
+				.fw_name = "xo",
+			},
+			.num_parents = 1,
+			.ops = &clk_alpha_pll_stromer_ops,
+		},
+	},
+};
+
 static struct clk_alpha_pll ipq_pll_stromer_plus = {
 	.offset = 0x0,
 	.regs = ipq_pll_offsets[CLK_ALPHA_PLL_TYPE_STROMER_PLUS],
@@ -145,8 +168,8 @@ struct apss_pll_data {
 };
 
 static const struct apss_pll_data ipq5018_pll_data = {
-	.pll_type = CLK_ALPHA_PLL_TYPE_STROMER_PLUS,
-	.pll = &ipq_pll_stromer_plus,
+	.pll_type = CLK_ALPHA_PLL_TYPE_STROMER,
+	.pll = &ipq_pll_stromer,
 	.pll_config = &ipq5018_pll_config,
 };
 
@@ -204,7 +227,8 @@ static int apss_ipq_pll_probe(struct pla
 
 	if (data->pll_type == CLK_ALPHA_PLL_TYPE_HUAYRA)
 		clk_alpha_pll_configure(data->pll, regmap, data->pll_config);
-	else if (data->pll_type == CLK_ALPHA_PLL_TYPE_STROMER_PLUS)
+	else if (data->pll_type == CLK_ALPHA_PLL_TYPE_STROMER ||
+		 data->pll_type == CLK_ALPHA_PLL_TYPE_STROMER_PLUS)
 		clk_stromer_pll_configure(data->pll, regmap, data->pll_config);
 
 	ret = devm_clk_register_regmap(dev, &data->pll->clkr);


