Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661314D7D30;
	Tue, 13 Oct 2026 11:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892235; cv=none; b=XX3SVWZAx1eeAbetsiSMMBwqhnQA4FyzpNwWT+kAIf4deAR2u53djrvxUc8869oZzsRVBLP4iUlo9NjVbOp1YPouSwstaBoSIP2p+DVR2Npi6Qn+Osd9bOqycr54uQ/WWSQkdpcfHjZRnzQPAnzJuYbPmxVvk+Hn9GEzQJS9Ewc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892235; c=relaxed/simple;
	bh=PvUtQwJFJyVksQAfA71OHNdCVQV7YR5xZLADa3ubQ1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt4sxexWEeVvG9dPmqMzQ/Q7Nv+noCGpH3eFS+N4Smj8u5DYLJU8jZFZCYiHW8aymzXWIBsVp4KtC1f713wnDf5cyAej05Wka691IyK8EHd3dKoh50MHL7+NWwLfvTigcypPDDRTbJLkTZlQNofjG06LTJDu+p6AU+nfkTtTkLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ntgp6TCZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ntgp6TCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714C41F000FF;
	Tue, 13 Oct 2026 11:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892234;
	bh=ehRbBMF1327G+kEP7RwLFbHvUftEgVkcOR2zWzc1HXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ntgp6TCZXmHo83jN6E/4dpZKrkQ8oyolQfyYfY57dfuPMMZeklXbN6mwz/rjiqbIs
	 KGn/f2nwz4GN1hKO4/zsEqB7dD16XM8qJkEoaLw4G7PhXART2nG0NBssHNvtGK4yMF
	 A9mA3cuO0jowpkiv2TPwEd4GUAjio+i+Sz+JVkj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 078/281] mmc: cavium-thunderx: destroy slot platform devices on remove
Date: Tue, 13 Oct 2026 13:36:34 +0200
Message-ID: <20261013112857.023347298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 29ee8cf18a21b02cd0b2e35f741b61cd1fe3e14e upstream.

thunder_mmc_probe() creates host->slot_pdev[i] with
of_platform_device_create(), while thunder_mmc_remove() does not destroy
the child platform devices.

The probe failure path removes each MMC slot and destroys its associated
platform device, but the normal remove path only removes the MMC slot.
As a result, the child platform devices remain registered after the
ThunderX MMC controller is removed.

Destroy each slot platform device during removal after cleaning up the
corresponding MMC slot, matching the probe failure cleanup path. Keep an
extra device reference around of_platform_device_destroy() as done in
the existing error path.

This issue was found by manual code inspection.

Fixes: 166bac38c3c56 ("mmc: cavium: Add MMC PCI driver for ThunderX SOCs")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/cavium-thunderx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/cavium-thunderx.c
+++ b/drivers/mmc/host/cavium-thunderx.c
@@ -173,9 +173,12 @@ static void thunder_mmc_remove(struct pc
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


