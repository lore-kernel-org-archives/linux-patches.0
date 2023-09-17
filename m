Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBCC6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E97C433CA;
	Sun, 17 Sep 2023 20:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981602;
	bh=Rg5DUJ2SIAsZ9xzy717JrDsr/u6SdSr8YULNb8Cbrd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eh5+EPqMyYxorTkxEF89YcrzYu5mYQZjbuYuon4+yG1/WapvbiIkJxtmNqM/elGJm
	 2+KvoujAtjzdTyI8nZnhS2UAy2woWnPCvn61oFL+IDkC/hRCaAlRs/YDnuvXfUSKgE
	 HVM9Cj9LMnuPqpH9NgvZx9ADUv39mOLK0mC9Y5ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikel Rychliski <mikel@mikelr.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/511] x86/efistub: Fix PCI ROM preservation in mixed mode
Date: Sun, 17 Sep 2023 21:08:24 +0200
Message-ID: <20230917191115.735090149@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Mikel Rychliski <mikel@mikelr.com>

[ Upstream commit 8b94da92559f7e403dc7ab81937cc50f949ee2fd ]

preserve_pci_rom_image() was accessing the romsize field in
efi_pci_io_protocol_t directly instead of using the efi_table_attr()
helper. This prevents the ROM image from being saved correctly during a
mixed mode boot.

Fixes: 2c3625cb9fa2 ("efi/x86: Fold __setup_efi_pci32() and __setup_efi_pci64() into one function")
Signed-off-by: Mikel Rychliski <mikel@mikelr.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/x86-stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index 72162645b553e..1cb4466e3c108 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -60,7 +60,7 @@ preserve_pci_rom_image(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
 	rom->data.type	= SETUP_PCI;
 	rom->data.len	= size - sizeof(struct setup_data);
 	rom->data.next	= 0;
-	rom->pcilen	= pci->romsize;
+	rom->pcilen	= romsize;
 	*__rom = rom;
 
 	status = efi_call_proto(pci, pci.read, EfiPciIoWidthUint16,
-- 
2.40.1



