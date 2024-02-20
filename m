Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF47F14F9C8;
	Tue, 20 Feb 2024 21:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464304; cv=none; b=ATjDTu8Xm9Xb5+g9HMSY0r/sXVmCuMufPiuV6zUPhpCUGCVpe4YLVeDfCuRandZP7ZDxb6n4+Ata03ehogH7mjyYANygINyLu8T5+zLqC/iq4f6goLcrPAOZviRZTK5e21/c1N3di4hP8bb1G9LkI8ZNd0GjeBF8RJMoTNSxe7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464304; c=relaxed/simple;
	bh=7uxUNJK8zccTyPwbNGDz5aAnWN5VuFEXDAK+c4H79Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPfGsKvrKAQlyQHOFPYPr3Ci5O29Y4i8RIiSJX0XzyynzWRgENhJ3J5YEwBmdIZu+5737fpVwBGOUkjRqb+fm0raVJdolF7fOqyBV21i7dNbd7uFZynJjsuWgnHeK+h7V5kZdgIwpY6+lVLATitSaw0YzM7L4Rga61jYLUiMX2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQuOYcNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQuOYcNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D349C433C7;
	Tue, 20 Feb 2024 21:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464304;
	bh=7uxUNJK8zccTyPwbNGDz5aAnWN5VuFEXDAK+c4H79Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQuOYcNp4feV3TBrsAzOPDfmfja6maqP0hgcAhDhmltolRG0GdmAgLP5S0hBsHSLu
	 o+ewOZ6JRNtfkRE8wsFtd0qcKYR9mWu3eN8d02Ev+C6Gm1klN8+DqCVB3dp3vvZYHp
	 XANAHKVxuUy2zcTZWp/RS5Hzw/xmyrRwBZllfqZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 316/331] x86/efi: Drop EFI stub .bss from .data section
Date: Tue, 20 Feb 2024 21:57:12 +0100
Message-ID: <20240220205648.148274833@linuxfoundation.org>
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

commit 5f51c5d0e905608ba7be126737f7c84a793ae1aa upstream.

Now that the EFI stub always zero inits its BSS section upon entry,
there is no longer a need to place the BSS symbols carried by the stub
into the .data section.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230912090051.4014114-18-ardb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/vmlinux.lds.S |    1 -
 drivers/firmware/efi/libstub/Makefile  |    7 -------
 2 files changed, 8 deletions(-)

--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -47,7 +47,6 @@ SECTIONS
 		_data = . ;
 		*(.data)
 		*(.data.*)
-		*(.bss.efistub)
 		_edata = . ;
 	}
 	. = ALIGN(L1_CACHE_BYTES);
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -108,13 +108,6 @@ lib-y				:= $(patsubst %.o,%.stub.o,$(li
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
 


