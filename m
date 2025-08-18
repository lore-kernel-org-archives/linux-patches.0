Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321D121FF5D;
	Mon, 18 Aug 2025 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524351; cv=none; b=P54SKTxQe1Ctx6QbRNjZ0KfYL9nCBqDKTS28SBeYPOAoOHJW4Y71yHBvsKT6z2pgX05VhxvYNqNuZbVSG2wSz+m2rToa+qAWWXvim0QrxRWEIl4fiAyluLYCSLd6TDM3Cpm50FS/DL+UDgEUtYCJpDwFa/owYG7PruyvgxRGSuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524351; c=relaxed/simple;
	bh=A3b/u5sxWkWu+xDjqWwIyzM7F3U7oPAsf6B+zBaBwhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KM9h9y9kFL11eImv0j20eIaKfr9siTHrjaUL5KGJhCU6QQuB8rHevrpfQfWN/9RcnSaFJOqdAWRa9y9IuUpBMKblAnL8WSgAjPdVKkrsqzYL4gHZrvPlCNbAbCzgaazp6+z/AauOuzmTDbZexaLo4qlZ7TOh//lyvdul1Jm2oXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=To09DOpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="To09DOpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974BBC4CEEB;
	Mon, 18 Aug 2025 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524351;
	bh=A3b/u5sxWkWu+xDjqWwIyzM7F3U7oPAsf6B+zBaBwhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=To09DOpl9kXxOd/SkIn32Sb6bI506PFOiLFmOZyLWbOrjLc+MVaJXBZO1RT8gl+gX
	 N5Bm+xFKZYEODlLiSg68l98mPGfzNue/XKyE4wC507UbtJmY5pqxj1yMMbbV5nk7lt
	 22VvYcM+XrGuAos0M+V8JWh9HFFWBv3cHEVauTAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 446/515] clk: qcom: dispcc-sm8750: Fix setting rate byte and pixel clocks
Date: Mon, 18 Aug 2025 14:47:12 +0200
Message-ID: <20250818124515.594693940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 0acf9e65a47d1e489c8b24c45a64436e30bcccf4 upstream.

On SM8750 the setting rate of pixel and byte clocks, while the parent
DSI PHY PLL, fails with:

  disp_cc_mdss_byte0_clk_src: rcg didn't update its configuration.

DSI PHY PLL has to be unprepared and its "PLL Power Down" bits in
CMN_CTRL_0 asserted.

Mark these clocks with CLK_OPS_PARENT_ENABLE to ensure the parent is
enabled during rate changes.

Cc: stable@vger.kernel.org
Fixes: f1080d8dab0f ("clk: qcom: dispcc-sm8750: Add SM8750 Display clock controller")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250520090741.45820-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/dispcc-sm8750.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8750.c b/drivers/clk/qcom/dispcc-sm8750.c
index 877b40d50e6f..ca09da111a50 100644
--- a/drivers/clk/qcom/dispcc-sm8750.c
+++ b/drivers/clk/qcom/dispcc-sm8750.c
@@ -393,7 +393,7 @@ static struct clk_rcg2 disp_cc_mdss_byte0_clk_src = {
 		.name = "disp_cc_mdss_byte0_clk_src",
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_byte2_ops,
 	},
 };
@@ -408,7 +408,7 @@ static struct clk_rcg2 disp_cc_mdss_byte1_clk_src = {
 		.name = "disp_cc_mdss_byte1_clk_src",
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_byte2_ops,
 	},
 };
@@ -712,7 +712,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk0_clk_src = {
 		.name = "disp_cc_mdss_pclk0_clk_src",
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
@@ -727,7 +727,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk1_clk_src = {
 		.name = "disp_cc_mdss_pclk1_clk_src",
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
@@ -742,7 +742,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk2_clk_src = {
 		.name = "disp_cc_mdss_pclk2_clk_src",
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
-- 
2.50.1



