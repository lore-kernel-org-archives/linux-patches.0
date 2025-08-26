Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC3717332C;
	Tue, 26 Aug 2025 11:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208423; cv=none; b=EKFFcMzuyCXrP7xa85lLAGOyLwL8OHVZnZUHXr+LC7bNUOJGiRgem9xK0euHt9IV5tgn4Co1nHcr2xcz3BPUGK6eQlHy1j8TEpopUBwhwG6V9ivpwSpHggcTPYK7177V2roAPUL55nYITX0PRfedYAsZ36SuFszW7Ha1/UF25CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208423; c=relaxed/simple;
	bh=gOCSFR5IJWn8n//MNdb7ZCDXmlJHfzGJPW0LTBLJ/m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQ7uAkAmyoDqzcol0cvAp8BXXkxfGDwsDZxHSpNhJuDIaS8BiOK8YlnL8efwGjoYANYE2rdHdhaP3qDiK+P6riA4muj0+LET/O0jBM2Bwe+alJv7kzZiwgfa7rj7BAjpjgZH8yu78nSxKZvf6tkyB41rMRkLyRsf7l7WQmqrXho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPAPA747; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPAPA747"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C47C4CEF1;
	Tue, 26 Aug 2025 11:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208422;
	bh=gOCSFR5IJWn8n//MNdb7ZCDXmlJHfzGJPW0LTBLJ/m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPAPA747iKVIOFF+QU3RgJujKY2cAmoyWXGgb7HDCuBJPnK5fjKqLxeNLI/nmlWBX
	 Y/F5IYAXVi8AVhoc89mKPp63YZBVAKTFshyhSTukQTAoDqLc/Ip21xCSZOiA+jmSV4
	 E/4P9vRSG73q5jY8pYtA6r1OTKqwvaOZYfG75GCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 074/322] PCI/portdrv: Use is_pciehp instead of is_hotplug_bridge
Date: Tue, 26 Aug 2025 13:08:09 +0200
Message-ID: <20250826110917.420541457@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 1d60796a62f327cd9e0a6a0865ded7656d2c67f9 upstream.

The PCIe port driver erroneously creates a subdevice for hotplug on ACPI
slots which are handled by the ACPI hotplug driver.

Avoid by checking the is_pciehp flag instead of is_hotplug_bridge when
deciding whether to create a subdevice.  The latter encompasses ACPI slots
whereas the former doesn't.

The superfluous subdevice has no real negative impact, it occupies memory
and interrupt resources but otherwise just sits there waiting for
interrupts from the slot that are never signaled.

Fixes: f8415222837b ("PCI: Use cached copy of PCI_EXP_SLTCAP_HPC bit")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v4.7+
Link: https://patch.msgid.link/40d5a5fe8d40595d505949c620a067fa110ee85e.1752390102.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/portdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -220,7 +220,7 @@ static int get_port_device_capability(st
 	struct pci_host_bridge *host = pci_find_host_bridge(dev->bus);
 	int services = 0;
 
-	if (dev->is_hotplug_bridge &&
+	if (dev->is_pciehp &&
 	    (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
 	     pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM) &&
 	    (pcie_ports_native || host->native_pcie_hotplug)) {


