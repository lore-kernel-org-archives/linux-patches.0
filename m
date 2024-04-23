Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595FD146A64;
	Tue, 23 Apr 2024 21:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908684; cv=none; b=Dskp7pY5hZePNN16UciBuyJrfxMBjTuN8/qiQf4NlqhohlyffgofcLYVBSpyMnHXQu7gc8XUz96BNzqZpfgE8497JxByw8aceOtYL6WdC2ssYxb4g9kJNW9TGN8ZRaPzgtv4JGlXaqgSYEpvaNBba2VQV9V7xdrERfshFqpXHQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908684; c=relaxed/simple;
	bh=HW3wc9c8453iBhyhmiyD72v5GVsdLPzgbLEA5Xs1n14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h484vs1V1BMA3SXZUrtLP1TJP7t5RO5HhkE23zz+hN1sEHGowOcEJC43Fx1UFsk9Fzf4s40Kq1IhmvoTaMiFKsbBzG/d3HrsmonWr+boKcfUSLtfwYXcITXT8Z0/sfM2z4HuAiBgtnENB3yEinFAtFBavWXthf1AXnzMgmbz7JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGaMYxCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGaMYxCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C838C116B1;
	Tue, 23 Apr 2024 21:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908684;
	bh=HW3wc9c8453iBhyhmiyD72v5GVsdLPzgbLEA5Xs1n14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGaMYxCghLxL8l8yW2cPHT5ZppC06OzQc8b94Gn4asWiynhAEjAT3oz3NWQ5NUTdR
	 NqFs4lOY5SH96onpVjUbGS9q5C1Tqd3p3u9kgOV+jp/2pnICrziN+6w6lnZK0pertL
	 RSU4+0/LAVJwdo6hLarFzDGT2270NJknIQWBrggI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 021/141] x86/boot: Define setup size in linker script
Date: Tue, 23 Apr 2024 14:38:09 -0700
Message-ID: <20240423213854.009698290@linuxfoundation.org>
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

[ Commit 093ab258e3fb1d1d3afdfd4a69403d44ce90e360 upstream ]

The setup block contains the real mode startup code that is used when
booting from a legacy BIOS, along with the boot_params/setup_data that
is used by legacy x86 bootloaders to pass the command line and initial
ramdisk parameters, among other things.

The setup block also contains the PE/COFF header of the entire combined
image, which includes the compressed kernel image, the decompressor and
the EFI stub.

This PE header describes the layout of the executable image in memory,
and currently, the fact that the setup block precedes it makes it rather
fiddly to get the right values into the right place in the final image.

Let's make things a bit easier by defining the setup_size in the linker
script so it can be referenced from the asm code directly, rather than
having to rely on the build tool to calculate it. For the time being,
add 64 bytes of fixed padding for the .reloc and .compat sections - this
will be removed in a subsequent patch after the PE/COFF header has been
reorganized.

This change has no impact on the resulting bzImage binary when
configured with CONFIG_EFI_MIXED=y.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230915171623.655440-13-ardb@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S      |    2 +-
 arch/x86/boot/setup.ld      |    4 ++++
 arch/x86/boot/tools/build.c |    6 ------
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -230,7 +230,7 @@ sentinel:	.byte 0xff, 0xff        /* Use
 
 	.globl	hdr
 hdr:
-setup_sects:	.byte 0			/* Filled in by build.c */
+		.byte setup_sects - 1
 root_flags:	.word ROOT_RDONLY
 syssize:	.long 0			/* Filled in by build.c */
 ram_size:	.word 0			/* Obsolete */
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -39,6 +39,10 @@ SECTIONS
 	.signature	: {
 		setup_sig = .;
 		LONG(0x5a5aaa55)
+
+		/* Reserve some extra space for the reloc and compat sections */
+		setup_size = ALIGN(ABSOLUTE(.) + 64, 512);
+		setup_sects = ABSOLUTE(setup_size / 512);
 	}
 
 
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -48,12 +48,7 @@ typedef unsigned int   u32;
 u8 buf[SETUP_SECT_MAX*512];
 
 #define PECOFF_RELOC_RESERVE 0x20
-
-#ifdef CONFIG_EFI_MIXED
 #define PECOFF_COMPAT_RESERVE 0x20
-#else
-#define PECOFF_COMPAT_RESERVE 0x0
-#endif
 
 static unsigned long efi_pe_entry;
 static unsigned long efi32_pe_entry;
@@ -388,7 +383,6 @@ int main(int argc, char ** argv)
 #endif
 
 	/* Patch the setup code with the appropriate size parameters */
-	buf[0x1f1] = setup_sectors-1;
 	put_unaligned_le32(sys_size, &buf[0x1f4]);
 
 	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16));


