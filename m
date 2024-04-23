Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E1F146D73;
	Tue, 23 Apr 2024 21:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908691; cv=none; b=dabrfB07pL4qld4wxNtgBsUgidgdckHPJzEU9gkLkmVdLpDvMHZZBWQA1GlrxKk31YyEr3hbVHg+X8XdKPvYH4PrntH1gNaiW2dVafnxrjj/QbW2UDpjVgqpc8B+ciVw9xeHBeo4vA5fThP0edtCTZXQjsfIDXjDIOi9V3nwDQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908691; c=relaxed/simple;
	bh=9XOX0/q6BZOe9rNbkGQD5yiUkprZCI2RxCFiwuKESkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjISFgNKJBXG3Yb57xZGMNI9Mdvl0n2kMcbmHAPP0D8SfpzF32h4JEE3qG7POCNhiFV+c0Lv6de0M8Rx3wPLjOlAdgEbAN7EzD/I90ADg6Zzx3Msixn98ufKSTnCIfEL+V891R27B+jdX1bP5x4wh13+jDbx6MJShcX+H/zSBmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcxL1amx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcxL1amx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8B8C116B1;
	Tue, 23 Apr 2024 21:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908691;
	bh=9XOX0/q6BZOe9rNbkGQD5yiUkprZCI2RxCFiwuKESkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcxL1amxHWEvSka7AuIJs54jVu8CW+a8T9kbgTpTr0oi5s/1g9ztSsPHH7BvDg0ea
	 Jr+5RqpQKHAElKPI2bf8mSV+AftNJ6CHtQD2JrVp93nME/Bhq3mZVQn1gBh6spdbu9
	 g0/OUGyvsSgwNGOhBy3sFNsy5PZuqDr8HhED2kkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 022/141] x86/boot: Derive file size from _edata symbol
Date: Tue, 23 Apr 2024 14:38:10 -0700
Message-ID: <20240423213854.042834225@linuxfoundation.org>
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

[ Commit aeb92067f6ae994b541d7f9752fe54ed3d108bcc upstream ]

Tweak the linker script so that the value of _edata represents the
decompressor binary's file size rounded up to the appropriate alignment.
This removes the need to calculate it in the build tool, and will make
it easier to refer to the file size from the header directly in
subsequent changes to the PE header layout.

While adding _edata to the sed regex that parses the compressed
vmlinux's symbol list, tweak the regex a bit for conciseness.

This change has no impact on the resulting bzImage binary when
configured with CONFIG_EFI_STUB=y.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230915171623.655440-14-ardb@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/Makefile                 |    2 +-
 arch/x86/boot/compressed/vmlinux.lds.S |    3 +++
 arch/x86/boot/header.S                 |    2 +-
 arch/x86/boot/tools/build.c            |   30 +++++++-----------------------
 4 files changed, 12 insertions(+), 25 deletions(-)

--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -91,7 +91,7 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vm
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [a-zA-Z] \(startup_32\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|efi32_pe_entry\|input_data\|kernel_info\|_end\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [a-zA-Z] \(startup_32\|efi.._stub_entry\|efi\(32\)\?_pe_entry\|input_data\|kernel_info\|_end\|_ehead\|_text\|_edata\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -46,6 +46,9 @@ SECTIONS
 		_data = . ;
 		*(.data)
 		*(.data.*)
+
+		/* Add 4 bytes of extra space for a CRC-32 checksum */
+		. = ALIGN(. + 4, 0x20);
 		_edata = . ;
 	}
 	. = ALIGN(L1_CACHE_BYTES);
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -232,7 +232,7 @@ sentinel:	.byte 0xff, 0xff        /* Use
 hdr:
 		.byte setup_sects - 1
 root_flags:	.word ROOT_RDONLY
-syssize:	.long 0			/* Filled in by build.c */
+syssize:	.long ZO__edata / 16
 ram_size:	.word 0			/* Obsolete */
 vid_mode:	.word SVGA_MODE
 root_dev:	.word 0			/* Default to major/minor 0/0 */
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -52,6 +52,7 @@ u8 buf[SETUP_SECT_MAX*512];
 
 static unsigned long efi_pe_entry;
 static unsigned long efi32_pe_entry;
+static unsigned long _edata;
 static unsigned long _end;
 
 /*----------------------------------------------------------------------*/
@@ -308,6 +309,7 @@ static void parse_zoffset(char *fname)
 	while (p && *p) {
 		PARSE_ZOFS(p, efi_pe_entry);
 		PARSE_ZOFS(p, efi32_pe_entry);
+		PARSE_ZOFS(p, _edata);
 		PARSE_ZOFS(p, _end);
 
 		p = strchr(p, '\n');
@@ -320,7 +322,6 @@ int main(int argc, char ** argv)
 {
 	unsigned int i, sz, setup_sectors;
 	int c;
-	u32 sys_size;
 	struct stat sb;
 	FILE *file, *dest;
 	int fd;
@@ -368,24 +369,14 @@ int main(int argc, char ** argv)
 		die("Unable to open `%s': %m", argv[2]);
 	if (fstat(fd, &sb))
 		die("Unable to stat `%s': %m", argv[2]);
-	sz = sb.st_size;
+	if (_edata != sb.st_size)
+		die("Unexpected file size `%s': %u != %u", argv[2], _edata,
+		    sb.st_size);
+	sz = _edata - 4;
 	kernel = mmap(NULL, sz, PROT_READ, MAP_SHARED, fd, 0);
 	if (kernel == MAP_FAILED)
 		die("Unable to mmap '%s': %m", argv[2]);
-	/* Number of 16-byte paragraphs, including space for a 4-byte CRC */
-	sys_size = (sz + 15 + 4) / 16;
-#ifdef CONFIG_EFI_STUB
-	/*
-	 * COFF requires minimum 32-byte alignment of sections, and
-	 * adding a signature is problematic without that alignment.
-	 */
-	sys_size = (sys_size + 1) & ~1;
-#endif
-
-	/* Patch the setup code with the appropriate size parameters */
-	put_unaligned_le32(sys_size, &buf[0x1f4]);
-
-	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16));
+	update_pecoff_text(setup_sectors * 512, i + _edata);
 
 
 	crc = partial_crc32(buf, i, crc);
@@ -397,13 +388,6 @@ int main(int argc, char ** argv)
 	if (fwrite(kernel, 1, sz, dest) != sz)
 		die("Writing kernel failed");
 
-	/* Add padding leaving 4 bytes for the checksum */
-	while (sz++ < (sys_size*16) - 4) {
-		crc = partial_crc32_one('\0', crc);
-		if (fwrite("\0", 1, 1, dest) != 1)
-			die("Writing padding failed");
-	}
-
 	/* Write the CRC */
 	put_unaligned_le32(crc, buf);
 	if (fwrite(buf, 1, 4, dest) != 4)


