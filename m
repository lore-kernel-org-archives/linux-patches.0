Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2544522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A70C433C7;
	Sun,  9 Jul 2023 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902589;
	bh=1kX83TQ70SRHfLdfSTNBl/QhwH5MTVWucoIT5t7/3Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2B8acMnq95FegAhYXTOAkkJeX4jef9CtXohmJnfloww0TyPKd6iCqpelPhFjdBdc
	 mDg7y7lprSI5Wvxj0cVAHUWCsHR0AWNPshXEKXQI7py2wZYbyjBDhKbKulUBixkSuB
	 9F03UIfEHKLdEaVpjl/JjkoHo/wn+uNovVZRD9k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Glenn Washburn <development@efficientek.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 423/431] efi/libstub: Disable PCI DMA before grabbing the EFI memory map
Date: Sun,  9 Jul 2023 13:16:11 +0200
Message-ID: <20230709111501.100955812@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
 drivers/firmware/efi/libstub/efi-stub-helper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 1e0203d74691f..732984295295f 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -378,6 +378,9 @@ efi_status_t efi_exit_boot_services(void *handle, void *priv,
 	struct efi_boot_memmap *map;
 	efi_status_t status;
 
+	if (efi_disable_pci_dma)
+		efi_pci_disable_bridge_busmaster();
+
 	status = efi_get_memory_map(&map, true);
 	if (status != EFI_SUCCESS)
 		return status;
@@ -388,9 +391,6 @@ efi_status_t efi_exit_boot_services(void *handle, void *priv,
 		return status;
 	}
 
-	if (efi_disable_pci_dma)
-		efi_pci_disable_bridge_busmaster();
-
 	status = efi_bs_call(exit_boot_services, handle, map->map_key);
 
 	if (status == EFI_INVALID_PARAMETER) {
-- 
2.39.2



