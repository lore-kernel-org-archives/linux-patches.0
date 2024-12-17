Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517378615A;
	Tue, 17 Dec 2024 17:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456247; cv=none; b=ddqm3JrnB//t0n+f+BcJY443NFez2dEjugi6grqiywn+xxRVfwO/aj/3FBZL+omF42D7eu5MD6k+T72xkW6xvw1HRD/L63WrAH9RGwUSt9D99jHaVa/U7fuxOPphBDsGnI6JpskDWu9T8iI9vtkUVxldfLZvOSXaME226WY/U30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456247; c=relaxed/simple;
	bh=jMtdiUXpFY9s6XF7rB7C/vazmPL7Xs1Va9xgKv+286g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTM0NoxBOpAbdf7Nfz6dA9pQGWwO6k4vuRhB1yd5H81yf8mLBuDlnynZtw9tNRXGobOcHoxNtiK0dxZMn6oxCAgHT9VUY6ouxi5gm2aJEuJocSMwMSsxVdYJFHVu5kLpdBY7/qqaJsxTfW27GX8JsAC1s+sh9fzjt9KzasLrmt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Dp+sPzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Dp+sPzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECF7C4CED3;
	Tue, 17 Dec 2024 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456247;
	bh=jMtdiUXpFY9s6XF7rB7C/vazmPL7Xs1Va9xgKv+286g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Dp+sPzk/MEMKnBfKx/jUK/p+NY2VIloVeTUIT9edey+uwjZoIggS63tUGhyO+epJ
	 JRKDQCInGPiIP9rzJmTFpbg2B5GXK8t4wSTMzP/e0+e8XMkbO+cXwRGDTBJkagaJ4X
	 oqLTOYg4EiUSk4wdkKy9e8ZAH02LCxTUNfaO2x0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 6.6 108/109] x86/xen: remove hypercall page
Date: Tue, 17 Dec 2024 18:08:32 +0100
Message-ID: <20241217170537.912454184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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
 arch/x86/kernel/callthunks.c         |    5 -----
 arch/x86/xen/enlighten.c             |    2 --
 arch/x86/xen/enlighten_hvm.c         |    9 +--------
 arch/x86/xen/enlighten_pvh.c         |    7 -------
 arch/x86/xen/xen-head.S              |   23 -----------------------
 6 files changed, 1 insertion(+), 47 deletions(-)

--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -88,8 +88,6 @@ struct xen_dm_op_buf;
  * there aren't more than 5 arguments...)
  */
 
-extern struct { char _entry[32]; } hypercall_page[];
-
 void xen_hypercall_func(void);
 DECLARE_STATIC_CALL(xen_hypercall, xen_hypercall_func);
 
--- a/arch/x86/kernel/callthunks.c
+++ b/arch/x86/kernel/callthunks.c
@@ -146,11 +146,6 @@ static bool skip_addr(void *dest)
 	    dest < (void*)relocate_kernel + KEXEC_CONTROL_CODE_MAX_SIZE)
 		return true;
 #endif
-#ifdef CONFIG_XEN
-	if (dest >= (void *)hypercall_page &&
-	    dest < (void*)hypercall_page + PAGE_SIZE)
-		return true;
-#endif
 	return false;
 }
 
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -27,8 +27,6 @@
 #include "smp.h"
 #include "pmu.h"
 
-EXPORT_SYMBOL_GPL(hypercall_page);
-
 DEFINE_STATIC_CALL(xen_hypercall, xen_hypercall_hvm);
 EXPORT_STATIC_CALL_TRAMP(xen_hypercall);
 
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -108,15 +108,8 @@ static void __init init_hvm_pv_info(void
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
@@ -28,17 +28,10 @@ EXPORT_SYMBOL_GPL(xen_pvh);
 
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
@@ -22,28 +22,6 @@
 #include <xen/interface/xen-mca.h>
 #include <asm/xen/interface.h>
 
-.pushsection .noinstr.text, "ax"
-	.balign PAGE_SIZE
-SYM_CODE_START(hypercall_page)
-	.rept (PAGE_SIZE / 32)
-		UNWIND_HINT_FUNC
-		ANNOTATE_NOENDBR
-		ANNOTATE_UNRET_SAFE
-		ret
-		/*
-		 * Xen will write the hypercall page, and sort out ENDBR.
-		 */
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
 #ifdef CONFIG_XEN_PV
 	__INIT
 SYM_CODE_START(startup_xen)
@@ -198,7 +176,6 @@ SYM_FUNC_END(xen_hypercall_intel)
 #else
 # define FEATURES_DOM0 0
 #endif
-	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
 	ELFNOTE(Xen, XEN_ELFNOTE_SUPPORTED_FEATURES,
 		.long FEATURES_PV | FEATURES_PVH | FEATURES_DOM0)
 	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")


