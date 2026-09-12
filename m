Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED06D3644D1;
	Sat, 12 Sep 2026 07:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197476; cv=none; b=pBtRFLy3s6sl902ErySutW18qLm9xrq0AcdMIqiHoHRV+Q21ibIFn+9giea9JdzoihEKEc6r/3PoWXxg5stsUQHuU0gc/rEyHLD6dRwzFc037OLbnzgyho4g5KK51PTHsc1Lo8xsbYfETEmZ/+vpO6Z4jhNefuSRAH+1M50Zs+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197476; c=relaxed/simple;
	bh=y2BuoaVtescd+DIVR1z+9OdrA7/HhrfOKc4EtM1tXHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRkZ4BAPZPdCLQFzW+4vVYRAEuO9PVW6chDHejlsH0YWJeJlnT8N8ANPxycdX5lZkwj/lTeVO1ke383dkESqInp/IJBi6NLNlSsNIwidSF63rvr3oFaTfOUp5bE2Dk4T8JJnL0FTd5QL2kuL2pSMgP7NkdXEbNTXo1YA98z1Rhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ig/lykr1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ig/lykr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E5E1F000FF;
	Sat, 12 Sep 2026 07:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197474;
	bh=0x5qYCCblrwJXuv59N2N7/n1rEaRiNRQj3XRNzvhPlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ig/lykr10t6aHrfbXV3/PVvn2jMwyg3ue+40+7/DGX5Yd0Z6CcwAaHPR05me18Myi
	 lamLceE2LAT4horuvZHs5fygURQ4P4ImqHdwTk/koDf4nE4CnKgCDv3YVOhG3dHOi0
	 6dInqqlzBVwpgvqtXy3Bri5aXuuo+g2bZ2LPRV38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0139/1815] PCI: imx6: Fix building against PCI_HOST_COMMON
Date: Sat, 12 Sep 2026 08:31:29 +0200
Message-ID: <20260912065652.277777484@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d4e0984f12ea958e0f2def90ddb1e193a896932b ]

When CONFIG_PCI_HOST_COMMON is set to =m, the i.MX6 PCIe driver
fails to link. This can happen when only i.MX endpoint mode is
enabled but not host mode, which would indirectly enable the
host-common driver itself.

  ld.lld: error: undefined symbol: pci_host_common_parse_ports
  >>> referenced by pci-imx6.c
  >>>               drivers/pci/controller/dwc/pci-imx6.o:(imx_pcie_host_init) in archive vmlinux.a

  ld.lld: error: undefined symbol: pci_host_common_delete_ports
  >>> referenced by pci-imx6.c
  >>>               drivers/pci/controller/dwc/pci-imx6.o:(imx_pcie_host_init) in archive vmlinux.a
  >>> referenced by pci-imx6.c
  >>>               drivers/pci/controller/dwc/pci-imx6.o:(imx_pcie_host_init) in archive vmlinux.a

Select the common module from the endpoint support directly.

Fixes: 250eea5c06f5 ("PCI: imx6: Parse 'reset-gpios' in Root Port nodes")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260616164049.3656435-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/Kconfig b/drivers/pci/controller/dwc/Kconfig
index aa0b784c85b47..7d49027c67368 100644
--- a/drivers/pci/controller/dwc/Kconfig
+++ b/drivers/pci/controller/dwc/Kconfig
@@ -126,6 +126,7 @@ config PCI_IMX6_EP
 	depends on ARCH_MXC || COMPILE_TEST
 	depends on PCI_ENDPOINT
 	select PCIE_DW_EP
+	select PCI_HOST_COMMON
 	select PCI_IMX6
 	help
 	  Enables support for the PCIe controller in the i.MX SoCs to
-- 
2.53.0



