Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D24130C366;
	Fri,  4 Sep 2026 05:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501018; cv=none; b=b3JNAscr7CxQjih1Jtnefed2rNjbz70imXvGehy8qTE4EUMFGNFfpyb6gBylTbjqkGYWuLPDAacOi/fSt4Xeue92cIXA7uvLRnnyD67Ceqjk4Bq3h4o5R9iAnRC4F7qOtnu8zMT+51PMs1rG+L8MrT5mgt1C7WozunMG/MY25nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501018; c=relaxed/simple;
	bh=srxQFFWVE4GcMhJHGB5eKWePOy1zhwKe4cmA1zAiDMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPG8gwcajFkZvV+qCY+fDKTtSsF/s3m7W9JTD1i6i2alIvC2yA0W6nuWt7Dft5aYgkOKNASglQ4aeQ12AMecO5VBsKYnmZOzYcTFZxeKE1BMty9JTcz1PDekSzmZKCNE6U2fxAVJgruglGSTlSodZPDM1tNTagtZgz9ccAi4sUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9NGflmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9NGflmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C7D1F00A3E;
	Fri,  4 Sep 2026 05:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501017;
	bh=KPBpWvNO3s5o7b7IUI5gDl5es7DUNO0Xlc4rRndZRlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9NGflmycT4AuDEhPREIGSPhaARVThmBF3/2Yi+rI+LKpkFobrIhxhG0UzDaoN6XI
	 VK62bAvFSWyJDS0oOUplOSMvzNbVid6iZy58K8U3yPDJNYUwmmnb4Bnao9zS0/uH9R
	 tIyM2mOIfxC0KBrsBFt1lVR3gSZiFZ1UL7/fLEyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Merlijn Wajer <merlijn@wizzup.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 208/552] hsi: omap_ssi_core: fix missing DMA mask setup for SSI controller device
Date: Fri,  4 Sep 2026 06:56:05 +0200
Message-ID: <20260904045754.027551414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>

commit e81250ec6b69248b00d38c523dc6a13efaf38aab upstream.

The OMAP SSI driver uses a synthetic HSI controller device allocated via
hsi_alloc_controller(), which does not go through the normal OF/platform
device initialization path.

As a result, the embedded struct device does not have a DMA mask
initialized by default.

After recent DMA API hardening changes, dma_map_sg() and related helpers
now require a valid dma_mask to be present, otherwise the driver may
crash or trigger warnings when attempting DMA mapping operations.

Fix this by explicitly initializing the DMA mask for the SSI controller
device and setting a 32-bit DMA mask, which matches the hardware
capabilities.

Cc: stable@vger.kernel.org
Fixes: f959dcd6ddfd ("dma-direct: Fix potential NULL pointer dereference")
Reported-by: Merlijn Wajer <merlijn@wizzup.org>
Closes: https://lore.kernel.org/linux-omap/4ed95c71-2066-6b4c-ad1b-53ef02d79d53@wizzup.org/
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Link: https://patch.msgid.link/20260724130522.706480-1-ivo.g.dimitrov.75@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hsi/controllers/omap_ssi_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -502,6 +502,12 @@ static int ssi_probe(struct platform_dev
 
 	pm_runtime_enable(&pd->dev);
 
+	ssi->device.dma_mask = &ssi->device.coherent_dma_mask;
+
+	err = dma_set_mask_and_coherent(&ssi->device, DMA_BIT_MASK(32));
+	if (err)
+		goto out2;
+
 	err = ssi_hw_init(ssi);
 	if (err < 0)
 		goto out2;


