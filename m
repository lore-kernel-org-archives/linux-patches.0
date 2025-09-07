Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5191A9FAA;
	Sun,  7 Sep 2025 20:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276288; cv=none; b=P2mvqzGtS+E1K4R7Vyg058t2X4Hu+3/pFXrYqxwqhkdPGOHz7uIQxVsCcHVDNR9MIQBYvD1mD8DYTJSjwOrvcGb+KhgrTolWKqFMNPA8DfBIKgTVk3P95bl/iFlg4UFL+rCRD38Snlb2Rnf3Bw3+7xsWXQhKCfaz+y+J2P6kq74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276288; c=relaxed/simple;
	bh=dQVJ0YlzUYsxA7FJaFiFc1IZxErGHEU/Bd4erPjkI3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln4k5oS/HnVg3T+6GUPIE7gWLKZjM1sehReOXZe8Ef5TDykSA3l/2ZYCqVN/KTiCfAY0fEfqNraIWyVneZcpQmIvAVsaJ+OmyIkGCwh+GqfVA3VxPTT1zPQyvnzofpES3gGyKN9ixCaquwtDDqVijIV7u9/VpfhAcEs80OvfYQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqtBqBVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqtBqBVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71894C4CEF0;
	Sun,  7 Sep 2025 20:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276287;
	bh=dQVJ0YlzUYsxA7FJaFiFc1IZxErGHEU/Bd4erPjkI3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqtBqBVfFkyD7WZx7ZsDbidKQw0Fzbw+ciEvGv6Duv46tCt1ri2s1zaSSgTIM5Dmt
	 0mloUuk3bC8aPhZxZVt+uLYNNsLTwsYWgQ4bdOYupeKx6kG+AjrsJwN/r8xJejxNQi
	 TzEl9c2j2wBWiSGMVswiNnR2a2U4Kb/JUOuhRU4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Currier <dullfire@yahoo.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/104] PCI/MSI: Add an option to write MSIX ENTRY_DATA before any reads
Date: Sun,  7 Sep 2025 21:58:12 +0200
Message-ID: <20250907195609.111892123@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Applied workaround to msix_setup_msi_descs() instead of msix_prepare_msi_desc() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi/msi.c |    3 +++
 include/linux/pci.h   |    2 ++
 2 files changed, 5 insertions(+)

--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -534,6 +534,9 @@ static int msix_setup_msi_descs(struct p
 
 		if (desc.pci.msi_attrib.can_mask) {
 			addr = pci_msix_desc_addr(&desc);
+			/* Workaround for SUN NIU insanity, which requires write before read */
+			if (dev->dev_flags & PCI_DEV_FLAGS_MSIX_TOUCH_ENTRY_DATA_FIRST)
+				writel(0, addr + PCI_MSIX_ENTRY_DATA);
 			desc.pci.msix_ctrl = readl(addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
 		}
 
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -244,6 +244,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
 	/* Device does honor MSI masking despite saying otherwise */
 	PCI_DEV_FLAGS_HAS_MSI_MASKING = (__force pci_dev_flags_t) (1 << 12),
+	/* Device requires write to PCI_MSIX_ENTRY_DATA before any MSIX reads */
+	PCI_DEV_FLAGS_MSIX_TOUCH_ENTRY_DATA_FIRST = (__force pci_dev_flags_t) (1 << 13),
 };
 
 enum pci_irq_reroute_variant {


