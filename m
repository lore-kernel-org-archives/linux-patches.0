Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC7D18A95F;
	Wed,  3 Jul 2024 11:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005174; cv=none; b=jxtX2HmjL+oS1Ukjimq44JB6hxumJC+wxjXHSfAlga8224GzN+CRq0zAeJrQdm7r/oYM+N9e47BEK/Js4oIXsQv6j2UCoh9n1+g4YCyXVq+YZOg5gLIYzydIZVb2iDahYZAD12OpllrXPjDd1Vp9kKrDgQmyKNWSVMr4ccqGwI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005174; c=relaxed/simple;
	bh=n2mOuBf+DomS4RfAqRz/ZCSo5bDxN+9oLhBBs3jq9N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcz0jzFe/mVTffS7O/qV3uKjWn0yEnpqUFRuON8TTODnsCZDr6kabPWImC6BbWEq0iCPRYcHdM+lZLMlYIz+d7jHK05jiuv9x4Z1L/4dU2IG0R4RiABSJpa2dl6tWXSs46fb2dDHAuCh5IiHf8P97uET3RmmVelqIqEjV0JxfTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkkJyceV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkkJyceV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A848FC2BD10;
	Wed,  3 Jul 2024 11:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005174;
	bh=n2mOuBf+DomS4RfAqRz/ZCSo5bDxN+9oLhBBs3jq9N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkkJyceVdlxQuG3U8Vs+ohSW76X7m0+JaOUpqxcRLezSBRq/FEw8auap916UaH4Aa
	 fdKXGTjx8oDFXZbGHI1vLquREQ+8uvfRtaUzEEf8vMRMsQmTtVKwoLvSU8yP9f7+rg
	 pUw7cwAblKlY8/I407kbAoonL0J6Oq05hGiKIsCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 285/290] efi: xen: Set EFI_PARAVIRT for Xen dom0 boot on all architectures
Date: Wed,  3 Jul 2024 12:41:06 +0200
Message-ID: <20240703102914.914826185@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Commit d85e3e34940788578eeffd94e8b7e1d28e7278e9 upstream ]

Currently, the EFI_PARAVIRT flag is only used by Xen dom0 boot on x86,
even though other architectures also support pseudo-EFI boot, where the
core kernel is invoked directly and provided with a set of data tables
that resemble the ones constructed by the EFI stub, which never actually
runs in that case.

Let's fix this inconsistency, and always set this flag when booting dom0
via the EFI boot path. Note that Xen on x86 does not provide the EFI
memory map in this case, whereas other architectures do, so move the
associated EFI_PARAVIRT check into the x86 platform code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/platform/efi/efi.c      |    8 +++++---
 arch/x86/platform/efi/memmap.c   |    3 +++
 drivers/firmware/efi/fdtparams.c |    4 ++++
 drivers/firmware/efi/memmap.c    |    3 ---
 4 files changed, 12 insertions(+), 6 deletions(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -234,9 +234,11 @@ int __init efi_memblock_x86_reserve_rang
 	data.desc_size		= e->efi_memdesc_size;
 	data.desc_version	= e->efi_memdesc_version;
 
-	rv = efi_memmap_init_early(&data);
-	if (rv)
-		return rv;
+	if (!efi_enabled(EFI_PARAVIRT)) {
+		rv = efi_memmap_init_early(&data);
+		if (rv)
+			return rv;
+	}
 
 	if (add_efi_memmap || do_efi_soft_reserve())
 		do_add_efi_memmap();
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -94,6 +94,9 @@ int __init efi_memmap_install(struct efi
 {
 	efi_memmap_unmap();
 
+	if (efi_enabled(EFI_PARAVIRT))
+		return 0;
+
 	return __efi_memmap_init(data);
 }
 
--- a/drivers/firmware/efi/fdtparams.c
+++ b/drivers/firmware/efi/fdtparams.c
@@ -30,11 +30,13 @@ static __initconst const char name[][22]
 
 static __initconst const struct {
 	const char	path[17];
+	u8		paravirt;
 	const char	params[PARAMCOUNT][26];
 } dt_params[] = {
 	{
 #ifdef CONFIG_XEN    //  <-------17------>
 		.path = "/hypervisor/uefi",
+		.paravirt = 1,
 		.params = {
 			[SYSTAB] = "xen,uefi-system-table",
 			[MMBASE] = "xen,uefi-mmap-start",
@@ -121,6 +123,8 @@ u64 __init efi_get_fdt_params(struct efi
 			pr_err("Can't find property '%s' in DT!\n", pname);
 			return 0;
 		}
+		if (dt_params[i].paravirt)
+			set_bit(EFI_PARAVIRT, &efi.flags);
 		return systab;
 	}
 notfound:
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -39,9 +39,6 @@ int __init __efi_memmap_init(struct efi_
 	struct efi_memory_map map;
 	phys_addr_t phys_map;
 
-	if (efi_enabled(EFI_PARAVIRT))
-		return 0;
-
 	phys_map = data->phys_map;
 
 	if (data->flags & EFI_MEMMAP_LATE)


