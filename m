Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B1A1EB5A;
	Mon,  4 Mar 2024 21:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588973; cv=none; b=CVe5MuGmuZCnZJd4UowsDDYeh/qYoxIDRbbv7Ge3JTP4/UAuoy05h0+uvaph3PSJ6wYH4kpekceQfWE8tdmlC2RE/pg6BJf+tLvRoJVUXjzLUwzI6rh3LPQYIG0i1QrNfpsUFthnDtsTjdswWBfIgFDa8+lz8cUaMq7yzxuwJ28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588973; c=relaxed/simple;
	bh=UFOkhs73GcUliKPV+efJqr4BoJa5t3z80OLs/b7RNN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+rI/09SBg2v1UB5djJf2AvsWR+4qWE2N+YTArdWoN2fTTLpN+LqF04v/ieD70LwNaNf5NFMhTqc9DgsfaLBMwkU3+BGQuYFuFh/uItkN/XiEL0yYHDXClAvJkJs/r7OrF9kWRLFX8icxDh1BOfmFoISZu64UJgxIUMEHC35VSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpKEJ0pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpKEJ0pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF728C433F1;
	Mon,  4 Mar 2024 21:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588973;
	bh=UFOkhs73GcUliKPV+efJqr4BoJa5t3z80OLs/b7RNN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpKEJ0pqCepVxlTAkY/m8M4r/IWVJO8IYOuaPurojgd5rzZPHZ6vgLRhChNXbwrvx
	 lMT8m6dpQBRN16MQL8aRXEzSo4+liLivbab/QOqWP6Mw6P1xDg4I11C0jwYicbRhav
	 mXOEShls5B4RE4yZ/sj0Lb+QzlarFU0w6kezpxZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 128/215] x86/boot: Robustify calling startup_{32,64}() from the decompressor code
Date: Mon,  4 Mar 2024 21:23:11 +0000
Message-ID: <20240304211601.130294874@linuxfoundation.org>
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

From: Alexander Lobakin <alexandr.lobakin@intel.com>

commit 7734a0f31e99c433df3063bbb7e8ee5a16a2cb82 upstream.

After commit ce697ccee1a8 ("kbuild: remove head-y syntax"), I
started digging whether x86 is ready for removing this old cruft.
Removing its objects from the list makes the kernel unbootable.
This applies only to bzImage, vmlinux still works correctly.
The reason is that with no strict object order determined by the
linker arguments, not the linker script, startup_64 can be placed
not right at the beginning of the kernel.
Here's vmlinux.map's beginning before removing:

  ffffffff81000000         vmlinux.o:(.head.text)
  ffffffff81000000                 startup_64
  ffffffff81000070                 secondary_startup_64
  ffffffff81000075                 secondary_startup_64_no_verify
  ffffffff81000160                 verify_cpu

and after:

  ffffffff81000000         vmlinux.o:(.head.text)
  ffffffff81000000                 pvh_start_xen
  ffffffff81000080                 startup_64
  ffffffff810000f0                 secondary_startup_64
  ffffffff810000f5                 secondary_startup_64_no_verify

Not a problem itself, but the self-extractor code has the address of
that function hardcoded the beginning, not looking onto the ELF
header, which always contains the address of startup_{32,64}().

So, instead of doing an "act of blind faith", just take the address
from the ELF header and extract a relative offset to the entry
point. The decompressor function already returns a pointer to the
beginning of the kernel to the Asm code, which then jumps to it,
so add that offset to the return value.
This doesn't change anything for now, but allows to resign from the
"head object list" for x86 and makes sure valid Kbuild or any other
improvements won't break anything here in general.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20230109170403.4117105-2-alexandr.lobakin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_32.S |    2 +-
 arch/x86/boot/compressed/head_64.S |    2 +-
 arch/x86/boot/compressed/misc.c    |   18 +++++++++++-------
 3 files changed, 13 insertions(+), 9 deletions(-)

--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -187,7 +187,7 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated
 	leal	boot_heap@GOTOFF(%ebx), %eax
 	pushl	%eax			/* heap area */
 	pushl	%esi			/* real mode pointer */
-	call	extract_kernel		/* returns kernel location in %eax */
+	call	extract_kernel		/* returns kernel entry point in %eax */
 	addl	$24, %esp
 
 /*
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -580,7 +580,7 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated
 	movl	input_len(%rip), %ecx	/* input_len */
 	movq	%rbp, %r8		/* output target address */
 	movl	output_len(%rip), %r9d	/* decompressed length, end of relocs */
-	call	extract_kernel		/* returns kernel location in %rax */
+	call	extract_kernel		/* returns kernel entry point in %rax */
 	popq	%rsi
 
 /*
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -277,7 +277,7 @@ static inline void handle_relocations(vo
 { }
 #endif
 
-static void parse_elf(void *output)
+static size_t parse_elf(void *output)
 {
 #ifdef CONFIG_X86_64
 	Elf64_Ehdr ehdr;
@@ -293,10 +293,8 @@ static void parse_elf(void *output)
 	if (ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
 	   ehdr.e_ident[EI_MAG1] != ELFMAG1 ||
 	   ehdr.e_ident[EI_MAG2] != ELFMAG2 ||
-	   ehdr.e_ident[EI_MAG3] != ELFMAG3) {
+	   ehdr.e_ident[EI_MAG3] != ELFMAG3)
 		error("Kernel is not a valid ELF file");
-		return;
-	}
 
 	debug_putstr("Parsing ELF... ");
 
@@ -328,6 +326,8 @@ static void parse_elf(void *output)
 	}
 
 	free(phdrs);
+
+	return ehdr.e_entry - LOAD_PHYSICAL_ADDR;
 }
 
 /*
@@ -356,6 +356,7 @@ asmlinkage __visible void *extract_kerne
 	const unsigned long kernel_total_size = VO__end - VO__text;
 	unsigned long virt_addr = LOAD_PHYSICAL_ADDR;
 	unsigned long needed_size;
+	size_t entry_offset;
 
 	/* Retain x86 boot parameters pointer passed from startup_32/64. */
 	boot_params = rmode;
@@ -456,14 +457,17 @@ asmlinkage __visible void *extract_kerne
 	debug_putstr("\nDecompressing Linux... ");
 	__decompress(input_data, input_len, NULL, NULL, output, output_len,
 			NULL, error);
-	parse_elf(output);
+	entry_offset = parse_elf(output);
 	handle_relocations(output, output_len, virt_addr);
-	debug_putstr("done.\nBooting the kernel.\n");
+
+	debug_putstr("done.\nBooting the kernel (entry_offset: 0x");
+	debug_puthex(entry_offset);
+	debug_putstr(").\n");
 
 	/* Disable exception handling before booting the kernel */
 	cleanup_exception_handling();
 
-	return output;
+	return output + entry_offset;
 }
 
 void fortify_panic(const char *name)


