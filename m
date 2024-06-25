Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B6D148315;
	Tue, 25 Jun 2024 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308727; cv=none; b=bUEVt4Zu5TG0HN3B1YblhAJ/p5e+eGGzJEsg9KRtFTUPKl0nVT72FGZE8TsdHfa13NPVkzbZqaR0ynbUSEsfZiaQnxWqDHC67qddk/YBt8jVuwMg4mQ+w8Zhn9Nsf9w0nL7Xb9zHAKsGUkw+RML99FKk3zABuLjma5mneiXRp3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308727; c=relaxed/simple;
	bh=6VopJ9iYNrBC4nxTuBJCaMgf+x2yKmCR1iNkz26CsOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ye4m7KL+6cH9qEENJtFOgFMJUgo+hnxgHRENhAYtZwE17vlzZ6Obsd0dJ2tp3Cqqp++9noeB3o6JQxnaS8CwNCeYshwqrVhDB7FBCF7Th63HK424pqh/4Sagb0UnLxvon9ED712gtCivkRCYTZmLibHMAYss//Qu21lYHtGp0TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vq317C7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vq317C7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DE6C32781;
	Tue, 25 Jun 2024 09:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308727;
	bh=6VopJ9iYNrBC4nxTuBJCaMgf+x2yKmCR1iNkz26CsOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vq317C7JnqyPcelRVKOe0ozuqZycGapbOsoWg+GYiGSPrzSWyZa5v/g4PiuH/OPQW
	 vyPS4UEmyKtecbq331ua+46epZlVPqKLgxzCuADhP6gdJR/igOR6+gGMwrNYcxihfa
	 zEsAxwHO9ENSF79HQDyX97Cdp53PBmCCATEoYToE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <Ashish.Kalra@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.9 219/250] efi/x86: Free EFI memory map only when installing a new one.
Date: Tue, 25 Jun 2024 11:32:57 +0200
Message-ID: <20240625085556.458619382@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 75dde792d6f6c2d0af50278bd374bf0c512fe196 upstream.

The logic in __efi_memmap_init() is shared between two different
execution flows:
- mapping the EFI memory map early or late into the kernel VA space, so
  that its entries can be accessed;
- the x86 specific cloning of the EFI memory map in order to insert new
  entries that are created as a result of making a memory reservation
  via a call to efi_mem_reserve().

In the former case, the underlying memory containing the kernel's view
of the EFI memory map (which may be heavily modified by the kernel
itself on x86) is not modified at all, and the only thing that changes
is the virtual mapping of this memory, which is different between early
and late boot.

In the latter case, an entirely new allocation is created that carries a
new, updated version of the kernel's view of the EFI memory map. When
installing this new version, the old version will no longer be
referenced, and if the memory was allocated by the kernel, it will leak
unless it gets freed.

The logic that implements this freeing currently lives on the code path
that is shared between these two use cases, but it should only apply to
the latter. So move it to the correct spot.

While at it, drop the dummy definition for non-x86 architectures, as
that is no longer needed.

Cc: <stable@vger.kernel.org>
Fixes: f0ef6523475f ("efi: Fix efi_memmap_alloc() leaks")
Tested-by: Ashish Kalra <Ashish.Kalra@amd.com>
Link: https://lore.kernel.org/all/36ad5079-4326-45ed-85f6-928ff76483d3@amd.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/efi.h     |    1 -
 arch/x86/platform/efi/memmap.c |   12 +++++++++++-
 drivers/firmware/efi/memmap.c  |    9 ---------
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -401,7 +401,6 @@ extern int __init efi_memmap_alloc(unsig
 				   struct efi_memory_map_data *data);
 extern void __efi_memmap_free(u64 phys, unsigned long size,
 			      unsigned long flags);
-#define __efi_memmap_free __efi_memmap_free
 
 extern int __init efi_memmap_install(struct efi_memory_map_data *data);
 extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -92,12 +92,22 @@ int __init efi_memmap_alloc(unsigned int
  */
 int __init efi_memmap_install(struct efi_memory_map_data *data)
 {
+	unsigned long size = efi.memmap.desc_size * efi.memmap.nr_map;
+	unsigned long flags = efi.memmap.flags;
+	u64 phys = efi.memmap.phys_map;
+	int ret;
+
 	efi_memmap_unmap();
 
 	if (efi_enabled(EFI_PARAVIRT))
 		return 0;
 
-	return __efi_memmap_init(data);
+	ret = __efi_memmap_init(data);
+	if (ret)
+		return ret;
+
+	__efi_memmap_free(phys, size, flags);
+	return 0;
 }
 
 /**
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -15,10 +15,6 @@
 #include <asm/early_ioremap.h>
 #include <asm/efi.h>
 
-#ifndef __efi_memmap_free
-#define __efi_memmap_free(phys, size, flags) do { } while (0)
-#endif
-
 /**
  * __efi_memmap_init - Common code for mapping the EFI memory map
  * @data: EFI memory map data
@@ -51,11 +47,6 @@ int __init __efi_memmap_init(struct efi_
 		return -ENOMEM;
 	}
 
-	if (efi.memmap.flags & (EFI_MEMMAP_MEMBLOCK | EFI_MEMMAP_SLAB))
-		__efi_memmap_free(efi.memmap.phys_map,
-				  efi.memmap.desc_size * efi.memmap.nr_map,
-				  efi.memmap.flags);
-
 	map.phys_map = data->phys_map;
 	map.nr_map = data->size / data->desc_size;
 	map.map_end = map.map + data->size;


