Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D8638389;
	Thu, 13 Feb 2025 14:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457674; cv=none; b=WZ/0ugWM+7hN1Dv1JzxpVWwh6VBqo+Lxmp/gGHbNSJUqjAhldEMKfCbVtFtUN95u9EVka9Bok1orSlV7JZ4gq9INJOG29cUMsziQhb5WnhhCL/mvIJfrE3sd1j+x/EEBnIfg3SeEERmjsWtEb6UI0n5iMK5XRDktjHsZdIuHk7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457674; c=relaxed/simple;
	bh=79PcT4ytbGiwh9mE1+gUl5PWnMyX/yEPmgNYd8w/1/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ohm5wnF4+5yzhLGnEDFm3RfgVCa0LcLBPB7hWzljr7IrNgWsMrCrDd3zIkVxnVKcZYUCsUNBgzfES3G8iQRrXj3fYuFj6nd2gYJflrmtx6oIIr+wJNWBrv4RwqDTFYDJPSPunLcn4C/cRxauGxAYdsrLwgg2i5raZbi8XfHtSPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoUy/txY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoUy/txY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C07C4CED1;
	Thu, 13 Feb 2025 14:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457674;
	bh=79PcT4ytbGiwh9mE1+gUl5PWnMyX/yEPmgNYd8w/1/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoUy/txY6+7/TuUjYcO4oNeF6dyrAkxZq5yD026VNZ1VeuDwQPWMQ+I/xJGNoAzLF
	 UkHX0zsvl0IuebTEWPPW2TIb2hA4FOKmY8CiNuQuOuH0hwi8iPeaMetqSvRO2jF3fk
	 MNMVaVy4RJc2xPhFKQcMrGdXYkBtSQlu/BXQ2OEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 180/422] clk: qcom: gcc-sm6350: Add missing parent_map for two clocks
Date: Thu, 13 Feb 2025 15:25:29 +0100
Message-ID: <20250213142443.492690442@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

commit 96fe1a7ee477d701cfc98ab9d3c730c35d966861 upstream.

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

Add the parent_map property for two clocks where it's missing and also
un-inline the parent_data as well to keep the matching parent_map and
parent_data together.

Fixes: 131abae905df ("clk: qcom: Add SM6350 GCC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241220-sm6350-parent_map-v1-1-64f3d04cb2eb@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-sm6350.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/clk/qcom/gcc-sm6350.c
+++ b/drivers/clk/qcom/gcc-sm6350.c
@@ -182,6 +182,14 @@ static const struct clk_parent_data gcc_
 	{ .hw = &gpll0_out_odd.clkr.hw },
 };
 
+static const struct parent_map gcc_parent_map_3[] = {
+	{ P_BI_TCXO, 0 },
+};
+
+static const struct clk_parent_data gcc_parent_data_3[] = {
+	{ .fw_name = "bi_tcxo" },
+};
+
 static const struct parent_map gcc_parent_map_4[] = {
 	{ P_BI_TCXO, 0 },
 	{ P_GPLL0_OUT_MAIN, 1 },
@@ -701,13 +709,12 @@ static struct clk_rcg2 gcc_ufs_phy_phy_a
 	.cmd_rcgr = 0x3a0b0,
 	.mnd_width = 0,
 	.hid_width = 5,
+	.parent_map = gcc_parent_map_3,
 	.freq_tbl = ftbl_gcc_ufs_phy_phy_aux_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_ufs_phy_phy_aux_clk_src",
-		.parent_data = &(const struct clk_parent_data){
-			.fw_name = "bi_tcxo",
-		},
-		.num_parents = 1,
+		.parent_data = gcc_parent_data_3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_3),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -764,13 +771,12 @@ static struct clk_rcg2 gcc_usb30_prim_mo
 	.cmd_rcgr = 0x1a034,
 	.mnd_width = 0,
 	.hid_width = 5,
+	.parent_map = gcc_parent_map_3,
 	.freq_tbl = ftbl_gcc_usb30_prim_mock_utmi_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_usb30_prim_mock_utmi_clk_src",
-		.parent_data = &(const struct clk_parent_data){
-			.fw_name = "bi_tcxo",
-		},
-		.num_parents = 1,
+		.parent_data = gcc_parent_data_3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_3),
 		.ops = &clk_rcg2_ops,
 	},
 };


