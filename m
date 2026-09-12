Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABC332B126;
	Sat, 12 Sep 2026 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239111; cv=none; b=hM3Cx+LWgQI3SAWdCYSnopg2TmfBzn7xeHG0BCmBevIFLEXgatcs/KZ+1GLMA4VdPhw0rvW6eUbkiIa5CBBMUswSVFeTyShrI/FACdnF2siHtD3IwKOysT3MmAevMME/WCoW97VI8A26hPDWSVwmhI7Lehju55JrWgOL+WJYn8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239111; c=relaxed/simple;
	bh=AU5ztwcJ382Xh7SVoyKgcWC5D4D7fLZTAmrJuLVVztM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1nzMV/BQv/1iSgsLwJYJ24++PQbhHhzZiXGOxykM9G6dOUsg/yaO1ZI37XNJIyLBQ1Tk9neTbXMRKV+QJhCOCNrg0cz/J+GrdAd+A9StxGTnz6WFWzrndZS6VeEsiGwHukswzEYC+RJadUEui3Je9pmB9KkoBx1AWThzLIesqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jGxbMMZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jGxbMMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185CB1F000FF;
	Sat, 12 Sep 2026 18:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239109;
	bh=yVXuot3S7SLrLFn+Svv66oPHj95wd3qlr5qlXtVcNLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jGxbMMZm6jiKfpLP/j9D+MeUz+T0kC/1wEpyLZBX4nSl3G5IiACW2yfsUZK6uGeK
	 uqS7jkHgz+p/naQCp1whZYYlzfg16PRsWce8ezybJMsEpK1mdN5U74llLTxq2m4lSs
	 yC45xQgDGtpOt8x3D/Eh3Ci2NQKT3sPUaebFKkhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Vladimir Zapolskiy <vz@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 599/935] ARM: lpc32xx: only run SoC init on LPC32xx hardware
Date: Sat, 12 Sep 2026 09:00:29 +0200
Message-ID: <20260912065540.580470450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 717ea4000867e6dffee5e1ed92150a9704ae9f68 ]

lpc32xx_check_uid() and lpc32xx_pm_init() are arch_initcalls that poke
LPC32xx-only registers. Since the multiplatform conversion they also
run on other ARCH_MULTI_V5 boards where access faults e.g. on versatile:

  Unable to handle kernel paging request at virtual address f4004130
  PC is at lpc32xx_check_uid+0x2c/0x9c

Drop the arch_initcall() registrations and call both functions directly
from lpc3250_machine_init(), the machine's .init_machine hook.
The calls are placed in link order (common.c, pm.c, phy3250.c) to
keep their previous relative ordering.

Fixes: 75bf1bd7d2f9 ("ARM: lpc32xx: allow multiplatform build")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-lpc32xx/common.c  | 5 +----
 arch/arm/mach-lpc32xx/common.h  | 2 ++
 arch/arm/mach-lpc32xx/phy3250.c | 2 ++
 arch/arm/mach-lpc32xx/pm.c      | 5 +----
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/common.c b/arch/arm/mach-lpc32xx/common.c
index 304ea61a07160..35ed3569c5a35 100644
--- a/arch/arm/mach-lpc32xx/common.c
+++ b/arch/arm/mach-lpc32xx/common.c
@@ -106,7 +106,7 @@ void __init lpc32xx_map_io(void)
 	iotable_init(lpc32xx_io_desc, ARRAY_SIZE(lpc32xx_io_desc));
 }
 
-static int __init lpc32xx_check_uid(void)
+void __init lpc32xx_check_uid(void)
 {
 	u32 uid[4];
 
@@ -119,7 +119,4 @@ static int __init lpc32xx_check_uid(void)
 		system_serial_low = uid[0];
 		system_serial_high = uid[1];
 	}
-
-	return 1;
 }
-arch_initcall(lpc32xx_check_uid);
diff --git a/arch/arm/mach-lpc32xx/common.h b/arch/arm/mach-lpc32xx/common.h
index 32f0ad2178077..06b20bea324e1 100644
--- a/arch/arm/mach-lpc32xx/common.h
+++ b/arch/arm/mach-lpc32xx/common.h
@@ -16,6 +16,8 @@
  * Other arch specific structures and functions
  */
 extern void __init lpc32xx_map_io(void);
+extern void __init lpc32xx_check_uid(void);
+extern void __init lpc32xx_pm_init(void);
 extern void __init lpc32xx_serial_init(void);
 
 /*
diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index 66701bf432488..ddc6333ca55da 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -71,6 +71,8 @@ static const struct of_dev_auxdata lpc32xx_auxdata_lookup[] __initconst = {
 
 static void __init lpc3250_machine_init(void)
 {
+	lpc32xx_check_uid();
+	lpc32xx_pm_init();
 	lpc32xx_serial_init();
 
 	of_platform_default_populate(NULL, lpc32xx_auxdata_lookup, NULL);
diff --git a/arch/arm/mach-lpc32xx/pm.c b/arch/arm/mach-lpc32xx/pm.c
index 2572bd89a5e8d..9b5c5e1462ed3 100644
--- a/arch/arm/mach-lpc32xx/pm.c
+++ b/arch/arm/mach-lpc32xx/pm.c
@@ -120,7 +120,7 @@ static const struct platform_suspend_ops lpc32xx_pm_ops = {
 #define EMC_DYN_MEM_CTRL_OFS 0x20
 #define EMC_SRMMC           (1 << 3)
 #define EMC_CTRL_REG io_p2v(LPC32XX_EMC_BASE + EMC_DYN_MEM_CTRL_OFS)
-static int __init lpc32xx_pm_init(void)
+void __init lpc32xx_pm_init(void)
 {
 	/*
 	 * Setup SDRAM self-refresh clock to automatically disable o
@@ -129,7 +129,4 @@ static int __init lpc32xx_pm_init(void)
 	__raw_writel(__raw_readl(EMC_CTRL_REG) | EMC_SRMMC, EMC_CTRL_REG);
 
 	suspend_set_ops(&lpc32xx_pm_ops);
-
-	return 0;
 }
-arch_initcall(lpc32xx_pm_init);
-- 
2.53.0



