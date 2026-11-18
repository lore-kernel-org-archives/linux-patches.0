Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038793;
	b=kUiEpIQbpl3S9ykqdZ7HBwDyBoJCHoHmnTBxeWThYKzTLSjmfAhksGEg3xPwpI6uT0Px
	 kMWMVWOQhud/jRJxEp+LFqYkMfJKELbUM50GnGFNO4yZfGKRA74uCXOyj187UBt1v5shD
	 Spb2OhBppIoEo6PUoL5ypXqIzeMvHtcYYUhH/YluqalUSu+MiKB7ln9ZOYm7gwwumRQPK
	 q1VKvuWDFgakWITS/GAiAQVLm1gMmzXg+Z+CtH/z+KL8tztZgP+9kDRRyNq8RyW+M77hi
	 Kq5z9KgF4N0zcwYlfJyzfliNj8W++y/0YgJIqVq2vo09WpNikozLo/FrXIu1HR+Fktg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qg58qdBI27ehX8jAsjjiTrrMid9vMttaH3i0o/9KLsc=;
	b=BpkOq08nWzADELowUSMiBYH06ma91xupQUQGbHYdPxj3+rQG+h/hHE/wZk/Anl2rLwmm
	 Isb7vHk+gYhzZjNIzj4cNrQ1NhoV4VWLeqSX2hVYhM9BxaUNYWA6vaUZ8+VMXkHIwkOHt
	 +2mXzJOb5MSieZdbXkHnJXtiQ2XZwjDc11Dqn1AUtN7/eB1VKHMj9eAHgriSFOvujZjVV
	 5Om3CmKMbaHPF3R+eEJvvJzKWzXRAqNEwQDKtEV/r+71IQi99+b+yoRELgLWVAplCN1rY
	 JwS8AloQIbON5V9dO9ZKi9u25oWUFGp4a3usO/RYXo7nsGKX4q4BJGnK1Ih17cMb+ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGvtqt8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2AC606A325;
	Wed, 18 Nov 2026 21:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGvtqt8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4C41F000C4;
	Wed, 18 Nov 2026 21:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038793;
	bh=qg58qdBI27ehX8jAsjjiTrrMid9vMttaH3i0o/9KLsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGvtqt8YYvxP4jzyexFun84avjc10jp2cnPTyPSsgipG8EoWI+AOlF6NfvbHnLRdl
	 fELA6i5OMneaF2Z7vrWmlrhQ+eZC+gT91f6oTkyl99psRaGJ1A/f+QdEEp8ddPwBUu
	 oBSL9ziMLVQf6kUI0hIqZxWI/4eNkfPlW7T4jTg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1867/3318] PCI/AER: Fix memory leak in aer_recover_work_func() when pci_dev is missing
Date: Wed, 18 Nov 2026 15:41:29 +0100
Message-ID: <20261118150417.948561980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priyank Rathod <rathodpriyank@google.com>

[ Upstream commit d4c842c3af5bc52b3ca0b8a7f116114e43b6ba44 ]

When ACPI APEI/GHES processes PCIe AER error records, it allocates memory
for aer_capability_regs (entry.regs) from ghes_estatus_pool and queues the
entry into aer_recover_ring.

In aer_recover_work_func(), items are popped from aer_recover_ring via
kfifo_get(). If pci_get_domain_bus_and_slot() fails to find a matching
pci_dev, the code previously executed 'continue', bypassing the call to
ghes_estatus_pool_region_free(). As a result, the memory allocated for
entry.regs from ghes_estatus_pool was leaked.

This is reachable whenever the device reported by firmware is not (or is no
longer) present in the PCI device tree, e.g. after hot-removal or when
firmware reports an error for a device the kernel never enumerated.

Refactor aer_recover_work_func() to ensure ghes_estatus_pool_region_free()
is called unconditionally for every dequeued entry, releasing the pool
memory even when pci_dev is missing.

Fixes: e2abc47a5a1a ("ACPI: APEI: Fix AER info corruption when error status data has multiple sections")
Signed-off-by: Priyank Rathod <rathodpriyank@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928-b4-fix-aer-memleaks-v5-2-ba6b94c9c9a6@google.com
[ sashal: changed pci_print_aer() calls to the existing cper_print_aer() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index bdf7e32529f99..2f7d88353b028 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1005,13 +1005,12 @@ static void aer_recover_work_func(struct work_struct *work)
 	while (kfifo_get(&aer_recover_ring, &entry)) {
 		pdev = pci_get_domain_bus_and_slot(entry.domain, entry.bus,
 						   entry.devfn);
-		if (!pdev) {
+		if (!pdev)
 			pr_err("no pci_dev for %04x:%02x:%02x.%x\n",
 			       entry.domain, entry.bus,
 			       PCI_SLOT(entry.devfn), PCI_FUNC(entry.devfn));
-			continue;
-		}
-		cper_print_aer(pdev, entry.severity, entry.regs);
+		else
+			cper_print_aer(pdev, entry.severity, entry.regs);
 		/*
 		 * Memory for aer_capability_regs(entry.regs) is being allocated from the
 		 * ghes_estatus_pool to protect it from overwriting when multiple sections
@@ -1021,13 +1020,15 @@ static void aer_recover_work_func(struct work_struct *work)
 		ghes_estatus_pool_region_free((unsigned long)entry.regs,
 					      sizeof(struct aer_capability_regs));
 
-		if (entry.severity == AER_NONFATAL)
-			pcie_do_recovery(pdev, pci_channel_io_normal,
-					 aer_root_reset);
-		else if (entry.severity == AER_FATAL)
-			pcie_do_recovery(pdev, pci_channel_io_frozen,
-					 aer_root_reset);
-		pci_dev_put(pdev);
+		if (pdev) {
+			if (entry.severity == AER_NONFATAL)
+				pcie_do_recovery(pdev, pci_channel_io_normal,
+						 aer_root_reset);
+			else if (entry.severity == AER_FATAL)
+				pcie_do_recovery(pdev, pci_channel_io_frozen,
+						 aer_root_reset);
+			pci_dev_put(pdev);
+		}
 	}
 }
 
-- 
2.53.0



