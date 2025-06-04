Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD47727D782;
	Wed,  4 Jun 2025 01:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999252; cv=none; b=IgGrnysLHqyuNC7HN76drwIW7KPlL3Qy1P8tVoi9t0CziWLD/w+UZD8rezzxBnijwSHAcsDNWItRVKjOXWxS523+opUkJ/cgfixOWjuI9QLa44maDvfPAs56GXPznAfyjRWw1DlwZzO5UQeT4o1N6PWBs5X6KmBTKgfXmtDT6Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999252; c=relaxed/simple;
	bh=gbINnOBjYacAd4NURcM3UJtbzlVb3rdVAEYqAOgMVV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NwvTIcft+Qn2uzEi2bYpU9vBFbRWbXJh2fIRn0nqnkebhjM/Vavt6rqrvYJsrNfQOIJML8Ev5qKtT1HQIBNXgOrGSYApqlPFuTi2hljddLtkL9RAHEKzL/pzTdwaaIqWLl4myEsAAO15Lgx9lmhTNle1bT4Yr1UD2jfIOZZj6Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lgFCoHW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lgFCoHW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA08C4CEED;
	Wed,  4 Jun 2025 01:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999252;
	bh=gbINnOBjYacAd4NURcM3UJtbzlVb3rdVAEYqAOgMVV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgFCoHW+D401LqlMg3OHSGLY9x1D0tjFirFlpfGpM186uloAE6p4AwmcXae+d9tud
	 mv+iW45JDivB+QvZ1me5MowceOQJ4hBRoxVJOTcGfdcbBsF/9VgK7aD/X49x8av26Q
	 iNtxxOUzf6VGu6LMzFEhI9+LoEY04vOwv5sC7Dot2y5cHlNra3qRBU4Kje3yrp6qk+
	 PbqyiTa2pVowcuhBeGobaIm/aLD/GQwdxfah+Y2zsnUrqPxzfp3t8soteeLs+JWQq0
	 CMoWzo+XDsCX+4U0g21u41tnmSX/GzKUkFpcuKFkHj/lt2TmHReL+RyPzhCVTfCHx5
	 ShgbonQEpu2gA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 16/20] clk: rockchip: rk3036: mark ddrphy as critical
Date: Tue,  3 Jun 2025 21:07:02 -0400
Message-Id: <20250604010706.7395-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010706.7395-1-sashal@kernel.org>
References: <20250604010706.7395-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
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
index 6a46f85ad8372..4a8c72d995735 100644
--- a/drivers/clk/rockchip/clk-rk3036.c
+++ b/drivers/clk/rockchip/clk-rk3036.c
@@ -429,6 +429,7 @@ static const char *const rk3036_critical_clocks[] __initconst = {
 	"hclk_peri",
 	"pclk_peri",
 	"pclk_ddrupctl",
+	"ddrphy",
 };
 
 static void __init rk3036_clk_init(struct device_node *np)
-- 
2.39.5

