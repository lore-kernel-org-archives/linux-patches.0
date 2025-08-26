Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65BA321F53;
	Tue, 26 Aug 2025 11:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207219; cv=none; b=h4/IEx0HY1KKNKa402VStj97P72LZXNoxIs0WLHyq3jsrSHcdFHtdpbYZPFnzlBT2gqqCdlwpd02NNpF9QGj0ucMYOJ5Gm2nSygIW9aK1zAbRob0wYfYBtim77sHwa6WROvpjRndhuJQbcHxoh4LG1/egX3yH81YIq2tGDhQwHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207219; c=relaxed/simple;
	bh=Ii8292jv9XiyK5YH1oMO3L5Ps/6ZqnZoV/k7b+LOxW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU1IZzdXRUdX5mR+jpoghiTHBCwaI+5F3OBtviD83efAdDXS9FqqBkSJAkT9Brk8o5H+YeRATG2hOqAbanri/oWKdrQpq7zQxZDF1AyLvCWVrbuzf3ptzsI86HutibDjfi1qSBJEc048zfmJYOaPAg1TyKO6xPGJVvZ5v9hlItw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vr4prnu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vr4prnu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B231C4CEF1;
	Tue, 26 Aug 2025 11:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207218;
	bh=Ii8292jv9XiyK5YH1oMO3L5Ps/6ZqnZoV/k7b+LOxW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vr4prnu0uy2eBlyjAXBWMrW4FUrSHdoeiRIln0OLoOKY7A8Nll3ThH/7HSgUB1ip8
	 WHDADO8cToZTmLO5cqMpRyiZwpITP+Q/+UTX67S4bD93Y9k874wUOHALwWELz+nV4m
	 QWto08ZCyoe05Awno2etZh+2dE1woXtP400M2R5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.16 097/457] PCI/portdrv: Use is_pciehp instead of is_hotplug_bridge
Date: Tue, 26 Aug 2025 13:06:21 +0200
Message-ID: <20250826110939.773865325@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


