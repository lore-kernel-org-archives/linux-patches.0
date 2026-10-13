Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051AA4FB9B7;
	Tue, 13 Oct 2026 12:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892980; cv=none; b=itFJ6maO0toLlGc7IRaktNg25lYcGBA4JTtpcSY8OUIlMfxT1HmmwFx/jTqvNtEHhUSGtLHYjsI3LGX1rMbFXLZJgLwM/NWm196q3ijf9rQV1vGaj+3uSx51uwax7X28dgIem5esk7fGqY/QmQYRlzO1qL1VzqmT6x4SQhu0AqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892980; c=relaxed/simple;
	bh=2iIKLQlMH5ayLHBw0hkuclRNxmvfRWLy6ZbnfCDsBM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJggUzDUa1nPl80nmCqsO47khvm5mjd9J6d+KQONr/JN8YfaFyzYO2RfuMBSjzBprtlKQQjumAZHJ7mHx9NvljbLn1Ch70cVPGYqtN6MWB68UoDZm9h6Ro/7Csi7viWfLCd7eG4eQFulWjDmiaaLbDtt0FGMuyIPs3L7/ZbyCvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpAw1xpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpAw1xpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5DC1F008A1;
	Tue, 13 Oct 2026 12:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892978;
	bh=QP/7lV6sdNI5NVxLOuX07yuOJ/sQugGPg7Op7QswbYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpAw1xpxC53IZFsKsiDnfuIsoCN89GpQfsnxEEJdXTsk41tMLLsxQlg7FZ0QD2+tM
	 pWcxL0bhMWGn8lkCAl3ttSSwtNRIo9Ua49nKLPkDv8k1VLuaGRAv+NGzYgJUjHIY6N
	 sGFQDQHuJtZzxMv5ASE7cMhhEH3Ro4ADIohXXK7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 073/621] mmc: cavium-octeon: destroy slot platform devices on remove
Date: Tue, 13 Oct 2026 13:31:08 +0200
Message-ID: <20261013112922.588713061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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


