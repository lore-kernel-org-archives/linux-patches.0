Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D54B846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95C1C4339C;
	Fri, 10 Mar 2023 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458850;
	bh=p3Ejt/L/+lps40p14tFbIqn6GnlgrRDC0h1j8Oxdbr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEsxh2QMDw0KadwiwMs4gvqNcLsBHeHLek7bPjUdKZAJ1qq05R/hnKDhH1jsK4WTC
	 kvlbnnQLDchwJFbalWRwoLpYEb4qAcYGExpHpyKT1B5HDU1tolmrYus+SdbLgY43Dj
	 /AYgrXVPGYz+WZc7Ahm/Pkh5nFBjx/9XhFfXPfVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Dengcheng Zhu <dzhu@wavecomp.com>,
	Paul Burton <paulburton@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	Sergei Shtylyov <sergei.shtylyov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/357] MIPS: SMP-CPS: fix build error when HOTPLUG_CPU not set
Date: Fri, 10 Mar 2023 14:37:34 +0100
Message-Id: <20230310133742.001276488@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6f02e39fa40f16c24e7a5c599a854c0d1682788d ]

When MIPS_CPS=y, MIPS_CPS_PM is not set, HOTPLUG_CPU is not set, and
KEXEC=y, cps_shutdown_this_cpu() attempts to call cps_pm_enter_state(),
which is not built when MIPS_CPS_PM is not set.
Conditionally execute the else branch based on CONFIG_HOTPLUG_CPU
to remove the build error.
This build failure is from a randconfig file.

mips-linux-ld: arch/mips/kernel/smp-cps.o: in function `$L162':
smp-cps.c:(.text.cps_kexec_nonboot_cpu+0x31c): undefined reference to `cps_pm_enter_state'

Fixes: 1447864bee4c ("MIPS: kexec: CPS systems to halt nonboot CPUs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dengcheng Zhu <dzhu@wavecomp.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/smp-cps.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/smp-cps.c b/arch/mips/kernel/smp-cps.c
index dbb3f1fc71ab6..f659adb681bc3 100644
--- a/arch/mips/kernel/smp-cps.c
+++ b/arch/mips/kernel/smp-cps.c
@@ -423,9 +423,11 @@ static void cps_shutdown_this_cpu(enum cpu_death death)
 			wmb();
 		}
 	} else {
-		pr_debug("Gating power to core %d\n", core);
-		/* Power down the core */
-		cps_pm_enter_state(CPS_PM_POWER_GATED);
+		if (IS_ENABLED(CONFIG_HOTPLUG_CPU)) {
+			pr_debug("Gating power to core %d\n", core);
+			/* Power down the core */
+			cps_pm_enter_state(CPS_PM_POWER_GATED);
+		}
 	}
 }
 
-- 
2.39.2



