Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533EB1A592
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iflsj3a3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EBBC433C7;
	Mon,  9 Oct 2023 13:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858738;
	bh=dxaBw4e0Kx5dF+W8hssmsAgL0Vnx6/7LHaGgQHQS94E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iflsj3a3iVwCj2IoQk7f6YinB/1BkSOvBc4lsts2oymxtD6+2niyFYOyHl5s4JIwf
	 FecA295ukhM0X9AizZs1FowCuMFycZcXzIoHZH0QU7jUnaP6u3kRj09BPMr5k4P8Bm
	 3dbaX6KTy6x1xJ4/iMPHseoWUWU4iMST3EcVifvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tejun Heo <tj@kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/226] ata: ahci: Add support for AMD A85 FCH (Hudson D4)
Date: Mon,  9 Oct 2023 15:00:45 +0200
Message-ID: <20231009130128.981450986@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit a17ab7aba5df4135ef77d7f6d7105e1ea414936f ]

Add support for the AMD A85 FCH (Hudson D4) AHCI adapter.

Since this adapter does not require the default 200 ms debounce delay
in sata_link_resume(), create a new board board_ahci_no_debounce_delay
with the link flag ATA_LFLAG_NO_DEBOUNCE_DELAY, and, for now, configure
the AMD A85 FCH (Hudson D4) to use it. On the ASUS F2A85-M PRO it
reduces the Linux kernel boot time by the expected 200 ms from 787 ms
to 585 ms.

Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: 2a2df98ec592 ("ata: ahci: Add Elkhart Lake AHCI controller")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index d831a80c25f04..1a3608f4209ec 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -51,6 +51,7 @@ enum board_ids {
 	board_ahci,
 	board_ahci_ign_iferr,
 	board_ahci_mobile,
+	board_ahci_no_debounce_delay,
 	board_ahci_nomsi,
 	board_ahci_noncq,
 	board_ahci_nosntf,
@@ -142,6 +143,13 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	[board_ahci_no_debounce_delay] = {
+		.flags		= AHCI_FLAG_COMMON,
+		.link_flags	= ATA_LFLAG_NO_DEBOUNCE_DELAY,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 	[board_ahci_nomsi] = {
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_MSI),
 		.flags		= AHCI_FLAG_COMMON,
@@ -442,6 +450,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 		board_ahci_al },
 	/* AMD */
 	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
+	{ PCI_VDEVICE(AMD, 0x7801), board_ahci_no_debounce_delay }, /* AMD Hudson-2 (AHCI mode) */
 	{ PCI_VDEVICE(AMD, 0x7900), board_ahci }, /* AMD CZ */
 	{ PCI_VDEVICE(AMD, 0x7901), board_ahci_mobile }, /* AMD Green Sardine */
 	/* AMD is using RAID class only for ahci controllers */
-- 
2.40.1



