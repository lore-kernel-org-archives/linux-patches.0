Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F911DED78;
	Wed, 19 Feb 2025 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956956; cv=none; b=Y8snxT6qxHiQmgWmvd/IBqLyEQ85xGwcV1OAEqEgsFRVzCu0dqumvUHyevLE8rs/89Vr4q9X3iUKwoo23BMWKhYOQcIE09QAF4l17Hp0jwGeSbbyFFH4PPG5nSL4fE9YJTwtbQ0qBJECW5MG1yvPCCGZ20uMcfwpGgUgCgk4e0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956956; c=relaxed/simple;
	bh=LzsDJ+xytW3P8RiSpd+BL5mxEOfTnD88GAu/cscPJ20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRhCtYG0l8vLlMiqJ+1sEWHwrxq7cPZB/dxXRCDWsdr13fHd1s+WxuMtOYEjHGJmAAqzW8dG/LqiR7iaONC40DOTduvE2keGY7ugWkfSRonc6Vb4uLJnersewD04Rg1qZ0pM7CX/aerjeejKb6zdwSSdjUzJwvQ63qVTPO4W/r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04zt6Wkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04zt6Wkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD92FC4CEE7;
	Wed, 19 Feb 2025 09:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956956;
	bh=LzsDJ+xytW3P8RiSpd+BL5mxEOfTnD88GAu/cscPJ20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04zt6WkcvaPZs2jhwH0hP4byu78y++RImagwbnZxr+ZxX3b758tN06VzuN3rRavCM
	 NNlERkJnISzajGXrFPfHaFjPr3MZBHbHY7u4oSrJo9SgXUNHYVta5xakUCL7raMcTz
	 0AW2+/owUZ43t1tlp9l5aKqkfw8Null4TpayG32A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 359/578] clk: qcom: dispcc-sm6350: Add missing parent_map for a clock
Date: Wed, 19 Feb 2025 09:26:03 +0100
Message-ID: <20250219082707.142765717@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

commit d4cdb196f182d2fbe336c968228be00d8c3fed05 upstream.

If a clk_rcg2 has a parent, it should also have parent_map defined,
otherwise we'll get a NULL pointer dereference when calling clk_set_rate
like the following:

  [    3.388105] Call trace:
  [    3.390664]  qcom_find_src_index+0x3c/0x70 (P)
  [    3.395301]  qcom_find_src_index+0x1c/0x70 (L)
  [    3.399934]  _freq_tbl_determine_rate+0x48/0x100
  [    3.404753]  clk_rcg2_determine_rate+0x1c/0x28
  [    3.409387]  clk_core_determine_round_nolock+0x58/0xe4
  [    3.421414]  clk_core_round_rate_nolock+0x48/0xfc
  [    3.432974]  clk_core_round_rate_nolock+0xd0/0xfc
  [    3.444483]  clk_core_set_rate_nolock+0x8c/0x300
  [    3.455886]  clk_set_rate+0x38/0x14c

Add the parent_map property for the clock where it's missing and also
un-inline the parent_data as well to keep the matching parent_map and
parent_data together.

Fixes: 837519775f1d ("clk: qcom: Add display clock controller driver for SM6350")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241220-sm6350-parent_map-v1-2-64f3d04cb2eb@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/dispcc-sm6350.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/clk/qcom/dispcc-sm6350.c
+++ b/drivers/clk/qcom/dispcc-sm6350.c
@@ -187,13 +187,12 @@ static struct clk_rcg2 disp_cc_mdss_dp_a
 	.cmd_rcgr = 0x1144,
 	.mnd_width = 0,
 	.hid_width = 5,
+	.parent_map = disp_cc_parent_map_6,
 	.freq_tbl = ftbl_disp_cc_mdss_dp_aux_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_dp_aux_clk_src",
-		.parent_data = &(const struct clk_parent_data){
-			.fw_name = "bi_tcxo",
-		},
-		.num_parents = 1,
+		.parent_data = disp_cc_parent_data_6,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_6),
 		.ops = &clk_rcg2_ops,
 	},
 };


