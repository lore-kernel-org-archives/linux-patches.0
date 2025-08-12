Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D58D1A01BF;
	Tue, 12 Aug 2025 18:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024407; cv=none; b=GIvG2RFq8In7UERJM7wGFJYty2C3yYk0HniBHqmiKmVkLF9mq7v5VurThtTKpH0VdgwBANOGZd6CaeT3693lMuvSfLaW6NY7cJ2bdA9aGhAwHVB4Ho9Hj2DymotCKHUFGW9YKpG6D6M+xDhSDdoF21fr4HKJ/tp6MpjMQcI9YyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024407; c=relaxed/simple;
	bh=V1JaOVhGLJKGQnjZQw84fbAI1C9OvlKbm/J0qk1cIDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjPxK95nIaPj/+h9ziwOdB+PqDQnq7G63MU9wrYlxpadV5CTXlUWx0hviW/FKnjwX3gKhYgeM5rZzObyj9Wao5iKgX3CffZSxtxqv/SaKjq/u4R0YGc042CElRju/t6cWTb4PaouNHNno/k+ws4bO8iaIl/izq9oJm2AwzYXKHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZh3lb0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZh3lb0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C1FC4CEF1;
	Tue, 12 Aug 2025 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024407;
	bh=V1JaOVhGLJKGQnjZQw84fbAI1C9OvlKbm/J0qk1cIDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZh3lb0uh6SHahrjyX0mcfM/gsLVr2Fi4tB+QNuCwy6T5k/PsBw6nbIPhFDwi3bd6
	 rutl3SfdDrD6N3DZL+Z3LUZ7d2STxFFnaRhGn3D+GvPzmBuQFafSMBbyEcA7DaquRS
	 effAWhUKD7XypSsHYb9SDYVMq3dQOmg5g5Boi+9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@riscstar.com>,
	Guodong Xu <guodong@riscstar.com>,
	Haylen Chu <heylenay@4d2.org>,
	Yixun Lan <dlan@gentoo.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 364/627] clk: spacemit: mark K1 pll1_d8 as critical
Date: Tue, 12 Aug 2025 19:30:59 +0200
Message-ID: <20250812173433.134374162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@riscstar.com>

[ Upstream commit 7554729de27daf6d54bcf8689d863bbe267828bf ]

The pll1_d8 clock is enabled by the boot loader, and is ultimately a
parent for numerous clocks, including those used by APB and AXI buses.
Guodong Xu discovered that this clock got disabled while responding to
getting -EPROBE_DEFER when requesting a reset controller.

The needed clock (CLK_DMA, along with its parents) had already been
enabled.  To respond to the probe deferral return, the CLK_DMA clock
was disabled, and this led to parent clocks also reducing their enable
count.  When the enable count for pll1_d8 was decremented it became 0,
which caused it to be disabled.  This led to a system hang.

Marking that clock critical resolves this by preventing it from being
disabled.

Define a new macro CCU_FACTOR_GATE_DEFINE() to allow clock flags to
be supplied for a CCU_FACTOR_GATE clock.

Fixes: 1b72c59db0add ("clk: spacemit: Add clock support for SpacemiT K1 SoC")
Signed-off-by: Alex Elder <elder@riscstar.com>
Tested-by: Guodong Xu <guodong@riscstar.com>
Reviewed-by: Haylen Chu <heylenay@4d2.org>
Link: https://lore.kernel.org/r/20250612224856.1105924-1-elder@riscstar.com
Signed-off-by: Yixun Lan <dlan@gentoo.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu-k1.c  |  3 ++-
 drivers/clk/spacemit/ccu_mix.h | 11 ++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/spacemit/ccu-k1.c b/drivers/clk/spacemit/ccu-k1.c
index cdde37a05235..df65009a07bb 100644
--- a/drivers/clk/spacemit/ccu-k1.c
+++ b/drivers/clk/spacemit/ccu-k1.c
@@ -170,7 +170,8 @@ CCU_FACTOR_GATE_DEFINE(pll1_d4, CCU_PARENT_HW(pll1), APBS_PLL1_SWCR2, BIT(3), 4,
 CCU_FACTOR_GATE_DEFINE(pll1_d5, CCU_PARENT_HW(pll1), APBS_PLL1_SWCR2, BIT(4), 5, 1);
 CCU_FACTOR_GATE_DEFINE(pll1_d6, CCU_PARENT_HW(pll1), APBS_PLL1_SWCR2, BIT(5), 6, 1);
 CCU_FACTOR_GATE_DEFINE(pll1_d7, CCU_PARENT_HW(pll1), APBS_PLL1_SWCR2, BIT(6), 7, 1);
-CCU_FACTOR_GATE_DEFINE(pll1_d8, CCU_PARENT_HW(pll1), APBS_PLL1_SWCR2, BIT(7), 8, 1);
+CCU_FACTOR_GATE_FLAGS_DEFINE(pll1_d8, CCU_PARENT_HW(pll1), APBS_PLL1_SWCR2, BIT(7), 8, 1,
+		CLK_IS_CRITICAL);
 CCU_FACTOR_GATE_DEFINE(pll1_d11_223p4, CCU_PARENT_HW(pll1), APBS_PLL1_SWCR2, BIT(15), 11, 1);
 CCU_FACTOR_GATE_DEFINE(pll1_d13_189, CCU_PARENT_HW(pll1), APBS_PLL1_SWCR2, BIT(16), 13, 1);
 CCU_FACTOR_GATE_DEFINE(pll1_d23_106p8, CCU_PARENT_HW(pll1), APBS_PLL1_SWCR2, BIT(20), 23, 1);
diff --git a/drivers/clk/spacemit/ccu_mix.h b/drivers/clk/spacemit/ccu_mix.h
index 51d19f5d6aac..54d40cd39b27 100644
--- a/drivers/clk/spacemit/ccu_mix.h
+++ b/drivers/clk/spacemit/ccu_mix.h
@@ -101,17 +101,22 @@ static struct ccu_mix _name = {							\
 	}									\
 }
 
-#define CCU_FACTOR_GATE_DEFINE(_name, _parent, _reg_ctrl, _mask_gate, _div,	\
-			       _mul)						\
+#define CCU_FACTOR_GATE_FLAGS_DEFINE(_name, _parent, _reg_ctrl, _mask_gate, _div,	\
+			       _mul, _flags)					\
 static struct ccu_mix _name = {							\
 	.gate	= CCU_GATE_INIT(_mask_gate),					\
 	.factor	= CCU_FACTOR_INIT(_div, _mul),					\
 	.common = {								\
 		.reg_ctrl	= _reg_ctrl,					\
-		CCU_MIX_INITHW(_name, _parent, spacemit_ccu_factor_gate_ops, 0)	\
+		CCU_MIX_INITHW(_name, _parent, spacemit_ccu_factor_gate_ops, _flags)	\
 	}									\
 }
 
+#define CCU_FACTOR_GATE_DEFINE(_name, _parent, _reg_ctrl, _mask_gate, _div,	\
+			       _mul)						\
+	CCU_FACTOR_GATE_FLAGS_DEFINE(_name, _parent, _reg_ctrl, _mask_gate, _div,	\
+			       _mul, 0)
+
 #define CCU_MUX_GATE_DEFINE(_name, _parents, _reg_ctrl, _shift, _width,		\
 			    _mask_gate, _flags)					\
 static struct ccu_mix _name = {							\
-- 
2.39.5



