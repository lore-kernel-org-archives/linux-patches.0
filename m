Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448014FE2D1;
	Tue, 13 Oct 2026 12:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892983; cv=none; b=ROVeLeaVyuR/9Sc/vcKCxswT+uibwbG7iRajydk61NLtOzfuuCtwFyjpATWOMGx2Y+ZlCMT7eZbZy6Y6XvmbbHCn1DhlULTEskcxSYvGtAylrv7GnvG77HcjtVemG8ms13im98bY6XX/rSBPq8Us89x5CxY+hsfNqMwf4cvTsns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892983; c=relaxed/simple;
	bh=xMJyVEevQMuDJysDjZhKDSalnzWo9dQoc3wqI6TgLAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fy3DnS+CViRr/oTrelLQvqWc0ohsC/pKfcwND5Xx8NcJUFl6KpTwe6wDR/w5SlmOlm2rTT1xBCTe8BjRuskNf3PGMPQ1wf/dtNLECobrEKPQj0n+ZBmzoX/LrZMk4PrY/IGyQewG1q1/UXaJfL2Xj+TyYIbznmkIwmbqdLy5XCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0uCMkT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0uCMkT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA121F000FF;
	Tue, 13 Oct 2026 12:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892982;
	bh=qciexvdZNYuQ4X//Ie9r42NdTGRg03NxWPJG+h8VZdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0uCMkT6R9lYzFriBfi2W+anjg5ME+/exHF5HtoU92gCXc/uT3xj9cFiWEI+/Clp9
	 TOsp4f9/JBV7xMDLhDCg1GpUxWrPWaUXPBWM/tAmLOh/YQIDvbMZRkERXX3cUlvi0Y
	 oAaadTDZ5UGqL/Pxltnw0ux9WqHfKO0wCx9f5yTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 074/621] mmc: cavium-thunderx: destroy slot platform devices on remove
Date: Tue, 13 Oct 2026 13:31:09 +0200
Message-ID: <20261013112922.612871389@linuxfoundation.org>
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


