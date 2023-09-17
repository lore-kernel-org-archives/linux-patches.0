Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAF26FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3309DC433C7;
	Sun, 17 Sep 2023 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978613;
	bh=eOMiWgP5zF1XSiJCHa6sk/eeOd8r44tLjlr+X3ecFww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xd8V01Bzv6Ul3iFKGsbUqW2A8f9JVlDV3wy8jRBJjT+FJ9VF8NQeCTDJHTrsEC/P7
	 EdG97svTWlGbTAKBaM0QDeCDJlJboav6kdWwuRnruYrc8wCJlc9phdt8xODkZIWf02
	 mfkgZkDjMwG4wKzz5KaenkaTG7iuwnmpFTiJQLdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikel Rychliski <mikel@mikelr.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/406] x86/efistub: Fix PCI ROM preservation in mixed mode
Date: Sun, 17 Sep 2023 21:08:54 +0200
Message-ID: <20230917191103.243547117@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5d0f1b1966fc6..9f998e6bff957 100644
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



