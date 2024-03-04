Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4198179F2;
	Mon,  4 Mar 2024 21:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589065; cv=none; b=S0uX26GF1QgpyMQdARXmNTVItjwXnCFLonvH7MHh36FktaT+n55SR6728xTi+KNH/09MG/HxwjIXz7dQAPiW8KJ/xREXWdNRcVkSN0rY8eZgOB48cPZyDv+BoWtUZFqXZdOwSvvvvHJUmG813pM+bkGLZGu4KG9003DYZJbppow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589065; c=relaxed/simple;
	bh=626Wq1Tvdxq5pJBbE7bNJQydvLIr+yTC8eYygiDcsOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1Y6qdDCuyEqBl3YQMTd39VbeQbbIgWbHTXEt5pW0BS2R41HQM7kNESTNGf0RwBxSeMDyXMp6YefYqokHxWenNENLil4dnfoBNQEYgu8hVzCSxWdwLw/mYJGF6HZ4ci4/OvaeFuPGe3Pr0vi24ctS4qrOW11mHU+3fDTNtzLeDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLRqkCAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLRqkCAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F20C433C7;
	Mon,  4 Mar 2024 21:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589065;
	bh=626Wq1Tvdxq5pJBbE7bNJQydvLIr+yTC8eYygiDcsOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLRqkCAC/RaYgcub8C25rEkOZmmHIycHhM83EUjxwqnNVhy/ouCzEWxvnubGFYM3b
	 tv+cXAFxr3YUaHgZSxWT413HnMlw4QOc0sHTJYuu8aPPGpNV4qLPLAoh5Az2hWPKmF
	 rfJoYFTUGPqG3Sn2mIXW5FMA9AO4PKJOOPaGt2mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 188/215] x86/decompressor: Factor out kernel decompression and relocation
Date: Mon,  4 Mar 2024 21:24:11 +0000
Message-ID: <20240304211602.919862342@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb+git@google.com>

From: Ard Biesheuvel <ardb@kernel.org>

[ Commit 83381519352d6b5b3e429bf72aaab907480cb6b6 upstream ]

Factor out the decompressor sequence that invokes the decompressor,
parses the ELF and applies the relocations so that it can be called
directly from the EFI stub.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-21-ardb@kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/misc.c |   29 ++++++++++++++++++++++++-----
 arch/x86/include/asm/boot.h     |    8 ++++++++
 2 files changed, 32 insertions(+), 5 deletions(-)

--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -330,11 +330,33 @@ static size_t parse_elf(void *output)
 	return ehdr.e_entry - LOAD_PHYSICAL_ADDR;
 }
 
+const unsigned long kernel_total_size = VO__end - VO__text;
+
 static u8 boot_heap[BOOT_HEAP_SIZE] __aligned(4);
 
 extern unsigned char input_data[];
 extern unsigned int input_len, output_len;
 
+unsigned long decompress_kernel(unsigned char *outbuf, unsigned long virt_addr,
+				void (*error)(char *x))
+{
+	unsigned long entry;
+
+	if (!free_mem_ptr) {
+		free_mem_ptr     = (unsigned long)boot_heap;
+		free_mem_end_ptr = (unsigned long)boot_heap + sizeof(boot_heap);
+	}
+
+	if (__decompress(input_data, input_len, NULL, NULL, outbuf, output_len,
+			 NULL, error) < 0)
+		return ULONG_MAX;
+
+	entry = parse_elf(outbuf);
+	handle_relocations(outbuf, output_len, virt_addr);
+
+	return entry;
+}
+
 /*
  * The compressed kernel image (ZO), has been moved so that its position
  * is against the end of the buffer used to hold the uncompressed kernel
@@ -354,7 +376,6 @@ extern unsigned int input_len, output_le
  */
 asmlinkage __visible void *extract_kernel(void *rmode, unsigned char *output)
 {
-	const unsigned long kernel_total_size = VO__end - VO__text;
 	unsigned long virt_addr = LOAD_PHYSICAL_ADDR;
 	memptr heap = (memptr)boot_heap;
 	unsigned long needed_size;
@@ -457,10 +478,8 @@ asmlinkage __visible void *extract_kerne
 #endif
 
 	debug_putstr("\nDecompressing Linux... ");
-	__decompress(input_data, input_len, NULL, NULL, output, output_len,
-			NULL, error);
-	entry_offset = parse_elf(output);
-	handle_relocations(output, output_len, virt_addr);
+
+	entry_offset = decompress_kernel(output, virt_addr, error);
 
 	debug_putstr("done.\nBooting the kernel (entry_offset: 0x");
 	debug_puthex(entry_offset);
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -79,4 +79,12 @@
 # define BOOT_STACK_SIZE	0x1000
 #endif
 
+#ifndef __ASSEMBLY__
+extern unsigned int output_len;
+extern const unsigned long kernel_total_size;
+
+unsigned long decompress_kernel(unsigned char *outbuf, unsigned long virt_addr,
+				void (*error)(char *x));
+#endif
+
 #endif /* _ASM_X86_BOOT_H */


