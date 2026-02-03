Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E571946C;
	Tue,  3 Feb 2026 00:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770078281; cv=none; b=hauz9VcX222W2Ogczc0E5GcUjGDoT6/AmvHF7jfA69S3pD5wUmCJf6DhjaWPCfek6hl7TmFPanYwwOpG4Hw1ZCjLJQHKgoVVjeLSnG7HLIIAm+KdkhNvb7umpn5I3rhaJpiSkZn8AlJQGjMHscPYcu/RRVPqh8vRGXZIaF3fu+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770078281; c=relaxed/simple;
	bh=ckGYPXGGVk5q9yYyLc4KnqazjXpZvCXMS9y+kEXYUnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K515JZPKLDxYV/IHJgCL12pLQyjyQeBcE+VTur+KFVBLN4ZXpSs9jaBaL1LPnrjw2OR9CoyaCwZeuJKrFjqJYhM5iRUNraOkl2Pb0ZIpf58HrDPX/OamYwbEocTRBgY3c2gdmFonTIMP2/FVXS1Uu1MkZAA7+7DKUS9EczmRqTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kCgIR7Lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCgIR7Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5C4C116C6;
	Tue,  3 Feb 2026 00:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770078281;
	bh=ckGYPXGGVk5q9yYyLc4KnqazjXpZvCXMS9y+kEXYUnA=;
	h=From:To:Cc:Subject:Date:From;
	b=kCgIR7LkX479n1JxK48u7WAvhs9K8bCbe2zOO0QMCcIXMcjIk02EHO8Lq9/gE5yOH
	 KsVMDSyCMOTr6X/y8mitSjpehoOi1AksS88l+EnTz+ZRH0OZ5F06U1+3UYzCeZyZYp
	 1CVii8+VLRVzQXSqvD0/7lMG6Ji8mtImFiC/lc4KHIxdsBnMVfYykEzVFx1KY6c07l
	 NaZEl/x9Tu25dCg+k/H6foWI+4QULVNYEcsWi6Wn7FiV6+U6WLPEVIIGP3TuX6A0E2
	 niYoRGK85SQIMM5ENoXMuMZo4STt2mNtckPNnZRZdEZHJLgK1+gSIKYloToVW7vC8I
	 esx5hSCe9UGCw==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Brian Masney <bmasney@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: [PATCH] Revert "clk: Respect CLK_OPS_PARENT_ENABLE during recalc"
Date: Mon,  2 Feb 2026 16:24:38 -0800
Message-ID: <20260203002439.1223213-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 669917676e93fca5ea3c66fc9539830312bec58e.
It's been shown to cause problems on i.MX and STM32 platforms
where the board doesn't boot. In one case, a clk with
CLK_IS_CRITICAL and CLK_OPS_PARENT_ENABLE is being registered
causing the parent to be enabled, the rate recalculated, and then
the parent is disabled causing the critical clk being registered
to stop clocking.

A fix for that would be to calculate the rate of the clk after
enabling the critical clk itself, but that wouldn't fix another
problem where a clk with CLK_OPS_PARENT_ENABLE is registered
before the parent is registered. In this case the hardware access
in the clk_ops::recalc_rate() function would fail if the parent
is disabled.

There are even more problems exposed by this patch because it
introduces logic that disables clks earlier in system boot than
has existed previously. Historically we've not disabled clks
until late init (clk_disable_unused) under the assumption that
clks have been registered enough to have a consistent view of the
clk tree. The clk_disable_unused logic doesn't work very well
though, leading to quite a few devices booting with
clk_ignore_unused on the kernel command line.

Long story short, disabling clks during clk registration is full
of pitfalls. Revert this commit until a proper solution can be
found.

Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Closes: https://lore.kernel.org/r/6239343.lOV4Wx5bFT@steina-w
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/r/036da7ce-6487-4a6e-9b15-97c6d3bcdcec@sirena.org.uk
Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Brian Masney <bmasney@redhat.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1b0f9d567f48..85d2f2481acf 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1921,14 +1921,7 @@ static unsigned long clk_recalc(struct clk_core *core,
 	unsigned long rate = parent_rate;
 
 	if (core->ops->recalc_rate && !clk_pm_runtime_get(core)) {
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_prepare_enable(core->parent);
-
 		rate = core->ops->recalc_rate(core->hw, parent_rate);
-
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_disable_unprepare(core->parent);
-
 		clk_pm_runtime_put(core);
 	}
 	return rate;
@@ -4038,9 +4031,6 @@ static int __clk_core_init(struct clk_core *core)
 	 */
 	clk_core_update_duty_cycle_nolock(core);
 
-	if (core->flags & CLK_OPS_PARENT_ENABLE)
-		clk_core_prepare_enable(core->parent);
-
 	/*
 	 * Set clk's rate.  The preferred method is to use .recalc_rate.  For
 	 * simple clocks and lazy developers the default fallback is to use the
@@ -4056,9 +4046,6 @@ static int __clk_core_init(struct clk_core *core)
 		rate = 0;
 	core->rate = core->req_rate = rate;
 
-	if (core->flags & CLK_OPS_PARENT_ENABLE)
-		clk_core_disable_unprepare(core->parent);
-
 	/*
 	 * Enable CLK_IS_CRITICAL clocks so newly added critical clocks
 	 * don't get accidentally disabled when walking the orphan tree and

base-commit: aa2ad19210a6a444111bce55e8b69579f29318fb
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

