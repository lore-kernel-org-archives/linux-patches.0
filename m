Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15782285C92;
	Mon, 22 Sep 2025 19:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569934; cv=none; b=TwcTtdZjBMJNFSyLPUXm1QGnfZ4XPbC6DdoTGlYe2fweaPhR9KBNQZGagPWTvA400DRyl5Gy1tMFOcPKKLeF4p6OrmwZopXQbDrhFfrKc1y0tQpW+2ZKIuAdYXwDehT6Z7yRDq1feWG3eKa8zXYLPx4WiLEBOEcYeaYaNcvObh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569934; c=relaxed/simple;
	bh=nJ2P2k+M5NOVkJV+JVBj0A4jVyMPnbwn4U3gT4lB69E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2Qz8XDStXMARZ2jsH1K10XNSCvumJzhy42PBHNsKzVYaxn1n6tEDU2Z88Cx4u1C5jb4XSaniM53bA7Pq5tjsu4LVJXdSFn+CZ+ZJiFBpoQ8sY5nYftO6yov5JECaMxCpMJZ4a6vMpHof8Jlms71ni/xmDPR2o1N6egGwU14epM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqCo/Sit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqCo/Sit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2451C4CEF0;
	Mon, 22 Sep 2025 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569934;
	bh=nJ2P2k+M5NOVkJV+JVBj0A4jVyMPnbwn4U3gT4lB69E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqCo/SitPBRAh+pWk3zcKx6ZVi3ue2pkGkny8I/rD6nDOGEiYW6YeO8+8BYx9B88u
	 Ly7DMD1IK9i39bHUtsq6gXTySzu5OvS+ec2jWyoT6LEBF4bDleDDCI06KWm9nRGC4Z
	 BULl1vkRf+NgXbipF1KzXVXIEDEiSv6ein3rswiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 057/105] mmc: mvsdio: Fix dma_unmap_sg() nents value
Date: Mon, 22 Sep 2025 21:29:40 +0200
Message-ID: <20250922192410.408331126@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 8ab2f1c35669bff7d7ed1bb16bf5cc989b3e2e17 upstream.

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 236caa7cc351 ("mmc: SDIO driver for Marvell SoCs")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mvsdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -292,7 +292,7 @@ static u32 mvsd_finish_data(struct mvsd_
 		host->pio_ptr = NULL;
 		host->pio_size = 0;
 	} else {
-		dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->sg_frags,
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
 			     mmc_get_dma_dir(data));
 	}
 


