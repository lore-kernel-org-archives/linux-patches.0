Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C5A3C36;
	Mon, 19 Feb 2024 23:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708384585; cv=none; b=MyFYzJSMDPDTodDDSfFoDntZ5x6FHguaiqhils2K1RPqrlaXL515lhN+qQUEaqn1C+++dd+uu6NQl3Fo5UN3r92YhXIq4B11AdbIQBp3/vUTXgsfL4a3XiADtbHLcMxY9X5PIuVa5y+i/9segO+jSuaWkBnZjl3GaQ+E8ufExNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708384585; c=relaxed/simple;
	bh=ASjtWw0IQtLFOtBU7WkX2iBN6Q62NEGXUjSWU2+64XQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFmKAkp6BrcpzvxoSK3qJaaRTjD8araj0ghcZCmcJxDLt5FrVfcd2muvL9fnpdwPLEJ+JVqRZ9P16TsAIbjJ9Tt/VxQbsqzSDzokUoBMFvTe+H+O1ojS8IkL487p4sWe0wv/zDTjKur+JHv3PPNT65cgD9x+CPa+vQapFoC3n5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bu5CHSnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bu5CHSnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF9AC433C7;
	Mon, 19 Feb 2024 23:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708384585;
	bh=ASjtWw0IQtLFOtBU7WkX2iBN6Q62NEGXUjSWU2+64XQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bu5CHSncWWQv7IF+uPPM7Exw90DUd+MqyEV8LwXg/R57oRNWulUcf/4qp7PWa3eSZ
	 HA1S7UjNlnOjAOWLixI+UBG427pEVlU0LTElXRUfWnu7o3t6X/RA3C6hCPM4a9us1i
	 MQiX5U9R4pO6MhGGqa1VkfGWiFZOQhGMq0Ek9hD4+cPVOCs6zQu2XpTxMIA6UpGVvP
	 PGQB5+C5yDyyH3PlHF+3GlsjKZ7xozitRa5C5nHqyOJlmVjShO4cyMVCLKL4LHnIAO
	 ZbYPSHB7vnhdSLVP4Z7+y0KmtMOUbhsV4+pUlFAB02vYygecwPS3CP3q7SYWH4iDzO
	 m0UgKSlDASwEQ==
Date: Mon, 19 Feb 2024 16:16:23 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
	svens@linux.ibm.com, morbo@google.com, justinstitt@google.com,
	linux-s390@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, Ulrich Weigand <ulrich.weigand@de.ibm.com>
Subject: Re: [PATCH] s390/boot: Add 'alloc' to info.bin .vmlinux.info section
 flags
Message-ID: <20240219231623.GA2565406@dev-arch.thelio-3990X>
References: <20240216-s390-fix-boot-with-llvm-objcopy-v1-1-0ac623daf42b@kernel.org>
 <20240219113248.16287-C-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219113248.16287-C-hca@linux.ibm.com>

Hi Heiko,

On Mon, Feb 19, 2024 at 12:32:48PM +0100, Heiko Carstens wrote:
> On Fri, Feb 16, 2024 at 12:55:53PM -0700, Nathan Chancellor wrote:
> > When attempting to boot a kernel compiled with OBJCOPY=llvm-objcopy,
> > there is a crash right at boot:
> > 
> >   Out of memory allocating 6d7800 bytes 8 aligned in range 0:20000000
> >   Reserved memory ranges:
> >   0000000000000000 a394c3c30d90cdaf DECOMPRESSOR
> >   Usable online memory ranges (info source: sclp read info [3]):
> >   0000000000000000 0000000020000000
> >   Usable online memory total: 20000000 Reserved: a394c3c30d90cdaf Free: 0
> >   Call Trace:
> >   (sp:0000000000033e90 [<0000000000012fbc>] physmem_alloc_top_down+0x5c/0x104)
> >    sp:0000000000033f00 [<0000000000011d56>] startup_kernel+0x3a6/0x77c
> >    sp:0000000000033f60 [<00000000000100f4>] startup_normal+0xd4/0xd4
> > 
> > GNU objcopy does not have any issues. Looking at differences between the
> > object files in each build reveals info.bin does not get properly
> > populated with llvm-objcopy, which results in an empty .vmlinux.info
> > section.
> ...
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1996
> > Link: https://github.com/llvm/llvm-project/commit/3c02cb7492fc78fb678264cebf57ff88e478e14f
> > Suggested-by: Ulrich Weigand <ulrich.weigand@de.ibm.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Thanks a lot, applied!
> 
> However when building the kernel with "LLVM=1" I can see

Thanks for testing, we are so close!

> something else which looks like an llvm-objdump bug to me:
> 
> $make LLVM=1 bzImage
> ...
>   SECTCMP .boot.data
> llvm-objdump: warning: section '.boot.data' mentioned in a -j/--section option, but not found in any input file
> 
> This works without warning with GNU objcopy, and actually the output
> is also different:
> 
> $ objdump -v
> GNU objdump (GNU Binutils for Ubuntu) 2.41
> 
> $ objdump -t -j .boot.data arch/s390/boot/vmlinux
> 
> arch/s390/boot/vmlinux:     file format elf64-s390
> 
> SYMBOL TABLE:
> 0000000000020000 l     O .boot.data     0000000000003000 sclp_info_sccb
> 00000000000240e0 l     O .boot.data     0000000000000001 sclp_info_sccb_valid
> 0000000000023010 g     O .boot.data     0000000000000008 ident_map_size
> 0000000000023018 g     O .boot.data     00000000000010c8 physmem_info
> 00000000000250e2 g       .boot.data     0000000000000000 __boot_data_end
> 0000000000020000 g       .boot.data     0000000000000000 __boot_data_start
> 00000000000240e2 g     O .boot.data     0000000000001000 early_command_line
> 0000000000023008 g     O .boot.data     0000000000000008 early_ipl_comp_list_size
> 0000000000023000 g     O .boot.data     0000000000000008 early_ipl_comp_list_addr
> 
> While with llvm-copy:
> 
> $ llvm-objdump --version
> LLVM (http://llvm.org/):
>   LLVM version 19.0.0git
> 
> $ llvm-objdump -t -j .boot.data arch/s390/boot/vmlinux
> 
> arch/s390/boot/vmlinux: file format elf64-s390
> 
> SYMBOL TABLE:
> 0000000000000200 l       .head.text     0000000000000000 ipl_start
> 0000000000010020 l       .head.text     00000000000000d4 startup_normal
> 00000000000101b0 l       .head.text     00000000000000b2 startup_kdump
> 0000000000010280 l       .head.text     000000000000005a startup_pgm_check_handler
> 000000000001025c l       .head.text     0000000000000000 startup_kdump_relocated
> 0000000000000000 l    df *ABS*  0000000000000000 als.c
> 000000000001e040 l     O .rodata        0000000000000018 als
> 000000000001f6f0 l     O .data  0000000000000050 print_missing_facilities.als_str
> 0000000000011800 l     F .text  00000000000000e2 print_machine_type
> ...
> 0000000000020000 l     O .boot.data     0000000000003000 sclp_info_sccb
> 00000000000240e0 l     O .boot.data     0000000000000001 sclp_info_sccb_valid
> ... and so on (everything is dumped)
> llvm-objdump: warning: section '.boot.data' mentioned in a -j/--section option, but not found in any input file
> 
> So somehow llvmdump's "-j/--section" option doesn not seem to work.

Re-reading Jordan's response to my initial report about this a couple of
years ago at https://github.com/ClangBuiltLinux/linux/issues/859, I
think I understand the issue now. '-j' / '--section' does work but not
for '-t'.  It works for '-h' and a couple of other flags:

https://github.com/llvm/llvm-project/blob/61a96e5afadd034e7d13126f0e43731bbad7ad89/llvm/test/tools/llvm-objdump/section-filter.test

and because '-t' does not work with '-j', there is a warning because the
'-j' argument values went unhandled:

https://github.com/llvm/llvm-project/blob/61a96e5afadd034e7d13126f0e43731bbad7ad89/llvm/tools/llvm-objdump/llvm-objdump.cpp#L485
https://github.com/llvm/llvm-project/blob/61a96e5afadd034e7d13126f0e43731bbad7ad89/llvm/tools/llvm-objdump/llvm-objdump.cpp#L3672

which is what Jordan's upstream report (https://llvm.org/pr50085) was
about fixing. However, it may not be too hard to fix '-t' to work with
'-j', I intend to take a look at it at some point this week.

However, since I am more of a kernel hacker than I am an LLVM one, I
came up with a potential solution in arch/s390/boot/Makefile, which is
basically just filtering the symbol table manually with grep... it
appears to produce stable results based on a small test Makefile I have
to make sure the output looks sane before running through sha256sum. I'd
be happy to send this as a formal patch if you'd accept it for full
LLVM=1 compatibility with LLVM 19.0.0+ and Linux 6.9+.

Cheers,
Nathan

diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index d40135efdec4..be3655825b4c 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -56,9 +56,9 @@ clean-files += vmlinux.map
 
 quiet_cmd_section_cmp = SECTCMP $*
 define cmd_section_cmp
-	s1=`$(OBJDUMP) -t -j "$*" "$<" | sort | \
+	s1=`$(OBJDUMP) -t "$<" | grep "\s$*\s\+" | sort | \
 		sed -n "/0000000000000000/! s/.*\s$*\s\+//p" | sha256sum`; \
-	s2=`$(OBJDUMP) -t -j "$*" "$(word 2,$^)" | sort | \
+	s2=`$(OBJDUMP) -t "$(word 2,$^)" | grep "\s$*\s\+" | sort | \
 		sed -n "/0000000000000000/! s/.*\s$*\s\+//p" | sha256sum`; \
 	if [ "$$s1" != "$$s2" ]; then \
 		echo "error: section $* differs between $< and $(word 2,$^)" >&2; \
