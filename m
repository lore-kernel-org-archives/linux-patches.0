Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33C718D636;
	Fri,  4 Sep 2026 05:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501527; cv=none; b=rSWZq4p5AQpy6gJvwU4VvvU4j9VzA1hkIDM0znkA+w5cv+l8U3CQcJJZkorbh0pDCuINo2+5SPMcxTVpZa02MseDx2Wp6as/nCO1wPgH8VwOwJ1mTALlg8cAzNMgB7aV4S+7nsngs7yIAh0SAIJHVt8oDjcz8HlnCcIrZwHB0pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501527; c=relaxed/simple;
	bh=Yg4UUrO0eAFuvIYMIpScW7JvDvrjpmvzVVFP8dzgIHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWv6ppJWI+Ib7EsW2bGgDomHslR2R7nY/AXZKyzWOMOPkm/HBJyjvVyE0tbW9ZswBo4Jv3ExfV6wrLCb00rHOXWCXQp07voJ0tHQyJo/L8crehA8xfkZYhHWSTFoRTgfM3ERDGTWhIR64c+n9mgDZufMdDYNmh/vsK2llQCLW5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COFQH3yI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COFQH3yI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229A51F00A3D;
	Fri,  4 Sep 2026 05:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501526;
	bh=EfBP1nJ54+Oj8oNx0rf6pF4KKRq+EICwrMWluGcmihE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COFQH3yIosEMIdoEyooRXKZ2j/DH54KawWBYKPwg/lWFdMER/l1Dp/h29vXftU4Qv
	 oJsh8p3ic89fEssmzQt09YNzg5cdo43XCGokdwp199zE5eHQiYH/43uztGQOZAX7CT
	 n+QsLxmqcLW1IlCC8tXiUperE3wmCiSFFLq4Bla0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Darshit Shah <darnshah@amazon.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.18 397/552] PCI/DPC: Allow DPC on all Downstream Ports when OS controls AER
Date: Fri,  4 Sep 2026 06:59:14 +0200
Message-ID: <20260904045759.345855068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Darshit Shah <darnshah@amazon.de>

commit 97ca178c899d0049210d325b123ed024eb5ac000 upstream.

PCIe r7.0, sec 6.2.11, "Implementation Note: Determination of DPC Control",
recommends that "... operating systems always link control of DPC to the
control of Advanced Error Reporting."

Any PCIe device may advertise AER, but only Root Ports and Root Complex
Event Collectors can generate AER interrupts, so the AER driver only binds
to RPs and RCECs.

Any Root Port or Switch Downstream Port may advertise Downstream Port
Containment (DPC), but previously the DPC driver was limited to devices the
AER driver could bind to, i.e., only RPs that advertised AER.

Since any Port with DPC can generate DPC interrupts, allow the DPC driver
to bind to such a Port as long as the OS controls AER, regardless of
whether the AER driver binds to it.

Signed-off-by: Darshit Shah <darnshah@amazon.de>
[bhelgaas: commit log, reorder || operands to simplify patch]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251211164257.81655-1-darnshah@amazon.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/portdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -264,7 +264,7 @@ static int get_port_device_capability(st
 	 */
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DPC) &&
 	    pci_aer_available() &&
-	    (pcie_ports_dpc_native || (services & PCIE_PORT_SERVICE_AER)))
+	    (pcie_ports_dpc_native || host->native_aer))
 		services |= PCIE_PORT_SERVICE_DPC;
 
 	/* Enable bandwidth control if more than one speed is supported. */


