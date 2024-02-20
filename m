Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDA314A4E6;
	Tue, 20 Feb 2024 21:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464317; cv=none; b=ZZr+F6bLgJTtMuV2+Nuj791fIE9U1R1DHamDybvUd2BMbsnIL26yCDC3zGIywHJL150O73D7obmeW3szpmRH0dbRn9XvjGxjFlnyBL05Mu2G0Qn9um4hmgjsox19ESnV1mPZe7AnowTbRad0dOVWXuwZ8SyzIUMhjWT2jRU6U6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464317; c=relaxed/simple;
	bh=oEKtrDfa3esrpaq+cmXwJuNftmdaZTL3BNPe6dMZTvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWLHeS8KsLUcEO5Vd2MuIWucB312jkzTuLaXpUG/U6pjAhToI+XiYYKepS0Wajqp9Iv8TWbYWdPx4SckaMvMV9WZawgwdjo3KDAH+HHJlv1GgTVJi+E/fHgWQUMoW9VmIxb5yFMutAJ/qAl4CE8hr4jcNrGFq5lbmmdj5UFPssQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMHREbu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMHREbu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2570AC433F1;
	Tue, 20 Feb 2024 21:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464317;
	bh=oEKtrDfa3esrpaq+cmXwJuNftmdaZTL3BNPe6dMZTvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMHREbu5QS6BJq4zLzsxY7CWVyAo/OKc8+ls2OLpSkxm3NNmk6F0HBmnkS6dmZfGm
	 02LOD6FiNXPDebDjVgF0UYXpmCw8W36vjoFBn2qJfPNxrrKwosu31WJO50nAs3I6WJ
	 tmBNBUerswxMLffJAuIbDmxdGQbTeN74yo2dta+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 320/331] x86/boot: Omit compression buffer from PE/COFF image memory footprint
Date: Tue, 20 Feb 2024 21:57:16 +0100
Message-ID: <20240220205648.280241556@linuxfoundation.org>
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

commit 8eace5b3555606e684739bef5bcdfcfe68235257 upstream.

Now that the EFI stub decompresses the kernel and hands over to the
decompressed image directly, there is no longer a need to provide a
decompression buffer as part of the .BSS allocation of the PE/COFF
image. It also means the PE/COFF image can be loaded anywhere in memory,
and setting the preferred image base is unnecessary. So drop the
handling of this from the header and from the build tool.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230912090051.4014114-22-ardb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S      |    6 +----
 arch/x86/boot/tools/build.c |   50 +++++---------------------------------------
 2 files changed, 8 insertions(+), 48 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -90,12 +90,10 @@ optional_header:
 #endif
 
 extra_header_fields:
-	# PE specification requires ImageBase to be 64k aligned
-	.set	image_base, (LOAD_PHYSICAL_ADDR + 0xffff) & ~0xffff
 #ifdef CONFIG_X86_32
-	.long	image_base			# ImageBase
+	.long	0				# ImageBase
 #else
-	.quad	image_base			# ImageBase
+	.quad	0				# ImageBase
 #endif
 	.long	0x20				# SectionAlignment
 	.long	0x20				# FileAlignment
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -65,7 +65,6 @@ static unsigned long efi_pe_entry;
 static unsigned long efi32_pe_entry;
 static unsigned long kernel_info;
 static unsigned long startup_64;
-static unsigned long _ehead;
 static unsigned long _end;
 
 /*----------------------------------------------------------------------*/
@@ -229,35 +228,22 @@ static void update_pecoff_setup_and_relo
 #endif
 }
 
-static void update_pecoff_text(unsigned int text_start, unsigned int file_sz,
-			       unsigned int init_sz)
+static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
 {
 	unsigned int pe_header;
 	unsigned int text_sz = file_sz - text_start;
-	unsigned int bss_sz = init_sz - file_sz;
+	unsigned int bss_sz = _end - text_sz;
 
 	pe_header = get_unaligned_le32(&buf[0x3c]);
 
 	/*
-	 * The PE/COFF loader may load the image at an address which is
-	 * misaligned with respect to the kernel_alignment field in the setup
-	 * header.
-	 *
-	 * In order to avoid relocating the kernel to correct the misalignment,
-	 * add slack to allow the buffer to be aligned within the declared size
-	 * of the image.
-	 */
-	bss_sz	+= CONFIG_PHYSICAL_ALIGN;
-	init_sz	+= CONFIG_PHYSICAL_ALIGN;
-
-	/*
 	 * Size of code: Subtract the size of the first sector (512 bytes)
 	 * which includes the header.
 	 */
 	put_unaligned_le32(file_sz - 512 + bss_sz, &buf[pe_header + 0x1c]);
 
 	/* Size of image */
-	put_unaligned_le32(init_sz, &buf[pe_header + 0x50]);
+	put_unaligned_le32(file_sz + bss_sz, &buf[pe_header + 0x50]);
 
 	/*
 	 * Address of entry point for PE/COFF executable
@@ -308,8 +294,7 @@ static void efi_stub_entry_update(void)
 
 static inline void update_pecoff_setup_and_reloc(unsigned int size) {}
 static inline void update_pecoff_text(unsigned int text_start,
-				      unsigned int file_sz,
-				      unsigned int init_sz) {}
+				      unsigned int file_sz) {}
 static inline void efi_stub_defaults(void) {}
 static inline void efi_stub_entry_update(void) {}
 
@@ -360,7 +345,6 @@ static void parse_zoffset(char *fname)
 		PARSE_ZOFS(p, efi32_pe_entry);
 		PARSE_ZOFS(p, kernel_info);
 		PARSE_ZOFS(p, startup_64);
-		PARSE_ZOFS(p, _ehead);
 		PARSE_ZOFS(p, _end);
 
 		p = strchr(p, '\n');
@@ -371,7 +355,7 @@ static void parse_zoffset(char *fname)
 
 int main(int argc, char ** argv)
 {
-	unsigned int i, sz, setup_sectors, init_sz;
+	unsigned int i, sz, setup_sectors;
 	int c;
 	u32 sys_size;
 	struct stat sb;
@@ -442,31 +426,9 @@ int main(int argc, char ** argv)
 	buf[0x1f1] = setup_sectors-1;
 	put_unaligned_le32(sys_size, &buf[0x1f4]);
 
-	init_sz = get_unaligned_le32(&buf[0x260]);
-#ifdef CONFIG_EFI_STUB
-	/*
-	 * The decompression buffer will start at ImageBase. When relocating
-	 * the compressed kernel to its end, we must ensure that the head
-	 * section does not get overwritten.  The head section occupies
-	 * [i, i + _ehead), and the destination is [init_sz - _end, init_sz).
-	 *
-	 * At present these should never overlap, because 'i' is at most 32k
-	 * because of SETUP_SECT_MAX, '_ehead' is less than 1k, and the
-	 * calculation of INIT_SIZE in boot/header.S ensures that
-	 * 'init_sz - _end' is at least 64k.
-	 *
-	 * For future-proofing, increase init_sz if necessary.
-	 */
-
-	if (init_sz - _end < i + _ehead) {
-		init_sz = (i + _ehead + _end + 4095) & ~4095;
-		put_unaligned_le32(init_sz, &buf[0x260]);
-	}
-#endif
-	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16), init_sz);
+	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16));
 
 	efi_stub_entry_update();
-
 	/* Update kernel_info offset. */
 	put_unaligned_le32(kernel_info, &buf[0x268]);
 


