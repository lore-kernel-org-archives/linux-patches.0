Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834D417FAB1;
	Wed,  3 Jul 2024 11:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006276; cv=none; b=gzmimkmpr8/JPnX8se38GhXjC8rZ8zUvXmOJhtkuVDBbkR90wHd6y82EDCBta6nAIS/3QxRhBIGmW0V8vVsdOBGULZ9IXeuZRyfseJhsNpPtqHvs9YyvLHVYUlNNj/++0fhtiECx2YKNY0juiPTdnw/wc9R9KsTpYSSNbxd9oxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006276; c=relaxed/simple;
	bh=k05znX6k3KaeF5jt4ueWO1GcMceY6+imkWdbneeRoxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezBTZta2lEULt6H6f45HMkF5bJOcPBnEfd2rI6Bxkh5r/2y0Fi83UH8D/1eyNH1iCJb3FD05vAIVvrWCbF+KPkgErnyw3jCtr+l6A3ZdDmWFDJNKMSJwwROYe1b+YKTfAeWmj/FS+7QLCoKYJf69g6lR+D2HYhbnhTAsPY7NByw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXF0IIzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXF0IIzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B90EC2BD10;
	Wed,  3 Jul 2024 11:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006276;
	bh=k05znX6k3KaeF5jt4ueWO1GcMceY6+imkWdbneeRoxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXF0IIzCAta2r+A+JW9To6O8Amqj7swSX2xMCurV3sPssCcCuvzJ1R3VzrnUmjCM8
	 x1kSeVbsdwDvT5206W6/pnWh9hL0+/AIfveBOJirDGyBGfIoqkayjdvmEWqJB2JuZJ
	 ScVnbC5fBDb3iGFpYlmtJFf8R8IAET13sp3Q61T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 351/356] efi: xen: Set EFI_PARAVIRT for Xen dom0 boot on all architectures
Date: Wed,  3 Jul 2024 12:41:27 +0200
Message-ID: <20240703102926.389042537@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


