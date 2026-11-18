Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041045;
	b=ScOrIv9Dw4zw036278Ai1L7MFCFpcirKRCKVvrVly6e276p/etsUhfV1qUtK2SQJ2/vd
	 1pg3WUBG97qpEBxVG21wSMMoGvhJuUMn3TAiwDPicdh8S0Hab1YyVnRBb3eTIkUYZBpLi
	 C2K0fVN03Qcpv0dUPbvYvcdlcEBzU1gSSoEtmZKp0T/iBFeH/IC2o+fjBwUsuP8ZipTaW
	 u22jgRunQtLFfQo20g0mCqiX85w9Dz9jt14kxa3pRqK4LiKiHmRZMRPaXTsYA4stf0FB7
	 JljlHhPCNNu353kLgHA+JBsrU3BMCxH/B3D0DtapioVMO/pa3WWb5YTIAyCPWJoOSRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5xk+lfFtROfqT8f9Hwa8hLDBxwaSxka6m+74wh6/lhg=;
	b=DK7kmfCg7Cueu4Gsh2EEZv/nI9aTH2KsqgnWt7K9m+vszYfJ4qpCmkvsWVNMoZ3nfb4n
	 Nx1H8HrG9AOuwHA1mHKBCuDwnHTpEBNuehgakWJ8Q6J8wDJl2caTk46e6vsBDqOAAbm44
	 +4NYnJ097952rdzEuPBCTwcHP5DgTPv7usBVG/+42hAewRhca5Sw/oF+fr8Zjov2QZOBp
	 VPKcmhP7+ivjuY027pLzviZTzfT/GxWjRoDPKeX8QQyM/PB7cbeTB1KMztICBtfDPX4NZ
	 BbR4yI3sqyoHtFwy6lSoZWh7WY5sFnSuMFUZL+flK/9PkLYCKak0PKfs2eTL0EQWugw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GE55HgWj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E712C606A31C;
	Wed, 18 Nov 2026 22:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GE55HgWj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F881F000C5;
	Wed, 18 Nov 2026 22:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041044;
	bh=5xk+lfFtROfqT8f9Hwa8hLDBxwaSxka6m+74wh6/lhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GE55HgWjy7s9+IRZtzWgKp6c024nwSL04K4na1s+6pRYfv3AYik/nz4Q9BjJLEpgG
	 OeeDXTG7xHFeS0uYBQuXxILcPnlPGAuB55etWMxEEeIWMdNkiNqaClz9R9cmlTKj36
	 Eygws3st9+3U5ivHqu5QYc3mrlzkCWQBJpd0IWzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2633/3318] efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exit_boot()
Date: Wed, 18 Nov 2026 15:54:15 +0100
Message-ID: <20261118150440.079347521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



