Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10C53644D1;
	Sat, 12 Sep 2026 07:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197480; cv=none; b=uabfdbnTG03Ls3WOzwgikmRHeneQGbtiDqVGDnppOz7y91T5U9E+MJNwD+X8x1gE5ydbj0Jzdlbd59lFZyk0pTcvt+qaDlOlKMcSkEv7u9wbpzbubP6NvYOqbRuxp7Us7I1kFVw3Qt6jnV0/HDlAbbJHtrybrXnbjZy7Iw+1YEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197480; c=relaxed/simple;
	bh=Wcc75G26KdkC4sRvATSZiLZu8WQRyaJ0rvDW9pwkRyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+IFZC34aeSv9+5rXcRZhWrIM12JFcuKJvveR889UKEHdFKZMPOjSihvQk0T2vi9ivpC4us9oVfGJV8gcBuH8iYHiNmtKGy27rpIgpOQYGKPc8bbknwm8g/9ihb3yi43eRDCnUjK58u0bMisjNOPxCFz545+ZX1j/MlkJiy2CVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1Sz3lO6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1Sz3lO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A071F000FF;
	Sat, 12 Sep 2026 07:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197479;
	bh=GJFlk1k+s0KesjC1RpHaR0BaSAGwNp/7QjrtmQGsrw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1Sz3lO65KuE17gQFjcQPVfNULwCUQ05y/5iYRHCkkjtR953Q29uhiuhqMHugwGTW
	 fFEzlBp0nNronnPGo8fmRt1heCFtNyCej33uhdQv0pAimLp3hqTaPlQDY6wpM0EdOB
	 6hqV7nT+8ziptOh2wYexeFQlQ1GmILQNWR8fGxNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0140/1815] PCI: imx6: Fix building against PCI_PWRCTRL_GENERIC
Date: Sat, 12 Sep 2026 08:31:30 +0200
Message-ID: <20260912065652.300666169@linuxfoundation.org>
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

[ Upstream commit 7f4d9901eb1fdd3d2e56b514dcc325b33185b8e1 ]

When endpoint mode is built-in, but pwrctrl support is in a loadable
module, the imx driver fails to build because the unused host
support still tries to link against pwrctrl:

  ld.lld: error: undefined symbol: pci_pwrctrl_power_off_devices
  >>> referenced by pci-imx6.c:1988 (drivers/pci/controller/dwc/pci-imx6.c:1988)
  >>>               drivers/pci/controller/dwc/pci-imx6.o:(imx_pcie_shutdown) in archive vmlinux.a

Add one more select for this.

Fixes: 85c1fcfa740d ("PCI: imx6: Integrate new pwrctrl API")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://patch.msgid.link/20260618143629.2035247-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/Kconfig b/drivers/pci/controller/dwc/Kconfig
index 7d49027c67368..49a7a2c50ca15 100644
--- a/drivers/pci/controller/dwc/Kconfig
+++ b/drivers/pci/controller/dwc/Kconfig
@@ -128,6 +128,7 @@ config PCI_IMX6_EP
 	select PCIE_DW_EP
 	select PCI_HOST_COMMON
 	select PCI_IMX6
+	select PCI_PWRCTRL_GENERIC
 	help
 	  Enables support for the PCIe controller in the i.MX SoCs to
 	  work in endpoint mode. The PCI controller on i.MX is based
-- 
2.53.0



