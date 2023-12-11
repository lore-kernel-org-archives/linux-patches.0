Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6733DE548;
	Mon, 11 Dec 2023 18:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePA+3GTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEA1C433C8;
	Mon, 11 Dec 2023 18:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321009;
	bh=HdBPXFWUWDd7pd8ZFPplYoLdeyCe+nDjH7uu+CJbe6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePA+3GTv94hchyytXm12ItIqdKAbY/519munlhDlKL9h/VBfRtDRf+dVoOCi/+HCH
	 r3rhKY/9CjTNZdPmd9AsgW2MnYkl2MN5JXwQWBo3ATatjRv8zX4rgmBTZDLWrSYrHJ
	 gxD4N1RNAHPgM70jBjkG6jQ4ESQBRcSNl7gr2ycI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 077/141] nvme-pci: Add sleep quirk for Kingston drives
Date: Mon, 11 Dec 2023 19:22:16 +0100
Message-ID: <20231211182029.899185527@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georg Gottleuber <ggo@tuxedocomputers.com>

commit 107b4e063d78c300b21e2d5291b1aa94c514ea5b upstream.

Some Kingston NV1 and A2000 are wasting a lot of power on specific TUXEDO
platforms in s2idle sleep if 'Simple Suspend' is used.

This patch applies a new quirk 'Force No Simple Suspend' to achieve a
low power sleep without 'Simple Suspend'.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/nvme.h |    5 +++++
 drivers/nvme/host/pci.c  |   16 +++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -154,6 +154,11 @@ enum nvme_quirks {
 	 * No temperature thresholds for channels other than 0 (Composite).
 	 */
 	NVME_QUIRK_NO_SECONDARY_TEMP_THRESH	= (1 << 19),
+
+	/*
+	 * Disables simple suspend/resume path.
+	 */
+	NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND	= (1 << 20),
 };
 
 /*
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2953,6 +2953,18 @@ static unsigned long check_vendor_combin
 		if ((dmi_match(DMI_BOARD_VENDOR, "LENOVO")) &&
 		     dmi_match(DMI_BOARD_NAME, "LNVNB161216"))
 			return NVME_QUIRK_SIMPLE_SUSPEND;
+	} else if (pdev->vendor == 0x2646 && (pdev->device == 0x2263 ||
+		   pdev->device == 0x500f)) {
+		/*
+		 * Exclude some Kingston NV1 and A2000 devices from
+		 * NVME_QUIRK_SIMPLE_SUSPEND. Do a full suspend to save a
+		 * lot fo energy with s2idle sleep on some TUXEDO platforms.
+		 */
+		if (dmi_match(DMI_BOARD_NAME, "NS5X_NS7XAU") ||
+		    dmi_match(DMI_BOARD_NAME, "NS5x_7xAU") ||
+		    dmi_match(DMI_BOARD_NAME, "NS5x_7xPU") ||
+		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1"))
+			return NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND;
 	}
 
 	return 0;
@@ -2993,7 +3005,9 @@ static struct nvme_dev *nvme_pci_alloc_d
 	dev->dev = get_device(&pdev->dev);
 
 	quirks |= check_vendor_combination_bug(pdev);
-	if (!noacpi && acpi_storage_d3(&pdev->dev)) {
+	if (!noacpi &&
+	    !(quirks & NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND) &&
+	    acpi_storage_d3(&pdev->dev)) {
 		/*
 		 * Some systems use a bios work around to ask for D3 on
 		 * platforms that support kernel managed suspend.


