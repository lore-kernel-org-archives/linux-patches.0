Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2AD1A6195;
	Tue, 30 Jul 2024 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358464; cv=none; b=knneozUr8ENfy01E8CH4cLRQvB9OXhc/Yc3RhK511lfZVJ0Vj2uzutfhDFQu1d8mu9TIWMi1q5HTjuSqjvwW4KuUascUMpDAB6HA4G/t2ZvXO5Q3BoCEKMmVbx8x2QOLr7sSIVuqJvGc9sqxQ/UKgXt6juXZcpYwGGq7Wm4Syw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358464; c=relaxed/simple;
	bh=5yXoxf8bi9Kn4wsxDHq4/yyeWc7w+R4Tgm7miYNcsSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz5nksLiYALJFgs293gxQCvnnX25uRrq5ubSsLScrhnUusXJ0m4X8Gmc1l3EgHFEyoK3wZ/D0jbnSgYg1P6R8GrzfGmsZkYe2rqNUEb8W/qM7WI4iqKha7dfnbeKcnF8CeNmO1yuTjIxzp7kSjBerJ9OfRjvI6uDVN2bSmtZ6n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+iTjo0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+iTjo0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B53C32782;
	Tue, 30 Jul 2024 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358464;
	bh=5yXoxf8bi9Kn4wsxDHq4/yyeWc7w+R4Tgm7miYNcsSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+iTjo0FYgmTxCZJC6eJtkHiTVG8aBzH+qRk1I2JTk8Ou0FD8zYHUhtyWQehc+yBX
	 l5LkjMsQPMqir70pljTE9LoP01+/8dF7oPa77k8jOr31MsNE+hQ3QQOVrcL8+D9dZo
	 AS77bWGOpm3PKumkDjjNeyBP3DArykDbD/0izqZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	mavrix#kernel@simplelogin.com,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 364/568] x86/efistub: Revert to heap allocated boot_params for PE entrypoint
Date: Tue, 30 Jul 2024 17:47:51 +0200
Message-ID: <20240730151654.088255404@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

commit ae835a96d72cd025421910edb0e8faf706998727 upstream.

This is a partial revert of commit

  8117961d98f ("x86/efi: Disregard setup header of loaded image")

which triggers boot issues on older Dell laptops. As it turns out,
switching back to a heap allocation for the struct boot_params
constructed by the EFI stub works around this, even though it is unclear
why.

Cc: Christian Heusel <christian@heusel.eu>
Reported-by: <mavrix#kernel@simplelogin.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -469,11 +469,12 @@ void __noreturn efi_stub_entry(efi_handl
 efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 				   efi_system_table_t *sys_table_arg)
 {
-	static struct boot_params boot_params __page_aligned_bss;
-	struct setup_header *hdr = &boot_params.hdr;
 	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
+	struct boot_params *boot_params;
+	struct setup_header *hdr;
 	int options_size = 0;
 	efi_status_t status;
+	unsigned long alloc;
 	char *cmdline_ptr;
 
 	if (efi_is_native())
@@ -491,6 +492,13 @@ efi_status_t __efiapi efi_pe_entry(efi_h
 		efi_exit(handle, status);
 	}
 
+	status = efi_allocate_pages(PARAM_SIZE, &alloc, ULONG_MAX);
+	if (status != EFI_SUCCESS)
+		efi_exit(handle, status);
+
+	boot_params = memset((void *)alloc, 0x0, PARAM_SIZE);
+	hdr	    = &boot_params->hdr;
+
 	/* Assign the setup_header fields that the kernel actually cares about */
 	hdr->root_flags	= 1;
 	hdr->vid_mode	= 0xffff;
@@ -500,13 +508,15 @@ efi_status_t __efiapi efi_pe_entry(efi_h
 
 	/* Convert unicode cmdline to ascii */
 	cmdline_ptr = efi_convert_cmdline(image, &options_size);
-	if (!cmdline_ptr)
+	if (!cmdline_ptr) {
+		efi_free(PARAM_SIZE, alloc);
 		efi_exit(handle, EFI_OUT_OF_RESOURCES);
+	}
 
 	efi_set_u64_split((unsigned long)cmdline_ptr, &hdr->cmd_line_ptr,
-			  &boot_params.ext_cmd_line_ptr);
+			  &boot_params->ext_cmd_line_ptr);
 
-	efi_stub_entry(handle, sys_table_arg, &boot_params);
+	efi_stub_entry(handle, sys_table_arg, boot_params);
 	/* not reached */
 }
 


