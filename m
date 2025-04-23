Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4942728B517;
	Wed, 23 Apr 2025 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422491; cv=none; b=NSz83IuDgDYy9J9bcwGcjYK2K8E0nt/X166frZNOJv+cgiyZAasbfDAYL64B9rC4pd8RrnncB8J7jx7gIitEjUt8BlQBSoTIvCqnrFe4r7eVEI+2a7MrVmJfW4MWpG5xCbKHACO7teq2nEiHVaUdgXMvbTvYIlQF34azyI+fEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422491; c=relaxed/simple;
	bh=AAQziMJaK2yl0kYbGVR7DLH3djjwA3qhrP0WLy2Rgn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iqKVRM3Ad2EHh4sThvQzwxS9gHadFNH/Dj9ayQ7Xgo49dj14+tyT2bUnbPfl3vgre4HGCGu1mJrNgY6AkJQ6VPNSCQs4/pTCnIdFjOsol0alT43qzr7HC17V26vUQtrkRCotM52PrRc1E/fCKdzX1UAqPbafEm4Dg0EOr9yNuC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2dIJF9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2dIJF9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF9DC4CEE3;
	Wed, 23 Apr 2025 15:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422490;
	bh=AAQziMJaK2yl0kYbGVR7DLH3djjwA3qhrP0WLy2Rgn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2dIJF9EvBmIu49EFQs3jS8BvSB+CrlgiBaTeYU9yXYIZofY4lTkLulxE3HTlbZVz
	 LNWaQJoeyxZLRcEhohELkIkN/2JZNLnING9bjoUXKaROh/OBYX9iY6PFMWPRUAuR+R
	 L2Mh2ANCZdYfqJhCueZwnGWFWWJW70ZyTVnZb8DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>
Subject: [PATCH 6.6 371/393] x86/xen: fix memblock_reserve() usage on PVH
Date: Wed, 23 Apr 2025 16:44:27 +0200
Message-ID: <20250423142658.656884252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

commit 4c006734898a113a64a528027274a571b04af95a upstream.

The current usage of memblock_reserve() in init_pvh_bootparams() is done before
the .bss is zeroed, and that used to be fine when
memblock_reserved_init_regions implicitly ended up in the .meminit.data
section.  However after commit 73db3abdca58c memblock_reserved_init_regions
ends up in the .bss section, thus breaking it's usage before the .bss is
cleared.

Move and rename the call to xen_reserve_extra_memory() so it's done in the
x86_init.oem.arch_setup hook, which gets executed after the .bss has been
zeroed, but before calling e820__memory_setup().

Fixes: 73db3abdca58c ("init/modpost: conditionally check section mismatch to __meminit*")
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20240725073116.14626-3-roger.pau@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
[ Context fixup for hypercall_page removal ]
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/xen/hypervisor.h |    5 -----
 arch/x86/platform/pvh/enlighten.c     |    3 ---
 arch/x86/xen/enlighten_pvh.c          |   15 ++++++++++++---
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -62,11 +62,6 @@ void xen_arch_unregister_cpu(int num);
 #ifdef CONFIG_PVH
 void __init xen_pvh_init(struct boot_params *boot_params);
 void __init mem_map_via_hcall(struct boot_params *boot_params_p);
-#ifdef CONFIG_XEN_PVH
-void __init xen_reserve_extra_memory(struct boot_params *bootp);
-#else
-static inline void xen_reserve_extra_memory(struct boot_params *bootp) { }
-#endif
 #endif
 
 /* Lazy mode for batching updates / context switch */
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -74,9 +74,6 @@ static void __init init_pvh_bootparams(b
 	} else
 		xen_raw_printk("Warning: Can fit ISA range into e820\n");
 
-	if (xen_guest)
-		xen_reserve_extra_memory(&pvh_bootparams);
-
 	pvh_bootparams.hdr.cmd_line_ptr =
 		pvh_start_info.cmdline_paddr;
 
--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -8,6 +8,7 @@
 #include <asm/io_apic.h>
 #include <asm/hypervisor.h>
 #include <asm/e820/api.h>
+#include <asm/setup.h>
 
 #include <xen/xen.h>
 #include <asm/xen/interface.h>
@@ -40,8 +41,9 @@ EXPORT_SYMBOL_GPL(xen_pvh);
  * hypervisor should notify us which memory ranges are suitable for creating
  * foreign mappings, but that's not yet implemented.
  */
-void __init xen_reserve_extra_memory(struct boot_params *bootp)
+static void __init pvh_reserve_extra_memory(void)
 {
+	struct boot_params *bootp = &boot_params;
 	unsigned int i, ram_pages = 0, extra_pages;
 
 	for (i = 0; i < bootp->e820_entries; i++) {
@@ -93,14 +95,21 @@ void __init xen_reserve_extra_memory(str
 	}
 }
 
+static void __init pvh_arch_setup(void)
+{
+	pvh_reserve_extra_memory();
+
+	if (xen_initial_domain())
+		xen_add_preferred_consoles();
+}
+
 void __init xen_pvh_init(struct boot_params *boot_params)
 {
 	xen_pvh = 1;
 	xen_domain_type = XEN_HVM_DOMAIN;
 	xen_start_flags = pvh_start_info.flags;
 
-	if (xen_initial_domain())
-		x86_init.oem.arch_setup = xen_add_preferred_consoles;
+	x86_init.oem.arch_setup = pvh_arch_setup;
 	x86_init.oem.banner = xen_banner;
 
 	xen_efi_init(boot_params);


