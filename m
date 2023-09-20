Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB65E3AC27
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA40C433C7;
	Wed, 20 Sep 2023 12:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213059;
	bh=PLsfQOY3VEaRLslUDvjLVzMjGzTHHsj0U60QQgMKo0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pf8oYf6gYVylEG+P/5SFodcWXTgeGBPtMzFMnhUpWMn9a/9T78hL6S9TMHjpevNF2
	 iQJFjSK/ddTVEdmgfD42QfY7YDjRxy4LKVGqtPo+Iu31Oe2wlKBatSe1PFFWV56O6I
	 Q1apLBcPQg9yaz1My6+a3mV3BfJl5RK+CxeXkD5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nageswara R Sastry <rnsastry@linux.ibm.com>,
	Russell Currey <ruscur@russell.cc>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/367] powerpc/iommu: Fix notifiers being shared by PCI and VIO buses
Date: Wed, 20 Sep 2023 13:28:42 +0200
Message-ID: <20230920112902.430707821@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell Currey <ruscur@russell.cc>

[ Upstream commit c37b6908f7b2bd24dcaaf14a180e28c9132b9c58 ]

fail_iommu_setup() registers the fail_iommu_bus_notifier struct to both
PCI and VIO buses.  struct notifier_block is a linked list node, so this
causes any notifiers later registered to either bus type to also be
registered to the other since they share the same node.

This causes issues in (at least) the vgaarb code, which registers a
notifier for PCI buses.  pci_notify() ends up being called on a vio
device, converted with to_pci_dev() even though it's not a PCI device,
and finally makes a bad access in vga_arbiter_add_pci_device() as
discovered with KASAN:

 BUG: KASAN: slab-out-of-bounds in vga_arbiter_add_pci_device+0x60/0xe00
 Read of size 4 at addr c000000264c26fdc by task swapper/0/1

 Call Trace:
   dump_stack_lvl+0x1bc/0x2b8 (unreliable)
   print_report+0x3f4/0xc60
   kasan_report+0x244/0x698
   __asan_load4+0xe8/0x250
   vga_arbiter_add_pci_device+0x60/0xe00
   pci_notify+0x88/0x444
   notifier_call_chain+0x104/0x320
   blocking_notifier_call_chain+0xa0/0x140
   device_add+0xac8/0x1d30
   device_register+0x58/0x80
   vio_register_device_node+0x9ac/0xce0
   vio_bus_scan_register_devices+0xc4/0x13c
   __machine_initcall_pseries_vio_device_init+0x94/0xf0
   do_one_initcall+0x12c/0xaa8
   kernel_init_freeable+0xa48/0xba8
   kernel_init+0x64/0x400
   ret_from_kernel_thread+0x5c/0x64

Fix this by creating separate notifier_block structs for each bus type.

Fixes: d6b9a81b2a45 ("powerpc: IOMMU fault injection")
Reported-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
[mpe: Add #ifdef to fix CONFIG_IBMVIO=n build]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230322035322.328709-1-ruscur@russell.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/iommu.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index d7d42bd448c4a..dd062eef533b1 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -133,17 +133,28 @@ static int fail_iommu_bus_notify(struct notifier_block *nb,
 	return 0;
 }
 
-static struct notifier_block fail_iommu_bus_notifier = {
+/*
+ * PCI and VIO buses need separate notifier_block structs, since they're linked
+ * list nodes.  Sharing a notifier_block would mean that any notifiers later
+ * registered for PCI buses would also get called by VIO buses and vice versa.
+ */
+static struct notifier_block fail_iommu_pci_bus_notifier = {
 	.notifier_call = fail_iommu_bus_notify
 };
 
+#ifdef CONFIG_IBMVIO
+static struct notifier_block fail_iommu_vio_bus_notifier = {
+	.notifier_call = fail_iommu_bus_notify
+};
+#endif
+
 static int __init fail_iommu_setup(void)
 {
 #ifdef CONFIG_PCI
-	bus_register_notifier(&pci_bus_type, &fail_iommu_bus_notifier);
+	bus_register_notifier(&pci_bus_type, &fail_iommu_pci_bus_notifier);
 #endif
 #ifdef CONFIG_IBMVIO
-	bus_register_notifier(&vio_bus_type, &fail_iommu_bus_notifier);
+	bus_register_notifier(&vio_bus_type, &fail_iommu_vio_bus_notifier);
 #endif
 
 	return 0;
-- 
2.40.1



