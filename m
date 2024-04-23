Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25694145B05;
	Tue, 23 Apr 2024 21:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908741; cv=none; b=jtBdZ2S8Fp1x80B5pK/RnVbgTuegXWcPCCeWJOerUts2ioWpxpml9qJZRQglZwb2uNcWfLl8BtfIIv69iZVJK7C4IzfiAOfaWvdwOuLTyed2ZQvnIg4gDAXSQLTt/vCTh7/D3oDeC6SJC7/Dz7FAION6Kniu/EgTedmSmW/513k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908741; c=relaxed/simple;
	bh=/oC+TQbW4X8vEySm5K0FjAuzL4GA6ksU/acUoGYJI+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D31jfAle0CoTitj8p1s8NnFAZ+jI/mc8PB5euNdhQXlveeQtBwnNV5d9yb97EHorV707phkcPXj4W1WDw3HsDYgRIP0AQwO3ZeLc9QF+3uG/1UTaLhB+pq3OtzEYVxgangkpvXNJ4KvYsv3+UXpfPYWH9UFvoeYAyWfFbBZ9gHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDp18Wam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDp18Wam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65DEC3277B;
	Tue, 23 Apr 2024 21:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908741;
	bh=/oC+TQbW4X8vEySm5K0FjAuzL4GA6ksU/acUoGYJI+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDp18WamFEQk+w4UVts24Pdq71pmPnNCdH9luhPZWl821ifqxnZOKMrWXVssqoHuA
	 3achrzVy/Z1J71kY+oawVKm6TPC9XeTkYzXrO7u4kaU3dhjuyWXPw0U7LRzxCb5lD0
	 RtE1RcTVEUbcItZiwc6c4VVo+LBpHY1oq9wVOYqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/141] PCI/DPC: Use FIELD_GET()
Date: Tue, 23 Apr 2024 14:39:05 -0700
Message-ID: <20240423213855.701061587@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 9a9eec4765737b9b2a8d6ae03de6480a5f12dd5c ]

Use FIELD_GET() to remove dependencies on the field position, i.e., the
shift value. No functional change intended.

Link: https://lore.kernel.org/r/20231018113254.17616-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/dpc.c        |    5 +++--
 drivers/pci/quirks.c          |    2 +-
 include/uapi/linux/pci_regs.h |    1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -9,6 +9,7 @@
 #define dev_fmt(fmt) "DPC: " fmt
 
 #include <linux/aer.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
@@ -203,7 +204,7 @@ static void dpc_process_rp_pio_error(str
 
 	/* Get First Error Pointer */
 	pci_read_config_word(pdev, cap + PCI_EXP_DPC_STATUS, &dpc_status);
-	first_error = (dpc_status & 0x1f00) >> 8;
+	first_error = FIELD_GET(PCI_EXP_DPC_RP_PIO_FEP, dpc_status);
 
 	for (i = 0; i < ARRAY_SIZE(rp_pio_error_string); i++) {
 		if ((status & ~mask) & (1 << i))
@@ -339,7 +340,7 @@ void pci_dpc_init(struct pci_dev *pdev)
 	/* Quirks may set dpc_rp_log_size if device or firmware is buggy */
 	if (!pdev->dpc_rp_log_size) {
 		pdev->dpc_rp_log_size =
-			(cap & PCI_EXP_DPC_RP_PIO_LOG_SIZE) >> 8;
+				FIELD_GET(PCI_EXP_DPC_RP_PIO_LOG_SIZE, cap);
 		if (pdev->dpc_rp_log_size < 4 || pdev->dpc_rp_log_size > 9) {
 			pci_err(pdev, "RP PIO log size %u is invalid\n",
 				pdev->dpc_rp_log_size);
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6105,7 +6105,7 @@ static void dpc_log_size(struct pci_dev
 	if (!(val & PCI_EXP_DPC_CAP_RP_EXT))
 		return;
 
-	if (!((val & PCI_EXP_DPC_RP_PIO_LOG_SIZE) >> 8)) {
+	if (FIELD_GET(PCI_EXP_DPC_RP_PIO_LOG_SIZE, val) == 0) {
 		pci_info(dev, "Overriding RP PIO Log Size to 4\n");
 		dev->dpc_rp_log_size = 4;
 	}
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1043,6 +1043,7 @@
 #define  PCI_EXP_DPC_STATUS_INTERRUPT	    0x0008 /* Interrupt Status */
 #define  PCI_EXP_DPC_RP_BUSY		    0x0010 /* Root Port Busy */
 #define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_EXT 0x0060 /* Trig Reason Extension */
+#define  PCI_EXP_DPC_RP_PIO_FEP		    0x1f00 /* RP PIO First Err Ptr */
 
 #define PCI_EXP_DPC_SOURCE_ID		 0x0A	/* DPC Source Identifier */
 


