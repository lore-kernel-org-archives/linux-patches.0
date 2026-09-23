Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F443A255A;
	Wed, 23 Sep 2026 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173788; cv=none; b=jfv63XtNGT6y1J5cf85x8u+SRiyXzKSf7W0JphGo/gPiN32/scwIDU7BSVAw0TV29vFgbydY2vKfCxbB3NFXoTebWJUTKEDO7v024H3rZxMI9Sy2NLaivIXrpN8uJV5SLz8i1oXWhcVe9h8pz86FUP3J0Epid7HOz8aI9nW/nHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173788; c=relaxed/simple;
	bh=4KEHWTQzqzoqgN82nRhDsiq0hjegHTqpI+R71GRxAWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJWdJ71guHjjiHbNmethgr2/VYbn/NlonlwOSXl46Avf8V5b8OuJ5NVTLQPUCpQr7hV4Bs9HqFmvyr/PuyCQ5RJNoThbtH3os3YTCd1TXD88umQFJqXpInSxUKeH1GVTdHa8ZDxju7uLo71pSAXOGEZLtg/pnYvjtkEdsWXnKxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0fRcoIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0fRcoIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D741F00893;
	Wed, 23 Sep 2026 14:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173786;
	bh=4TmHeC7A1pY3bpiUusr8664/AQbe4e/NIIftf8TrBPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0fRcoIFcP+kId4YU+mmTf/DFzvcGKEPHsvHt8z0bUMtAe9tMM7zbP7IZYCibS2/z
	 LXys3pVv23B90AI28UIGG4yndKA75ItJ6l0CghSNqNC831NoAWSqoU/SfYdsW2Xrzi
	 Jw9+3lyeE9+GT4PeabIY5eoqw/L22TtZs4ETdxKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Maillard <florian.maillard@mailoo.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 344/438] mmc: rtsx_pci_sdmmc: ignore broken write-protect on ThinkPad X260
Date: Wed, 23 Sep 2026 16:06:05 +0200
Message-ID: <20260923140653.734884096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Maillard <florian.maillard@mailoo.org>

commit 9c182bc5d7817437a7d04ab96133f9191846d93d upstream.

The Realtek RTS522A card reader in the Lenovo ThinkPad X260
(subsystem 17aa:504a) incorrectly reports inserted SD cards as
write-protected.

This causes the MMC core to expose the card as read-only:

  mmcblk0: mmc0:aaaa SN256 238 GiB (ro)

and /sys/block/mmcblk0/ro reports 1.

Setting MMC_CAP2_NO_WRITE_PROTECT makes the card writable again.
Limit the quirk to the affected Lenovo subsystem.

Assisted-by: ChatGPT:GPT-5.6 Sol
Signed-off-by: Florian Maillard <florian.maillard@mailoo.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1425,6 +1425,11 @@ static void realtek_init_host(struct rea
 		mmc->caps = mmc->caps | MMC_CAP_AGGRESSIVE_PM;
 	mmc->caps2 = MMC_CAP2_NO_PRESCAN_POWERUP | MMC_CAP2_FULL_PWR_CYCLE |
 		MMC_CAP2_NO_SDIO;
+
+	if (pcr->pci->device == 0x522a &&
+	    pcr->pci->subsystem_vendor == PCI_VENDOR_ID_LENOVO &&
+	    pcr->pci->subsystem_device == 0x504a)
+		mmc->caps2 |= MMC_CAP2_NO_WRITE_PROTECT;
 	mmc->max_current_330 = 400;
 	mmc->max_current_180 = 800;
 	mmc->ops = &realtek_pci_sdmmc_ops;


