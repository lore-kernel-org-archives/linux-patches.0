Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2AC5F56B;
	Tue, 13 Feb 2024 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845304; cv=none; b=hGEHN2IM6bjYgkLboQ5z5QhlMgUP9bmK5GN2MSMKyY68aNjJD7VeermGvPihpohEeMWtUsy1/pXP0KcK9k6INuahLtdKy7JdL2S0qYTGCXIR7ebsiKYJA4T1WGs5jpp5+44YtadIhq3Kv31IA2AOy7hj32NuV+GNY0ayBKIWAt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845304; c=relaxed/simple;
	bh=7m1a6zxxujqA3j0x2TL9jJj26I55zfjN6c7IwMh+Y90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsxyoB735I/OdZPs7cxHNZrpTGWaF5IgHWEeCITj6FMqpEV6IOOKiQx3AcLH7ihRILDFo/CKWsypfO4cid3yGalxB2ejOL1Mk20VKsPJBQOMS1rdxK/uQNzSLlViChoJeIJRrSbO0YhIqPkCmex5r7tTRLu8KhzYdolhMHOCt2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYT1GtqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYT1GtqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82920C433F1;
	Tue, 13 Feb 2024 17:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845304;
	bh=7m1a6zxxujqA3j0x2TL9jJj26I55zfjN6c7IwMh+Y90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYT1GtqIHho7JAR9w2Fo8rBc8ORNNUZ0dq12M1FU36sK2O3uxVRaC+pdgQ2Sih/QP
	 O1G3yLS5lnc9vsxM49lNNQiVFMzu+sQbBpu0iADgOwMx/VGmxqXN1HPo9W+xtaO+uZ
	 nClmKYn+kZs5BfZ7nHUNm8ZzJ1aJ24i9uKVSzw0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/121] x86/efistub: Give up if memory attribute protocol returns an error
Date: Tue, 13 Feb 2024 18:20:50 +0100
Message-ID: <20240213171854.197828144@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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
index 70b325a2f1f3..5d0934ae7dc8 100644
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
@@ -837,9 +843,7 @@ static efi_status_t efi_decompress_kernel(unsigned long *kernel_entry)
 
 	*kernel_entry = addr + entry;
 
-	efi_adjust_memory_range_protection(addr, kernel_total_size);
-
-	return EFI_SUCCESS;
+	return efi_adjust_memory_range_protection(addr, kernel_total_size);
 }
 
 static void __noreturn enter_kernel(unsigned long kernel_addr,
diff --git a/drivers/firmware/efi/libstub/x86-stub.h b/drivers/firmware/efi/libstub/x86-stub.h
index 2748bca192df..4433d0f97441 100644
--- a/drivers/firmware/efi/libstub/x86-stub.h
+++ b/drivers/firmware/efi/libstub/x86-stub.h
@@ -7,8 +7,8 @@ extern struct boot_params *boot_params_pointer asm("boot_params");
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



