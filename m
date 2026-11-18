Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031048;
	b=QpuSjsurS/3v/jzpLd+2F11hEvT8S4cnP18YAaCHjsGjpE0JXwZLjeiSjuYosUn4PI5s
	 Rqi3gWqJT7qCpGnwjmoOQkVEZ4+X6vnCv7HbNHjhwz11iAbZMw8G5EeArHeintkdkhJok
	 b4RQ3C3albPRuM98H+Sx+4SP1FmdO+Vx4k1+irYWuP1bDUKWDsxneSGFWhEafgdfBlWV0
	 rY+B89GF3dk0L1+a+98VMZrwr+r2+MD86AwYctHFpaPkPAlKL4V90384GsKIhXpC3qix1
	 6DhYWAzrYH0jnrEA/2QJlxD3yvCI3IG8sGNxJJG95Djhtkp+PUONvrVIySuueMaWpyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=skcdvMbC2EKXk1jqOHL1y0s0M9Ww/MHWI7uMaQtCpPQ=;
	b=A78pNWeAXnJtOAZfsB4Mi9dIHXeYrG6jVQsCsO6FHQv2iqEVqH7aEgltlt1y4byF+Lhn
	 VOKtunD5VjdjzcamRc3hSNKckK38ApUq6tRqozyfgVro/x5WTKypYnrzs2AWD3MLkvNaP
	 pACJ/IfuaUIBomF7X8KDnRirrFHxNHZSq6l9uB0mgISvEUoXCIho18o3U8imTWcWqiEKG
	 ZZ4NSQbYI1wzQKsCuuDiymEu1jLWm0Ou1jdUI5i3VJIdUqoL1zqOQEkASpckCRcy+n1KI
	 zBSlje3A5YGmXZJPgtjVl6IC4saprutJMYk77RNAf0lFL740G0QjC+rRbH0ybpJ4L8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTVBo2XX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70658606A31C;
	Wed, 18 Nov 2026 19:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTVBo2XX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CFE1F000C4;
	Wed, 18 Nov 2026 19:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031048;
	bh=skcdvMbC2EKXk1jqOHL1y0s0M9Ww/MHWI7uMaQtCpPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTVBo2XXF1GKtEJsWR9R16B8rrpgj6GMfyr/3aUMHNtx939QBa3E6ssumjKbFswHN
	 /y7qpAsqoCNW8vo0h7VEOMYqlcmwjHKtH2zAe4L1+tT6Ezpi3NO3pXrPw3fAuzv1Vv
	 7qmXfxmhD7yieCsB66hMfwuzxqaQbmsTk7+a/crA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0918/1756] efi/libstub: Use cleanup helpers for freeing copies of the memory map
Date: Wed, 18 Nov 2026 15:50:45 +0100
Message-ID: <20261118150046.532268622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit ad69b0b6f9954796875ee4faf6c16c9caca21999 ]

The EFI stub may obtain the memory map from the firmware numerous times,
and this involves doing a EFI pool allocation first, which needs to be
freed after use.

Streamline this using a cleanup helper, which makes the code easier to
follow.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Stable-dep-of: 8ea857a2bb54 ("efi/libstub: Free cmdline_ptr in efi_pe_entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/kaslr.c       |  4 +---
 drivers/firmware/efi/libstub/mem.c         | 20 ++++++++------------
 drivers/firmware/efi/libstub/randomalloc.c |  4 +---
 drivers/firmware/efi/libstub/relocate.c    | 10 ++++------
 drivers/firmware/efi/libstub/x86-stub.c    | 11 ++++++-----
 5 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index 6318c40bda38a..4bc963e999eb9 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -57,7 +57,7 @@ u32 efi_kaslr_get_phys_seed(efi_handle_t image_handle)
  */
 static bool check_image_region(u64 base, u64 size)
 {
-	struct efi_boot_memmap *map;
+	struct efi_boot_memmap *map __free(efi_pool) = NULL;
 	efi_status_t status;
 	bool ret = false;
 	int map_offset;
@@ -80,8 +80,6 @@ static bool check_image_region(u64 base, u64 size)
 		}
 	}
 
-	efi_bs_call(free_pool, map);
-
 	return ret;
 }
 
diff --git a/drivers/firmware/efi/libstub/mem.c b/drivers/firmware/efi/libstub/mem.c
index 4f1fa302234d8..9c82259eea816 100644
--- a/drivers/firmware/efi/libstub/mem.c
+++ b/drivers/firmware/efi/libstub/mem.c
@@ -20,10 +20,10 @@
 efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
 				bool install_cfg_tbl)
 {
+	struct efi_boot_memmap tmp, *m __free(efi_pool) = NULL;
 	int memtype = install_cfg_tbl ? EFI_ACPI_RECLAIM_MEMORY
 				      : EFI_LOADER_DATA;
 	efi_guid_t tbl_guid = LINUX_EFI_BOOT_MEMMAP_GUID;
-	struct efi_boot_memmap *m, tmp;
 	efi_status_t status;
 	unsigned long size;
 
@@ -48,24 +48,20 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
 		 */
 		status = efi_bs_call(install_configuration_table, &tbl_guid, m);
 		if (status != EFI_SUCCESS)
-			goto free_map;
+			return status;
 	}
 
 	m->buff_size = m->map_size = size;
 	status = efi_bs_call(get_memory_map, &m->map_size, m->map, &m->map_key,
 			     &m->desc_size, &m->desc_ver);
-	if (status != EFI_SUCCESS)
-		goto uninstall_table;
+	if (status != EFI_SUCCESS) {
+		if (install_cfg_tbl)
+			efi_bs_call(install_configuration_table, &tbl_guid, NULL);
+		return status;
+	}
 
-	*map = m;
+	*map = no_free_ptr(m);
 	return EFI_SUCCESS;
-
-uninstall_table:
-	if (install_cfg_tbl)
-		efi_bs_call(install_configuration_table, &tbl_guid, NULL);
-free_map:
-	efi_bs_call(free_pool, m);
-	return status;
 }
 
 /**
diff --git a/drivers/firmware/efi/libstub/randomalloc.c b/drivers/firmware/efi/libstub/randomalloc.c
index 593e98e3b993e..fd80b2f3233aa 100644
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -62,9 +62,9 @@ efi_status_t efi_random_alloc(unsigned long size,
 			      unsigned long alloc_min,
 			      unsigned long alloc_max)
 {
+	struct efi_boot_memmap *map __free(efi_pool) = NULL;
 	unsigned long total_slots = 0, target_slot;
 	unsigned long total_mirrored_slots = 0;
-	struct efi_boot_memmap *map;
 	efi_status_t status;
 	int map_offset;
 
@@ -137,7 +137,5 @@ efi_status_t efi_random_alloc(unsigned long size,
 		break;
 	}
 
-	efi_bs_call(free_pool, map);
-
 	return status;
 }
diff --git a/drivers/firmware/efi/libstub/relocate.c b/drivers/firmware/efi/libstub/relocate.c
index bf676dd127a14..d4264bfb6dc17 100644
--- a/drivers/firmware/efi/libstub/relocate.c
+++ b/drivers/firmware/efi/libstub/relocate.c
@@ -23,14 +23,14 @@
 efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align,
 				 unsigned long *addr, unsigned long min)
 {
-	struct efi_boot_memmap *map;
+	struct efi_boot_memmap *map __free(efi_pool) = NULL;
 	efi_status_t status;
 	unsigned long nr_pages;
 	int i;
 
 	status = efi_get_memory_map(&map, false);
 	if (status != EFI_SUCCESS)
-		goto fail;
+		return status;
 
 	/*
 	 * Enforce minimum alignment that EFI or Linux requires when
@@ -82,11 +82,9 @@ efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align,
 	}
 
 	if (i == map->map_size / map->desc_size)
-		status = EFI_NOT_FOUND;
+		return EFI_NOT_FOUND;
 
-	efi_bs_call(free_pool, map);
-fail:
-	return status;
+	return EFI_SUCCESS;
 }
 
 /**
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index b11c46215a81f..d54454cbab1c3 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -617,7 +617,7 @@ static efi_status_t allocate_e820(struct boot_params *params,
 				  struct setup_data **e820ext,
 				  u32 *e820ext_size)
 {
-	struct efi_boot_memmap *map;
+	struct efi_boot_memmap *map __free(efi_pool) = NULL;
 	efi_status_t status;
 	__u32 nr_desc;
 
@@ -631,13 +631,14 @@ static efi_status_t allocate_e820(struct boot_params *params,
 				 EFI_MMAP_NR_SLACK_SLOTS;
 
 		status = alloc_e820ext(nr_e820ext, e820ext, e820ext_size);
+		if (status != EFI_SUCCESS)
+			return status;
 	}
 
-	if (IS_ENABLED(CONFIG_UNACCEPTED_MEMORY) && status == EFI_SUCCESS)
-		status = allocate_unaccepted_bitmap(nr_desc, map);
+	if (IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
+		return allocate_unaccepted_bitmap(nr_desc, map);
 
-	efi_bs_call(free_pool, map);
-	return status;
+	return EFI_SUCCESS;
 }
 
 struct exit_boot_struct {
-- 
2.53.0



