Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD233EDE49;
	Tue, 12 May 2026 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608714; cv=none; b=S2V+HPXb4XTAQ3mx+x9pq7kB2NLy9cObgNmTI183h1ZFPnlHfmoCxWPAhUcVDfw9u6o5UUEPLVI8fyFeOucQMbIqDcGedCEinadO6Y+i2dNBdnilUdwRJl2prK5TpEzdDdo7rna6ThdzAy9cbKknRZbRgS3rc4tWBdGIl5tJQLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608714; c=relaxed/simple;
	bh=iAEJECpm80IwgFHUyceq83dynUxOff6VIo5w4TJRsnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsiYM14Nr1Gt+yp+yCdSyLFtdQOwg0j4l54TZ48PMIdPv+kyiXA3PBhprMfODDxOhJfTx4DxTFockq+BKqI0irMXWN0HHsyZEfWeeSaWSUulByFfQGMfNBrxUXfWQQnENaJoqPgs26NVzhCHRQ6os5KwSd6Wt7EjWEPWj04a1Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYNtGmIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYNtGmIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8481BC2BCB0;
	Tue, 12 May 2026 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608713;
	bh=iAEJECpm80IwgFHUyceq83dynUxOff6VIo5w4TJRsnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYNtGmIWB9yzca3HKBI7OT2z3AkHDF91QsF9tETe1HXBsOcQLN04uKWH3LNgkJKjA
	 XeGGuYFgxoMBKMsw9dCiNgBQc9rLwMAcYl2Bv9htLtzjJgAw0x8NlcMjfGi4rAhkPR
	 lU5wUyzmGWKS/K2dsg43MFy8KwQD0cIISYySNzY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.18 186/270] PCI/AER: Clear only error bits in PCIe Device Status
Date: Tue, 12 May 2026 19:39:47 +0200
Message-ID: <20260512173942.364734438@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit a8aeea1bf3c80cc87983689e0118770e019bd4f3 upstream.

Currently, pcie_clear_device_status() clears the entire PCIe Device Status
register (PCI_EXP_DEVSTA) by writing back the value read from the register,
which affects not only the error status bits but also other writable bits.

According to PCIe r7.0, sec 7.5.3.5, this register contains:

  - RW1C error status bits (CED, NFED, FED, URD at bits 0-3): These are the
    four error status bits that need to be cleared.

  - Read-only bits (AUXPD at bit 4, TRPND at bit 5): Writing to these has
    no effect.

  - Emergency Power Reduction Detected (bit 6): A RW1C non-error bit
    introduced in PCIe r5.0 (2019). This is currently the only writable
    non-error bit in the Device Status register. Unconditionally clearing
    this bit can interfere with other software components that rely on this
    power management indication.

  - Reserved bits (RsvdZ): These bits are required to be written as zero.
    Writing 1s to them (as the current implementation may do) violates the
    specification.

To prevent unintended side effects, modify pcie_clear_device_status() to
only write 1s to the four error status bits (CED, NFED, FED, URD), leaving
the Emergency Power Reduction Detected bit and reserved bits unaffected.

Fixes: ec752f5d54d7 ("PCI/AER: Clear device status bits during ERR_FATAL and ERR_NONFATAL")
Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260211124624.49656-1-xueshuai@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2272,10 +2272,9 @@ EXPORT_SYMBOL_GPL(pci_set_pcie_reset_sta
 #ifdef CONFIG_PCIEAER
 void pcie_clear_device_status(struct pci_dev *dev)
 {
-	u16 sta;
-
-	pcie_capability_read_word(dev, PCI_EXP_DEVSTA, &sta);
-	pcie_capability_write_word(dev, PCI_EXP_DEVSTA, sta);
+	pcie_capability_write_word(dev, PCI_EXP_DEVSTA,
+				   PCI_EXP_DEVSTA_CED | PCI_EXP_DEVSTA_NFED |
+				   PCI_EXP_DEVSTA_FED | PCI_EXP_DEVSTA_URD);
 }
 #endif
 


