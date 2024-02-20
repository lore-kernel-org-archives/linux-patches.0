Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BDC14F9DA;
	Tue, 20 Feb 2024 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464357; cv=none; b=OS/doQvdgjcyPgXT76yua4MeO67GrHFNn+yr6FF1km6umMo1L9huQuImRSlcr/DJTJZwu5W6D5wlm7hbYYIwLT9pF1Q3nsSWDW7Mrs5bBTl1Ot12NzaIIT9mv4VtZaqoqrfNVYZOpodR89PtkxbWiDglUZfoIODx+gabua9zjSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464357; c=relaxed/simple;
	bh=KAZWilAryTVdr3Pk+eZ/Y+JM9HDXwPa5keSehLCfyKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKaeyTHn91vCWrFhzpHSGM10AfzF9bgFZ05fLUUz6jnfQUbtR+x8OrQ/W9MlCbhtrURYcyS6AZP8bST9+fAbYdWkTQeKWPnbkwbMlL1CP9m1ZoQ537DPa+ZMhTz1TxlaTdmp7jeWmrzGxtCT5t1OZ+QhVAzjQJtPNbqXB3AemTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNrgEYgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNrgEYgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CD9C433F1;
	Tue, 20 Feb 2024 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464356;
	bh=KAZWilAryTVdr3Pk+eZ/Y+JM9HDXwPa5keSehLCfyKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNrgEYgHQsAbyGns0mo5UOT8RY7LQG2BxNT6jEI6hnfCa/ASU+SAWSPqmXgCCw0us
	 gR2BoBeYbbTUdpY6Xa7HplXhVG3Ymgfg9ME8NhOmSOUhdf/u+jlvfeq/3XtUkaw1Z6
	 6L2LkODhGhsnPgyO6xcQMPC6touc+fC2Z689a1hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Beaton <mjsbeaton@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 331/331] x86/efistub: Use 1:1 file:memory mapping for PE/COFF .compat section
Date: Tue, 20 Feb 2024 21:57:27 +0100
Message-ID: <20240220205648.652098439@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 1ad55cecf22f05f1c884adf63cc09d3c3e609ebf upstream.

The .compat section is a dummy PE section that contains the address of
the 32-bit entrypoint of the 64-bit kernel image if it is bootable from
32-bit firmware (i.e., CONFIG_EFI_MIXED=y)

This section is only 8 bytes in size and is only referenced from the
loader, and so it is placed at the end of the memory view of the image,
to avoid the need for padding it to 4k, which is required for sections
appearing in the middle of the image.

Unfortunately, this violates the PE/COFF spec, and even if most EFI
loaders will work correctly (including the Tianocore reference
implementation), PE loaders do exist that reject such images, on the
basis that both the file and memory views of the file contents should be
described by the section headers in a monotonically increasing manner
without leaving any gaps.

So reorganize the sections to avoid this issue. This results in a slight
padding overhead (< 4k) which can be avoided if desired by disabling
CONFIG_EFI_MIXED (which is only needed in rare cases these days)

Fixes: 3e3eabe26dc8 ("x86/boot: Increase section and file alignment to 4k/512")
Reported-by: Mike Beaton <mjsbeaton@gmail.com>
Link: https://lkml.kernel.org/r/CAHzAAWQ6srV6LVNdmfbJhOwhBw5ZzxxZZ07aHt9oKkfYAdvuQQ%40mail.gmail.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S |   14 ++++++--------
 arch/x86/boot/setup.ld |    6 +++---
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -106,8 +106,7 @@ extra_header_fields:
 	.word	0				# MinorSubsystemVersion
 	.long	0				# Win32VersionValue
 
-	.long	setup_size + ZO__end + pecompat_vsize
-						# SizeOfImage
+	.long	setup_size + ZO__end		# SizeOfImage
 
 	.long	salign				# SizeOfHeaders
 	.long	0				# CheckSum
@@ -143,7 +142,7 @@ section_table:
 	.ascii	".setup"
 	.byte	0
 	.byte	0
-	.long	setup_size - salign 		# VirtualSize
+	.long	pecompat_fstart - salign 	# VirtualSize
 	.long	salign				# VirtualAddress
 	.long	pecompat_fstart - salign	# SizeOfRawData
 	.long	salign				# PointerToRawData
@@ -156,8 +155,8 @@ section_table:
 #ifdef CONFIG_EFI_MIXED
 	.asciz	".compat"
 
-	.long	8				# VirtualSize
-	.long	setup_size + ZO__end		# VirtualAddress
+	.long	pecompat_fsize			# VirtualSize
+	.long	pecompat_fstart			# VirtualAddress
 	.long	pecompat_fsize			# SizeOfRawData
 	.long	pecompat_fstart			# PointerToRawData
 
@@ -172,17 +171,16 @@ section_table:
 	 * modes this image supports.
 	 */
 	.pushsection ".pecompat", "a", @progbits
-	.balign	falign
-	.set	pecompat_vsize, salign
+	.balign	salign
 	.globl	pecompat_fstart
 pecompat_fstart:
 	.byte	0x1				# Version
 	.byte	8				# Size
 	.word	IMAGE_FILE_MACHINE_I386		# PE machine type
 	.long	setup_size + ZO_efi32_pe_entry	# Entrypoint
+	.byte	0x0				# Sentinel
 	.popsection
 #else
-	.set	pecompat_vsize, 0
 	.set	pecompat_fstart, setup_size
 #endif
 	.ascii	".text"
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -24,6 +24,9 @@ SECTIONS
 	.text		: { *(.text .text.*) }
 	.text32		: { *(.text32) }
 
+	.pecompat	: { *(.pecompat) }
+	PROVIDE(pecompat_fsize = setup_size - pecompat_fstart);
+
 	. = ALIGN(16);
 	.rodata		: { *(.rodata*) }
 
@@ -36,9 +39,6 @@ SECTIONS
 	. = ALIGN(16);
 	.data		: { *(.data*) }
 
-	.pecompat	: { *(.pecompat) }
-	PROVIDE(pecompat_fsize = setup_size - pecompat_fstart);
-
 	.signature	: {
 		setup_sig = .;
 		LONG(0x5a5aaa55)


