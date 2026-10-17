Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894EE3BB69B;
	Sat, 17 Oct 2026 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257243; cv=none; b=JBysivzccxsyBP+rbi7lUXvGjAWTwjfTCbU6DZRH9WQe9fClrIoA2xuBHdCnYBY0mbWc8XQbkIrLIyGzI7mg6fafF0GvuEIOINU1pUMWu+9f3WdOMRxX+Zl0N6uwWkY6f9V5+baygdXfkEZD69rnbGE9/fyDq0bFC1l/Ju3F+3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257243; c=relaxed/simple;
	bh=M5nACWHpK5dpbeGEHA0NZvQD7o+e6MmbUcS70frdojk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5RxgcMbqdqOPC6aaYnmYlYxad4uAQHIs7q8x6hsL6Etx/tJkRw7EW+oO9mMEOVQRu3E19aG3apc6/DtZwGl8CEyhcGDw2y8gUVCEYCcVCWPYyqjDq2YaFNmgtwC7LWL1VDVzjFO1f8BAKb76AZx6TNtbKiyhYFNH3InCN1KW5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arOq4rSR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arOq4rSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66441F000C5;
	Sat, 17 Oct 2026 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257242;
	bh=68RYVDepoJkx+Yl4fhdCiSBHXK0FCNjk3alW/MWYepU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arOq4rSRKGvj9WERLMvUxcNNz6nppyk3qqxOSrnHX5rvIyJ/POnP+Xu01ccpMl391
	 A/Mylvejw3Am8nhFgAx+E6FR0wpEtt1zBDsHB/xeFiNHomJ8XQB2QNa9C+StA/3ZDG
	 xNkmXOgsIS0K5N7eSNNpcRlA+aYu+ZIuxezST/Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0497/1674] mmc: cavium-octeon: destroy slot platform devices on remove
Date: Sat, 17 Oct 2026 17:46:09 +0200
Message-ID: <20261017160443.873192747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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


