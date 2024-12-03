Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FAD1EE001;
	Tue,  3 Dec 2024 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238871; cv=none; b=hBAwmxBahjHCG/AN7jlTt/pafmu4O8v+oyOKe3tsgv4wnvSMTfp9UWjMeKT9r0UgD9herMemdxPUfkh9nJGjWDNS7ShQ5j5SRkNSh90I37UP8qR6LJelG5OIKX065vdeAfDRaxebCIvGtt+sBjmy4X5J1OBCZXUTCIxlgIp2xwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238871; c=relaxed/simple;
	bh=4p/k7k1i8c+m9+QT36ZWsotUiWQSaL1s45XqNYnO8a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOomRX3X60gaX1XNlZUHNg/UD7CJ8AJDvdrvCm8dAvas/DLhFU7qWhvOjw5bn4XxKdyZyliy/0qsc0Kxmp/4NktR0XojJO4/ezX3SU7i2BZ8cWNxnPn7iJn5cVXP2aiwBKw76y7CPCHm8j3HbAlgnl+xYmiOcXhIDNPsqyFrpzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+KuM15a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+KuM15a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9C1C4CECF;
	Tue,  3 Dec 2024 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238871;
	bh=4p/k7k1i8c+m9+QT36ZWsotUiWQSaL1s45XqNYnO8a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+KuM15a7zGmdCZ1oyxXhA2BNv2J+580aC72rirDBB1f4s8VxTZ5altX8qaB/5hbd
	 7OaL0eqs3NCjaju/VMtRKiEhdI1OUifeLIqLKzUgEGTaaiLPbsMQxx1Epk0fuwyxAa
	 g2C8LaMXRklhj10jnoFgajOunQLmMCg/na0M7sPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 425/817] clk: imx: lpcg-scu: SW workaround for errata (e10858)
Date: Tue,  3 Dec 2024 15:39:57 +0100
Message-ID: <20241203144012.474270355@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 5ee063fac85656bea9cfe3570af147ba1701ba18 ]

Back-to-back LPCG writes can be ignored by the LPCG register due to
a HW bug. The writes need to be separated by at least 4 cycles of
the gated clock. See https://www.nxp.com.cn/docs/en/errata/IMX8_1N94W.pdf

The workaround is implemented as follows:
1. For clocks running greater than or equal to 24MHz, a read
followed by the write will provide sufficient delay.
2. For clocks running below 24MHz, add a delay of 4 clock cylces
after the write to the LPCG register.

Fixes: 2f77296d3df9 ("clk: imx: add lpcg clock support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241027-imx-clk-v1-v3-1-89152574d1d7@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-lpcg-scu.c | 37 ++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/imx/clk-lpcg-scu.c b/drivers/clk/imx/clk-lpcg-scu.c
index dd5abd09f3e20..620afdf8dc03e 100644
--- a/drivers/clk/imx/clk-lpcg-scu.c
+++ b/drivers/clk/imx/clk-lpcg-scu.c
@@ -6,10 +6,12 @@
 
 #include <linux/bits.h>
 #include <linux/clk-provider.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/units.h>
 
 #include "clk-scu.h"
 
@@ -41,6 +43,29 @@ struct clk_lpcg_scu {
 
 #define to_clk_lpcg_scu(_hw) container_of(_hw, struct clk_lpcg_scu, hw)
 
+/* e10858 -LPCG clock gating register synchronization errata */
+static void lpcg_e10858_writel(unsigned long rate, void __iomem *reg, u32 val)
+{
+	writel(val, reg);
+
+	if (rate >= 24 * HZ_PER_MHZ || rate == 0) {
+		/*
+		 * The time taken to access the LPCG registers from the AP core
+		 * through the interconnect is longer than the minimum delay
+		 * of 4 clock cycles required by the errata.
+		 * Adding a readl will provide sufficient delay to prevent
+		 * back-to-back writes.
+		 */
+		readl(reg);
+	} else {
+		/*
+		 * For clocks running below 24MHz, wait a minimum of
+		 * 4 clock cycles.
+		 */
+		ndelay(4 * (DIV_ROUND_UP(1000 * HZ_PER_MHZ, rate)));
+	}
+}
+
 static int clk_lpcg_scu_enable(struct clk_hw *hw)
 {
 	struct clk_lpcg_scu *clk = to_clk_lpcg_scu(hw);
@@ -57,7 +82,8 @@ static int clk_lpcg_scu_enable(struct clk_hw *hw)
 		val |= CLK_GATE_SCU_LPCG_HW_SEL;
 
 	reg |= val << clk->bit_idx;
-	writel(reg, clk->reg);
+
+	lpcg_e10858_writel(clk_hw_get_rate(hw), clk->reg, reg);
 
 	spin_unlock_irqrestore(&imx_lpcg_scu_lock, flags);
 
@@ -74,7 +100,7 @@ static void clk_lpcg_scu_disable(struct clk_hw *hw)
 
 	reg = readl_relaxed(clk->reg);
 	reg &= ~(CLK_GATE_SCU_LPCG_MASK << clk->bit_idx);
-	writel(reg, clk->reg);
+	lpcg_e10858_writel(clk_hw_get_rate(hw), clk->reg, reg);
 
 	spin_unlock_irqrestore(&imx_lpcg_scu_lock, flags);
 }
@@ -145,13 +171,8 @@ static int __maybe_unused imx_clk_lpcg_scu_resume(struct device *dev)
 {
 	struct clk_lpcg_scu *clk = dev_get_drvdata(dev);
 
-	/*
-	 * FIXME: Sometimes writes don't work unless the CPU issues
-	 * them twice
-	 */
-
-	writel(clk->state, clk->reg);
 	writel(clk->state, clk->reg);
+	lpcg_e10858_writel(0, clk->reg, clk->state);
 	dev_dbg(dev, "restore lpcg state 0x%x\n", clk->state);
 
 	return 0;
-- 
2.43.0



