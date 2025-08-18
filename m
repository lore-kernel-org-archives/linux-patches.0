Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35408342CBF;
	Mon, 18 Aug 2025 13:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523321; cv=none; b=hoQNlVgmHnp1+bcaDro4rjX2eon23mmv2Qqep8olHKub6LzN5rDdA6MO/AcuUy7TCW/pdB3VtVncBlulclgy7aGg5Hx0v3DPOj4rY6waSRMd94JRMt/McdzurV8fKPPAMJ2eR+tzRSX0xT25Feb+fewMUJN0/90BddbS5IA7BbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523321; c=relaxed/simple;
	bh=lrGMdHbqMoJo0d47gQ7iTT6Gt5sUgLObdw1miH0mS34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OADNtjMuknePu/s0f8/v+8NTr9bkLX8OnsSPUTn7rCFtPoPCHJDLpq0mPe0XwCzPd/8q/ntOBgY8t48EvFe3ZmmhbyPFTpXmW7Pu2xbSE++zaRVeUBxnnSGEgtcs2Tmyk6QXEwdmEHW6Vd+dzkrcoaEG6cAAuRM3+zjKoG8Pl14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2okImK8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2okImK8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06D4C4CEEB;
	Mon, 18 Aug 2025 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523321;
	bh=lrGMdHbqMoJo0d47gQ7iTT6Gt5sUgLObdw1miH0mS34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2okImK8qSpqxBGxoHNwak/mm0aBkYqn/pT/5rksX9U/s0EoWtNoMcotsrWGJMzuum
	 nWU0yIOx45O9vsfmQV/W5fGuub4rT9v6fNLI0VJyB4jZbAcMeSm+IuOHWalLQtKqic
	 ndyDSTAy5Iy4YkVB9LTP7LWVz7ch93B8vqiJhWlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kochetkov <al.kochet@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 135/515] ARM: rockchip: fix kernel hang during smp initialization
Date: Mon, 18 Aug 2025 14:42:01 +0200
Message-ID: <20250818124503.591472506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Kochetkov <al.kochet@gmail.com>

[ Upstream commit 7cdb433bb44cdc87dc5260cdf15bf03cc1cd1814 ]

In order to bring up secondary CPUs main CPU write trampoline
code to SRAM. The trampoline code is written while secondary
CPUs are powered on (at least that true for RK3188 CPU).
Sometimes that leads to kernel hang. Probably because secondary
CPU execute trampoline code while kernel doesn't expect.

The patch moves SRAM initialization step to the point where all
secondary CPUs are powered down.

That fixes rarely hangs on RK3188:
[    0.091568] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.091996] rockchip_smp_prepare_cpus: ncores 4

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Link: https://lore.kernel.org/r/20250703140453.1273027-1-al.kochet@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-rockchip/platsmp.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
index 36915a073c23..f432d22bfed8 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -279,11 +279,6 @@ static void __init rockchip_smp_prepare_cpus(unsigned int max_cpus)
 	}
 
 	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
-		if (rockchip_smp_prepare_sram(node)) {
-			of_node_put(node);
-			return;
-		}
-
 		/* enable the SCU power domain */
 		pmu_set_power_domain(PMU_PWRDN_SCU, true);
 
@@ -316,11 +311,19 @@ static void __init rockchip_smp_prepare_cpus(unsigned int max_cpus)
 		asm ("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
 		ncores = ((l2ctlr >> 24) & 0x3) + 1;
 	}
-	of_node_put(node);
 
 	/* Make sure that all cores except the first are really off */
 	for (i = 1; i < ncores; i++)
 		pmu_set_power_domain(0 + i, false);
+
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
+		if (rockchip_smp_prepare_sram(node)) {
+			of_node_put(node);
+			return;
+		}
+	}
+
+	of_node_put(node);
 }
 
 static void __init rk3036_smp_prepare_cpus(unsigned int max_cpus)
-- 
2.39.5



