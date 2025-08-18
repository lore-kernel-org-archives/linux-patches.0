Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33D8335BA3;
	Mon, 18 Aug 2025 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525065; cv=none; b=oPFiQVistshDhIpiUFBafZ9pn0WLaMKwV5qALpVq9obXluawW1CLQHuOMsWp3s0IBPoyui9zlH6LdE+QG/TanE2M4gEkDSxIKoZ06z087aEJt6k40J5aBG9o6LkXsxIRhXGUTvXGfS537ls/tHmrzZ2JAKIuX52fHZlWrl9Td8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525065; c=relaxed/simple;
	bh=oun18WkY52jzwSxZF0e3kD30pcvt4cZ6s9NTTyJnITU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nG8/qaTcx42LC4Gq0deyvPu/yaSzvdqITSwRIG0lvzA2CepaxTUCZk0eX2vQKQQHeTzOPjtra7OP5XhtQ24d6Zun7WzKdUwqDrnblwhXSZks3lZsIcx/jTXtilrYmPV3BT/5yNTenqdmwvltOJSLc9WdRPhP9hsygAA0DBPE+Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEQdBa0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEQdBa0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AC1C4CEEB;
	Mon, 18 Aug 2025 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525064;
	bh=oun18WkY52jzwSxZF0e3kD30pcvt4cZ6s9NTTyJnITU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEQdBa0t7DwGgsEJ+vk5uRd9MaeTg0D9swRY5g06vRg1x/1yIYfz/nuV0PFRyAa2v
	 B3T6a+mr4MmNuWVEwJDOpxRHrcrHRxYtuLW2GPUHJ5XsFCmmqeqWAlERSyMa/Mc8Pb
	 pd7D0FBnYOiT/xGvqZNy/L7H3rOEOYKIZurPZTyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kochetkov <al.kochet@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 148/570] ARM: rockchip: fix kernel hang during smp initialization
Date: Mon, 18 Aug 2025 14:42:15 +0200
Message-ID: <20250818124511.519821512@linuxfoundation.org>
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



