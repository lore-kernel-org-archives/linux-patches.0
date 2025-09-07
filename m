Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7304189BB0;
	Sun,  7 Sep 2025 20:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276695; cv=none; b=Y5l0ql058TnTrfQFg1TaMUK5VoGaYoJBke+i7OmpxxfKqkduXBgGkB9jLZEDX2J4WVc/xFNB+iGuamPYmapWrWcpLsHsw+IfTKRD0etPJS5WHg2ZcN2oR4r6QBgcVoV9TfDXJpUaYiB09KFOEezMLgUisSxuC34ntGOuE81/3gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276695; c=relaxed/simple;
	bh=2WyPavsNqRawZXGBt5jB4f3QBMs5cPHIxOkROJ/IyrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mS/j+OCjwyvQC9U6tsk3fRXEvNpY1ticdaVNdDqhLtl6tJM3g1VQMne7l44+5FHnlBYZ74CNzI01S7zncEvlaYcBQqF+EQq/Z4UytamiEt5cEa0mJCLjkVMjaniBpQ7nN41u3BROqMJwxINR39J/yQdhAYb2uLzqJU9l0yClY2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdvYqF2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdvYqF2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B9CC4CEF0;
	Sun,  7 Sep 2025 20:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276695;
	bh=2WyPavsNqRawZXGBt5jB4f3QBMs5cPHIxOkROJ/IyrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdvYqF2JvTDaPK8qQLtfXvpDANfjxoQ6T3QQ9JRsGJB/Hy9uLhQNmeD0i9AbCyR/x
	 fLP/jxz4s3e9rnt2czp3PDhzDF/FuzS9XdlSTUCfP6A0shDCrVm2185AlHVd1HdnRu
	 FSDX1CEF9viqHdytB8/7FL2K+DD3r8ZKUwgqoMv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Currier <dullfire@yahoo.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/121] PCI/MSI: Add an option to write MSIX ENTRY_DATA before any reads
Date: Sun,  7 Sep 2025 21:58:36 +0200
Message-ID: <20250907195611.890788497@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Currier <dullfire@yahoo.com>

[ Upstream commit cf761e3dacc6ad5f65a4886d00da1f9681e6805a ]

Commit 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X entries") introduced a
readl() from ENTRY_VECTOR_CTRL before the writel() to ENTRY_DATA.

This is correct, however some hardware, like the Sun Neptune chips, the NIU
module, will cause an error and/or fatal trap if any MSIX table entry is
read before the corresponding ENTRY_DATA field is written to.

Add an optional early writel() in msix_prepare_msi_desc().

Fixes: 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X entries")
Signed-off-by: Jonathan Currier <dullfire@yahoo.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241117234843.19236-2-dullfire@yahoo.com
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi/msi.c |    3 +++
 include/linux/pci.h   |    2 ++
 2 files changed, 5 insertions(+)

--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -610,6 +610,9 @@ void msix_prepare_msi_desc(struct pci_de
 	if (desc->pci.msi_attrib.can_mask) {
 		void __iomem *addr = pci_msix_desc_addr(desc);
 
+		/* Workaround for SUN NIU insanity, which requires write before read */
+		if (dev->dev_flags & PCI_DEV_FLAGS_MSIX_TOUCH_ENTRY_DATA_FIRST)
+			writel(0, addr + PCI_MSIX_ENTRY_DATA);
 		desc->pci.msix_ctrl = readl(addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
 	}
 }
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -245,6 +245,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
 	/* Device does honor MSI masking despite saying otherwise */
 	PCI_DEV_FLAGS_HAS_MSI_MASKING = (__force pci_dev_flags_t) (1 << 12),
+	/* Device requires write to PCI_MSIX_ENTRY_DATA before any MSIX reads */
+	PCI_DEV_FLAGS_MSIX_TOUCH_ENTRY_DATA_FIRST = (__force pci_dev_flags_t) (1 << 13),
 };
 
 enum pci_irq_reroute_variant {


