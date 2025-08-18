Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CD2343D8C;
	Mon, 18 Aug 2025 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525860; cv=none; b=cUCpxqJfUj7NvsvbvTo/DcljSvzvowLHZvDEna8SmKiV51BvSK5PXQiqtkkMCfaUVlnc8cLZEZoPziMOOdsj5SMixoKuHCqIwi2KqzI+Vbb1/+NA9vMvi3Z+rl/p3kZ2apCELzT6ERKth2+slvDi3RBNJM8VloMYXfNXzAf8/Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525860; c=relaxed/simple;
	bh=WPy16ivYc0SwzR1WLaAOsaglN9RFYvuTLgyqUyukXqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPctLW9CCHbTukdSYfkq5FZSsfPVw7p/YSS7HTo8aOexI1WIY6wgBhLIq33Ic0HALtEYrxEmIYwdnB1bGuGDPsu3VcIpYVqXMtnSdQpMD+n6mDW88l7uh0DFN2+L0XSIC+S/CYgInDOxUbSrCX8E4+Dvav9mlJMphN4OP8o9hDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I50kvWKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I50kvWKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8662BC4CEEB;
	Mon, 18 Aug 2025 14:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525860;
	bh=WPy16ivYc0SwzR1WLaAOsaglN9RFYvuTLgyqUyukXqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I50kvWKTedynayoJO+euNI5aSFvjKe/7/LFsu7LWZlulfoG+Lx5Fa3xcXD9fKwy/p
	 QlVnpqyES/2WQRlra+O8uKw23h1rYGi4V1RkfyYdS0iCwwCfbcAWVUgVySh3MMGcX+
	 njPdZT/v9Vkmp4Ige0YPMuUhkSuSXYXEkjHoSCOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drew Fustini <drew@pdp7.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 388/570] clk: thead: Mark essential bus clocks as CLK_IGNORE_UNUSED
Date: Mon, 18 Aug 2025 14:46:15 +0200
Message-ID: <20250818124520.791710106@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Michal Wilczynski <m.wilczynski@samsung.com>

[ Upstream commit 0370395d45ca6dd53bb931978f0e91ac8dd6f1c5 ]

Probing peripherals in the AON and PERI domains, such as the PVT thermal
sensor and the PWM controller, can lead to boot hangs or unresponsive
devices on the LPi4A board. The root cause is that their parent bus
clocks ('CLK_CPU2AON_X2H' and the 'CLK_PERISYS_APB' clocks) are
automatically gated by the kernel's power-saving mechanisms when the bus
is perceived as idle.

Alternative solutions were investigated, including modeling the parent
bus in the Device Tree with 'simple-pm-bus' or refactoring the clock
driver's parentage. The 'simple-pm-bus' approach is not viable due to
the lack of defined bus address ranges in the hardware manual and its
creation of improper dependencies on the 'pm_runtime' API for consumer
drivers.

Therefore, applying the'`CLK_IGNORE_UNUSED' flag directly to the
essential bus clocks is the most direct and targeted fix. This prevents
the kernel from auto-gating these buses and ensures peripherals remain
accessible.

This change fixes the boot hang associated with the PVT sensor and
resolves the functional issues with the PWM controller.

Link: https://lore.kernel.org/all/9e8a12db-236d-474c-b110-b3be96edf057@samsung.com/ [1]

Reviewed-by: Drew Fustini <drew@pdp7.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
Signed-off-by: Drew Fustini <drew@pdp7.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index 485b1d5cfd18..cf1bba58f641 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -792,11 +792,12 @@ static CCU_GATE(CLK_AON2CPU_A2X, aon2cpu_a2x_clk, "aon2cpu-a2x", axi4_cpusys2_ac
 		0x134, BIT(8), 0);
 static CCU_GATE(CLK_X2X_CPUSYS, x2x_cpusys_clk, "x2x-cpusys", axi4_cpusys2_aclk_pd,
 		0x134, BIT(7), 0);
-static CCU_GATE(CLK_CPU2AON_X2H, cpu2aon_x2h_clk, "cpu2aon-x2h", axi_aclk_pd, 0x138, BIT(8), 0);
+static CCU_GATE(CLK_CPU2AON_X2H, cpu2aon_x2h_clk, "cpu2aon-x2h", axi_aclk_pd,
+		0x138, BIT(8), CLK_IGNORE_UNUSED);
 static CCU_GATE(CLK_CPU2PERI_X2H, cpu2peri_x2h_clk, "cpu2peri-x2h", axi4_cpusys2_aclk_pd,
 		0x140, BIT(9), CLK_IGNORE_UNUSED);
 static CCU_GATE(CLK_PERISYS_APB1_HCLK, perisys_apb1_hclk, "perisys-apb1-hclk", perisys_ahb_hclk_pd,
-		0x150, BIT(9), 0);
+		0x150, BIT(9), CLK_IGNORE_UNUSED);
 static CCU_GATE(CLK_PERISYS_APB2_HCLK, perisys_apb2_hclk, "perisys-apb2-hclk", perisys_ahb_hclk_pd,
 		0x150, BIT(10), CLK_IGNORE_UNUSED);
 static CCU_GATE(CLK_PERISYS_APB3_HCLK, perisys_apb3_hclk, "perisys-apb3-hclk", perisys_ahb_hclk_pd,
-- 
2.39.5



