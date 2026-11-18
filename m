Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018809;
	b=Y4nXQvRD4DAjrLTlaabEjHKMp8T4n8uEg3oojox4ajr0wOw1z08mLFxgcYPZOGqDHlD2
	 PTDiFGGWbyi0AuZvGdFQ9G3cG5Vff2MuSqrqFRoOV7I1BRfmrMZ9xvzpWYpKd0eJPgWwR
	 RbtmV5M9ANY5wZB8glyDXZIsj2/cdn+QUpIF3vYSIPsTpP/DHO/1AHgCauwed0cBXA9Ys
	 WxK/n1DgiCfTpEPbTKl5TFYeronHxpLF6asJZOKuZV6R0+doABK/TXbzv5LQfEXoqJEnX
	 sGLYfRX5iaZBhtaKUOMWykF1poZLJUXtuKKtQKYspi4ORRfcY5TLY72Wf8uzckr38Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z5hIjkHGSE8C+hl48JFWhgCwvq9N1f441gm0G+qqY7o=;
	b=YkfgG7kkXca5z/7JJ2P4sZPyXsZ31aMvTA9TOptyys3QFDFmwcFuyiL9oUqVQlPbuadS
	 3tVtLMtjzY8abfaAl17l845NZUBoZPx9fG5gMwDdpd5VazsAXOYgWuBRbuxtUNfRp+c6N
	 hjeas2W402wQo3O2w5D2l/X4lsRskCclb4jZlHglj0CT/jc5URwL4c/ehIEMPIiGBLNNO
	 Mux4XLz6lhbZ65tLESOb8CWUvum55NTbczktdV1gE1clcsbEcwrpafYrUB/QyNFphesFR
	 o6VfaHTfpVlzvL5c+4aQiN1pZqn0rNrts+X1rv/phpY7CGcA/tKMvdOe4rK97OiMgnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLHVst17;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8C1606A330;
	Wed, 18 Nov 2026 16:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLHVst17
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CAB1F000C5;
	Wed, 18 Nov 2026 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018809;
	bh=z5hIjkHGSE8C+hl48JFWhgCwvq9N1f441gm0G+qqY7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLHVst17WeLM950Jf4g0JeHf1OzBI1ZTXJxgK6aeMSk2r8RM39nzlBCwyjW6n+PtE
	 Pi6iTsiSv+/d3xWgqNannE79z74vLXOSGh4oM39WNoa/NZESIJiD4mSyiOKgjTeghk
	 zekNDcoquXA18IlLbNxg1qAQKdtMX8OTwxD2UyEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1372/2651] efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exit_boot()
Date: Wed, 18 Nov 2026 15:43:32 +0100
Message-ID: <20261118150337.422121061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 23b3543d3041b..f01450b499754 100644
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



