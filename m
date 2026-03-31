Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940D02FE042;
	Tue, 31 Mar 2026 17:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976742; cv=none; b=vGmcFI1SU4bhbpTsfr4GmxH2aQrVCcfiD6Ig3GwI56XAX6l9gg9yoxR3IhjvFpnAkZ7ou5O2RAbGbFiDdIJTPmeM30WUxenWzrF8WLtRmeYQJFAstAsTQIAHtuqo4luL90GQPgZc68kGTxr+P5cyB/HQal9CaKlweRXnm49rUq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976742; c=relaxed/simple;
	bh=OqK6h/fWLLtM+dWvqooSqQGNzsegwSnefJj6yrfJRpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nl3iWALjIlyRjnflQlyFvFey+BBqM3Kr4I82oJ5ku36HwDR8xJbC01Ux4zwpY3rNZlAAPv0Sx8aZn50dYGKOI9AlHzC2dop8L+e8fIGurn3FdhD3yLLOwnleBI2ARUQ8d+diV3Nz+pWxYzSXMDWykhkNGJs52ntmLDeRuJoQQgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bS1xcda5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bS1xcda5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F2AC2BCB1;
	Tue, 31 Mar 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976742;
	bh=OqK6h/fWLLtM+dWvqooSqQGNzsegwSnefJj6yrfJRpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bS1xcda5gnD9g8QnXfO1llkKhGUoP6WECBKKzzs4ZEsZsSypjft9nSQMkcoCx1fKp
	 DOG87vupiTNJfZuQPgQf6rkpUUuiDKXFPfNmQQDEv+1ukvKZNo5lDZshk9bYy68+3H
	 7KEHcq0/R88fxXYtkqgzfRHF3AmMqOMNfM7eKQPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.18 211/309] x86/cpu: Enable FSGSBASE early in cpu_init_exception_handling()
Date: Tue, 31 Mar 2026 18:21:54 +0200
Message-ID: <20260331161801.213754946@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikunj A Dadhania <nikunj@amd.com>

commit 05243d490bb7852a8acca7b5b5658019c7797a52 upstream.

Move FSGSBASE enablement from identify_cpu() to cpu_init_exception_handling()
to ensure it is enabled before any exceptions can occur on both boot and
secondary CPUs.

== Background ==

Exception entry code (paranoid_entry()) uses ALTERNATIVE patching based on
X86_FEATURE_FSGSBASE to decide whether to use RDGSBASE/WRGSBASE instructions
or the slower RDMSR/SWAPGS sequence for saving/restoring GSBASE.

On boot CPU, ALTERNATIVE patching happens after enabling FSGSBASE in CR4.
When the feature is available, the code is permanently patched to use
RDGSBASE/WRGSBASE, which require CR4.FSGSBASE=1 to execute without triggering

== Boot Sequence ==

Boot CPU (with CR pinning enabled):
  trap_init()
    cpu_init()                   <- Uses unpatched code (RDMSR/SWAPGS)
      x2apic_setup()
  ...
  arch_cpu_finalize_init()
    identify_boot_cpu()
      identify_cpu()
        cr4_set_bits(X86_CR4_FSGSBASE)  # Enables the feature
	# This becomes part of cr4_pinned_bits
    ...
    alternative_instructions()   <- Patches code to use RDGSBASE/WRGSBASE

Secondary CPUs (with CR pinning enabled):
  start_secondary()
    cr4_init()                   <- Code already patched, CR4.FSGSBASE=1
                                    set implicitly via cr4_pinned_bits

    cpu_init()                   <- exceptions work because FSGSBASE is
                                    already enabled

Secondary CPU (with CR pinning disabled):
  start_secondary()
    cr4_init()                   <- Code already patched, CR4.FSGSBASE=0
    cpu_init()
      x2apic_setup()
        rdmsrq(MSR_IA32_APICBASE)  <- Triggers #VC in SNP guests
          exc_vmm_communication()
            paranoid_entry()       <- Uses RDGSBASE with CR4.FSGSBASE=0
                                      (patched code)
    ...
    ap_starting()
      identify_secondary_cpu()
        identify_cpu()
	  cr4_set_bits(X86_CR4_FSGSBASE)  <- Enables the feature, which is
                                             too late

== CR Pinning ==

Currently, for secondary CPUs, CR4.FSGSBASE is set implicitly through
CR-pinning: the boot CPU sets it during identify_cpu(), it becomes part of
cr4_pinned_bits, and cr4_init() applies those pinned bits to secondary CPUs.
This works but creates an undocumented dependency between cr4_init() and the
pinning mechanism.

== Problem ==

Secondary CPUs boot after alternatives have been applied globally. They
execute already-patched paranoid_entry() code that uses RDGSBASE/WRGSBASE
instructions, which require CR4.FSGSBASE=1. Upcoming changes to CR pinning
behavior will break the implicit dependency, causing secondary CPUs to
generate #UD.

This issue manifests itself on AMD SEV-SNP guests, where the rdmsrq() in
x2apic_setup() triggers a #VC exception early during cpu_init(). The #VC
handler (exc_vmm_communication()) executes the patched paranoid_entry() path.
Without CR4.FSGSBASE enabled, RDGSBASE instructions trigger #UD.

== Fix ==

Enable FSGSBASE explicitly in cpu_init_exception_handling() before loading
exception handlers. This makes the dependency explicit and ensures both
boot and secondary CPUs have FSGSBASE enabled before paranoid_entry()
executes.

Fixes: c82965f9e530 ("x86/entry/64: Handle FSGSBASE enabled paranoid entry/exit")
Reported-by: Borislav Petkov <bp@alien8.de>
Suggested-by: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260318075654.1792916-2-nikunj@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2020,12 +2020,6 @@ static void identify_cpu(struct cpuinfo_
 	setup_smap(c);
 	setup_umip(c);
 
-	/* Enable FSGSBASE instructions if available. */
-	if (cpu_has(c, X86_FEATURE_FSGSBASE)) {
-		cr4_set_bits(X86_CR4_FSGSBASE);
-		elf_hwcap2 |= HWCAP2_FSGSBASE;
-	}
-
 	/*
 	 * The vendor-specific functions might have changed features.
 	 * Now we do "generic changes."
@@ -2386,6 +2380,18 @@ void cpu_init_exception_handling(bool bo
 	/* GHCB needs to be setup to handle #VC. */
 	setup_ghcb();
 
+	/*
+	 * On CPUs with FSGSBASE support, paranoid_entry() uses
+	 * ALTERNATIVE-patched RDGSBASE/WRGSBASE instructions. Secondary CPUs
+	 * boot after alternatives are patched globally, so early exceptions
+	 * execute patched code that depends on FSGSBASE. Enable the feature
+	 * before any exceptions occur.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_FSGSBASE)) {
+		cr4_set_bits(X86_CR4_FSGSBASE);
+		elf_hwcap2 |= HWCAP2_FSGSBASE;
+	}
+
 	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
 		/* The boot CPU has enabled FRED during early boot */
 		if (!boot_cpu)


