Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F094F3ED5;
	Tue, 13 Oct 2026 11:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892203; cv=none; b=Wp7B3Vb5V6Bi+0U/lr8lQTGOmV1nSqFDWhkJwmpAtl0677Y0aC8QKyWxSonldZUgXfyLXmWJPZCDB46gPMc+sQ/raIdlywm7Az5R2zoJIX9djitcBP7VjfTj00H4dKQeWRUIEYoVd+6Kln1mMzWKHSH6v7hO9rKd1OqdfCmMWOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892203; c=relaxed/simple;
	bh=Lzxw2loZz8k1kDgN2PxjUAzMtAW4uBej0Xo8y1pRVJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULSzFQX5OM0S0y+kD4/7mLoe5VALYgIq+R+Ps9ZDbpSR8DH5CD3NlaFeRsdJHkUQ8XYwnudmH3Thmkt1WBZtA7aqyZ4ndAHKxdd5IRObCEDc2E71le45GFeH2dhiFEdBPgSRt9S5/lhcYkc7dbYzWzic+WHvrKv3NhAk5MOwitE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpKz1Ysa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpKz1Ysa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2731F000FF;
	Tue, 13 Oct 2026 11:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892200;
	bh=AwPoGWIBtRh3jYZNAA1Q9pQCA/kCvCCS5GE0WtVbC6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpKz1Ysa1JbX1wKxAGlmGu45hT+JAUflB9qByazhJMuIKlUjUNqjxuMgOB85qkoRk
	 c+NBUgzIfX6wFbajUIEPWA3yTu/S8Blc5ZAPWCXXdlPygOH86gxT7GeSEuuTOkhr/i
	 m5honqJ3zOCMOL8o+SChu1z7nALdu2cgJ8Qjqs/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 077/281] mmc: cavium-octeon: destroy slot platform devices on remove
Date: Tue, 13 Oct 2026 13:36:33 +0200
Message-ID: <20261013112856.999667328@linuxfoundation.org>
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
@@ -301,9 +301,12 @@ static void octeon_mmc_remove(struct pla
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


