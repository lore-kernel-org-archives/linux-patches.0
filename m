Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7257BB10;
	Mon,  4 Mar 2024 21:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588534; cv=none; b=gdBfukh+x1e3gRpT65uTxH8a9tNEgqk8sJMdF0l2skONHj05QOOfU88FfJgsFd/NM8cQQFYOBfL+ELvXR9A4nb1ge4UV93Ef/uoXCOxkyoz4ALOy42DbmmVhCdOsnzSRmi0J3K1gwGCBoBkx2ViXx6X4b+xIu7HWDCPdOSwdQVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588534; c=relaxed/simple;
	bh=KxhWlXRKQ83dyo7+sEb2vSdgw2YZqLbI/qZ97WQhCV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpwDNPWfTJYklH9+XjAMYPd71acMCTMA1XiQDvexQQYGuPf3nVzB2cT6H26nnVevfMw9dWhwyFi5qzGVjHMqHSSDYyHdeaxqrDZ891Um5eC0BE+LD7aCFjaAKQr9G9HCH6JUZ9wcgf9hpqah+hX+vnHDRG/rdncCfxK73UaxNnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZdJnKhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZdJnKhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADEEC433F1;
	Mon,  4 Mar 2024 21:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588534;
	bh=KxhWlXRKQ83dyo7+sEb2vSdgw2YZqLbI/qZ97WQhCV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZdJnKhvpK/32PtIJOTOG4/n1WnEufci1uGe0dteOAaFBoxST+eYIiFzdNkIZBk75
	 TilbyBXJ2NOq0tETkp126HHIW5vsz8kNxvwfgnMXDBfESk546YisTZAVtl9/5NXtnS
	 SO0M3/qn/4X46XYK+z+Iu4ZV7JWatLKBLab3fX04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Gaurav Batra <gbatra@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/143] powerpc/rtas: use correct function name for resetting TCE tables
Date: Mon,  4 Mar 2024 21:24:08 +0000
Message-ID: <20240304211553.991085876@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit fad87dbd48156ab940538f052f1820f4b6ed2819 ]

The PAPR spec spells the function name as

  "ibm,reset-pe-dma-windows"

but in practice firmware uses the singular form:

  "ibm,reset-pe-dma-window"

in the device tree. Since we have the wrong spelling in the RTAS
function table, reverse lookups (token -> name) fail and warn:

  unexpected failed lookup for token 86
  WARNING: CPU: 1 PID: 545 at arch/powerpc/kernel/rtas.c:659 __do_enter_rtas_trace+0x2a4/0x2b4
  CPU: 1 PID: 545 Comm: systemd-udevd Not tainted 6.8.0-rc4 #30
  Hardware name: IBM,9105-22A POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1060.00 (NL1060_028) hv:phyp pSeries
  NIP [c0000000000417f0] __do_enter_rtas_trace+0x2a4/0x2b4
  LR [c0000000000417ec] __do_enter_rtas_trace+0x2a0/0x2b4
  Call Trace:
   __do_enter_rtas_trace+0x2a0/0x2b4 (unreliable)
   rtas_call+0x1f8/0x3e0
   enable_ddw.constprop.0+0x4d0/0xc84
   dma_iommu_dma_supported+0xe8/0x24c
   dma_set_mask+0x5c/0xd8
   mlx5_pci_init.constprop.0+0xf0/0x46c [mlx5_core]
   probe_one+0xfc/0x32c [mlx5_core]
   local_pci_probe+0x68/0x12c
   pci_call_probe+0x68/0x1ec
   pci_device_probe+0xbc/0x1a8
   really_probe+0x104/0x570
   __driver_probe_device+0xb8/0x224
   driver_probe_device+0x54/0x130
   __driver_attach+0x158/0x2b0
   bus_for_each_dev+0xa8/0x120
   driver_attach+0x34/0x48
   bus_add_driver+0x174/0x304
   driver_register+0x8c/0x1c4
   __pci_register_driver+0x68/0x7c
   mlx5_init+0xb8/0x118 [mlx5_core]
   do_one_initcall+0x60/0x388
   do_init_module+0x7c/0x2a4
   init_module_from_file+0xb4/0x108
   idempotent_init_module+0x184/0x34c
   sys_finit_module+0x90/0x114

And oopses are possible when lockdep is enabled or the RTAS
tracepoints are active, since those paths dereference the result of
the lookup.

Use the correct spelling to match firmware's behavior, adjusting the
related constants to match.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 8252b88294d2 ("powerpc/rtas: improve function information lookups")
Reported-by: Gaurav Batra <gbatra@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240222-rtas-fix-ibm-reset-pe-dma-window-v1-1-7aaf235ac63c@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/rtas.h | 4 ++--
 arch/powerpc/kernel/rtas.c      | 9 +++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/rtas.h b/arch/powerpc/include/asm/rtas.h
index c697c3c746946..33024a2874a69 100644
--- a/arch/powerpc/include/asm/rtas.h
+++ b/arch/powerpc/include/asm/rtas.h
@@ -68,7 +68,7 @@ enum rtas_function_index {
 	RTAS_FNIDX__IBM_READ_SLOT_RESET_STATE,
 	RTAS_FNIDX__IBM_READ_SLOT_RESET_STATE2,
 	RTAS_FNIDX__IBM_REMOVE_PE_DMA_WINDOW,
-	RTAS_FNIDX__IBM_RESET_PE_DMA_WINDOWS,
+	RTAS_FNIDX__IBM_RESET_PE_DMA_WINDOW,
 	RTAS_FNIDX__IBM_SCAN_LOG_DUMP,
 	RTAS_FNIDX__IBM_SET_DYNAMIC_INDICATOR,
 	RTAS_FNIDX__IBM_SET_EEH_OPTION,
@@ -163,7 +163,7 @@ typedef struct {
 #define RTAS_FN_IBM_READ_SLOT_RESET_STATE         rtas_fn_handle(RTAS_FNIDX__IBM_READ_SLOT_RESET_STATE)
 #define RTAS_FN_IBM_READ_SLOT_RESET_STATE2        rtas_fn_handle(RTAS_FNIDX__IBM_READ_SLOT_RESET_STATE2)
 #define RTAS_FN_IBM_REMOVE_PE_DMA_WINDOW          rtas_fn_handle(RTAS_FNIDX__IBM_REMOVE_PE_DMA_WINDOW)
-#define RTAS_FN_IBM_RESET_PE_DMA_WINDOWS          rtas_fn_handle(RTAS_FNIDX__IBM_RESET_PE_DMA_WINDOWS)
+#define RTAS_FN_IBM_RESET_PE_DMA_WINDOW           rtas_fn_handle(RTAS_FNIDX__IBM_RESET_PE_DMA_WINDOW)
 #define RTAS_FN_IBM_SCAN_LOG_DUMP                 rtas_fn_handle(RTAS_FNIDX__IBM_SCAN_LOG_DUMP)
 #define RTAS_FN_IBM_SET_DYNAMIC_INDICATOR         rtas_fn_handle(RTAS_FNIDX__IBM_SET_DYNAMIC_INDICATOR)
 #define RTAS_FN_IBM_SET_EEH_OPTION                rtas_fn_handle(RTAS_FNIDX__IBM_SET_EEH_OPTION)
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 87d65bdd3ecae..46b9476d75824 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -310,8 +310,13 @@ static struct rtas_function rtas_function_table[] __ro_after_init = {
 	[RTAS_FNIDX__IBM_REMOVE_PE_DMA_WINDOW] = {
 		.name = "ibm,remove-pe-dma-window",
 	},
-	[RTAS_FNIDX__IBM_RESET_PE_DMA_WINDOWS] = {
-		.name = "ibm,reset-pe-dma-windows",
+	[RTAS_FNIDX__IBM_RESET_PE_DMA_WINDOW] = {
+		/*
+		 * Note: PAPR+ v2.13 7.3.31.4.1 spells this as
+		 * "ibm,reset-pe-dma-windows" (plural), but RTAS
+		 * implementations use the singular form in practice.
+		 */
+		.name = "ibm,reset-pe-dma-window",
 	},
 	[RTAS_FNIDX__IBM_SCAN_LOG_DUMP] = {
 		.name = "ibm,scan-log-dump",
-- 
2.43.0



