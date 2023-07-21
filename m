Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E6B200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAB6C433C8;
	Fri, 21 Jul 2023 19:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966160;
	bh=HVh57GH8wOXrHbikRGpZWS4eh5229SUEU0IKY/VcES0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVvF93n35PVMrRBdTKEfT8032lrSYAnFihjPLDA8uEAtqDNmbH83saWwilS2Y6loT
	 Lfr/X6Zg9PiVTGbKeAApO/7Re5YhtBA44LKxX2+mg2G18En9g35T/hdGuynFvsrjp/
	 h1ZmGZ+2lhexhzZbBGyk66Kt0ug6C5olSZ5CIInI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Glenn Washburn <development@efficientek.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/532] efi/libstub: Disable PCI DMA before grabbing the EFI memory map
Date: Fri, 21 Jul 2023 18:02:29 +0200
Message-ID: <20230721160627.648060341@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 2e28a798c3092ea42b968fa16ac835969d124898 ]

Currently, the EFI stub will disable PCI DMA as the very last thing it
does before calling ExitBootServices(), to avoid interfering with the
firmware's normal operation as much as possible.

However, the stub will invoke DisconnectController() on all endpoints
downstream of the PCI bridges it disables, and this may affect the
layout of the EFI memory map, making it substantially more likely that
ExitBootServices() will fail the first time around, and that the EFI
memory map needs to be reloaded.

This, in turn, increases the likelihood that the slack space we
allocated is insufficient (and we can no longer allocate memory via boot
services after having called ExitBootServices() once), causing the
second call to GetMemoryMap (and therefore the boot) to fail. This makes
the PCI DMA disable feature a bit more fragile than it already is, so
let's make it more robust, by allocating the space for the EFI memory
map after disabling PCI DMA.

Fixes: 4444f8541dad16fe ("efi: Allow disabling PCI busmastering on bridges during boot")
Reported-by: Glenn Washburn <development@efficientek.com>
Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index d489bdc645fe1..2a00eb627c3c3 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -439,8 +439,10 @@ efi_status_t efi_exit_boot_services(void *handle,
 {
 	efi_status_t status;
 
-	status = efi_get_memory_map(map);
+	if (efi_disable_pci_dma)
+		efi_pci_disable_bridge_busmaster();
 
+	status = efi_get_memory_map(map);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -448,9 +450,6 @@ efi_status_t efi_exit_boot_services(void *handle,
 	if (status != EFI_SUCCESS)
 		goto free_map;
 
-	if (efi_disable_pci_dma)
-		efi_pci_disable_bridge_busmaster();
-
 	status = efi_bs_call(exit_boot_services, handle, *map->key_ptr);
 
 	if (status == EFI_INVALID_PARAMETER) {
-- 
2.39.2



