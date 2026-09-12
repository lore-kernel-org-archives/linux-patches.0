Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66461345EA7;
	Sat, 12 Sep 2026 17:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232990; cv=none; b=CcfFriBXWwGDhKs1qpJfnSKcSYbO+SMyyW9yXuvkggj29b4zRLliUiK1eO4MCXWLPQueCSi/nHc7Tb+QRyq/ADiCqmkXlmJWVMw0FvMIemOVsEtC5svxXr5Hj3tQ+EyGVdtDjYp73k86xrJAtZ+SDmYX+Qn1XtOuEMgz7gr8Rf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232990; c=relaxed/simple;
	bh=dp1XtNWfEGSG051WaCWyXpx4/5B+vOtW25zTq1waJqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMZQLBeSMg6JKerufRxquxn4+Be2zvbJH5jEgxiLKssbX7m6LFItY08yxLa3+DDTp26OzndEpOy3nnehgNDz+885YzIeufjkdR3U4mp2Hn6OjZwkqVOBypoAc5Q8AOKSBZvA2ue0YCacGfU+P2NHizajITZk+hFrIz3J62XCau0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc+0osQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc+0osQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0851F000FF;
	Sat, 12 Sep 2026 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232989;
	bh=6EhSqL7SdYxu9kDxK0/TLA+9uTX0mTzevFTi8wE85pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xc+0osQ10d6yzQ5yrTLSUVBJyxz+OKsbsr8zmouBumRRKLYKdZjrS3iVeSuk5VHQh
	 v6Soqii23i1ZsTSflLkaMnFEaTy0PK807ySYwuXC7zF3iNM6GD3nEe5Xljg8MYygEH
	 u9JJ/NyvFk329ZQFeHHcdWPhGJpTvWBw6nhRWuzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Merlijn Wajer <merlijn@wizzup.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 080/935] hsi: omap_ssi_core: fix missing DMA mask setup for SSI controller device
Date: Sat, 12 Sep 2026 08:51:50 +0200
Message-ID: <20260912065528.666865550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,6 +509,12 @@ static int ssi_probe(struct platform_dev
 
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


