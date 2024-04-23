Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3262143C57;
	Tue, 23 Apr 2024 21:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908612; cv=none; b=I68+vX8+6SrKEa7ETpzWzkXQQkmNIViqP4eO2mhiUXIn7edSuQy+oGvYbhSfQmLhNsQ38eDqICamsvcHHfeINJ/Clkqh+ayCpfeMjA7jwiW3rSVEdEmuP7I3W9yxlStFT1X13dEP/gMpPIflIGbiV0Vhi2GPnTHk6TViRBhS3U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908612; c=relaxed/simple;
	bh=TUWd2auQxia9Bn16rfkiCn2YBR2c9in61RRr6ynOVcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RK+ag/O+B8l+zhxNlzsS523uK7t/HUf8RCoqmFkw2jPBqMA/EYApvFLmGLJiCKmsVBSqogCVI/ZmnEkhTQG3pqBIR4E7uzuf5ndXC/Uob8lQ0BMW1k33Q7UnZyftDhSd/kxAGoQ8yt1mQfxigcb2dAmKqG0wY5mb4gBEXFaoaDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzKPvg0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzKPvg0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77881C116B1;
	Tue, 23 Apr 2024 21:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908612;
	bh=TUWd2auQxia9Bn16rfkiCn2YBR2c9in61RRr6ynOVcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzKPvg0PV72kM/626FZcjmwfGbT2IprGDIftnpI11GiaE730FaoPqowxQ0jSQQ5qe
	 ECUmVnr/UghAEE/A9sJNz0tToLpmxzdZyFr8hVq3L/xv7xb/84D1K+/4IXrEfdiVDE
	 OqSF9W5v6Ngkk51ZXrelkc72bBDn7QhxvUt4/Lhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/158] PCI/DPC: Use FIELD_GET()
Date: Tue, 23 Apr 2024 14:38:40 -0700
Message-ID: <20240423213858.460070742@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -202,7 +203,7 @@ static void dpc_process_rp_pio_error(str
 
 	/* Get First Error Pointer */
 	pci_read_config_word(pdev, cap + PCI_EXP_DPC_STATUS, &dpc_status);
-	first_error = (dpc_status & 0x1f00) >> 8;
+	first_error = FIELD_GET(PCI_EXP_DPC_RP_PIO_FEP, dpc_status);
 
 	for (i = 0; i < ARRAY_SIZE(rp_pio_error_string); i++) {
 		if ((status & ~mask) & (1 << i))
@@ -338,7 +339,7 @@ void pci_dpc_init(struct pci_dev *pdev)
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
@@ -6198,7 +6198,7 @@ static void dpc_log_size(struct pci_dev
 	if (!(val & PCI_EXP_DPC_CAP_RP_EXT))
 		return;
 
-	if (!((val & PCI_EXP_DPC_RP_PIO_LOG_SIZE) >> 8)) {
+	if (FIELD_GET(PCI_EXP_DPC_RP_PIO_LOG_SIZE, val) == 0) {
 		pci_info(dev, "Overriding RP PIO Log Size to 4\n");
 		dev->dpc_rp_log_size = 4;
 	}
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1045,6 +1045,7 @@
 #define  PCI_EXP_DPC_STATUS_INTERRUPT	    0x0008 /* Interrupt Status */
 #define  PCI_EXP_DPC_RP_BUSY		    0x0010 /* Root Port Busy */
 #define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_EXT 0x0060 /* Trig Reason Extension */
+#define  PCI_EXP_DPC_RP_PIO_FEP		    0x1f00 /* RP PIO First Err Ptr */
 
 #define PCI_EXP_DPC_SOURCE_ID		 0x0A	/* DPC Source Identifier */
 


