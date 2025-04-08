Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D522690D7;
	Tue,  8 Apr 2025 11:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113241; cv=none; b=Gp1mRZBU8Di9jz0rsIHAtkvB5L4f9B8k0sHV4S+mmh2IqCpdG6VtzmG/YorlgsTm5j0nX9/GkbSJvwXUPMw8X4xoBKFWCmuTK+OLOSsI9Dudzs2GdZFvEEfYN16QWAE0In59TcPqnsASRLkZrWJVmhIITvKeidspuw3gXBwc55E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113241; c=relaxed/simple;
	bh=Ja/NdBSMPpuVtlxZYsVuNC/uCy7yvz49bX4W2px9GXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfikyCo1o8Iz6GwMWwK8uNgoGLlyF3iIWJ6yvdI8xp1v+/g0Rb65OhxoS5tedD9Jpe+ubAs5EN3gaJ6+0h8Ly+bpXDqZEVJhZV1HBWNcTfn4UuLwv4QBBychVT7WAwEo6llLWYPSWG4JggJEsNia0fI/jVBKv7INsuSa5wzSUlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7CWe4So; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7CWe4So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB80C4CEE5;
	Tue,  8 Apr 2025 11:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113241;
	bh=Ja/NdBSMPpuVtlxZYsVuNC/uCy7yvz49bX4W2px9GXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7CWe4SorKvaXPdG8xNF3mTbziPZ8JPLVtPAMGEZGFSNSEG13Xkhdk1uoCBWMrIya
	 KqQyl2zurywTKKPZCeGNx3w41uzlpPPgu2FDTJl5ZEMnVnhqsTSXglIM4YxM3gA5vb
	 IYjokzktdtyOPr/qE486GFeUrxgSLSsDaXJtd5ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/268] clk: amlogic: g12b: fix cluster A parent data
Date: Tue,  8 Apr 2025 12:48:17 +0200
Message-ID: <20250408104830.811460089@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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
index f373a8d48b1d3..faaf33a82721d 100644
--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -1138,8 +1138,18 @@ static struct clk_regmap g12a_cpu_clk_div16_en = {
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
@@ -1204,7 +1214,10 @@ static struct clk_regmap g12a_cpu_clk_apb_div = {
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
@@ -1238,7 +1251,10 @@ static struct clk_regmap g12a_cpu_clk_atb_div = {
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
@@ -1272,7 +1288,10 @@ static struct clk_regmap g12a_cpu_clk_axi_div = {
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
@@ -1307,13 +1326,6 @@ static struct clk_regmap g12a_cpu_clk_trace_div = {
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



