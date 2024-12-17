Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAE81F7568;
	Tue, 17 Dec 2024 17:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455709; cv=none; b=ALtEubXmiKhiGtkCqT3TRDB4M5kzlgk/aCqRytn9yxDt2sUsCecIh+0eFsm9vAcSbc3XOsZIlI54yr0Pp8jzDhfRLoU1bs4Vb0bk94tCkhr++mWHN5S7mrtaLxglFGvkkdgeqPQPU1xJuGifPWg66euPAzu+5aBjL6oQ40QMmrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455709; c=relaxed/simple;
	bh=rSez1/ZgvmwHE229zDyTOG3h/WIXDGRMBAZylU4KSc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cX2IYflWogL9mdSrp9trOXRyfwRCKMs+HmZgAKW/BuquN8nxIMeKT1ieIYxY3q8sSiPqZ6GGfeBd/n8W2yU0AlFK+LnCk0daSOWy0MhgHG2CZRPqIdL9CzATqy+JXkOxcpsWpEhY7lqNSZJXn9Sfh3SCbb/citmq9N0vtzSCZz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHAchOmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHAchOmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AB9C4CED3;
	Tue, 17 Dec 2024 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455709;
	bh=rSez1/ZgvmwHE229zDyTOG3h/WIXDGRMBAZylU4KSc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHAchOmF4NV3iPh4KCI/SzSzRilxcU2htefKq6DTJynWQ/Wj2tVHtqvlYWhHrnt0U
	 h8FpffTehlNi1ZH3d9A5hyfw1ld4W0jLS7QVOwQy+cK8sagDP6/9xIXQBLB3yZcQGU
	 HcCh9ZxwX5YVUTEb7ItillJjV7Da7aoghBP7Qxhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.15 50/51] x86/xen: remove hypercall page
Date: Tue, 17 Dec 2024 18:07:43 +0100
Message-ID: <20241217170522.523398210@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit 7fa0da5373685e7ed249af3fa317ab1e1ba8b0a6 upstream.

The hypercall page is no longer needed. It can be removed, as from the
Xen perspective it is optional.

But, from Linux's perspective, it removes naked RET instructions that
escape the speculative protections that Call Depth Tracking and/or
Untrain Ret are trying to achieve.

This is part of XSA-466 / CVE-2024-53241.

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/xen/hypercall.h |    2 --
 arch/x86/xen/enlighten.c             |    2 --
 arch/x86/xen/enlighten_hvm.c         |    9 +--------
 arch/x86/xen/enlighten_pvh.c         |    7 -------
 arch/x86/xen/xen-head.S              |   19 -------------------
 5 files changed, 1 insertion(+), 38 deletions(-)

--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -88,8 +88,6 @@ struct xen_dm_op_buf;
  * there aren't more than 5 arguments...)
  */
 
-extern struct { char _entry[32]; } hypercall_page[];
-
 void xen_hypercall_func(void);
 DECLARE_STATIC_CALL(xen_hypercall, xen_hypercall_func);
 
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -26,8 +26,6 @@
 #include "smp.h"
 #include "pmu.h"
 
-EXPORT_SYMBOL_GPL(hypercall_page);
-
 DEFINE_STATIC_CALL(xen_hypercall, xen_hypercall_hvm);
 EXPORT_STATIC_CALL_TRAMP(xen_hypercall);
 
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -101,15 +101,8 @@ static void __init init_hvm_pv_info(void
 	/* PVH set up hypercall page in xen_prepare_pvh(). */
 	if (xen_pvh_domain())
 		pv_info.name = "Xen PVH";
-	else {
-		u64 pfn;
-		uint32_t msr;
-
+	else
 		pv_info.name = "Xen HVM";
-		msr = cpuid_ebx(base + 2);
-		pfn = __pa(hypercall_page);
-		wrmsr_safe(msr, (u32)pfn, (u32)(pfn >> 32));
-	}
 
 	xen_setup_features();
 
--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -27,17 +27,10 @@ EXPORT_SYMBOL_GPL(xen_pvh);
 
 void __init xen_pvh_init(struct boot_params *boot_params)
 {
-	u32 msr;
-	u64 pfn;
-
 	xen_pvh = 1;
 	xen_domain_type = XEN_HVM_DOMAIN;
 	xen_start_flags = pvh_start_info.flags;
 
-	msr = cpuid_ebx(xen_cpuid_base() + 2);
-	pfn = __pa(hypercall_page);
-	wrmsr_safe(msr, (u32)pfn, (u32)(pfn >> 32));
-
 	if (xen_initial_domain())
 		x86_init.oem.arch_setup = xen_add_preferred_consoles;
 	x86_init.oem.banner = xen_banner;
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -146,24 +146,6 @@ SYM_FUNC_START(xen_hypercall_intel)
 SYM_FUNC_END(xen_hypercall_intel)
 	.popsection
 
-.pushsection .text
-	.balign PAGE_SIZE
-SYM_CODE_START(hypercall_page)
-	.rept (PAGE_SIZE / 32)
-		UNWIND_HINT_FUNC
-		ANNOTATE_UNRET_SAFE
-		ret
-		.skip 31, 0xcc
-	.endr
-
-#define HYPERCALL(n) \
-	.equ xen_hypercall_##n, hypercall_page + __HYPERVISOR_##n * 32; \
-	.type xen_hypercall_##n, @function; .size xen_hypercall_##n, 32
-#include <asm/xen-hypercalls.h>
-#undef HYPERCALL
-SYM_CODE_END(hypercall_page)
-.popsection
-
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_VERSION,  .asciz "2.6")
 	ELFNOTE(Xen, XEN_ELFNOTE_XEN_VERSION,    .asciz "xen-3.0")
@@ -177,7 +159,6 @@ SYM_CODE_END(hypercall_page)
 #ifdef CONFIG_XEN_PV
 	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
 #endif
-	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
 	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,
 		.ascii "!writable_page_tables|pae_pgdir_above_4gb")
 	ELFNOTE(Xen, XEN_ELFNOTE_SUPPORTED_FEATURES,


