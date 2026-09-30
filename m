Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A7051AEF3;
	Wed, 30 Sep 2026 18:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792136; cv=none; b=EpO0N5lTZjWZ65yfhJOA5d+SPlhIwjkmS/qx4Hz/E2f54LCd9b6osY8idtPm3OS1LLQawVMhqIs1pFd02qaNdgSuLBjlIBYV0t5FZzsW07j2UdwbrIUiGyNEmgwMVTlEmwi6xaS/EGklBZ4r1uzw4w2CyVquvDRr+2fJ7WnGx2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792136; c=relaxed/simple;
	bh=wXSlpyPGIH/bpaE8h9TWWNq9SCJmaMBe08Cw/c7RwqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay9qx/yu2u4uetdb8A0P5bkrbhmz7U6hyIxL/i4/E7B9fNIc6MQRrjzvUPmMPU+Xbmf4Aa0zPW0LV2I5NXA+hVfIJvRia9fDDiCTPMQCYCzGxNmDEHwSDYZsTrblZLuV2wMoxxcwu0BIY6kCy0DpH84J8PwYlISsRW+9OGf97PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFgyj8wO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFgyj8wO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725E11F000FF;
	Wed, 30 Sep 2026 18:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792135;
	bh=d+YBq0oTYYjvK37/lXJacvwMf2LhRYcsru8gn+dG37Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFgyj8wOqMfIYglWLtcS4dNiuFFzj+A27oVA7/hWH+uVkkMrmff52NwcsnLOH3Ex3
	 eCyK6S3SggyIzHuycM91SXp/lb4nYlC5dSz6xaNsUulr+Shk0S9fUxrbgR60WreGY/
	 Z233D1ivKFi/o+C85l6jwl6nkvqPWbZulsVs/5Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Maillard <florian.maillard@mailoo.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 547/752] mmc: rtsx_pci_sdmmc: ignore broken write-protect on ThinkPad X260
Date: Wed, 30 Sep 2026 17:26:57 +0200
Message-ID: <20260930152410.080367054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1488,6 +1488,11 @@ static void realtek_init_host(struct rea
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


