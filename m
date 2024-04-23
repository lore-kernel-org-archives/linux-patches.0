Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7A41420BE;
	Tue, 23 Apr 2024 21:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908702; cv=none; b=jm/Mc+oSjrtVsNpNh1nkFdhwI2C8+qUWSlWbvQrrUeNEJiApCquURPvhEktuzslxDi4gXPi0viAlUOJ3cLxM8ilM+rwl20B73GRL4TTB8qbv9HH+9fdHc1gldlby0RCVYCJnVJx9tfo6SVGPot+Pr9wdOvuL6vjO2BGmJLp8XjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908702; c=relaxed/simple;
	bh=/6dCX7XcaNK5OeU3e97N+FmuLi43m9L8cQsXXGY+PF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCx9ApQV8LLZCiuLFDUibf6ZaQcRi/THnpNqtoie+65YTqKbfFxVy8s6ju4iDRjm8ZOLceMygFRZ4SNHOJJ2x8O4ZKuYf08wcpmimztRo49GTUVijPwWSjZJAGDAlquyjK0tTx8PoN4TT733fC3Q1JZMx5FEiZH2Jh0sjZJ16mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jM4AR2kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jM4AR2kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA630C3277B;
	Tue, 23 Apr 2024 21:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908701;
	bh=/6dCX7XcaNK5OeU3e97N+FmuLi43m9L8cQsXXGY+PF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jM4AR2kreu+n5izoc9UnVxfB4V93++zx3HJuOu/y2c1onyiiCQwdwFMcc204P7j6O
	 dZ7kItxkTHABbkKTzEcR+wdjbRkZuXBz7G7z2dNXLPu80z+Nh7QC29BDFcsUf4C9sG
	 yI/tWLZfWWbZj4C49zKjs0NtWESWjuT1MhdTxb74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 020/141] x86/boot: Set EFI handover offset directly in header asm
Date: Tue, 23 Apr 2024 14:38:08 -0700
Message-ID: <20240423213853.976656706@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

[ Commit eac956345f99dda3d68f4ae6cf7b494105e54780 upstream ]

The offsets of the EFI handover entrypoints are available to the
assembler when constructing the header, so there is no need to set them
from the build tool afterwards.

This change has no impact on the resulting bzImage binary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230915171623.655440-12-ardb@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S      |   18 +++++++++++++++++-
 arch/x86/boot/tools/build.c |   24 ------------------------
 2 files changed, 17 insertions(+), 25 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -523,8 +523,24 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR
 # define INIT_SIZE VO_INIT_SIZE
 #endif
 
+	.macro		__handover_offset
+#ifndef CONFIG_EFI_HANDOVER_PROTOCOL
+	.long		0
+#elif !defined(CONFIG_X86_64)
+	.long		ZO_efi32_stub_entry
+#else
+	/* Yes, this is really how we defined it :( */
+	.long		ZO_efi64_stub_entry - 0x200
+#ifdef CONFIG_EFI_MIXED
+	.if		ZO_efi32_stub_entry != ZO_efi64_stub_entry - 0x200
+	.error		"32-bit and 64-bit EFI entry points do not match"
+	.endif
+#endif
+#endif
+	.endm
+
 init_size:		.long INIT_SIZE		# kernel initialization size
-handover_offset:	.long 0			# Filled in by build.c
+handover_offset:	__handover_offset
 kernel_info_offset:	.long ZO_kernel_info
 
 # End of setup header #####################################################
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -55,8 +55,6 @@ u8 buf[SETUP_SECT_MAX*512];
 #define PECOFF_COMPAT_RESERVE 0x0
 #endif
 
-static unsigned long efi32_stub_entry;
-static unsigned long efi64_stub_entry;
 static unsigned long efi_pe_entry;
 static unsigned long efi32_pe_entry;
 static unsigned long _end;
@@ -265,31 +263,12 @@ static void efi_stub_defaults(void)
 #endif
 }
 
-static void efi_stub_entry_update(void)
-{
-	unsigned long addr = efi32_stub_entry;
-
-#ifdef CONFIG_EFI_HANDOVER_PROTOCOL
-#ifdef CONFIG_X86_64
-	/* Yes, this is really how we defined it :( */
-	addr = efi64_stub_entry - 0x200;
-#endif
-
-#ifdef CONFIG_EFI_MIXED
-	if (efi32_stub_entry != addr)
-		die("32-bit and 64-bit EFI entry points do not match\n");
-#endif
-#endif
-	put_unaligned_le32(addr, &buf[0x264]);
-}
-
 #else
 
 static inline void update_pecoff_setup_and_reloc(unsigned int size) {}
 static inline void update_pecoff_text(unsigned int text_start,
 				      unsigned int file_sz) {}
 static inline void efi_stub_defaults(void) {}
-static inline void efi_stub_entry_update(void) {}
 
 static inline int reserve_pecoff_reloc_section(int c)
 {
@@ -332,8 +311,6 @@ static void parse_zoffset(char *fname)
 	p = (char *)buf;
 
 	while (p && *p) {
-		PARSE_ZOFS(p, efi32_stub_entry);
-		PARSE_ZOFS(p, efi64_stub_entry);
 		PARSE_ZOFS(p, efi_pe_entry);
 		PARSE_ZOFS(p, efi32_pe_entry);
 		PARSE_ZOFS(p, _end);
@@ -416,7 +393,6 @@ int main(int argc, char ** argv)
 
 	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16));
 
-	efi_stub_entry_update();
 
 	crc = partial_crc32(buf, i, crc);
 	if (fwrite(buf, 1, i, dest) != i)


