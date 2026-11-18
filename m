Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049344;
	b=2uvIfrGPuDNrbJH//+WGwMztest231hq7EYwPTZxXg9hoCpnYodIOV22H8aoQT/NTT37
	 AIFd3+ZEuSfqHiRve6jWaGmUzSFmh9L6zFBgTzJNkD3Ytz76S7WdjXdPHc0Ik9CNFs8WO
	 BpDPtFvszG1VqmnPc+yOEUXlaBdiZjL0tVnXjoM9Qrt6cxmJM/7+buBQ/pLfkI3aL8CCq
	 yf3qYdM/8mcOe+F5oOcC0TAj6UeHAW6tAddO8k1uqgCOaZwvncDNuLOEWASwoJn+AmoS3
	 RrXgoZ+0WI32jW1UpgoAWBl2hZ7N6m0f1uY9fRKRhcULGjKxNjj8QBM7yiLoOzHelvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7tlDrvjKvmBkIwL9unLcCcqQmTmuenWlR7yVG5NuDx8=;
	b=y8MvJxIOZ0eYRWuLGZxbhMt2OJBPhOLpthcjtX9Zq2KZ1EhHx2vgbEmgq7wM+ZEt6Gw6
	 t/mxtAZAW51lgeExQOxxP8pn3hiQx95AKeoU/MCk/h0skzHaWnSgWL2lK5d3b0o2FG/Ue
	 rWkU+dJQP6dCgkA4ZO9gYnVDpgLoZYbTxGd0lj0DyjTdnQLyhJ2em4gWaPrttpGqNftso
	 F9esDmuKhGhhNZVF1DsaZyG9cLK/JgXb5rN7HDubvW4ehpzYrqRSPaiVp2ova/yPiF/mZ
	 RF7cPfESMMtbg7cnedj+rPYfUXCTr66C0yJd0mJyDDfEq/iNOW/dek011HM6iP4d7FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSO+hXKL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF8160A2600;
	Thu, 19 Nov 2026 00:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSO+hXKL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19731F000C5;
	Thu, 19 Nov 2026 00:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049344;
	bh=7tlDrvjKvmBkIwL9unLcCcqQmTmuenWlR7yVG5NuDx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSO+hXKLlit8cUE4oafLLxApHocq2WZLkEaAvnKh1LdvCAJr7jYUxFTTsh3nIQYeb
	 HCFWHytwvnkjMz+FdAFgmv3F757DlMaoQxQlVEWESy1BzFjKpnl/MbDMPyg0O4q/wq
	 MY4JgxUJmby4kd66oW55uMXxbZxtSCRZ/bWf+/kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2277/2857] efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exit_boot()
Date: Wed, 18 Nov 2026 15:55:11 +0100
Message-ID: <20261118150323.440658681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



