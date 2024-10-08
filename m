Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3331D1DE88B;
	Tue,  8 Oct 2024 12:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389934; cv=none; b=assnNXEbtN3/ApD7wAiCDtpqn51B6zd2Cxt02iwQgZj3CiiN9j81ZifQ9TCJhd9zw5LU2h/ZkUOkxz1UGu+EzNQFBHoSv9Lm4XfUxMRQLqIyA3JerMv6k3r84J57Vxt7XBhXGE1RP53R3nFvITQqcLplxtqbiSOtx1qTFXqyLrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389934; c=relaxed/simple;
	bh=8Ifbtp+Xrp9dNG+NdsuXF3jezNz1YIGK7+DpLm6SIXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYybqmQJrNtFak3fqHraI3fwHlv0APF9iypBmuEj77cbmGsm58UBmRyWRNvLYQJ+Zto5qlFJHr0uRV9Lgp9+0vZXTKBXt7wLZV669/KetniekPfWKmVvK7c3T0R2navE7EWnw/NFcMLhafGQ4AbrjShb/Snp9gE74M7pZKpyEwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uee/IJwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uee/IJwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFE7C4CEC7;
	Tue,  8 Oct 2024 12:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389934;
	bh=8Ifbtp+Xrp9dNG+NdsuXF3jezNz1YIGK7+DpLm6SIXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uee/IJwXiAOo3cZZJMwlcnaaYuKozsCdaIpaW9jC5+jo8FMGtFzc0RTNhczugDFOg
	 MfIwBiv+oi6hUBQ7SN5u701qdZYyw496D0Aoa1kvzcYwho9yZsHe7ZAigN6xWcsw6F
	 LgAQRMwNRv1JFIl097+sPyadYoNCvqaAOSxZIu8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Newcater <rob@durendal.co.uk>,
	Christian Heusel <christian@heusel.eu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 140/482] x86/apic: Remove logical destination mode for 64-bit
Date: Tue,  8 Oct 2024 14:03:23 +0200
Message-ID: <20241008115653.812861585@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 838ba7733e4e3a94a928e8d0a058de1811a58621 ]

Logical destination mode of the local APIC is used for systems with up to
8 CPUs. It has an advantage over physical destination mode as it allows to
target multiple CPUs at once with IPIs.

That advantage was definitely worth it when systems with up to 8 CPUs
were state of the art for servers and workstations, but that's history.

Aside of that there are systems which fail to work with logical destination
mode as the ACPI/DMI quirks show and there are AMD Zen1 systems out there
which fail when interrupt remapping is enabled as reported by Rob and
Christian. The latter problem can be cured by firmware updates, but not all
OEMs distribute the required changes.

Physical destination mode is guaranteed to work because it is the only way
to get a CPU up and running via the INIT/INIT/STARTUP sequence.

As the number of CPUs keeps increasing, logical destination mode becomes a
less used code path so there is no real good reason to keep it around.

Therefore remove logical destination mode support for 64-bit and default to
physical destination mode.

Reported-by: Rob Newcater <rob@durendal.co.uk>
Reported-by: Christian Heusel <christian@heusel.eu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Rob Newcater <rob@durendal.co.uk>
Link: https://lore.kernel.org/all/877cd5u671.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/apic.h         |   8 --
 arch/x86/kernel/apic/apic_flat_64.c | 119 ++--------------------------
 2 files changed, 7 insertions(+), 120 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 9327eb00e96d0..be2045a18e69b 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -345,20 +345,12 @@ extern struct apic *apic;
  * APIC drivers are probed based on how they are listed in the .apicdrivers
  * section. So the order is important and enforced by the ordering
  * of different apic driver files in the Makefile.
- *
- * For the files having two apic drivers, we use apic_drivers()
- * to enforce the order with in them.
  */
 #define apic_driver(sym)					\
 	static const struct apic *__apicdrivers_##sym __used		\
 	__aligned(sizeof(struct apic *))			\
 	__section(".apicdrivers") = { &sym }
 
-#define apic_drivers(sym1, sym2)					\
-	static struct apic *__apicdrivers_##sym1##sym2[2] __used	\
-	__aligned(sizeof(struct apic *))				\
-	__section(".apicdrivers") = { &sym1, &sym2 }
-
 extern struct apic *__apicdrivers[], *__apicdrivers_end[];
 
 /*
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index f37ad3392fec9..e0308d8c4e6c2 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -8,129 +8,25 @@
  * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
  * James Cleverdon.
  */
-#include <linux/cpumask.h>
 #include <linux/export.h>
-#include <linux/acpi.h>
 
-#include <asm/jailhouse_para.h>
 #include <asm/apic.h>
 
 #include "local.h"
 
-static struct apic apic_physflat;
-static struct apic apic_flat;
-
-struct apic *apic __ro_after_init = &apic_flat;
-EXPORT_SYMBOL_GPL(apic);
-
-static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	return 1;
-}
-
-static void _flat_send_IPI_mask(unsigned long mask, int vector)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__default_send_IPI_dest_field(mask, vector, APIC_DEST_LOGICAL);
-	local_irq_restore(flags);
-}
-
-static void flat_send_IPI_mask(const struct cpumask *cpumask, int vector)
-{
-	unsigned long mask = cpumask_bits(cpumask)[0];
-
-	_flat_send_IPI_mask(mask, vector);
-}
-
-static void
-flat_send_IPI_mask_allbutself(const struct cpumask *cpumask, int vector)
-{
-	unsigned long mask = cpumask_bits(cpumask)[0];
-	int cpu = smp_processor_id();
-
-	if (cpu < BITS_PER_LONG)
-		__clear_bit(cpu, &mask);
-
-	_flat_send_IPI_mask(mask, vector);
-}
-
-static u32 flat_get_apic_id(u32 x)
+static u32 physflat_get_apic_id(u32 x)
 {
 	return (x >> 24) & 0xFF;
 }
 
-static int flat_probe(void)
+static int physflat_probe(void)
 {
 	return 1;
 }
 
-static struct apic apic_flat __ro_after_init = {
-	.name				= "flat",
-	.probe				= flat_probe,
-	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
-
-	.dest_mode_logical		= true,
-
-	.disable_esr			= 0,
-
-	.init_apic_ldr			= default_init_apic_ldr,
-	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
-
-	.max_apic_id			= 0xFE,
-	.get_apic_id			= flat_get_apic_id,
-
-	.calc_dest_apicid		= apic_flat_calc_apicid,
-
-	.send_IPI			= default_send_IPI_single,
-	.send_IPI_mask			= flat_send_IPI_mask,
-	.send_IPI_mask_allbutself	= flat_send_IPI_mask_allbutself,
-	.send_IPI_allbutself		= default_send_IPI_allbutself,
-	.send_IPI_all			= default_send_IPI_all,
-	.send_IPI_self			= default_send_IPI_self,
-	.nmi_to_offline_cpu		= true,
-
-	.read				= native_apic_mem_read,
-	.write				= native_apic_mem_write,
-	.eoi				= native_apic_mem_eoi,
-	.icr_read			= native_apic_icr_read,
-	.icr_write			= native_apic_icr_write,
-	.wait_icr_idle			= apic_mem_wait_icr_idle,
-	.safe_wait_icr_idle		= apic_mem_wait_icr_idle_timeout,
-};
-
-/*
- * Physflat mode is used when there are more than 8 CPUs on a system.
- * We cannot use logical delivery in this case because the mask
- * overflows, so use physical mode.
- */
 static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-#ifdef CONFIG_ACPI
-	/*
-	 * Quirk: some x86_64 machines can only use physical APIC mode
-	 * regardless of how many processors are present (x86_64 ES7000
-	 * is an example).
-	 */
-	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
-		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
-		printk(KERN_DEBUG "system APIC only can use physical flat");
-		return 1;
-	}
-
-	if (!strncmp(oem_id, "IBM", 3) && !strncmp(oem_table_id, "EXA", 3)) {
-		printk(KERN_DEBUG "IBM Summit detected, will use apic physical");
-		return 1;
-	}
-#endif
-
-	return 0;
-}
-
-static int physflat_probe(void)
-{
-	return apic == &apic_physflat || num_possible_cpus() > 8 || jailhouse_paravirt();
+	return 1;
 }
 
 static struct apic apic_physflat __ro_after_init = {
@@ -146,7 +42,7 @@ static struct apic apic_physflat __ro_after_init = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 
 	.max_apic_id			= 0xFE,
-	.get_apic_id			= flat_get_apic_id,
+	.get_apic_id			= physflat_get_apic_id,
 
 	.calc_dest_apicid		= apic_default_calc_apicid,
 
@@ -166,8 +62,7 @@ static struct apic apic_physflat __ro_after_init = {
 	.wait_icr_idle			= apic_mem_wait_icr_idle,
 	.safe_wait_icr_idle		= apic_mem_wait_icr_idle_timeout,
 };
+apic_driver(apic_physflat);
 
-/*
- * We need to check for physflat first, so this order is important.
- */
-apic_drivers(apic_physflat, apic_flat);
+struct apic *apic __ro_after_init = &apic_physflat;
+EXPORT_SYMBOL_GPL(apic);
-- 
2.43.0



