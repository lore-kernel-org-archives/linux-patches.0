Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00973F23C5;
	Wed, 23 Sep 2026 14:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175097; cv=none; b=Hvpv5mV/aT/V7o/y3oxk55uDrg9Po7G2TkIui10tBRFvuRURONtU8MOCHGGczj3J8NfN8Ke3gfP/GcL6qx5CNE7pMdqVSYpFDiD3JAfR9wBjORQQDaDhbzkK/kgixF7c/hamildA0jCZIjn5uD0PE5fFzLl/mqzR5/sR97eHdA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175097; c=relaxed/simple;
	bh=oL20+XjiR2FFWY6PSoMMz41JpqXTiYjjswF9frsJ0Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpZpAfbEjdxZprWfcNgX//vYF8qBeUqt9bvoh97KvSfFAghI3ek4SH1kgbphAnhEwH4+ahaxYuqoRB8G3aDr0VHrXoaLN7SRjmNY0mu1g752WcDw2NPaBfVxjHfl9Ki+7zqoVLWNcbvmzwlrM3Hq/NO5RP5eJyDJy2l6h6Tkzkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L236DDQX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L236DDQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F3C1F000FF;
	Wed, 23 Sep 2026 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175096;
	bh=4wgRRtiHhfeJZNUs/6V2fd8nOa4LNSgh0b5Z3ZsTJ00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L236DDQXkmTijfNyB+XBQqSm0QkNpiufJ48zHoabbjdr7G78sYwr3h/HUsErSAVNk
	 YRx7mMjJiOzzX6G5j0IihcpXoTLNk+QIOICh2UOQxaq6KYgRStTepcdG4CqeVZPgJs
	 hrNY5dAM7U8yQpBLaKwd/BvhAcX/o5w12XiuZYlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Maillard <florian.maillard@mailoo.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 285/398] mmc: rtsx_pci_sdmmc: ignore broken write-protect on ThinkPad X260
Date: Wed, 23 Sep 2026 16:05:59 +0200
Message-ID: <20260923140650.805148810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -1501,6 +1501,11 @@ static void realtek_init_host(struct rea
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


