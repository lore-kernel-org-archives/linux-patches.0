Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B961E1A2B;
	Wed, 19 Feb 2025 08:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954225; cv=none; b=B9ET+gLdUBxwQjLv53bYSMaDu4SFu2+97XcWVypsdvYLradLzjECLL8Zkr1nnzPmvVaaRQ7Rk6sKgfgAuWU+/RcxHBeL9m/OuBC92TuKE0Nu/6AMYIhKWxVtfcX5/48BtKiR6RoVyrKsILNN6qe0ntB/sjXhjmL2My0mK4xV5aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954225; c=relaxed/simple;
	bh=3g0L/UW2xsI24sNhsXfRjVco7kmVmcJdFBlS0u5ECCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naiRNt9kB6jyU+dZmYWSueTUtiAJi0L6dkTT+3shxm2ELyPpEJoRXwmDRseEq+mivNfvWCq/TvwrY2m4RsKIHYjMmmmTWRp8ZAYKz58ykpbla/WQyFD6Hu/2dL5P7BTt2hGO1p7/Lq9Ok2la9WseQXXI+DyijeVV+Q2oRNW3kDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQD3WXkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQD3WXkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB62EC4CED1;
	Wed, 19 Feb 2025 08:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954225;
	bh=3g0L/UW2xsI24sNhsXfRjVco7kmVmcJdFBlS0u5ECCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQD3WXkMl0SypUGpKF8UdwIXBos9nvCh9PU5m2cIOzfVX+TjmOe7/1l1n/sMZl4Mq
	 hU5QVoyEE1NFpVDc0D/inolzUVilIdPu+mKZl46Y3cSmiXd9Wyl/dJV2GhL4Kq9m7L
	 OVmc2I4/elPsg0bf67mUjrUxQ0WF0byNdK8JQJRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Baoqi Zhang <zhangbaoqi@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 135/274] USB: pci-quirks: Fix HCCPARAMS register error for LS7A EHCI
Date: Wed, 19 Feb 2025 09:26:29 +0100
Message-ID: <20250219082614.890899254@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -958,6 +958,15 @@ static void quirk_usb_disable_ehci(struc
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


