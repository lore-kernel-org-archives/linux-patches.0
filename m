Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2D714A4E6;
	Tue, 20 Feb 2024 21:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464314; cv=none; b=ixrBqkcrZ83PCtKHRQ4W9ErQFXYMAxRFoxL2I+K6RUIKyDTZ4P/VIK1X2rIzGHxFmdjNnlAXvqUcm5Ky2E6LJTqlHV9RDzQBhl5WLOAytk79Lq66UYmE8XtZT64T0rUieVM5o10TztdSiU64y9H9446YkZzI180E+K/7jtJ4iCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464314; c=relaxed/simple;
	bh=NmfOsQ/IJncxfuSu2p2W1//S753amNl+Qzdcwgze/5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5XU0lRJ5z2/LDZlXM6QJ5dT8IA8ddcX422cwDi+++X7BJb+gh9PPkRVazDhpveNwk9zoueIYqlzJ4NRL/HmidpUimb/tz37+w++PXxXYFpvuIvCaRLV23/TABTeGSp4yLBq4hY5G8zyunciCkZvaZiiHRcdviLs/zfyCLYNxmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKKAxA3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKKAxA3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE527C433C7;
	Tue, 20 Feb 2024 21:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464314;
	bh=NmfOsQ/IJncxfuSu2p2W1//S753amNl+Qzdcwgze/5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKKAxA3ij3xu1XB6e7ltMNyoED9jKIRsY8mMJF4XnVPzc4cI+deznKXSgq6Uw/wzV
	 wbsXl+T2bkoShyK/MxYPZq+MeaTXFKx+9bTydAHrSxmQiWSoQXr9XvSRu6wIFnhm96
	 9djPu11sQOnIeAoI8AMTtzTP3BbJI0cYh/K6oV1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>
Subject: [PATCH 6.6 319/331] x86/boot: Remove the bugger off message
Date: Tue, 20 Feb 2024 21:57:15 +0100
Message-ID: <20240220205648.242683257@linuxfoundation.org>
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

commit 768171d7ebbce005210e1cf8456f043304805c15 upstream.

Ancient (pre-2003) x86 kernels could boot from a floppy disk straight from
the BIOS, using a small real mode boot stub at the start of the image
where the BIOS would expect the boot record (or boot block) to appear.

Due to its limitations (kernel size < 1 MiB, no support for IDE, USB or
El Torito floppy emulation), this support was dropped, and a Linux aware
bootloader is now always required to boot the kernel from a legacy BIOS.

To smoothen this transition, the boot stub was not removed entirely, but
replaced with one that just prints an error message telling the user to
install a bootloader.

As it is unlikely that anyone doing direct floppy boot with such an
ancient kernel is going to upgrade to v6.5+ and expect that this boot
method still works, printing this message is kind of pointless, and so
it should be possible to remove the logic that emits it.

Let's free up this space so it can be used to expand the PE header in a
subsequent patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Link: https://lore.kernel.org/r/20230912090051.4014114-21-ardb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S |   49 -------------------------------------------------
 arch/x86/boot/setup.ld |    7 ++++---
 2 files changed, 4 insertions(+), 52 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -38,64 +38,15 @@ SYSSEG		= 0x1000		/* historical load add
 
 	.code16
 	.section ".bstext", "ax"
-
-	.global bootsect_start
-bootsect_start:
 #ifdef CONFIG_EFI_STUB
 	# "MZ", MS-DOS header
 	.word	MZ_MAGIC
-#endif
-
-	# Normalize the start address
-	ljmp	$BOOTSEG, $start2
-
-start2:
-	movw	%cs, %ax
-	movw	%ax, %ds
-	movw	%ax, %es
-	movw	%ax, %ss
-	xorw	%sp, %sp
-	sti
-	cld
-
-	movw	$bugger_off_msg, %si
-
-msg_loop:
-	lodsb
-	andb	%al, %al
-	jz	bs_die
-	movb	$0xe, %ah
-	movw	$7, %bx
-	int	$0x10
-	jmp	msg_loop
-
-bs_die:
-	# Allow the user to press a key, then reboot
-	xorw	%ax, %ax
-	int	$0x16
-	int	$0x19
-
-	# int 0x19 should never return.  In case it does anyway,
-	# invoke the BIOS reset code...
-	ljmp	$0xf000,$0xfff0
-
-#ifdef CONFIG_EFI_STUB
 	.org	0x38
 	#
 	# Offset to the PE header.
 	#
 	.long	LINUX_PE_MAGIC
 	.long	pe_header
-#endif /* CONFIG_EFI_STUB */
-
-	.section ".bsdata", "a"
-bugger_off_msg:
-	.ascii	"Use a boot loader.\r\n"
-	.ascii	"\n"
-	.ascii	"Remove disk and press any key to reboot...\r\n"
-	.byte	0
-
-#ifdef CONFIG_EFI_STUB
 pe_header:
 	.long	PE_MAGIC
 
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -10,10 +10,11 @@ ENTRY(_start)
 SECTIONS
 {
 	. = 0;
-	.bstext		: { *(.bstext) }
-	.bsdata		: { *(.bsdata) }
+	.bstext	: {
+		*(.bstext)
+		. = 495;
+	} =0xffffffff
 
-	. = 495;
 	.header		: { *(.header) }
 	.entrytext	: { *(.entrytext) }
 	.inittext	: { *(.inittext) }


