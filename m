Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F24B24677F;
	Thu, 28 May 2026 20:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998624; cv=none; b=r2zgSJK3Jl3fhGXjTfvkZ4UhvXcivPhKHnV/D3I7oFBloVL5gHG9u1TdEw/42746eHtqaHqOHqVb1C1i/VhfK8cC8HVHTY0xUj59Ymlotw+ZGmATKSCsQ2+LlHrLl9psNfzVsOpCUz+2fmllrSJvceT8jLC3nh9EZQW0uTAxBwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998624; c=relaxed/simple;
	bh=n1PkagUP0OZP2n5cTRgfsQUCHmg2PCocWNeweRVQ9C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mN90/uEZrzer5jo694FHDRsiLrHuuwMGhryWbhbwSOTpeFeNcdOzvvOxguW6fWsQN2ZI7FlvPjKX6Gn3nIR0SvKRBzz97eM4eCnCBLiHCYZvZMYkrvSReWWHm2rAWVIEChvjfJj08UxsL0zTIpk9gULcQMxHtxUUnEkuek5a1wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gg1CWVxc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gg1CWVxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEC11F000E9;
	Thu, 28 May 2026 20:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998623;
	bh=icSplH8/qlzKAa+Iwhm1rVWIzFFI4nVG9W0Rj9C98F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gg1CWVxcOJLSIfAUtZqnsrJqVrdGtqJUMgUlD/xRv71eyp7UirAcd9xrCkmrDxoXd
	 svH3QLYPOl5DbS6Mf8k873YUUtVns9jGEvThBIZNgyH2dnccz3GiNQE1WLBI3RoS28
	 yTUJUldU/y5jEY2B9HbUE/Jd+dl4ZZPyev+YwyNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 203/461] ARM: integrator: Fix early initialization
Date: Thu, 28 May 2026 21:45:32 +0200
Message-ID: <20260528194652.968546933@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 90d77b30a666049ad24df463f52e5d529c44e8cd ]

Starting with commit bdb249fce9ad4 ("ARM: integrator: read counter using
syscon/regmap"), intcp_init_early calls syscon_regmap_lookup_by_compatible
which in turn calls of_syscon_register. This function allocates memory.
Since the memory management code has not been initialized at that time,
the call always fails. It either returns -ENOMEM or crashes as follows.

Unable to handle kernel NULL pointer dereference at virtual address 0000000c when read
[0000000c] *pgd=00000000
Internal error: Oops: 5 [#1] ARM
Modules linked in:
CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc5-00026-g5fcc9bf84ee5 #1 PREEMPT
Hardware name: ARM Integrator/CP (Device Tree)
PC is at __kmalloc_cache_noprof+0xec/0x39c
LR is at __kmalloc_cache_noprof+0x34/0x39c
...
Call trace:
 __kmalloc_cache_noprof from of_syscon_register+0x7c/0x310
 of_syscon_register from device_node_get_regmap+0xa4/0xb0
 device_node_get_regmap from intcp_init_early+0xc/0x40
 intcp_init_early from start_kernel+0x60/0x688
 start_kernel from 0x0

The crash is seen due to a dereferenced pointer which is not supposed to be
NULL but is NULL if the memory management subsystem has not been
initialized. The crash is not seen with all versions of gcc. Some versions
such as gcc 9.x apparently do not dereference the pointer, presumably if
tracing is disabled. The problem has been reproduced with gcc 10.x, 11.x,
and 13.x. Either case, if the crash is not seen, the call to
syscon_regmap_lookup_by_compatible returns -ENOMEM, and
sched_clock_register is never called.

Fix the problem by moving the early initialization code into the standard
machine initialization code.

Fixes: bdb249fce9ad4 ("ARM: integrator: read counter using syscon/regmap")
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/20250518164118.3859567-1-linux@roeck-us.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20260505-integrator-fixes-v1-1-56ab9aac59db@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-versatile/integrator_cp.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-versatile/integrator_cp.c b/arch/arm/mach-versatile/integrator_cp.c
index 2ed4ded56b3fe..03dfb5f720b7b 100644
--- a/arch/arm/mach-versatile/integrator_cp.c
+++ b/arch/arm/mach-versatile/integrator_cp.c
@@ -86,14 +86,6 @@ static u64 notrace intcp_read_sched_clock(void)
 	return val;
 }
 
-static void __init intcp_init_early(void)
-{
-	cm_map = syscon_regmap_lookup_by_compatible("arm,core-module-integrator");
-	if (IS_ERR(cm_map))
-		return;
-	sched_clock_register(intcp_read_sched_clock, 32, 24000000);
-}
-
 static void __init intcp_init_irq_of(void)
 {
 	cm_init();
@@ -119,6 +111,10 @@ static void __init intcp_init_of(void)
 {
 	struct device_node *cpcon;
 
+	cm_map = syscon_regmap_lookup_by_compatible("arm,core-module-integrator");
+	if (!IS_ERR(cm_map))
+		sched_clock_register(intcp_read_sched_clock, 32, 24000000);
+
 	cpcon = of_find_matching_node(NULL, intcp_syscon_match);
 	if (!cpcon)
 		return;
@@ -138,7 +134,6 @@ static const char * intcp_dt_board_compat[] = {
 DT_MACHINE_START(INTEGRATOR_CP_DT, "ARM Integrator/CP (Device Tree)")
 	.reserve	= integrator_reserve,
 	.map_io		= intcp_map_io,
-	.init_early	= intcp_init_early,
 	.init_irq	= intcp_init_irq_of,
 	.init_machine	= intcp_init_of,
 	.dt_compat      = intcp_dt_board_compat,
-- 
2.53.0



