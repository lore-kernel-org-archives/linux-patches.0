Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8209B50255F;
	Tue, 13 Oct 2026 12:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895795; cv=none; b=JSGfRid7H12i6jGbS6YzISOTnMUSS0Ul1pZ1OF7MtRWrbuwGA5eJCUiVOIUpcQTg8LKXDyuQxJWhS9tMCuzfZsUuQeNkiI1/S17qtlgJ8wLcX18xy1zkS9qrZxSccK3T5inqjiMpfh6oaHJTHXDom2l+fIpGcIMA+ZOswC5sZRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895795; c=relaxed/simple;
	bh=Oheojt7kmbmkSoCA74ath1H6p2QrFJciXwfCOScDPVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GE8SJ+Doc1heAQape14ar+i8rC66TwhNvUdktacEE3Sm7LrlwmopWfMrAOSRWyQxNYHaIClQ1oHTHeYgzPhu+97OkkVvsKiPtu9XvBW3LjNvMiaD9vp4GSQ+hL8dAO4YYd3cMe8Cpwt78IaeeMEtH8bcV2jz9BN4IFalJa0gBiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAdQx48X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAdQx48X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1521F000FF;
	Tue, 13 Oct 2026 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895794;
	bh=x9csGev+TOJ4KDYTDTDuqpm2iBa42C8NnLZnh3WSnbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAdQx48XdBQYdpX+ehnNL3pyu0/mu0FUtaNz0MzSktmhdnOPuw765j7wYcDczMDW6
	 CLdHgPuop+5vDBuTuUctjwDGoZmh8mQ8CxpvILgZ/4LRb9fV/zZVDQhYBM2lwiseab
	 45kKLq6cbjj8PjnIwckE2msRKtn/rNuECjvkzzao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 395/497] mmc: cavium-octeon: destroy slot platform devices on remove
Date: Tue, 13 Oct 2026 13:39:22 +0200
Message-ID: <20261013112917.268253632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 0f4d4424fc1d651ec3fa63a0a8060ba9087eb0ec upstream.

octeon_mmc_probe() creates host->slot_pdev[i] with
of_platform_device_create(), while octeon_mmc_remove() does not destroy
the child platform devices.

The probe failure path removes each MMC slot and destroys its associated
platform device, but the normal remove path only removes the MMC slot.
As a result, the child platform devices remain registered after the
Octeon MMC controller is removed.

Destroy each slot platform device during removal after cleaning up the
corresponding MMC slot, matching the probe failure cleanup path.

This issue was found by manual code inspection.

Fixes: 01d95843335c ("mmc: cavium: Add MMC support for Octeon SOCs.")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/cavium-octeon.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/cavium-octeon.c
+++ b/drivers/mmc/host/cavium-octeon.c
@@ -302,9 +302,12 @@ static void octeon_mmc_remove(struct pla
 	u64 dma_cfg;
 	int i;
 
-	for (i = 0; i < CAVIUM_MAX_MMC; i++)
+	for (i = 0; i < CAVIUM_MAX_MMC; i++) {
 		if (host->slot[i])
 			cvm_mmc_of_slot_remove(host->slot[i]);
+		if (host->slot_pdev[i])
+			of_platform_device_destroy(&host->slot_pdev[i]->dev, NULL);
+	}
 
 	dma_cfg = readq(host->dma_base + MIO_EMM_DMA_CFG(host));
 	dma_cfg &= ~MIO_EMM_DMA_CFG_EN;


