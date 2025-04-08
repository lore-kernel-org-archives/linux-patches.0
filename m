Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4FF266EEA;
	Tue,  8 Apr 2025 11:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112748; cv=none; b=qB9E6lkWzQ0+jkI5Ip/cpSosZT+nYesMxZaoGVjzPsWVy9YSlYjFPJks9v8tBL5E0AUm2+rh7s2Gh17mxfAXagLcXH6ut6WWI3prtRrrBRDho+LoK7AVf05nDIKJ7YnafmZO1IeU9qwEzyaJKabk8pfrkrpdL+jE/qfxf/rv1Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112748; c=relaxed/simple;
	bh=+sdad2PZWoQNwo95PgTI7GYL2O6g6xzStDx+LCQmBiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9ved9eH3bqDHQj0ZnFlSxUVcMNHGR5UM545kQGS4PzYQ28ZJasY6924sEds1BSwC1PII1RW5Vt4N9v/xvDAG6PA9E8xfdQYofsgwZ5Z03+nZbwKU6kxHDrUCYx+fDnQeKaN7lgx6M34BMO4WsBC+zL0C6ktm0nUDUUo48FVdiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRjy3Vxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRjy3Vxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B03C4CEE5;
	Tue,  8 Apr 2025 11:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112748;
	bh=+sdad2PZWoQNwo95PgTI7GYL2O6g6xzStDx+LCQmBiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRjy3VxxV2Ck/t4Y0tGOdFziXyW996u5Zg5ebLCrsBwFkUIn+01EqC6sxc3OKPCrp
	 mL35hmNWAlMC/kuQ88usKrgCKAbNc5UD1pk3yqR7HK37lroYaubuyxQFZhR1HT6R6K
	 G3gGrpct1oIFUIBJ9f+r6UUySPUlxIslI3sLAyQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/279] clk: amlogic: g12b: fix cluster A parent data
Date: Tue,  8 Apr 2025 12:49:26 +0200
Message-ID: <20250408104831.270153626@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 8995f8f108c3ac5ad52b12a6cfbbc7b3b32e9a58 ]

Several clocks used by both g12a and g12b use the g12a cpu A clock hw
pointer as clock parent. This is incorrect on g12b since the parents of
cluster A cpu clock are different. Also the hw clock provided as parent to
these children is not even registered clock on g12b.

Fix the problem by reverting to the global namespace and let CCF pick
the appropriate, as it is already done for other clocks, such as
cpu_clk_trace_div.

Fixes: 25e682a02d91 ("clk: meson: g12a: migrate to the new parent description method")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241213-amlogic-clk-g12a-cpua-parent-fix-v1-1-d8c0f41865fe@baylibre.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/g12a.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/meson/g12a.c b/drivers/clk/meson/g12a.c
index 310accf94830b..a623596c1e490 100644
--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -1136,8 +1136,18 @@ static struct clk_regmap g12a_cpu_clk_div16_en = {
 	.hw.init = &(struct clk_init_data) {
 		.name = "cpu_clk_div16_en",
 		.ops = &clk_regmap_gate_ro_ops,
-		.parent_hws = (const struct clk_hw *[]) {
-			&g12a_cpu_clk.hw
+		.parent_data = &(const struct clk_parent_data) {
+			/*
+			 * Note:
+			 * G12A and G12B have different cpu clocks (with
+			 * different struct clk_hw). We fallback to the global
+			 * naming string mechanism so this clock picks
+			 * up the appropriate one. Same goes for the other
+			 * clock using cpu cluster A clock output and present
+			 * on both G12 variant.
+			 */
+			.name = "cpu_clk",
+			.index = -1,
 		},
 		.num_parents = 1,
 		/*
@@ -1202,7 +1212,10 @@ static struct clk_regmap g12a_cpu_clk_apb_div = {
 	.hw.init = &(struct clk_init_data){
 		.name = "cpu_clk_apb_div",
 		.ops = &clk_regmap_divider_ro_ops,
-		.parent_hws = (const struct clk_hw *[]) { &g12a_cpu_clk.hw },
+		.parent_data = &(const struct clk_parent_data) {
+			.name = "cpu_clk",
+			.index = -1,
+		},
 		.num_parents = 1,
 	},
 };
@@ -1236,7 +1249,10 @@ static struct clk_regmap g12a_cpu_clk_atb_div = {
 	.hw.init = &(struct clk_init_data){
 		.name = "cpu_clk_atb_div",
 		.ops = &clk_regmap_divider_ro_ops,
-		.parent_hws = (const struct clk_hw *[]) { &g12a_cpu_clk.hw },
+		.parent_data = &(const struct clk_parent_data) {
+			.name = "cpu_clk",
+			.index = -1,
+		},
 		.num_parents = 1,
 	},
 };
@@ -1270,7 +1286,10 @@ static struct clk_regmap g12a_cpu_clk_axi_div = {
 	.hw.init = &(struct clk_init_data){
 		.name = "cpu_clk_axi_div",
 		.ops = &clk_regmap_divider_ro_ops,
-		.parent_hws = (const struct clk_hw *[]) { &g12a_cpu_clk.hw },
+		.parent_data = &(const struct clk_parent_data) {
+			.name = "cpu_clk",
+			.index = -1,
+		},
 		.num_parents = 1,
 	},
 };
@@ -1305,13 +1324,6 @@ static struct clk_regmap g12a_cpu_clk_trace_div = {
 		.name = "cpu_clk_trace_div",
 		.ops = &clk_regmap_divider_ro_ops,
 		.parent_data = &(const struct clk_parent_data) {
-			/*
-			 * Note:
-			 * G12A and G12B have different cpu_clks (with
-			 * different struct clk_hw). We fallback to the global
-			 * naming string mechanism so cpu_clk_trace_div picks
-			 * up the appropriate one.
-			 */
 			.name = "cpu_clk",
 			.index = -1,
 		},
-- 
2.39.5



