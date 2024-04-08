Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1711745D6;
	Mon,  8 Apr 2024 13:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583920; cv=none; b=f8/ZPUbwcWxPJGkg6f9CX4xTqGnPCmWH7q4AjWvyKR4u8DnRMIte4jxvElqCh78i9ocgAnyGO3wYQ0IhFb4Erk0iMSlplN/hRASlD/bi+gaZCfYNCdXYP2tItxbtpO/IHLoESCOru/6kSzbO00lQJ/nIsuRVDCUykvZ3pVCBqi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583920; c=relaxed/simple;
	bh=eMs8QAUHdZoo3JHSiCgbYpdOj4YlIqcpQjsX/DBJaYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLAy+HN1rakhDbxE4Q3TbPExhjt4f3tw4lLz9idDXcxGntx8qdrzchcNiw2szl0eEZkGshisWFj1Ln+KXfFQI/JoJwlH0CR3VbjWIOS+sVmut0Lz2Tvt7pY1vj4RUV+/qShzXzEa0WgqW9HUHZnlPyU78oSImSLGMdLS3ingFSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arcg+E1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arcg+E1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771D9C433C7;
	Mon,  8 Apr 2024 13:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583919;
	bh=eMs8QAUHdZoo3JHSiCgbYpdOj4YlIqcpQjsX/DBJaYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arcg+E1KZrN33prt2sFHBh0XEEOTfqkCzjmPLyAyjIm8IyUrKMJ5QdOO+RQrCB/ZE
	 jn7dYO8+eTn+l83CbHswPO0ZASIFvZy/eLc1EQwIPLDIzD0GNwdUO5qdQh4ZKXSK2V
	 5XU8x83zyLTJM6dGmnRPpo6B8pvOKglDB1zP/8L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.6 249/252] efi/libstub: Add generic support for parsing mem_encrypt=
Date: Mon,  8 Apr 2024 14:59:08 +0200
Message-ID: <20240408125314.384775944@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 7205f06e847422b66c1506eee01b9998ffc75d76 upstream.

Parse the mem_encrypt= command line parameter from the EFI stub if
CONFIG_ARCH_HAS_MEM_ENCRYPT=y, so that it can be passed to the early
boot code by the arch code in the stub.

This avoids the need for the core kernel to do any string parsing very
early in the boot.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240227151907.387873-16-ardb+git@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c |    8 ++++++++
 drivers/firmware/efi/libstub/efistub.h         |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -24,6 +24,8 @@ static bool efi_noinitrd;
 static bool efi_nosoftreserve;
 static bool efi_disable_pci_dma = IS_ENABLED(CONFIG_EFI_DISABLE_PCI_DMA);
 
+int efi_mem_encrypt;
+
 bool __pure __efi_soft_reserve_enabled(void)
 {
 	return !efi_nosoftreserve;
@@ -75,6 +77,12 @@ efi_status_t efi_parse_options(char cons
 			efi_noinitrd = true;
 		} else if (IS_ENABLED(CONFIG_X86_64) && !strcmp(param, "no5lvl")) {
 			efi_no5lvl = true;
+		} else if (IS_ENABLED(CONFIG_ARCH_HAS_MEM_ENCRYPT) &&
+			   !strcmp(param, "mem_encrypt") && val) {
+			if (parse_option_str(val, "on"))
+				efi_mem_encrypt = 1;
+			else if (parse_option_str(val, "off"))
+				efi_mem_encrypt = -1;
 		} else if (!strcmp(param, "efi") && val) {
 			efi_nochunk = parse_option_str(val, "nochunk");
 			efi_novamap |= parse_option_str(val, "novamap");
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -37,8 +37,8 @@ extern bool efi_no5lvl;
 extern bool efi_nochunk;
 extern bool efi_nokaslr;
 extern int efi_loglevel;
+extern int efi_mem_encrypt;
 extern bool efi_novamap;
-
 extern const efi_system_table_t *efi_system_table;
 
 typedef union efi_dxe_services_table efi_dxe_services_table_t;


