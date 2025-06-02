Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E078F1E0DD8;
	Mon,  2 Jun 2025 14:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874059; cv=none; b=lKNRz/UKr+LlxoUiqHGUQeVcHubYShI7K6hccJaWwLd//1DWuA+GeZlzbgBRGaixEFP5t3bxIO3iB65mqNR6iZnsH5OG4w1AGr2drmq3c/vkvPJAs9HlTKPOAt2GMcrswv+Z+zD22xpgp/3VhY+kekY2Pmc/c2FZ76MAxQA8a1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874059; c=relaxed/simple;
	bh=exr8vI+faovxTHgTjQsoneWpyOx/EP2vj5/WMzcJmJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcNRrlYAz7T1rprLm2wq/n2asemmBd1OqwQtDWOAodaYIN3aXFbgNQnWhtWrJbbiWrG6XZKn9yjgT4JIYNuHN51C46ayiS52IfIX1dBI/j231ZvGcqhh4p3TMh6Ts+JN2tkFFlGYYnYk+QDLrFJMek3A/3Oa5DVltjBE4E0ye5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KPEtxEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KPEtxEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D86AC4CEEB;
	Mon,  2 Jun 2025 14:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874057;
	bh=exr8vI+faovxTHgTjQsoneWpyOx/EP2vj5/WMzcJmJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KPEtxECGHdUBjnZwGXIu6DjRrcqrIxpqF02i9ZcBisHBbdJRQ/BZqC/i0xxWE7QZ
	 pUyBqNetFusGE6WHIHnv7QxtvHmfnUktZUSSZmOswWXuaYrWj3yB0ukwdf7MXyiK/C
	 3oxwgd0BVOPizd18O5qy811Oxrl7n0C5bWJJZheY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kuba=20Szczodrzy=C5=84ski?= <kuba@szczodrzynski.pl>,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 336/444] clk: sunxi-ng: d1: Add missing divider for MMC mod clocks
Date: Mon,  2 Jun 2025 15:46:40 +0200
Message-ID: <20250602134354.567015424@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 98e6da673cc6dd46ca9a599802bd2c8f83606710 ]

The D1/R528/T113 SoCs have a hidden divider of 2 in the MMC mod clocks,
just as other recent SoCs. So far we did not describe that, which led
to the resulting MMC clock rate to be only half of its intended value.

Use a macro that allows to describe a fixed post-divider, to compensate
for that divisor.

This brings the MMC performance on those SoCs to its expected level,
so about 23 MB/s for SD cards, instead of the 11 MB/s measured so far.

Fixes: 35b97bb94111 ("clk: sunxi-ng: Add support for the D1 SoC clocks")
Reported-by: Kuba Szczodrzyński <kuba@szczodrzynski.pl>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20250501120631.837186-1-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun20i-d1.c | 44 ++++++++++++++++------------
 drivers/clk/sunxi-ng/ccu_mp.h        | 22 ++++++++++++++
 2 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun20i-d1.c b/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
index f95c3615ca772..98f107e96317e 100644
--- a/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
+++ b/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
@@ -412,19 +412,23 @@ static const struct clk_parent_data mmc0_mmc1_parents[] = {
 	{ .hw = &pll_periph0_2x_clk.common.hw },
 	{ .hw = &pll_audio1_div2_clk.common.hw },
 };
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(mmc0_clk, "mmc0", mmc0_mmc1_parents, 0x830,
-				       0, 4,	/* M */
-				       8, 2,	/* P */
-				       24, 3,	/* mux */
-				       BIT(31),	/* gate */
-				       0);
-
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(mmc1_clk, "mmc1", mmc0_mmc1_parents, 0x834,
-				       0, 4,	/* M */
-				       8, 2,	/* P */
-				       24, 3,	/* mux */
-				       BIT(31),	/* gate */
-				       0);
+static SUNXI_CCU_MP_DATA_WITH_MUX_GATE_POSTDIV(mmc0_clk, "mmc0",
+					       mmc0_mmc1_parents, 0x830,
+					       0, 4,		/* M */
+					       8, 2,		/* P */
+					       24, 3,		/* mux */
+					       BIT(31),		/* gate */
+					       2,		/* post-div */
+					       0);
+
+static SUNXI_CCU_MP_DATA_WITH_MUX_GATE_POSTDIV(mmc1_clk, "mmc1",
+					       mmc0_mmc1_parents, 0x834,
+					       0, 4,		/* M */
+					       8, 2,		/* P */
+					       24, 3,		/* mux */
+					       BIT(31),		/* gate */
+					       2,		/* post-div */
+					       0);
 
 static const struct clk_parent_data mmc2_parents[] = {
 	{ .fw_name = "hosc" },
@@ -433,12 +437,14 @@ static const struct clk_parent_data mmc2_parents[] = {
 	{ .hw = &pll_periph0_800M_clk.common.hw },
 	{ .hw = &pll_audio1_div2_clk.common.hw },
 };
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(mmc2_clk, "mmc2", mmc2_parents, 0x838,
-				       0, 4,	/* M */
-				       8, 2,	/* P */
-				       24, 3,	/* mux */
-				       BIT(31),	/* gate */
-				       0);
+static SUNXI_CCU_MP_DATA_WITH_MUX_GATE_POSTDIV(mmc2_clk, "mmc2", mmc2_parents,
+					       0x838,
+					       0, 4,		/* M */
+					       8, 2,		/* P */
+					       24, 3,		/* mux */
+					       BIT(31),		/* gate */
+					       2,		/* post-div */
+					       0);
 
 static SUNXI_CCU_GATE_HWS(bus_mmc0_clk, "bus-mmc0", psi_ahb_hws,
 			  0x84c, BIT(0), 0);
diff --git a/drivers/clk/sunxi-ng/ccu_mp.h b/drivers/clk/sunxi-ng/ccu_mp.h
index 6e50f3728fb5f..7d836a9fb3db3 100644
--- a/drivers/clk/sunxi-ng/ccu_mp.h
+++ b/drivers/clk/sunxi-ng/ccu_mp.h
@@ -52,6 +52,28 @@ struct ccu_mp {
 		}							\
 	}
 
+#define SUNXI_CCU_MP_DATA_WITH_MUX_GATE_POSTDIV(_struct, _name, _parents, \
+						_reg,			\
+						_mshift, _mwidth,	\
+						_pshift, _pwidth,	\
+						_muxshift, _muxwidth,	\
+						_gate, _postdiv, _flags)\
+	struct ccu_mp _struct = {					\
+		.enable	= _gate,					\
+		.m	= _SUNXI_CCU_DIV(_mshift, _mwidth),		\
+		.p	= _SUNXI_CCU_DIV(_pshift, _pwidth),		\
+		.mux	= _SUNXI_CCU_MUX(_muxshift, _muxwidth),		\
+		.fixed_post_div	= _postdiv,				\
+		.common	= {						\
+			.reg		= _reg,				\
+			.features	= CCU_FEATURE_FIXED_POSTDIV,	\
+			.hw.init	= CLK_HW_INIT_PARENTS_DATA(_name, \
+							_parents,	\
+							&ccu_mp_ops,	\
+							_flags),	\
+		}							\
+	}
+
 #define SUNXI_CCU_MP_WITH_MUX_GATE(_struct, _name, _parents, _reg,	\
 				   _mshift, _mwidth,			\
 				   _pshift, _pwidth,			\
-- 
2.39.5



