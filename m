Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4EE1A6195;
	Tue, 30 Jul 2024 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357272; cv=none; b=W/ntgdDaWxpYpQKFmvKKw9wzDsStqiyVRN6z1q9AYaC/cFcOP1aqUQlTWwcY+M+zmChLGS4UJA6hcuJ4GDaT64dvVnvz3gIiswf3VpmvHU3RyZOctWBIgyGUh9quYDoOshAm064Na8qkpbIMGhMLTEEJjYDT9ChiCG6f2gilbcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357272; c=relaxed/simple;
	bh=C4ZVLqMsx8hvnY6VbM5orTldkmrdGOxk47Jl+BRg6Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUajHwq13e6OhjfeEeLcFr11x+w405AHYYJVNefTQrWV08zbNeG4IzjM+Sfdeuxa5pOxfjHT/J8M79OaNPNFuJlje4r/xfiMu319NQFv/VkP1HE5vQwloCltKWVUbg4a90JAfseKN4+LAKgl53uUL29oLUmG2w8+fQd5R3bIrjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCvm8/E+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCvm8/E+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA82C32782;
	Tue, 30 Jul 2024 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357271;
	bh=C4ZVLqMsx8hvnY6VbM5orTldkmrdGOxk47Jl+BRg6Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCvm8/E+EMrEG5PYIUbtdAo8l65yO+4nEngy9T4Jq8qk7Gk6ifel+jcgoPmr7RP+L
	 3S8gZ4naDfPfo+1eY0hLM3oJNo/N4RcuPu754kAZ04uWQwz9LFpzzTPcjEUMfxZ8wt
	 EN4sT4k3lidczTxPaILqMCVkrhxdp+hGLaACcPOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	mavrix#kernel@simplelogin.com,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 275/440] x86/efistub: Revert to heap allocated boot_params for PE entrypoint
Date: Tue, 30 Jul 2024 17:48:28 +0200
Message-ID: <20240730151626.574004219@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
@@ -435,11 +435,12 @@ void __noreturn efi_stub_entry(efi_handl
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
@@ -457,6 +458,13 @@ efi_status_t __efiapi efi_pe_entry(efi_h
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
@@ -466,13 +474,15 @@ efi_status_t __efiapi efi_pe_entry(efi_h
 
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
 


