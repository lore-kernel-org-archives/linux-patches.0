Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E380355819;
	Wed, 30 Sep 2026 19:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796367; cv=none; b=Mhv6lpchQmDCtTBEwXd2QuHVGqcq/ldZYQYcHdFXCjba4DsZkwiGzRU3sUp9bvVT4ZeUyCzcnsvOur+MVFQ1QjM3ud2Jif2icSZ0Ag+bzzWVpaWd9p6OaTA4X46rpkL3JCNCepkA8uQeBslo+D2H+kx7kPidwwJSWSIuDeI2WZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796367; c=relaxed/simple;
	bh=C1D20sI1abuq4Kpm/7Aoqswz7YaEMAPkkeJgmuO/v0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/R15tPqnDHIOaaMS3NQrXXdaO7KCQZzT7X1fqQAMmuDC/Mn4nerivjKAjwku78Tr5JF1Lr2ikndoxsQxhPpQQpXK8s0hH3UfBnM73ej0aewh/oO7VLhixWujEIJmjAyoG+rEMn9dutIKAgujvA8qUN5/frvSFnfoOZnRyWP9so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsjvdubK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsjvdubK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83741F00898;
	Wed, 30 Sep 2026 19:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796366;
	bh=c4C3ggbmYPdQ3txIwbTxG2ZJg2Qt/TKShV4yamzbNCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsjvdubKkJNe0EnvBQTcVDMuuYOK7RVWiBKq3KNdZycqGpmTNr3v6s9se7F+yCUeJ
	 /nIQLhkLAYBflq7URyFHQQgwVXWy4jNMNVQ5BUi2OSS/UEiqjbKJpVHXrY6N1N7r/g
	 0ri158BPoo8YJseeWfIxE9tRYAjCMR8luX873YjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Maillard <florian.maillard@mailoo.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0887/1193] mmc: rtsx_pci_sdmmc: ignore broken write-protect on ThinkPad X260
Date: Wed, 30 Sep 2026 17:26:11 +0200
Message-ID: <20260930152453.955665442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


