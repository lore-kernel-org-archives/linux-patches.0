Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D300825EF89;
	Tue, 27 May 2025 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366074; cv=none; b=ZONA4Hyl6Z0+a40xU3D/gzz6pJsN2HkzwbtkuR+KiilPe2altFfzccywloZcnTJRLxABA3wMjAgIP/Va9Xk3d6CyhVYFAGlWLCKfWld96QYuiMMbH/CWk/jaqMPdkEh4DJmIrxB0A9xGnS702jvtNREUME2+dqwTaL0sGLNpPqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366074; c=relaxed/simple;
	bh=tAAbmY6cmXhk7KZoh2ALA7edLibAg1Lz9BBERI0k4M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BpyPYVb9TfSeJdZX+7X7MLruKvjNiFX1DP2tYeUkyWcGThSIEqbAHu4/YXz5ePvo4JFNBhtjugSaPKCHMygkenNN5xvtviNSRd4m0vrN+xjD4Rexqjy1c9aQ+iYysAh79cpTatTUVfVy4TqoSN4D4W4Cy8H+jJ3sjtgB3LIYwZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5/0+qHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5/0+qHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED21C4CEE9;
	Tue, 27 May 2025 17:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366074;
	bh=tAAbmY6cmXhk7KZoh2ALA7edLibAg1Lz9BBERI0k4M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5/0+qHGpb7uv7ULEH/6iydl7QvQxKEmMpA4KbM8Kcz9uyKOjYfIYnWrBEQ4fjLj7
	 IU/6ytROMcMQttjQBK21dQUjv+UyXuOC3cSBiTEQii04s5Ck6HvvsTGUOLsTxCL/s0
	 +DVGVx15AsOwvew/j3X43U+mth2dKguNYu7HBCAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kuba=20Szczodrzy=C5=84ski?= <kuba@szczodrzynski.pl>,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 542/626] clk: sunxi-ng: d1: Add missing divider for MMC mod clocks
Date: Tue, 27 May 2025 18:27:15 +0200
Message-ID: <20250527162507.014164680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3f095515f54f9..54d2c7f0ed632 100644
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



