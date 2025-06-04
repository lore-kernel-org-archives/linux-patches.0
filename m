Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562C720B80A;
	Wed,  4 Jun 2025 01:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998996; cv=none; b=GiopzEY3wyKxcTO5IbXMTiCBvLwaUuUkF8H0zjzTh8LJLCpfO7PB4lIOXeZKxaLCQcYvK0EoXZIyjS1mdcqu8HCF72F3Kdxo+FTbvrOKvCVqeEH9t/dqrYpjxzoEw+6da8ZUQa5m8a/yVdYLEH5C9esiBSW9SFQejASpgux1uZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998996; c=relaxed/simple;
	bh=7GqPQYInUriePbu52Umq2SHKyss5K8IBI1SLlGH9f9U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VRWZ7vNQXQYoX9jg6S08U5JhyZoDzTkX+kY62IlYV2sUaanjzJSSwZlQpUfEqIeZe1AXPkIxIqFkBsvIMDDfgFbaJT8ifFaAWH6qEvtPfpIJLNsh6WXkstTHUnrOGNb3tJUf/22RKyWYCXXTSK+zOs1hYyU8TWnf27Rks15dmXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkuF14sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkuF14sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D68CC4CEF2;
	Wed,  4 Jun 2025 01:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998996;
	bh=7GqPQYInUriePbu52Umq2SHKyss5K8IBI1SLlGH9f9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkuF14swEXnY/ibcg6EEUH+ppwShise89MWomiFfTY3WJi4I0ubUACjPxVEYRIDya
	 ZsgeNvt6fVG92UKTmhtzqBCrynCwwKW0LEXYx2SuW05hD6yZIXK6JC7LsWDOyXTB1s
	 ORT41T9XXwyge0psYaMQJMtzifNIusSU1qsS0yrabvMg4mQXINvLnmzu1sdajTTeLu
	 tVtz7acoXvopvmZvld2uxj6i75O9Fl69YCUh1Ki1g2ERnI7z1UFgO5WT6WQy1gRzh/
	 vQFh5cXOGqz45mYugDWHARiowYJslelJgUvZWoh1rQxYITRv1K/obPkSGHYtIvXMR4
	 oHS6FZs/DDDBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.6 35/62] clk: rockchip: rk3036: mark ddrphy as critical
Date: Tue,  3 Jun 2025 21:01:46 -0400
Message-Id: <20250604010213.3462-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010213.3462-1-sashal@kernel.org>
References: <20250604010213.3462-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 596a977b34a722c00245801a5774aa79cec4e81d ]

The ddrphy is supplied by the dpll, but due to the limited number of PLLs
on the rk3036, the dpll also is used for other periperhals, like the GPU.

So it happened, when the Lima driver turned off the gpu clock, this in
turn also disabled the dpll and thus the ram.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250503202532.992033-4-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should absolutely be backported to stable kernel
trees. Here's my detailed analysis: ## Critical System Stability Issue
The commit fixes a **critical system stability problem** where the DDR
PHY clock can be disabled, causing the system to lose access to RAM and
crash. This is evidenced by: 1. **Root Cause Analysis**: The commit
message clearly explains that "when the Lima driver turned off the gpu
clock, this in turn also disabled the dpll and thus the ram" - this is a
shared resource conflict that can brick the system. 2. **Hardware
Limitation**: The RK3036 has "limited number of PLLs" where the DPLL is
shared between the DDR PHY (memory controller) and GPU, creating an
inherent conflict when GPU clock management affects memory access. ##
Code Change Analysis The fix is **minimal and safe**: ```c static const
char *const rk3036_critical_clocks[] __initconst = { "aclk_cpu",
"aclk_peri", "hclk_peri", "pclk_peri", "pclk_ddrupctl", + "ddrphy", //
<-- Single line addition }; ``` - **Single line change**: Adding
"ddrphy" to the critical clocks array - **No functional changes**: Uses
existing critical clock infrastructure - **No API modifications**:
Compatible with all kernel versions that support Rockchip clocks - **No
dependencies**: Self-contained fix within the clock driver ##
Backporting Criteria Evaluation ✅ **Fixes important bug**: System
crashes when GPU driver disables clocks ✅ **Small and contained**: One
line addition to existing array ✅ **Minimal regression risk**: Only
prevents clock from being disabled, no new functionality ✅ **Clear side
effects**: Explicitly intended to keep DDR PHY always enabled ✅
**Critical subsystem**: Memory controller availability is fundamental to
system operation ## Similar Commit Pattern Analysis Looking at the
provided similar commits, this follows the **exact same pattern** as
Similar Commit #3 (Status: YES) which fixed "unrecoverable freezes and
rcu_sched stall warnings" - both address critical system stability
issues through clock configuration fixes. Unlike the other commits
marked "NO" which were feature additions or exports, this is a **pure
bugfix** addressing a **hardware design limitation** that causes system
crashes. ## Conclusion This commit prevents **complete system failure**
through a **trivial, safe change** that has **zero risk of regression**.
The fix addresses a fundamental hardware limitation in the RK3036 where
shared PLLs can cause memory controller clock starvation. This is
exactly the type of critical stability fix that stable trees are
designed to include.

 drivers/clk/rockchip/clk-rk3036.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/rockchip/clk-rk3036.c b/drivers/clk/rockchip/clk-rk3036.c
index d644bc155ec6e..f5f27535087a3 100644
--- a/drivers/clk/rockchip/clk-rk3036.c
+++ b/drivers/clk/rockchip/clk-rk3036.c
@@ -431,6 +431,7 @@ static const char *const rk3036_critical_clocks[] __initconst = {
 	"hclk_peri",
 	"pclk_peri",
 	"pclk_ddrupctl",
+	"ddrphy",
 };
 
 static void __init rk3036_clk_init(struct device_node *np)
-- 
2.39.5

