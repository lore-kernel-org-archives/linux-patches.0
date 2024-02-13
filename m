Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428FCAD55;
	Tue, 13 Feb 2024 17:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845654; cv=none; b=Eose/JTQRLHyWK4jofsqClYSSnAJ5n9qKdkScHxutUDA67YaIR9T4w/9yeBI8K73ozZz4DGVLhob1hy3FY+QGImW8wrWEQJBnzSwAmBsWaD5j4YKT+pnHgMNQ+mrrTAh9K3GJE4RZLWkgswXWAXgr47PtPdwMjT9dJe+ewinWoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845654; c=relaxed/simple;
	bh=B333NfeITKiolNdBwohX4Sc9O10wf74jmr5civ+oxeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5t3tb4qvPRM4zvcQu/car1hoYiNwixnwslJH+/YkdfwjtnPBO4lepDGltKJxo85ZwCyv8VwQEUxew2juNhpjpF3eCvGHrINvfI+4kxJbHbzEBG4CnTQz4Qhxd9TWq3PnC1m7LnzrVga8GKj4xBKIUBstR3sKIEkDRcZvxKD6Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhfU5HW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhfU5HW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1C8C43390;
	Tue, 13 Feb 2024 17:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845654;
	bh=B333NfeITKiolNdBwohX4Sc9O10wf74jmr5civ+oxeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhfU5HW4KwfH+Oj6IDAShYsEj0JyOIEfO2X+hG6pBaNGU3hdPcMdn9tGI6rlE3nBC
	 UP4Hbc92rD6ELVeKjtkrPw0UdSaK4LrPzsEN3qlGEmE2pUiuaowpc90aq1hWlCmhML
	 0NGxPYrUSM7CAHGQKpqk0NPLUywLUOXALuxXZ4dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 020/124] x86/efistub: Give up if memory attribute protocol returns an error
Date: Tue, 13 Feb 2024 18:20:42 +0100
Message-ID: <20240213171854.322552854@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit a7a6a01f88e87dec4bf2365571dd2dc7403d52d0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/x86-stub.c | 24 ++++++++++++++----------
 drivers/firmware/efi/libstub/x86-stub.h |  4 ++--
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index 0d510c9a06a4..cb0be88c8131 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -223,8 +223,8 @@ static void retrieve_apple_device_properties(struct boot_params *boot_params)
 	}
 }
 
-void efi_adjust_memory_range_protection(unsigned long start,
-					unsigned long size)
+efi_status_t efi_adjust_memory_range_protection(unsigned long start,
+						unsigned long size)
 {
 	efi_status_t status;
 	efi_gcd_memory_space_desc_t desc;
@@ -236,13 +236,17 @@ void efi_adjust_memory_range_protection(unsigned long start,
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
@@ -255,7 +259,7 @@ void efi_adjust_memory_range_protection(unsigned long start,
 		status = efi_dxe_call(get_memory_space_descriptor, start, &desc);
 
 		if (status != EFI_SUCCESS)
-			return;
+			break;
 
 		next = desc.base_address + desc.length;
 
@@ -280,8 +284,10 @@ void efi_adjust_memory_range_protection(unsigned long start,
 				 unprotect_start,
 				 unprotect_start + unprotect_size,
 				 status);
+			break;
 		}
 	}
+	return EFI_SUCCESS;
 }
 
 static void setup_unaccepted_memory(void)
@@ -805,9 +811,7 @@ static efi_status_t efi_decompress_kernel(unsigned long *kernel_entry)
 
 	*kernel_entry = addr + entry;
 
-	efi_adjust_memory_range_protection(addr, kernel_total_size);
-
-	return EFI_SUCCESS;
+	return efi_adjust_memory_range_protection(addr, kernel_total_size);
 }
 
 static void __noreturn enter_kernel(unsigned long kernel_addr,
diff --git a/drivers/firmware/efi/libstub/x86-stub.h b/drivers/firmware/efi/libstub/x86-stub.h
index 37c5a36b9d8c..1c20e99a6494 100644
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
-- 
2.43.0



