Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6528481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7547C433EF;
	Fri, 10 Mar 2023 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457622;
	bh=4unAjt4V5SjOwcZePewu1fuScVRo67vkT/F46A6vQYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8dIQ4SC0k2GIFc6mpshShs0dp+tNISt+xrgTHiQPPcuSER0ScqB/kmgHdnVpUyKl
	 jeynqwowiw7D0fm581MGe+llwu4XDwUVFIMkqfmxabIXiuI15iE2kC7Ah/YVfRbeFs
	 xNoBe/s2tTsN9ByRery3UpGRddRMXBkDna9FOrNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/200] PCI: pciehp: Add Qualcomm quirk for Command Completed erratum
Date: Fri, 10 Mar 2023 14:39:37 +0100
Message-Id: <20230310133722.315966030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 82b34b0800af8c9fc9988c290cdc813e0ca0df31 ]

The Qualcomm PCI bridge device (Device ID 0x010e) found in chipsets such as
SC8280XP used in Lenovo Thinkpad X13s, does not set the Command Completed
bit unless writes to the Slot Command register change "Control" bits.

This results in timeouts like below during boot and resume from suspend:

  pcieport 0002:00:00.0: pciehp: Timeout on hotplug command 0x03c0 (issued 2020 msec ago)
  ...
  pcieport 0002:00:00.0: pciehp: Timeout on hotplug command 0x13f1 (issued 107724 msec ago)

Add the device to the Command Completed quirk to mark commands "completed"
immediately unless they change the "Control" bits.

Link: https://lore.kernel.org/r/20230213144922.89982-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 040ae076ec0e9..112c8f401ac4e 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1086,6 +1086,8 @@ static void quirk_cmd_compl(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x010e,
+			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0110,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0400,
-- 
2.39.2



