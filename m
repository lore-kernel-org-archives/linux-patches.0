Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFF619AD51;
	Tue, 16 Jul 2024 16:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146220; cv=none; b=OZtzK032seDCWbi6u8cF+RQq9VvQwMG08SjyhDuKXVRxtinvg5v1zj7qaK2Uux9bIDpdZl8uXO01v1epYhLB5//nizDQ4qUHEmkRv8FvgDTb4WLnbUV8abMWSOAjtf1niMUqffBPch0f86dEfit5DWGm4Zoncf5rlSBIEnGNmy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146220; c=relaxed/simple;
	bh=x6roRpgTbFnPVjGXfApWkvU3H+Q1BcDWFsMWdddjDQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwZJ339/q8nal49k/1JdiBE9MLYuO+Pf9FCUg7GKPGf00KuMq8stUFt51sL2syc5qhIKGm8GaKH2qvaXCoCIGmY+RdL/jWJybRC7A6dAvIvAA16bRYDpFl4SyqpCwWWU7JjcHjxSeGkUrjdI41zdw/jH8d9iqRJdExJslSwBEi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KgSX5Wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KgSX5Wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521ACC116B1;
	Tue, 16 Jul 2024 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146220;
	bh=x6roRpgTbFnPVjGXfApWkvU3H+Q1BcDWFsMWdddjDQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KgSX5WahEXareP3MmelEozaxqN2gUT7lO+CavOGvTY3xNpcr76UZOl063TngNrYY
	 Jy8gIXStuIayQm0fhlWd9lP+TSnGWe2z5oEU2fDfn6mMfS9k/lvTBwdk2U7c5ygNd8
	 892xrX/OmltreMjNaODVYbGuvyiuTKrZ5qDmJjTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/144] clk: qcom: gcc-sm6350: Fix gpll6* & gpll7 parents
Date: Tue, 16 Jul 2024 17:32:13 +0200
Message-ID: <20240716152755.008604267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e32ad7499285f..84ae27184cfd0 100644
--- a/drivers/clk/qcom/gcc-sm6350.c
+++ b/drivers/clk/qcom/gcc-sm6350.c
@@ -99,8 +99,8 @@ static struct clk_alpha_pll gpll6 = {
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
@@ -123,7 +123,7 @@ static struct clk_alpha_pll_postdiv gpll6_out_even = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll6_out_even",
 		.parent_hws = (const struct clk_hw*[]){
-			&gpll0.clkr.hw,
+			&gpll6.clkr.hw,
 		},
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_fabia_ops,
@@ -138,8 +138,8 @@ static struct clk_alpha_pll gpll7 = {
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



