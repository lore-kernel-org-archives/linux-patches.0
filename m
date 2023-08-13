Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C519446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D5EC433C8;
	Sun, 13 Aug 2023 21:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962412;
	bh=S+nnZ7Mif79z4asiwYDbNCCbMlJqrfAlnqdXDpPl11g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVY1feQnbhqbJdXOPHWryyUM1sumyfycaHGionBGucNgXdUHrSPWTGlPkTJbCUitf
	 aXnBAxhvoadyhqkcfEE5OAgLIJpZaUPhB3J0dGgi+AHRxtyyeK9mv5t1hDMYHqP0lO
	 mVBmibDaCDsBkjDepL9QXi6+kY3nGoyNfV47iB2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: [PATCH 6.1 002/149] Revert "loongarch/cpu: Switch to arch_cpu_finalize_init()"
Date: Sun, 13 Aug 2023 23:17:27 +0200
Message-ID: <20230813211718.832873199@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 08e86d42e2c916e362d124e3bc6c824eb1862498 which is
commit 9841c423164787feb8f1442f922b7d80a70c82f1 upstream.

As Gunter reports:
	Building loongarch:defconfig ... failed
	--------------
	Error log:
	<stdin>:569:2: warning: #warning syscall fstat not implemented [-Wcpp]
	arch/loongarch/kernel/setup.c: In function 'arch_cpu_finalize_init':
	arch/loongarch/kernel/setup.c:86:9: error: implicit declaration of function 'alternative_instructions'

	Actually introduced in v6.1.44 with commit 08e86d42e2c9 ("loongarch/cpu:
	Switch to arch_cpu_finalize_init()"). Alternative instruction support
	was only introduced for loongarch in v6.2 with commit 19e5eb15b00c
	("LoongArch: Add alternative runtime patching mechanism").

So revert it from 6.1.y.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/fcd7b764-9047-22ba-a040-41b6ff99959c@roeck-us.net
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Kconfig        |    1 -
 arch/loongarch/kernel/setup.c |    6 ------
 2 files changed, 7 deletions(-)

--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -10,7 +10,6 @@ config LOONGARCH
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
-	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -12,7 +12,6 @@
  */
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <linux/cpu.h>
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/export.h>
@@ -81,11 +80,6 @@ const char *get_system_type(void)
 	return "generic-loongson-machine";
 }
 
-void __init arch_cpu_finalize_init(void)
-{
-	alternative_instructions();
-}
-
 static const char *dmi_string_parse(const struct dmi_header *dm, u8 s)
 {
 	const u8 *bp = ((u8 *) dm) + dm->length;


