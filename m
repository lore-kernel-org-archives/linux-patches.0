Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636EA39FE1;
	Fri, 24 Nov 2023 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnnNrWOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BC0C433C8;
	Fri, 24 Nov 2023 18:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849868;
	bh=kj7+p2F6ZN9Kq5aWA5TEWHQiBR/fjn9NGTq57FXhACQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnnNrWOOZFW77nXLi1kmSt4SXE0xq3R1h+IV0TWfRDSXPR9G8WaHoF9MV4GNRNl51
	 0hvVLfiZkB4RSdQI+OGkT3xrQNYvx+lM3Vp2aeFbjxRSifJybXE+kuMxkaaNduEcOJ
	 TNW3u9FVaQdAS+WDuJFfXhO5QWLqVnNBOtNix7ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Schroeder <CSchroeder@sonifi.com>,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 328/530] PCI: Lengthen reset delay for VideoPropulsion Torrent QN16e card
Date: Fri, 24 Nov 2023 17:48:14 +0000
Message-ID: <20231124172038.008220761@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit c9260693aa0c1e029ed23693cfd4d7814eee6624 upstream.

Commit ac91e6980563 ("PCI: Unify delay handling for reset and resume")
shortened an unconditional 1 sec delay after a Secondary Bus Reset to 100
msec for PCIe (per PCIe r6.1 sec 6.6.1).  The 1 sec delay is only required
for Conventional PCI.

But it turns out that there are PCIe devices which require a longer delay
than prescribed before first config space access after reset recovery or
resume from D3cold:

Chad reports that a "VideoPropulsion Torrent QN16e" MPEG QAM Modulator
"raises a PCI system error (PERR), as reported by the IPMI event log, and
the hardware itself would suffer a catastrophic event, cycling the server"
unless the longer delay is observed.

The card is specified to conform to PCIe r1.0 and indeed only supports Gen1
speed (2.5 GT/s) according to lspci.  PCIe r1.0 sec 7.6 prescribes the same
100 msec delay as PCIe r6.1 sec 6.6.1:

  To allow components to perform internal initialization, system software
  must wait for at least 100 ms from the end of a reset (cold/warm/hot)
  before it is permitted to issue Configuration Requests

The behavior of the Torrent QN16e card thus appears to be a quirk.  Treat
it as such and lengthen the reset delay for this specific device.

Fixes: ac91e6980563 ("PCI: Unify delay handling for reset and resume")
Link: https://lore.kernel.org/r/47727e792c7f0282dc144e3ec8ce8eb6e713394e.1695304512.git.lukas@wunner.de
Reported-by: Chad Schroeder <CSchroeder@sonifi.com>
Closes: https://lore.kernel.org/linux-pci/DM6PR16MB2844903E34CAB910082DF019B1FAA@DM6PR16MB2844.namprd16.prod.outlook.com/
Tested-by: Chad Schroeder <CSchroeder@sonifi.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6211,3 +6211,15 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_XILINX, 0x5020, of_pci_make_dev_node);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_XILINX, 0x5021, of_pci_make_dev_node);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REDHAT, 0x0005, of_pci_make_dev_node);
+
+/*
+ * Devices known to require a longer delay before first config space access
+ * after reset recovery or resume from D3cold:
+ *
+ * VideoPropulsion (aka Genroco) Torrent QN16e MPEG QAM Modulator
+ */
+static void pci_fixup_d3cold_delay_1sec(struct pci_dev *pdev)
+{
+	pdev->d3cold_delay = 1000;
+}
+DECLARE_PCI_FIXUP_FINAL(0x5555, 0x0004, pci_fixup_d3cold_delay_1sec);


