Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCBE1494D1;
	Tue, 23 Apr 2024 21:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908672; cv=none; b=QEjiCW3bb17iaaiWfO+kAZfUQEornmWmrxXfTFCQ11h+X0oCHFkvjEeAcfjHkhEdrqP4uYfLvx24L/vLTSUfZC5kJR6H2zlg/6GPoyUMnRKL19M14u3yl4U1VyQ5A1FkD8dJlm4u/7gnkFDrbqznHb0ewRDjUSvVsMDjidEDzzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908672; c=relaxed/simple;
	bh=cm0h1YoBN/cR7KJQrxTby9NGn/WUgErE5mljhnpBzZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZfPMFLQvMqrMwcun1YZa9ElgwY5tzYm0OQRKONyFipBilctoNfB/e755Jh/m5+XUvlL74SNR/oQ12e3PjngvEY1A+9UYq0Ucd2VUsyfCKvYBOQXlvk/h4PR4EycwvTFIdSYyDaF3iX8OtLH2Y9ZLj978iqTiTkwNKWjb9iV7Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bZrzecY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bZrzecY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3B4C32782;
	Tue, 23 Apr 2024 21:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908671;
	bh=cm0h1YoBN/cR7KJQrxTby9NGn/WUgErE5mljhnpBzZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bZrzecYEH9oZvCmuht+diqVPoxIyIW0+bsCfn37M+z0992aWqTbZxudxP9cy9DBM
	 kwR4HvLkBU3vIw1TCjuHufCiUtiZvbU+owMsAhAbjyA8VL8EwjYBIFlckrzsnTYnfE
	 /Z1O012BT+eKRCLO1MW1pug1gfwPEzPZvwLXIgtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 011/141] x86/efi: Drop EFI stub .bss from .data section
Date: Tue, 23 Apr 2024 14:37:59 -0700
Message-ID: <20240423213853.722219408@linuxfoundation.org>
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

[ Commit 5f51c5d0e905608ba7be126737f7c84a793ae1aa upstream ]

Now that the EFI stub always zero inits its BSS section upon entry,
there is no longer a need to place the BSS symbols carried by the stub
into the .data section.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230912090051.4014114-18-ardb@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/vmlinux.lds.S |    1 -
 drivers/firmware/efi/libstub/Makefile  |    7 -------
 2 files changed, 8 deletions(-)

--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -46,7 +46,6 @@ SECTIONS
 		_data = . ;
 		*(.data)
 		*(.data.*)
-		*(.bss.efistub)
 		_edata = . ;
 	}
 	. = ALIGN(L1_CACHE_BYTES);
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -102,13 +102,6 @@ lib-y				:= $(patsubst %.o,%.stub.o,$(li
 # https://bugs.llvm.org/show_bug.cgi?id=46480
 STUBCOPY_FLAGS-y		+= --remove-section=.note.gnu.property
 
-#
-# For x86, bootloaders like systemd-boot or grub-efi do not zero-initialize the
-# .bss section, so the .bss section of the EFI stub needs to be included in the
-# .data section of the compressed kernel to ensure initialization. Rename the
-# .bss section here so it's easy to pick out in the linker script.
-#
-STUBCOPY_FLAGS-$(CONFIG_X86)	+= --rename-section .bss=.bss.efistub,load,alloc
 STUBCOPY_RELOC-$(CONFIG_X86_32)	:= R_386_32
 STUBCOPY_RELOC-$(CONFIG_X86_64)	:= R_X86_64_64
 


