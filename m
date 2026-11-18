Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025694;
	b=1dlqdMtzhOl1a7sTR5fkmMeFhmOydX2E1Jh0Su11n/nHtbASticcTB/Orm1zVvfaKTuc
	 H8V1HB+ffYDw6OV+Du+6f4zk85Xql1ttlqHN8sHmtI3K3zpk1OWEtKbzVyVATHFMIYlsh
	 568TNFvd5foY3wKUAo+Xrisu1HA7OipRujXlA4KiQfaQHD7ESkEHOC1fsoj4kphhTaaPb
	 nzXLxT+ygUtKWzbmwW5MfHZnxYvPeMO0Ml9rTXGaUeEu6VyB1C86hZQ9iNBQe95oNSiTt
	 jhFbxMiB3y5Tk1dzr6zMtB3cb/haM5kyaGpe67QPpQh/SNQaebrwHrh8O0yc7bFVABQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQqp2sTEtyaolp6iDsR+8fzA5HCgY2WiJxElyjUQjrk=;
	b=vCp7829BX7NmMYkiCKio+8Z8kFfrnTcg4NleueR08KDqsAliTNN2pAq4oDRmnO4ismw7
	 0jZaXTmXg7UCqRDXAta/Hr00Yxh1rcOXmLF0dRbRLSU4VKOway30FTyUNPtc4P/pc5aEq
	 Crq7TXVnJhFuLCt0ObzNdTMzBL75yT41pWRhAkQs13L1NJwkFcGGu1Yoa165B7IXNYGBo
	 f8t7SkTMZk9vS9uxWHzJeev6aAT6tdtPV/DwKOh+oirtvl6oQF0q8Gkk7U1jw/J6JAD2y
	 7CiB0JAd97OPKL3pct0CHokS78zoXg7gzgremr7V/NIEaF6ZhA5/B7fOvio17p8mDDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2Ly67t0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8A9606A320;
	Wed, 18 Nov 2026 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2Ly67t0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEFA1F000C4;
	Wed, 18 Nov 2026 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025694;
	bh=wQqp2sTEtyaolp6iDsR+8fzA5HCgY2WiJxElyjUQjrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2Ly67t0a/TJ8d7bKJmn2gDvSfaGzU+1MZYC8Lvnsbi+zmwcLU1GVb31lcdVop1dZ
	 GwSEbt0BYaB3A2F2MIPPxJeD/EaYQaA/WHM3FzKqSkZrJysBJBO9TPgtDCKQyQPO63
	 P0I8Cs+KMZxDXe372VSQs+sn1KyvGW3Ffzyhi6JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1153/2151] efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exit_boot()
Date: Wed, 18 Nov 2026 15:48:08 +0100
Message-ID: <20261118150204.179396643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit d83fe67339f2032d8facf0fe8a047a4c5d15394f ]

Sashiko says fdt_addr can point to either an allocated fdt or the fdt from
get_fdt() which is memory owned by FW.

Only the allocated fdt should be freed on the error unwind path. Use a
dedicated variable for the allocation's size so that the free does not get
confused.

Fixes: 4fc8e738ff3e ("efi: libstub: remove DT dependency from generic stub")
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/fdt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 6a337f1f8787b..b7a2d7aa61b4e 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -229,6 +229,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 	u32 desc_ver;
 	efi_status_t status;
 	struct exit_boot_struct priv;
+	unsigned long fdt_size_allocated = 0;
 	unsigned long fdt_addr = 0;
 	unsigned long fdt_size = 0;
 
@@ -251,12 +252,13 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 		if (strstr(cmdline_ptr, "dtb="))
 			efi_err("Ignoring DTB from command line.\n");
 	} else {
-		status = efi_load_dtb(image, &fdt_addr, &fdt_size);
+		status = efi_load_dtb(image, &fdt_addr, &fdt_size_allocated);
 
 		if (status != EFI_SUCCESS && status != EFI_NOT_READY) {
 			efi_err("Failed to load device tree!\n");
 			goto fail;
 		}
+		fdt_size = fdt_size_allocated;
 	}
 
 	if (fdt_addr) {
@@ -334,7 +336,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 	efi_free(MAX_FDT_SIZE, *new_fdt_addr);
 
 fail:
-	efi_free(fdt_size, fdt_addr);
+	efi_free(fdt_size_allocated, fdt_addr);
 	if (!efi_novamap)
 		efi_bs_call(free_pool, priv.runtime_map);
 
-- 
2.53.0



