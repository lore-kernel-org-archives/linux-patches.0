Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637E425BAAA;
	Tue, 11 Mar 2025 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707078; cv=none; b=fTeW4ffpw2yIHSMHaPYA7GjrXXJdU5Mghh/uQ5TTZqfACQUCrOHx5o0I79MuAnkuDpbiOasJyFjwekWGJOsAJKtAtkoFnW433Q66odnjQXw6vOdfD3VHiIcPkgH7nLDvdJ4abrJjwCxA7sIr4aGgHHE5a/YxiNbnaKJYFm2gDFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707078; c=relaxed/simple;
	bh=pFsR0SiFKrCu2qyQ1H8ophJmr11hbTRB5JOZ0YFn6sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKmGhAqsrY2ETQ28FI2eg3mzLBE6CNk0rG3/7vpcH272wrOmmkksvzcvGehYLHwHE7Y7zsd1U2/+WfNEUYHLnLVyx/3lj+XbfkmRp4Y1nUtg8v5o4hz57KNT/WHl2PMnZASiApJbDU13qHia1qjbQCLmCiCEltWycElp+huw/FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXYk3VjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXYk3VjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBE6C4CEE9;
	Tue, 11 Mar 2025 15:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707078;
	bh=pFsR0SiFKrCu2qyQ1H8ophJmr11hbTRB5JOZ0YFn6sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXYk3VjBXxp3zJo3kHa8tKdHraj/Q5C5K4RUDSEAeaR4TrPLiBrmyTQRlNQRfFZQR
	 mOghHG4rwGg4bXLslS26rZvnAFFuW1JmzmUBHkTv+ENYBzJPj+VnK2WgoocBW076LA
	 Wunycn4OQ0J//z5abCN7vj4poJ5PaMLwsshO6/eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 266/462] efi: Avoid cold plugged memory for placing the kernel
Date: Tue, 11 Mar 2025 15:58:52 +0100
Message-ID: <20250311145808.874787165@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit ba69e0750b0362870294adab09339a0c39c3beaf upstream.

UEFI 2.11 introduced EFI_MEMORY_HOT_PLUGGABLE to annotate system memory
regions that are 'cold plugged' at boot, i.e., hot pluggable memory that
is available from early boot, and described as system RAM by the
firmware.

Existing loaders and EFI applications running in the boot context will
happily use this memory for allocating data structures that cannot be
freed or moved at runtime, and this prevents the memory from being
unplugged. Going forward, the new EFI_MEMORY_HOT_PLUGGABLE attribute
should be tested, and memory annotated as such should be avoided for
such allocations.

In the EFI stub, there are a couple of occurrences where, instead of the
high-level AllocatePages() UEFI boot service, a low-level code sequence
is used that traverses the EFI memory map and carves out the requested
number of pages from a free region. This is needed, e.g., for allocating
as low as possible, or for allocating pages at random.

While AllocatePages() should presumably avoid special purpose memory and
cold plugged regions, this manual approach needs to incorporate this
logic itself, in order to prevent the kernel itself from ending up in a
hot unpluggable region, preventing it from being unplugged.

So add the EFI_MEMORY_HOTPLUGGABLE macro definition, and check for it
where appropriate.

Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c                 |    6 ++++--
 drivers/firmware/efi/libstub/randomalloc.c |    3 +++
 drivers/firmware/efi/libstub/relocate.c    |    3 +++
 include/linux/efi.h                        |    1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -774,13 +774,15 @@ char * __init efi_md_typeattr_format(cha
 		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_RO |
 		     EFI_MEMORY_WP | EFI_MEMORY_RP | EFI_MEMORY_XP |
 		     EFI_MEMORY_NV | EFI_MEMORY_SP | EFI_MEMORY_CPU_CRYPTO |
-		     EFI_MEMORY_RUNTIME | EFI_MEMORY_MORE_RELIABLE))
+		     EFI_MEMORY_MORE_RELIABLE | EFI_MEMORY_HOT_PLUGGABLE |
+		     EFI_MEMORY_RUNTIME))
 		snprintf(pos, size, "|attr=0x%016llx]",
 			 (unsigned long long)attr);
 	else
 		snprintf(pos, size,
-			 "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
+			 "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
 			 attr & EFI_MEMORY_RUNTIME		? "RUN" : "",
+			 attr & EFI_MEMORY_HOT_PLUGGABLE	? "HP"  : "",
 			 attr & EFI_MEMORY_MORE_RELIABLE	? "MR"  : "",
 			 attr & EFI_MEMORY_CPU_CRYPTO   	? "CC"  : "",
 			 attr & EFI_MEMORY_SP			? "SP"  : "",
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -24,6 +24,9 @@ static unsigned long get_entry_num_slots
 	if (md->type != EFI_CONVENTIONAL_MEMORY)
 		return 0;
 
+	if (md->attribute & EFI_MEMORY_HOT_PLUGGABLE)
+		return 0;
+
 	if (efi_soft_reserve_enabled() &&
 	    (md->attribute & EFI_MEMORY_SP))
 		return 0;
--- a/drivers/firmware/efi/libstub/relocate.c
+++ b/drivers/firmware/efi/libstub/relocate.c
@@ -62,6 +62,9 @@ efi_status_t efi_low_alloc_above(unsigne
 		if (desc->type != EFI_CONVENTIONAL_MEMORY)
 			continue;
 
+		if (desc->attribute & EFI_MEMORY_HOT_PLUGGABLE)
+			continue;
+
 		if (efi_soft_reserve_enabled() &&
 		    (desc->attribute & EFI_MEMORY_SP))
 			continue;
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -125,6 +125,7 @@ typedef	struct {
 #define EFI_MEMORY_RO		((u64)0x0000000000020000ULL)	/* read-only */
 #define EFI_MEMORY_SP		((u64)0x0000000000040000ULL)	/* soft reserved */
 #define EFI_MEMORY_CPU_CRYPTO	((u64)0x0000000000080000ULL)	/* supports encryption */
+#define EFI_MEMORY_HOT_PLUGGABLE	BIT_ULL(20)	/* supports unplugging at runtime */
 #define EFI_MEMORY_RUNTIME	((u64)0x8000000000000000ULL)	/* range requires runtime mapping */
 #define EFI_MEMORY_DESCRIPTOR_VERSION	1
 


