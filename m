Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4FC1C6AB;
	Mon,  4 Mar 2024 21:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589148; cv=none; b=j+aedvrhSxWTmJiQXqcKHvG/o/025IAkvQG5Y5ML0MqM/rBPc1dWhEC3K6SLkahs4xSb84H3PgbBV9OtK/rQH5hWXo0h4km9oKF3Z/dnUsOac3sBm+quFk3HCpUEKClMxJ8PU5jtYiztF8ki8mU/S9u0tPrMfQEafyw1Rk10GXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589148; c=relaxed/simple;
	bh=yBDwWNjRTsrD0euOLwiVQrlMxKsrQnt9XWrqBBO4PIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEZTO6pFb2GKNbYJ93wkj6ebrML7Fq8rXut/YsIpZGrWcAMDWBBpSOUFl5JaFW0+s5uSRQvtTmXJmRgZJEQFaedk6c9x3bXDJsPN9n/SuUPfJUGCVXkKZUJR2dG9gqnM8+2vHD9tKojZufKx8WlziE/B0kRIZidjnx1Yqwruj04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYu5b2Da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYu5b2Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38ADC433F1;
	Mon,  4 Mar 2024 21:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589148;
	bh=yBDwWNjRTsrD0euOLwiVQrlMxKsrQnt9XWrqBBO4PIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYu5b2DaJ3jRn5rrKXLS4nXov0hxX+Pm5/F8hmEgyvcFuDsRIeeZ93J3ZGI3Z3wyp
	 ch2onpQXMTcxuSOFVgX/BTeK96BaHs+lh4kgKZKe0eVj9/kFr52KGhniGG3M7Xyi9J
	 GwGtrshU0UnB5Dh0pEgmWBLxW04REuME9MPDc+yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 214/215] x86/efistub: Give up if memory attribute protocol returns an error
Date: Mon,  4 Mar 2024 21:24:37 +0000
Message-ID: <20240304211603.773167945@linuxfoundation.org>
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

commit a7a6a01f88e87dec4bf2365571dd2dc7403d52d0 upstream.

The recently introduced EFI memory attributes protocol should be used
if it exists to ensure that the memory allocation created for the kernel
permits execution. This is needed for compatibility with tightened
requirements related to Windows logo certification for x86 PCs.

Currently, we simply strip the execute protect (XP) attribute from the
entire range, but this might be rejected under some firmware security
policies, and so in a subsequent patch, this will be changed to only
strip XP from the executable region that runs early, and make it
read-only (RO) as well.

In order to catch any issues early, ensure that the memory attribute
protocol works as intended, and give up if it produces spurious errors.

Note that the DXE services based fallback was always based on best
effort, so don't propagate any errors returned by that API.

Fixes: a1b87d54f4e4 ("x86/efistub: Avoid legacy decompressor when doing EFI boot")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |   24 ++++++++++++++----------
 drivers/firmware/efi/libstub/x86-stub.h |    4 ++--
 2 files changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -212,8 +212,8 @@ static void retrieve_apple_device_proper
 	}
 }
 
-void efi_adjust_memory_range_protection(unsigned long start,
-					unsigned long size)
+efi_status_t efi_adjust_memory_range_protection(unsigned long start,
+						unsigned long size)
 {
 	efi_status_t status;
 	efi_gcd_memory_space_desc_t desc;
@@ -225,13 +225,17 @@ void efi_adjust_memory_range_protection(
 	rounded_end = roundup(start + size, EFI_PAGE_SIZE);
 
 	if (memattr != NULL) {
-		efi_call_proto(memattr, clear_memory_attributes, rounded_start,
-			       rounded_end - rounded_start, EFI_MEMORY_XP);
-		return;
+		status = efi_call_proto(memattr, clear_memory_attributes,
+					rounded_start,
+					rounded_end - rounded_start,
+					EFI_MEMORY_XP);
+		if (status != EFI_SUCCESS)
+			efi_warn("Failed to clear EFI_MEMORY_XP attribute\n");
+		return status;
 	}
 
 	if (efi_dxe_table == NULL)
-		return;
+		return EFI_SUCCESS;
 
 	/*
 	 * Don't modify memory region attributes, they are
@@ -244,7 +248,7 @@ void efi_adjust_memory_range_protection(
 		status = efi_dxe_call(get_memory_space_descriptor, start, &desc);
 
 		if (status != EFI_SUCCESS)
-			return;
+			break;
 
 		next = desc.base_address + desc.length;
 
@@ -269,8 +273,10 @@ void efi_adjust_memory_range_protection(
 				 unprotect_start,
 				 unprotect_start + unprotect_size,
 				 status);
+			break;
 		}
 	}
+	return EFI_SUCCESS;
 }
 
 static efi_char16_t *efistub_fw_vendor(void)
@@ -800,9 +806,7 @@ static efi_status_t efi_decompress_kerne
 
 	*kernel_entry = addr + entry;
 
-	efi_adjust_memory_range_protection(addr, kernel_total_size);
-
-	return EFI_SUCCESS;
+	return efi_adjust_memory_range_protection(addr, kernel_total_size);
 }
 
 static void __noreturn enter_kernel(unsigned long kernel_addr,
--- a/drivers/firmware/efi/libstub/x86-stub.h
+++ b/drivers/firmware/efi/libstub/x86-stub.h
@@ -5,8 +5,8 @@
 extern void trampoline_32bit_src(void *, bool);
 extern const u16 trampoline_ljmp_imm_offset;
 
-void efi_adjust_memory_range_protection(unsigned long start,
-					unsigned long size);
+efi_status_t efi_adjust_memory_range_protection(unsigned long start,
+						unsigned long size);
 
 #ifdef CONFIG_X86_64
 efi_status_t efi_setup_5level_paging(void);


