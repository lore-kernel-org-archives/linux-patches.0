Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF38B168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5572DC433D2;
	Mon,  8 May 2023 11:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544864;
	bh=gkfnnr1qoSbUOYReg2jWrFx1R+8WYHwcmUOKvnwDoOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsvyLRWJtQsxXbvVl2QBsXvDmasTyxEJJJv4JKRntMSayauFwTszPZyhOjH+ct8J7
	 CB6GGKGkEC1e2ftGfocslIq9K4NNfkTqhx0GsZ7bEd4RCIIi4Iogy5QawJ8uzKLusr
	 R5Pr9HapwI9jTHD31cqwfdSwTTVk/K9VWIA/Ewbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tsaur Erwin <erwin.tsaur@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 518/694] PCI/EDR: Clear Device Status after EDR error recovery
Date: Mon,  8 May 2023 11:45:53 +0200
Message-Id: <20230508094451.028962815@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit c441b1e03da6c680a3e12da59c554f454f2ccf5e ]

During EDR recovery, the OS must clear error status of the port that
triggered DPC even if firmware retains control of DPC and AER (see the
implementation note in the PCI Firmware spec r3.3, sec 4.6.12).

Prior to 068c29a248b6 ("PCI/ERR: Clear PCIe Device Status errors only if
OS owns AER"), the port Device Status was cleared in this path:

  edr_handle_event
    dpc_process_error(dev)                 # "dev" triggered DPC
    pcie_do_recovery(dev, dpc_reset_link)
      dpc_reset_link                       # exit DPC
      pcie_clear_device_status(dev)        # clear Device Status

After 068c29a248b6, pcie_do_recovery() no longer clears Device Status when
firmware controls AER, so the error bit remains set even after recovery.

Per the "Downstream Port Containment configuration control" bit in the
returned _OSC Control Field (sec 4.5.1), the OS is allowed to clear error
status until it evaluates _OST, so clear Device Status in
edr_handle_event() if the error recovery was successful.

[bhelgaas: commit log]
Fixes: 068c29a248b6 ("PCI/ERR: Clear PCIe Device Status errors only if OS owns AER")
Link: https://lore.kernel.org/r/20230315235449.1279209-1-sathyanarayanan.kuppuswamy@linux.intel.com
Reported-by: Tsaur Erwin <erwin.tsaur@intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/edr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pcie/edr.c b/drivers/pci/pcie/edr.c
index a6b9b479b97ad..87734e4c3c204 100644
--- a/drivers/pci/pcie/edr.c
+++ b/drivers/pci/pcie/edr.c
@@ -193,6 +193,7 @@ static void edr_handle_event(acpi_handle handle, u32 event, void *data)
 	 */
 	if (estate == PCI_ERS_RESULT_RECOVERED) {
 		pci_dbg(edev, "DPC port successfully recovered\n");
+		pcie_clear_device_status(edev);
 		acpi_send_edr_status(pdev, edev, EDR_OST_SUCCESS);
 	} else {
 		pci_dbg(edev, "DPC port recovery failed\n");
-- 
2.39.2



