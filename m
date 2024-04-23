Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BD91494D1;
	Tue, 23 Apr 2024 21:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908674; cv=none; b=MpHBOBZ5+8iUGCtWYCRf0JuOMFqK+qrv2RTpSnTf5O1qLWTTlHeRDHnkHQzKtIlNE/EXj7isu4wUUvxf7KzzxB4GQknr/wkZxOqXZP6a1p+tkZizNk1FwSaleYCWfRSpK7vnrTZuEgCiyTIQ+rdGmbI62ygOTcqHO8JnUonP26c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908674; c=relaxed/simple;
	bh=bedFAg8llQ+CksIALuKjrapGphII4OHfZOleKPBuVvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkXweQQYBvNeNjL7+r8+MIcSqlZe2EnsqpFipiudeF9sGGwLosjMR0FcMSUq5Qn/eK+o9sFO4gOgkAWjX6kWoQ4IhJVkQ9cH4Y0Hr4aCjTekUXBp9hReUY/B/fE3MZ/ze3yO1cxCfpkF2f6Xe/uZAgpq7GdK4D2cv4rcJAJrNgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbrxwkhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbrxwkhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AC9C116B1;
	Tue, 23 Apr 2024 21:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908674;
	bh=bedFAg8llQ+CksIALuKjrapGphII4OHfZOleKPBuVvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbrxwkhRgze5diJnXtCWIzohllYEpdEV+gHOBYi8sfr/ROv7VFJBMseVvhjCghhCm
	 wAejnb0CzqHPcbrJL6qU/lU1JzbGHKrk1EjGvmRS2Ft8mLflp/xvGrqFq/h1rDwni9
	 m7lTo2khXGFecaBJ8XyQjsA6BZDoN1B4ytGbB/Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>
Subject: [PATCH 6.1 015/141] x86/boot: Remove the bugger off message
Date: Tue, 23 Apr 2024 14:38:03 -0700
Message-ID: <20240423213853.835535793@linuxfoundation.org>
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

[ Commit 768171d7ebbce005210e1cf8456f043304805c15 upstream ]

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
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S |   49 -------------------------------------------------
 arch/x86/boot/setup.ld |    7 ++++---
 2 files changed, 4 insertions(+), 52 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -38,63 +38,14 @@ SYSSEG		= 0x1000		/* historical load add
 
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
 	.org	0x3c
 	#
 	# Offset to the PE header.
 	#
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


