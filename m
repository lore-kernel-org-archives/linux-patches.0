Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D958E155A26;
	Tue,  9 Jul 2024 11:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523894; cv=none; b=MjcoOF5Du/X/T8rqJfxRkgC3HQt6hEk37fajbc2PQchjJwuHwzEvoLYmUhzZck7cGu1PoWf7hEhre4WgT73puJVctluetKJeqQNPZH4CHNetgy9J7ANG2mvVVcT0bqr1/qFtdkTHlDc83PJzQfOU23RAGwFeiZnSwRjdO6pfq40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523894; c=relaxed/simple;
	bh=JscuFbupbxMySFry+QwgNBMZDa+xlOIlncfagaLX1t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHp9yEwjFhwGUiJjMzYq8SZmVLS9n9+Czfhr1vHlpdRuwNJyCMQUl1k+entfbFDBSnDpPO/0UMyLeefsuYkol3c5PKX5igCPqjCc4pQA5TbqQSxVMZnI7hYUl/RN60gHj/XvknA2ic4Gwo/3qNzUlXvLFjwtLVgmFT7ZGEkGKQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IqSEeBC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IqSEeBC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D32CC3277B;
	Tue,  9 Jul 2024 11:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523894;
	bh=JscuFbupbxMySFry+QwgNBMZDa+xlOIlncfagaLX1t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IqSEeBC9tZDs+ds+6CkvqQYyQzqnQ15euWchHEuL1jdaMWSKBXeIHu0xnSGv/5+VT
	 cE8LaNF3yO8CzN5oMuIfQj2IDqb2x2zautw66jsWWKjh5sPphdWmgjO9YWb/fz9+TH
	 eVRdTRvSLAp2xmNTx3RLG2TGbxlYV4bVKiApQM58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/139] clk: qcom: gcc-sm6350: Fix gpll6* & gpll7 parents
Date: Tue,  9 Jul 2024 13:10:18 +0200
Message-ID: <20240709110702.733502725@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 3414f41a13eb41db15c558fbc695466203dca4fa ]

Both gpll6 and gpll7 are parented to CXO at 19.2 MHz and not to GPLL0
which runs at 600 MHz. Also gpll6_out_even should have the parent gpll6
and not gpll0.

Adjust the parents of these clocks to make Linux report the correct rate
and not absurd numbers like gpll7 at ~25 GHz or gpll6 at 24 GHz.

Corrected rates are the following:

  gpll7              807999902 Hz
  gpll6              768000000 Hz
     gpll6_out_even  384000000 Hz
  gpll0              600000000 Hz
     gpll0_out_odd   200000000 Hz
     gpll0_out_even  300000000 Hz

And because gpll6 is the parent of gcc_sdcc2_apps_clk_src (at 202 MHz)
that clock also reports the correct rate now and avoids this warning:

  [    5.984062] mmc0: Card appears overclocked; req 202000000 Hz, actual 6312499237 Hz

Fixes: 131abae905df ("clk: qcom: Add SM6350 GCC driver")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20240508-sm6350-gpll-fix-v1-1-e4ea34284a6d@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm6350.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm6350.c b/drivers/clk/qcom/gcc-sm6350.c
index cf4a7b6e0b23a..0559a33faf00e 100644
--- a/drivers/clk/qcom/gcc-sm6350.c
+++ b/drivers/clk/qcom/gcc-sm6350.c
@@ -100,8 +100,8 @@ static struct clk_alpha_pll gpll6 = {
 		.enable_mask = BIT(6),
 		.hw.init = &(struct clk_init_data){
 			.name = "gpll6",
-			.parent_hws = (const struct clk_hw*[]){
-				&gpll0.clkr.hw,
+			.parent_data = &(const struct clk_parent_data){
+				.fw_name = "bi_tcxo",
 			},
 			.num_parents = 1,
 			.ops = &clk_alpha_pll_fixed_fabia_ops,
@@ -124,7 +124,7 @@ static struct clk_alpha_pll_postdiv gpll6_out_even = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll6_out_even",
 		.parent_hws = (const struct clk_hw*[]){
-			&gpll0.clkr.hw,
+			&gpll6.clkr.hw,
 		},
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_fabia_ops,
@@ -139,8 +139,8 @@ static struct clk_alpha_pll gpll7 = {
 		.enable_mask = BIT(7),
 		.hw.init = &(struct clk_init_data){
 			.name = "gpll7",
-			.parent_hws = (const struct clk_hw*[]){
-				&gpll0.clkr.hw,
+			.parent_data = &(const struct clk_parent_data){
+				.fw_name = "bi_tcxo",
 			},
 			.num_parents = 1,
 			.ops = &clk_alpha_pll_fixed_fabia_ops,
-- 
2.43.0



