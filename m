Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B5125BACC;
	Tue, 11 Mar 2025 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707123; cv=none; b=uP4vBkJUtVtGhJXpBCFYLixhG4W0CLbwKWfvsxGfpRo/FrSwbLduV9cDhGa7a0mlQBA2Ute0IQp9Lz+0Dj6atNiUKvnGQSPBHsuNJLayKFd0zXcfA2/AlMUAw2CbrUJ+2IKMsVpcw1aCTno/o0s2sEub6p91KLDDfjZqQ9fJF8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707123; c=relaxed/simple;
	bh=4l1JZ817b1HtvHlGnuuiVDTU5h/ocWFQQwRrcb6/qyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iv/5lbzOyuScH2W4cqqYCPX5YcB2XJE+yVJWiohqBDsH8WZ/1rXOVwVTOTyRQTiJNJT8r7y1bJTDL1zZjWHqqQv2gf8ZJEEKJW15zWP5H1nRBPld7o+Ep9IwRTDNv2fDgE//HsBJBy2u2fnmS8TB0r98YCukLjHRMZZZJVnlAIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ahgtzlov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ahgtzlov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB7CC4CEE9;
	Tue, 11 Mar 2025 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707122;
	bh=4l1JZ817b1HtvHlGnuuiVDTU5h/ocWFQQwRrcb6/qyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ahgtzlov99q5j5Myekrr4V/SZVdc/77LaAc/LK4DZNjCkGzfbc/2O3cJNLT1SzPCC
	 8NVbCKH08NcN5KgPgyaxCbZvQ4omzCSUm/+lM+fDlbJsg5LoikAi9PxvfSf2WNkmSM
	 AP99Bs+ROQcF2mfvINzU1CGNPqHJpKdRGzTh5Yo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Baoqi Zhang <zhangbaoqi@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 5.10 250/462] USB: pci-quirks: Fix HCCPARAMS register error for LS7A EHCI
Date: Tue, 11 Mar 2025 15:58:36 +0100
Message-ID: <20250311145808.238934953@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit e71f7f42e3c874ac3314b8f250e8416a706165af upstream.

LS7A EHCI controller doesn't have extended capabilities, so the EECP
(EHCI Extended Capabilities Pointer) field of HCCPARAMS register should
be 0x0, but it reads as 0xa0 now. This is a hardware flaw and will be
fixed in future, now just clear the EECP field to avoid error messages
on boot:

......
[    0.581675] pci 0000:00:04.1: EHCI: unrecognized capability ff
[    0.581699] pci 0000:00:04.1: EHCI: unrecognized capability ff
[    0.581716] pci 0000:00:04.1: EHCI: unrecognized capability ff
[    0.581851] pci 0000:00:04.1: EHCI: unrecognized capability ff
......
[    0.581916] pci 0000:00:05.1: EHCI: unrecognized capability ff
[    0.581951] pci 0000:00:05.1: EHCI: unrecognized capability ff
[    0.582704] pci 0000:00:05.1: EHCI: unrecognized capability ff
[    0.582799] pci 0000:00:05.1: EHCI: unrecognized capability ff
......

Cc: stable <stable@kernel.org>
Signed-off-by: Baoqi Zhang <zhangbaoqi@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/r/20250202124935.480500-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/pci-quirks.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -948,6 +948,15 @@ static void quirk_usb_disable_ehci(struc
 	 * booting from USB disk or using a usb keyboard
 	 */
 	hcc_params = readl(base + EHCI_HCC_PARAMS);
+
+	/* LS7A EHCI controller doesn't have extended capabilities, the
+	 * EECP (EHCI Extended Capabilities Pointer) field of HCCPARAMS
+	 * register should be 0x0 but it reads as 0xa0.  So clear it to
+	 * avoid error messages on boot.
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_LOONGSON && pdev->device == 0x7a14)
+		hcc_params &= ~(0xffL << 8);
+
 	offset = (hcc_params >> 8) & 0xff;
 	while (offset && --count) {
 		pci_read_config_dword(pdev, offset, &cap);


