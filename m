Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624011422D8;
	Thu, 13 Feb 2025 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460431; cv=none; b=JTHe9y5JBnYYE9lAbDp2/R1ne6TOwmVL1xbYyESVYULB8rt1ugo7oIKopoQiZV9AzZBYZs1Nouj3HsRIPuYC0t+XCIyfweqagqsgDBbr6Q9sePaRxAtdQXKZciJpQgqcFxmdTL0GuCxctDch6dtCnIoS8/zRmr20hEaOdjXax1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460431; c=relaxed/simple;
	bh=JWeyU3RAbGp96yvAg6o0qYZCTyznupDatScm6nBMgiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ny3dnlRAz7bvo9jPGhRk4+zWg6JnT6bKc1pv9DlavmLbkrjNx2lMJeck9HrScsERZgBdUVwGbFLVM8NoMO5hK1fbZcEFRRbhEPhWqM+BtZbj5963LA+YrZEyG9AZJ4Aqke/SylpD5WZ2Hcg0q4ny71b7gvv7kAgJIPl0HQO0RFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHw06tzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHw06tzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C551FC4CED1;
	Thu, 13 Feb 2025 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460431;
	bh=JWeyU3RAbGp96yvAg6o0qYZCTyznupDatScm6nBMgiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHw06tztPXhv/S6gEsaZq366FSNqR99mGFtfHoW0x6fYt/gM7UPr2g0SNXDb4Y9o/
	 LSDJbptZj/CEm8PivUoTrwo6QDLM3ZSoe+AO1fnjIsCInC9KmQyUUScXGb1UsZARDX
	 7NkF4p0ur29hpCz3qs3CvBo+XUMZVksZN+mZeTNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 111/273] clk: qcom: dispcc-sm6350: Add missing parent_map for a clock
Date: Thu, 13 Feb 2025 15:28:03 +0100
Message-ID: <20250213142411.732309554@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


