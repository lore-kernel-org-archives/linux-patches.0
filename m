Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C4A381A5
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDFDbTPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88971C4E778;
	Wed, 15 Nov 2023 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081559;
	bh=djBFG7ovNwvXP8vdPStiPtGn/Yy4R3kwTQLdn7nMOC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDFDbTPcFLJQ/neKKbxCmEJZmUf6w+SKEOGY8RHlUXP0/jh9+rij7FaRnjj336/SZ
	 lpLkCQ4we5i3sRWuQdeicCC6YWeJEOvOPKB/Df9X4R8PH5iBWTxXsbdLcaQ/+q7gAz
	 ElAt1wwYcmbc3C1ej8vtbSTbGdu3nVsvhVT7ZFXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/244] xhci: Loosen RPM as default policy to cover for AMD xHC 1.1
Date: Wed, 15 Nov 2023 15:36:22 -0500
Message-ID: <20231115203559.743866051@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 4baf1218150985ee3ab0a27220456a1f027ea0ac ]

The AMD USB host controller (1022:43f7) isn't going into PCI D3 by default
without anything connected. This is because the policy that was introduced
by commit a611bf473d1f ("xhci-pci: Set runtime PM as default policy on all
xHC 1.2 or later devices") only covered 1.2 or later.

The 1.1 specification also has the same requirement as the 1.2
specification for D3 support. So expand the runtime PM as default policy
to all AMD 1.1 devices as well.

Fixes: a611bf473d1f ("xhci-pci: Set runtime PM as default policy on all xHC 1.2 or later devices")
Link: https://composter.com.ua/documents/xHCI_Specification_for_USB.pdf
Co-developed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20231019102924.2797346-15-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 29a442b621182..d0223facb92a1 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -349,6 +349,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	/* xHC spec requires PCI devices to support D3hot and D3cold */
 	if (xhci->hci_version >= 0x120)
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
+	else if (pdev->vendor == PCI_VENDOR_ID_AMD && xhci->hci_version >= 0x110)
+		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
-- 
2.42.0



