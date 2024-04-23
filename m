Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74251420BE;
	Tue, 23 Apr 2024 21:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908698; cv=none; b=feoi9TJuhg8e2chMuio/451hTU94k/vG80RmoIGtaRThYP0ioZzJV8aOa5IlNu3/a6dSD4PhR7p1glsp/sfTzp7F7ypf4NGQksBpirX0E5dC9447PwdpiYWPWMy5ODIW4CmavMswif6lZujxiflyQDYIA7fs7b4idEzea3gXUyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908698; c=relaxed/simple;
	bh=9U+M2VN7kKZIxQ6Xe4nFHWo7aD+Jw56i3Wcrb5G0D8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqKpMlQ2OCD06QQmYkAZB6aDJWZD37ACguiuhrWNR0GTAt+ZfwSLYqZVDqIsGSmbMbwMl5weCXvQ2B1daVPiYQ6R2tcOY+vDSjTstk2YWCT7s+D6k6QWmDsJ7HgL+pn0F7U5b9PA5kN3/fhxQRN9+JHONixnTgNTrbhiDOqm0Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkhg0ywP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkhg0ywP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB13EC3277B;
	Tue, 23 Apr 2024 21:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908697;
	bh=9U+M2VN7kKZIxQ6Xe4nFHWo7aD+Jw56i3Wcrb5G0D8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkhg0ywPtcPJZY10pq0ttuNKaSR7GX3lyEx+85jPxh/dLU+90cznEcf7jMKMHeNTa
	 irg9aQGS0WbqMWQklQTj/4rNghFWtPLlHgnQ6H7BTiph9TVQMJkF9tl2u+hgQbu3UG
	 35xW5joj87U4qc4rGK1cKBD4sipq+2zfmNhigS8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 024/141] x86/boot: Drop PE/COFF .reloc section
Date: Tue, 23 Apr 2024 14:38:12 -0700
Message-ID: <20240423213854.110855725@linuxfoundation.org>
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

[ Commit fa5750521e0a4efbc1af05223da9c4bbd6c21c83 upstream ]

Ancient buggy EFI loaders may have required a .reloc section to be
present at some point in time, but this has not been true for a long
time so the .reloc section can just be dropped.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230915171623.655440-16-ardb@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S      |   20 --------------------
 arch/x86/boot/setup.ld      |    4 ++--
 arch/x86/boot/tools/build.c |   34 +++++-----------------------------
 3 files changed, 7 insertions(+), 51 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -154,26 +154,6 @@ section_table:
 		IMAGE_SCN_MEM_READ		| \
 		IMAGE_SCN_MEM_EXECUTE		# Characteristics
 
-	#
-	# The EFI application loader requires a relocation section
-	# because EFI applications must be relocatable. The .reloc
-	# offset & size fields are filled in by build.c.
-	#
-	.ascii	".reloc"
-	.byte	0
-	.byte	0
-	.long	0
-	.long	0
-	.long	0				# SizeOfRawData
-	.long	0				# PointerToRawData
-	.long	0				# PointerToRelocations
-	.long	0				# PointerToLineNumbers
-	.word	0				# NumberOfRelocations
-	.word	0				# NumberOfLineNumbers
-	.long	IMAGE_SCN_CNT_INITIALIZED_DATA	| \
-		IMAGE_SCN_MEM_READ		| \
-		IMAGE_SCN_MEM_DISCARDABLE	# Characteristics
-
 #ifdef CONFIG_EFI_MIXED
 	#
 	# The offset & size fields are filled in by build.c.
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -40,8 +40,8 @@ SECTIONS
 		setup_sig = .;
 		LONG(0x5a5aaa55)
 
-		/* Reserve some extra space for the reloc and compat sections */
-		setup_size = ALIGN(ABSOLUTE(.) + 64, 512);
+		/* Reserve some extra space for the compat section */
+		setup_size = ALIGN(ABSOLUTE(.) + 32, 512);
 		setup_sects = ABSOLUTE(setup_size / 512);
 	}
 
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -47,7 +47,6 @@ typedef unsigned int   u32;
 /* This must be large enough to hold the entire setup */
 u8 buf[SETUP_SECT_MAX*512];
 
-#define PECOFF_RELOC_RESERVE 0x20
 #define PECOFF_COMPAT_RESERVE 0x20
 
 static unsigned long efi32_pe_entry;
@@ -180,24 +179,13 @@ static void update_pecoff_section_header
 	update_pecoff_section_header_fields(section_name, offset, size, size, offset);
 }
 
-static void update_pecoff_setup_and_reloc(unsigned int size)
+static void update_pecoff_setup(unsigned int size)
 {
 	u32 setup_offset = 0x200;
-	u32 reloc_offset = size - PECOFF_RELOC_RESERVE - PECOFF_COMPAT_RESERVE;
-#ifdef CONFIG_EFI_MIXED
-	u32 compat_offset = reloc_offset + PECOFF_RELOC_RESERVE;
-#endif
-	u32 setup_size = reloc_offset - setup_offset;
+	u32 compat_offset = size - PECOFF_COMPAT_RESERVE;
+	u32 setup_size = compat_offset - setup_offset;
 
 	update_pecoff_section_header(".setup", setup_offset, setup_size);
-	update_pecoff_section_header(".reloc", reloc_offset, PECOFF_RELOC_RESERVE);
-
-	/*
-	 * Modify .reloc section contents with a single entry. The
-	 * relocation is applied to offset 10 of the relocation section.
-	 */
-	put_unaligned_le32(reloc_offset + 10, &buf[reloc_offset]);
-	put_unaligned_le32(10, &buf[reloc_offset + 4]);
 
 #ifdef CONFIG_EFI_MIXED
 	update_pecoff_section_header(".compat", compat_offset, PECOFF_COMPAT_RESERVE);
@@ -214,21 +202,10 @@ static void update_pecoff_setup_and_relo
 #endif
 }
 
-static int reserve_pecoff_reloc_section(int c)
-{
-	/* Reserve 0x20 bytes for .reloc section */
-	memset(buf+c, 0, PECOFF_RELOC_RESERVE);
-	return PECOFF_RELOC_RESERVE;
-}
-
 #else
 
-static inline void update_pecoff_setup_and_reloc(unsigned int size) {}
+static inline void update_pecoff_setup(unsigned int size) {}
 
-static inline int reserve_pecoff_reloc_section(int c)
-{
-	return 0;
-}
 #endif /* CONFIG_EFI_STUB */
 
 static int reserve_pecoff_compat_section(int c)
@@ -307,7 +284,6 @@ int main(int argc, char ** argv)
 	fclose(file);
 
 	c += reserve_pecoff_compat_section(c);
-	c += reserve_pecoff_reloc_section(c);
 
 	/* Pad unused space with zeros */
 	setup_sectors = (c + 511) / 512;
@@ -316,7 +292,7 @@ int main(int argc, char ** argv)
 	i = setup_sectors*512;
 	memset(buf+c, 0, i-c);
 
-	update_pecoff_setup_and_reloc(i);
+	update_pecoff_setup(i);
 
 	/* Open and stat the kernel file */
 	fd = open(argv[2], O_RDONLY);


