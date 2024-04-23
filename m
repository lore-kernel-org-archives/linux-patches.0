Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF621420BE;
	Tue, 23 Apr 2024 21:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908697; cv=none; b=l0hNf0AulEM7JVmrXr14kpHKoewpnxNbN9edcy5VIFl90FQM3j0mosDaHA2OSaMchAZOfHlNwRVaJ3SQ5w6j1j+HrKSPM7Nh4WVurPcRXNuO6IezveKBQ20noH3IIy1N4F7Xzcj/yZlbDlKBZMsHPtKocSuFvsK2xjkswHAZSZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908697; c=relaxed/simple;
	bh=RFf1ZnnsANlf+ITGLZrd7AUnXmyFQw3AizD+mqzCAzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptPrcGXsSzVICx3dEO8e3p3u6/CJWN8JrPNYRdqXPAxQ3a+weTnfXieyPB7xrqH5e8W2LQvftepDJaGPvjYcobV0k0H2Z58ukPZCTM/8kjl4S+hMm1c8+TFF2EBOpmCXy/Ij9A2eqlW8kWiFgzZAVzI0LKQN/rNVqKPgNtzl04A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yU1tJA8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yU1tJA8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127BCC116B1;
	Tue, 23 Apr 2024 21:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908697;
	bh=RFf1ZnnsANlf+ITGLZrd7AUnXmyFQw3AizD+mqzCAzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yU1tJA8LUyy7HvZc0h58sTCwrZgaDsG3iq0D5XN8VPd/HIV/zaNk6ZlhF2NAsMXAt
	 0TjRPcFXY/umIIwLYknKR8P8Asx+K0PsvoteaB2DrpPUZ8ZPKdTMT/ehd6IDxdTC29
	 F2PmyB08SNDg9h4GdD2RDd2M2ERITz/BWLsKvIIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 023/141] x86/boot: Construct PE/COFF .text section from assembler
Date: Tue, 23 Apr 2024 14:38:11 -0700
Message-ID: <20240423213854.078917417@linuxfoundation.org>
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

[ Commit efa089e63b56bdc5eca754b995cb039dd7a5457e upstream ]

Now that the size of the setup block is visible to the assembler, it is
possible to populate the PE/COFF header fields from the asm code
directly, instead of poking the values into the binary using the build
tool. This will make it easier to reorganize the section layout without
having to tweak the build tool in lockstep.

This change has no impact on the resulting bzImage binary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230915171623.655440-15-ardb@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S      |   22 ++++++--------------
 arch/x86/boot/tools/build.c |   47 --------------------------------------------
 2 files changed, 7 insertions(+), 62 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -74,14 +74,12 @@ optional_header:
 	.byte	0x02				# MajorLinkerVersion
 	.byte	0x14				# MinorLinkerVersion
 
-	# Filled in by build.c
-	.long	0				# SizeOfCode
+	.long	setup_size + ZO__end - 0x200	# SizeOfCode
 
 	.long	0				# SizeOfInitializedData
 	.long	0				# SizeOfUninitializedData
 
-	# Filled in by build.c
-	.long	0x0000				# AddressOfEntryPoint
+	.long	setup_size + ZO_efi_pe_entry	# AddressOfEntryPoint
 
 	.long	0x0200				# BaseOfCode
 #ifdef CONFIG_X86_32
@@ -104,10 +102,7 @@ extra_header_fields:
 	.word	0				# MinorSubsystemVersion
 	.long	0				# Win32VersionValue
 
-	#
-	# The size of the bzImage is written in tools/build.c
-	#
-	.long	0				# SizeOfImage
+	.long	setup_size + ZO__end 		# SizeOfImage
 
 	.long	0x200				# SizeOfHeaders
 	.long	0				# CheckSum
@@ -198,18 +193,15 @@ section_table:
 		IMAGE_SCN_MEM_DISCARDABLE	# Characteristics
 #endif
 
-	#
-	# The offset & size fields are filled in by build.c.
-	#
 	.ascii	".text"
 	.byte	0
 	.byte	0
 	.byte	0
-	.long	0
-	.long	0x0				# startup_{32,64}
-	.long	0				# Size of initialized data
+	.long	ZO__end
+	.long	setup_size
+	.long	ZO__edata			# Size of initialized data
 						# on disk
-	.long	0x0				# startup_{32,64}
+	.long	setup_size
 	.long	0				# PointerToRelocations
 	.long	0				# PointerToLineNumbers
 	.word	0				# NumberOfRelocations
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -50,10 +50,8 @@ u8 buf[SETUP_SECT_MAX*512];
 #define PECOFF_RELOC_RESERVE 0x20
 #define PECOFF_COMPAT_RESERVE 0x20
 
-static unsigned long efi_pe_entry;
 static unsigned long efi32_pe_entry;
 static unsigned long _edata;
-static unsigned long _end;
 
 /*----------------------------------------------------------------------*/
 
@@ -216,32 +214,6 @@ static void update_pecoff_setup_and_relo
 #endif
 }
 
-static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
-{
-	unsigned int pe_header;
-	unsigned int text_sz = file_sz - text_start;
-	unsigned int bss_sz = _end - text_sz;
-
-	pe_header = get_unaligned_le32(&buf[0x3c]);
-
-	/*
-	 * Size of code: Subtract the size of the first sector (512 bytes)
-	 * which includes the header.
-	 */
-	put_unaligned_le32(file_sz - 512 + bss_sz, &buf[pe_header + 0x1c]);
-
-	/* Size of image */
-	put_unaligned_le32(file_sz + bss_sz, &buf[pe_header + 0x50]);
-
-	/*
-	 * Address of entry point for PE/COFF executable
-	 */
-	put_unaligned_le32(text_start + efi_pe_entry, &buf[pe_header + 0x28]);
-
-	update_pecoff_section_header_fields(".text", text_start, text_sz + bss_sz,
-					    text_sz, text_start);
-}
-
 static int reserve_pecoff_reloc_section(int c)
 {
 	/* Reserve 0x20 bytes for .reloc section */
@@ -249,22 +221,9 @@ static int reserve_pecoff_reloc_section(
 	return PECOFF_RELOC_RESERVE;
 }
 
-static void efi_stub_defaults(void)
-{
-	/* Defaults for old kernel */
-#ifdef CONFIG_X86_32
-	efi_pe_entry = 0x10;
-#else
-	efi_pe_entry = 0x210;
-#endif
-}
-
 #else
 
 static inline void update_pecoff_setup_and_reloc(unsigned int size) {}
-static inline void update_pecoff_text(unsigned int text_start,
-				      unsigned int file_sz) {}
-static inline void efi_stub_defaults(void) {}
 
 static inline int reserve_pecoff_reloc_section(int c)
 {
@@ -307,10 +266,8 @@ static void parse_zoffset(char *fname)
 	p = (char *)buf;
 
 	while (p && *p) {
-		PARSE_ZOFS(p, efi_pe_entry);
 		PARSE_ZOFS(p, efi32_pe_entry);
 		PARSE_ZOFS(p, _edata);
-		PARSE_ZOFS(p, _end);
 
 		p = strchr(p, '\n');
 		while (p && (*p == '\r' || *p == '\n'))
@@ -328,8 +285,6 @@ int main(int argc, char ** argv)
 	void *kernel;
 	u32 crc = 0xffffffffUL;
 
-	efi_stub_defaults();
-
 	if (argc != 5)
 		usage();
 	parse_zoffset(argv[3]);
@@ -376,8 +331,6 @@ int main(int argc, char ** argv)
 	kernel = mmap(NULL, sz, PROT_READ, MAP_SHARED, fd, 0);
 	if (kernel == MAP_FAILED)
 		die("Unable to mmap '%s': %m", argv[2]);
-	update_pecoff_text(setup_sectors * 512, i + _edata);
-
 
 	crc = partial_crc32(buf, i, crc);
 	if (fwrite(buf, 1, i, dest) != i)


