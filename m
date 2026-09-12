Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A5538F259;
	Sat, 12 Sep 2026 08:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202294; cv=none; b=rfAfyK6r7UQSWuMZmhYVVnxMkFy+sBlfqyHmELfC7OWqRctIRs2ABbvmngMBLaZxIDgTnRQ/Ki3tOH+O9HSp1P3kdXmEjthP0bONXGT/T6bEV+dfTBs1Wr8vcHCXb5Khxx4fgQn9jnO/VDwQybuRoFs63uiUTBqyJr+nYkQYaPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202294; c=relaxed/simple;
	bh=OHH0uYm6WkeBrnqFHYdUSJ49i71wHe9ykCZAO7d1PxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxvYG5osZO3HlOQshYC9b7gF0ivvbyYFlzEqmTkwZcbIcC6fUUSFCo0xmlQkZMJ8Q5ajRpURvJ+g6/GYS2jA7qpd09PdShZzfXF20F3drPaPhu52fCueWW5327BwB7Xl2s6YsU9QrdALQ8JG4nBQyJESenKv6hWMjHR6/JRj7Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zq6SdQ67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zq6SdQ67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACBC1F000FF;
	Sat, 12 Sep 2026 08:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202292;
	bh=ErlnmFqMzLE0NVLbpACtuKAlinlJ4YbUxqKiJOruDCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zq6SdQ67F2LuNBytz29aRhwN7vUIX31RnkNxmiuhhtR3G/kXGqRMdWIkyGTRL9NyY
	 szB/JvP5JseyoVHrE92Dvc1jhpwwSumbJ2G7OYro3zOUTeaBYUjr0GMzmE7yjSLpAF
	 YmmFf3XVcfF9uUhnvWLaM3Wr0ox7eeUWP536HySk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Aksh Garg <a-garg7@ti.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1172/1815] PCI: cadence: Fix host/endpoint dependencies for cadence-plat driver
Date: Sat, 12 Sep 2026 08:48:42 +0200
Message-ID: <20260912065716.528120864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aksh Garg <a-garg7@ti.com>

[ Upstream commit 79752653c136493ae8c3b4260f9f80de0b91d0bf ]

The cadence-plat driver has a single platform driver that can be built-in
or a loadable module, but it calls two separate backend drivers depending
on whether it is a host or endpoint.

If one of the mode is build as built-in and another as loadable module,
we end up with a situation where the built-in pcie-cadence-plat driver
tries to call the modular host or endpoint driver, which causes a link
failure:

  ld: error: undefined symbol: cdns_pcie_ep_setup
  >>> referenced by pcie-cadence-plat.c
  >>>               drivers/pci/controller/cadence/pcie-cadence-plat.o:(cdns_plat_pcie_probe) in archive vmlinux.a

  ld: error: undefined symbol: cdns_pcie_host_setup
  >>> referenced by pcie-cadence-plat.c
  >>>               drivers/pci/controller/cadence/pcie-cadence-plat.o:(cdns_plat_pcie_probe) in archive vmlinux.a

Fix this by moving the 'select' of PCIE_CADENCE_HOST and PCIE_CADENCE_EP
from the individual PLAT_HOST/PLAT_EP symbols into the common PCIE_CADENCE_PLAT
symbol, conditioned on which backends (modes) are enabled.

Fixes: 611627a4e5e4 ("PCI: cadence: Add module support for platform controller driver")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/linux-next/589ea512-93c6-4e1c-83d7-ba45a0b35843@infradead.org/
Signed-off-by: Aksh Garg <a-garg7@ti.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260805105014.3952686-1-a-garg7@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/cadence/Kconfig b/drivers/pci/controller/cadence/Kconfig
index 9e651d5459735..fd704dec47dda 100644
--- a/drivers/pci/controller/cadence/Kconfig
+++ b/drivers/pci/controller/cadence/Kconfig
@@ -20,11 +20,12 @@ config PCIE_CADENCE_EP
 
 config PCIE_CADENCE_PLAT
 	tristate
+	select PCIE_CADENCE_HOST if PCIE_CADENCE_PLAT_HOST != n
+	select PCIE_CADENCE_EP if PCIE_CADENCE_PLAT_EP != n
 
 config PCIE_CADENCE_PLAT_HOST
 	tristate "Cadence platform PCIe controller (host mode)"
 	depends on OF
-	select PCIE_CADENCE_HOST
 	select PCIE_CADENCE_PLAT
 	help
 	  Say Y here if you want to support the Cadence PCIe platform controller in
@@ -35,7 +36,6 @@ config PCIE_CADENCE_PLAT_EP
 	tristate "Cadence platform PCIe controller (endpoint mode)"
 	depends on OF
 	depends on PCI_ENDPOINT
-	select PCIE_CADENCE_EP
 	select PCIE_CADENCE_PLAT
 	help
 	  Say Y here if you want to support the Cadence PCIe platform controller in
-- 
2.53.0



