Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C032061675;
	Mon,  4 Mar 2024 21:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588970; cv=none; b=qMLNQfFudW36t+AhO+PNYWmSJqj/iSrUDU3EZXMJeWx6Sl4ynCNXkhX73rOmSC6UDWAbEXyhsO8LFWDSDyeyrhwQXJnMGnIVWz2wGH22uaLiCD9GcjxVB3+d6UX5D1JFYJTMxU2LjGPvXV2DSWaonb9adyAezzPWvC8dCnFKNic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588970; c=relaxed/simple;
	bh=h274z+cRGL3tK+n0YpNTcsWnl9toKTtxfD1afOmGF+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKM3C6DrpZyR+q9MQY/blhhqiSh1Gdr2UHyv/6ae6Yhy0v28K1ScoJ4LxCM6u3q4jFY3hMrZdquEZrEUWvvXHjvpY7HIBJLkK+JKEaF3QfwnDF/B4wokw0WIupBNVZ0K9D0PapzEvNOJv4MNmAXCeiW6Zwimv2yOOb+wFe9+NA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXpEI5jO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXpEI5jO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529FDC433F1;
	Mon,  4 Mar 2024 21:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588970;
	bh=h274z+cRGL3tK+n0YpNTcsWnl9toKTtxfD1afOmGF+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXpEI5jO8xLXu5KzT3d7rOveqsdlcm3zClJUNRuBCEGR0uVilqWpwwYxPr4sPvBXA
	 jIS85iRwDz4zTZ3GjvZIxMB3lMlJTXeQsluQGhKbjbs7dyckHkp2Q4wu/eFwheLzAC
	 L7wSicELO77+rOdJRSv2gFWEbtOBTS+9fLZ88J7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 127/215] x86/efi: Make the deprecated EFI handover protocol optional
Date: Mon,  4 Mar 2024 21:23:10 +0000
Message-ID: <20240304211601.094999250@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit cc3fdda2876e58a7e83e558ab51853cf106afb6a upstream.

The EFI handover protocol permits a bootloader to invoke the kernel as a
EFI PE/COFF application, while passing a bootparams struct as a third
argument to the entrypoint function call.

This has no basis in the UEFI specification, and there are better ways
to pass additional data to a UEFI application (UEFI configuration
tables, UEFI variables, UEFI protocols) than going around the
StartImage() boot service and jumping to a fixed offset in the loaded
image, just to call a different function that takes a third parameter.

The reason for handling struct bootparams in the bootloader was that the
EFI stub could only load initrd images from the EFI system partition,
and so passing it via struct bootparams was needed for loaders like
GRUB, which pass the initrd in memory, and may load it from anywhere,
including from the network. Another motivation was EFI mixed mode, which
could not use the initrd loader in the EFI stub at all due to 32/64 bit
incompatibilities (which will be fixed shortly [0]), and could not
invoke the ordinary PE/COFF entry point either, for the same reasons.

Given that loaders such as GRUB already carried the bootparams handling
in order to implement non-EFI boot, retaining that code and just passing
bootparams to the EFI stub was a reasonable choice (although defining an
alternate entrypoint could have been avoided.) However, the GRUB side
changes never made it upstream, and are only shipped by some of the
distros in their downstream versions.

In the meantime, EFI support has been added to other Linux architecture
ports, as well as to U-boot and systemd, including arch-agnostic methods
for passing initrd images in memory [1], and for doing mixed mode boot
[2], none of them requiring anything like the EFI handover protocol. So
given that only out-of-tree distro GRUB relies on this, let's permit it
to be omitted from the build, in preparation for retiring it completely
at a later date. (Note that systemd-boot does have an implementation as
well, but only uses it as a fallback for booting images that do not
implement the LoadFile2 based initrd loading method, i.e., v5.8 or older)

[0] https://lore.kernel.org/all/20220927085842.2860715-1-ardb@kernel.org/
[1] ec93fc371f01 ("efi/libstub: Add support for loading the initrd from a device path")
[2] 97aa276579b2 ("efi/x86: Add true mixed mode entry point into .compat section")

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-18-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig                   |   17 +++++++++++++++++
 arch/x86/boot/compressed/head_64.S |    4 +++-
 arch/x86/boot/header.S             |    2 +-
 arch/x86/boot/tools/build.c        |    2 ++
 4 files changed, 23 insertions(+), 2 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1982,6 +1982,23 @@ config EFI_STUB
 
 	  See Documentation/admin-guide/efi-stub.rst for more information.
 
+config EFI_HANDOVER_PROTOCOL
+	bool "EFI handover protocol (DEPRECATED)"
+	depends on EFI_STUB
+	default y
+	help
+	  Select this in order to include support for the deprecated EFI
+	  handover protocol, which defines alternative entry points into the
+	  EFI stub.  This is a practice that has no basis in the UEFI
+	  specification, and requires a priori knowledge on the part of the
+	  bootloader about Linux/x86 specific ways of passing the command line
+	  and initrd, and where in memory those assets may be loaded.
+
+	  If in doubt, say Y. Even though the corresponding support is not
+	  present in upstream GRUB or other bootloaders, most distros build
+	  GRUB with numerous downstream patches applied, and may rely on the
+	  handover protocol as as result.
+
 config EFI_MIXED
 	bool "EFI mixed-mode support"
 	depends on EFI_STUB && X86_64
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -286,7 +286,7 @@ SYM_FUNC_START(startup_32)
 	lret
 SYM_FUNC_END(startup_32)
 
-#ifdef CONFIG_EFI_MIXED
+#if IS_ENABLED(CONFIG_EFI_MIXED) && IS_ENABLED(CONFIG_EFI_HANDOVER_PROTOCOL)
 	.org 0x190
 SYM_FUNC_START(efi32_stub_entry)
 	add	$0x4, %esp		/* Discard return address */
@@ -535,7 +535,9 @@ trampoline_return:
 SYM_CODE_END(startup_64)
 
 #ifdef CONFIG_EFI_STUB
+#ifdef CONFIG_EFI_HANDOVER_PROTOCOL
 	.org 0x390
+#endif
 SYM_FUNC_START(efi64_stub_entry)
 	and	$~0xf, %rsp			/* realign the stack */
 	movq	%rdx, %rbx			/* save boot_params pointer */
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -406,7 +406,7 @@ xloadflags:
 # define XLF1 0
 #endif
 
-#ifdef CONFIG_EFI_STUB
+#ifdef CONFIG_EFI_HANDOVER_PROTOCOL
 # ifdef CONFIG_EFI_MIXED
 #  define XLF23 (XLF_EFI_HANDOVER_32|XLF_EFI_HANDOVER_64)
 # else
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -290,6 +290,7 @@ static void efi_stub_entry_update(void)
 {
 	unsigned long addr = efi32_stub_entry;
 
+#ifdef CONFIG_EFI_HANDOVER_PROTOCOL
 #ifdef CONFIG_X86_64
 	/* Yes, this is really how we defined it :( */
 	addr = efi64_stub_entry - 0x200;
@@ -299,6 +300,7 @@ static void efi_stub_entry_update(void)
 	if (efi32_stub_entry != addr)
 		die("32-bit and 64-bit EFI entry points do not match\n");
 #endif
+#endif
 	put_unaligned_le32(addr, &buf[0x264]);
 }
 


