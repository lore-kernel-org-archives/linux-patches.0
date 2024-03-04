Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668021EB5A;
	Mon,  4 Mar 2024 21:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588894; cv=none; b=NB4n4dD9lAgx9LOARMLqIlvGEldzgDRRMzjVanXKjQY51Ru6aoenOU2o8SH+nLY3xnCP/6mzz83qfyV65zvGspb6YfNYCen/o5qIL3QQHp4eKWAEWZtN2QYM+PRQY6dHPtZW0Sglu5A5W12TB+58vNQbO46oDjEgSVKwJzLPg8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588894; c=relaxed/simple;
	bh=iXCK+tO3GkclWl0c0ZcvbvmoEEkjIUUCrctvYlzH39w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYJGK1KkjtFxi02U1JLFzKgpjPEPLLEpV0MWaWt1+rdon7WwQQlwCQzWNO91wSIXzp+imtTqU6GJ40F0JAE7tgGFFifTWE1lWxgXiKxoV/bLQJFHvyhQPUJpyPy5mJXjO8Skn9ccFY7Khd4vNl41PDJ17d+/0OpFE3jBRXq2NnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LW8OCllL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW8OCllL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032CBC433C7;
	Mon,  4 Mar 2024 21:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588894;
	bh=iXCK+tO3GkclWl0c0ZcvbvmoEEkjIUUCrctvYlzH39w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW8OCllLVI5aDIgss49u+IQX9vxNhUXygYs7Opz45X4w7wVETE3dUwdiPdr3fsF24
	 1x+v6Y0WEVMjZqtlAMlaRboWV8uDLPviPYlbmD9xN6gPR19wlcBnwkmLLlsoICzQu8
	 VWaGUfxTY43rpUXiIxKy/AtOHhM1UUTlT5I9lh7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 129/215] x86/efistub: Branch straight to kernel entry point from C code
Date: Mon,  4 Mar 2024 21:23:12 +0000
Message-ID: <20240304211601.166350284@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit d2d7a54f69b67cd0a30e0ebb5307cb2de625baac upstream.

Instead of returning to the calling code in assembler that does nothing
more than perform an indirect call with the boot_params pointer in
register ESI/RSI, perform the jump directly from the EFI stub C code.
This will allow the asm entrypoint code to be dropped entirely in
subsequent patches.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-4-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -279,7 +279,7 @@ adjust_memory_range_protection(unsigned
 #define TRAMPOLINE_PLACEMENT_BASE ((128 - 8)*1024)
 #define TRAMPOLINE_PLACEMENT_SIZE (640*1024 - (128 - 8)*1024)
 
-void startup_32(struct boot_params *boot_params);
+extern const u8 startup_32[], startup_64[];
 
 static void
 setup_memory_protection(unsigned long image_base, unsigned long image_size)
@@ -760,10 +760,19 @@ static efi_status_t exit_boot(struct boo
 	return EFI_SUCCESS;
 }
 
+static void __noreturn enter_kernel(unsigned long kernel_addr,
+				    struct boot_params *boot_params)
+{
+	/* enter decompressed kernel with boot_params pointer in RSI/ESI */
+	asm("jmp *%0"::"r"(kernel_addr), "S"(boot_params));
+
+	unreachable();
+}
+
 /*
- * On success, we return the address of startup_32, which has potentially been
- * relocated by efi_relocate_kernel.
- * On failure, we exit to the firmware via efi_exit instead of returning.
+ * On success, this routine will jump to the relocated image directly and never
+ * return.  On failure, it will exit to the firmware via efi_exit() instead of
+ * returning.
  */
 asmlinkage unsigned long efi_main(efi_handle_t handle,
 				  efi_system_table_t *sys_table_arg,
@@ -905,7 +914,10 @@ asmlinkage unsigned long efi_main(efi_ha
 		goto fail;
 	}
 
-	return bzimage_addr;
+	if (IS_ENABLED(CONFIG_X86_64))
+		bzimage_addr += startup_64 - startup_32;
+
+	enter_kernel(bzimage_addr, boot_params);
 fail:
 	efi_err("efi_main() failed!\n");
 


