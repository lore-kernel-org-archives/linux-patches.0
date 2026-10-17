Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98923BB133;
	Sat, 17 Oct 2026 17:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257246; cv=none; b=sd7unhRYQHque72btNlUTLyM/3NYRGYxWA30nSyVJDVtwicQUz2XegCXGQ4b/vS548AqN7RU5Pbo5YxGwTyeFOm9hUpwy0O8wX5OkmG+VTBPJXGi57gs+MF9J8Z7Xuyg+xQlI9VxRQBuprUfKHIQC2ydUXto20V8mH1lavVtZkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257246; c=relaxed/simple;
	bh=3cdztheoG79YKzpkk99sOcffwkF4EjA/efh928hIB6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBnsJxHSzUdX5LpZf/3nGSv58wh7B7eiBnjZsbdPzPoqA9NlTGV2Q3SD4dB8l1L+LlqzYgMAhnL2rRYT37H+YwLVqD6hHZwwAWaDq3ng4HibzwZ8kghPMREQoSg8XobbrTQPt5GkTTQQVmYyTl3T2KOgI+AAEHflTjU9C94iuh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4InbDaM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4InbDaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021551F000C4;
	Sat, 17 Oct 2026 17:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257245;
	bh=gLcpkJwlTD5okwP08L38T2fwLukqT8lWhIUhjTqRap8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4InbDaMNwXYavMeiNkwfNB/apxafJmBAacKG8VjXYLPofcxL8MU4A66Le8zwvGi3
	 nc0V5ktemOw3l8SZqRdLY10aBxksxuybZER2N0X6+lyWbuDSDTKhMlcZnweWzhg7Zg
	 nEgh+dluiZ6UXDtB5lCe0FdmwY477PpNgkQrKM2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0498/1674] mmc: cavium-thunderx: destroy slot platform devices on remove
Date: Sat, 17 Oct 2026 17:46:10 +0200
Message-ID: <20261017160443.898528666@linuxfoundation.org>
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
@@ -174,9 +174,12 @@ static void thunder_mmc_remove(struct pc
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


