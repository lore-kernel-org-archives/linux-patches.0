Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C6B41DEDA;
	Fri,  4 Sep 2026 06:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502694; cv=none; b=UZuaI2zFdPtU0BeflARACQ494h8anzovFRd5g+TmG8lFM+kK8C1YmDIlmyzDP9jpeIoEsqaTrtWonRn1o91b1zFZnQG9zQ1IyhTvKiJpIB8G5aoUfVR+0Ivtkx5StnjdDnJy2qOn2+NQiH+30JEZfz0JwCTllqt7k9kLL9AHSEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502694; c=relaxed/simple;
	bh=tCnJBvo8UajeDl+i0iLOamofNPYiTclOiSz/3WcI9xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5qbkJE8rvEVnn+C8IvFev55VLwvLajiO0GiNpcFW4ym9504F22KIfgEMYTohviBFwgJn04z2ZlfZ4S4RUr2fKVZU/TC6mT41GFRhGx/vcsk4J6NlGT1icEeBA/4Y4Ilb164B52s8L38RNs3Wy2oETSVOEtLaJnSWw5VE7YNDvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuvbrFHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuvbrFHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA921F00A3D;
	Fri,  4 Sep 2026 06:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502693;
	bh=0VNg7nJGO0pWMWVW7l1nCktoT8wWK69gs6OdkWVHOSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuvbrFHb5bHm9wxvxAwgpi9CQSHBScoyQZL58GPnbby1vTcgK/Vng1guPZtD7AFhl
	 cfWHNLmzxDtN88hIScElMMsiTRy3I5Ay9dMAL9+lsDJkJICfbhO6ypqQrTZzTG+FsF
	 RjsII7yO9/TX/NZ8KsHuJ/Jj8AgcnptDLkrqoIhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Darshit Shah <darnshah@amazon.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.12 297/403] PCI/DPC: Allow DPC on all Downstream Ports when OS controls AER
Date: Fri,  4 Sep 2026 07:01:40 +0200
Message-ID: <20260904045741.598177049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 
 	if (pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM ||


