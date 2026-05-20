Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB023E95A4;
	Wed, 20 May 2026 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300492; cv=none; b=aj9b6tE3mfuFyAU8BPRSo4ZspV5z+criEw48XKTzO9J9mK4zZTTZzU0h4MgLeTbTQZ5L6oXx4FvKQflHpIhmRgL+yLHnBPxU6LadN2hC01nbKqTtiKKd8V215j22HMBHhBnZTGs2pu2dxSSMmdpWIDqpJIrj58JxyEiDspV9ud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300492; c=relaxed/simple;
	bh=7gxEUxsU/jG5226bLhD4HfieoyoEvnMEJyDvFT0XeyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSGfUemx64iFvSF0ZvFuVZOFXBdva4FfIAQh4PNt6YkxNf2x7dkrsVOlmNAW5DthFYdc5uvZb9pz9JZOKzSxTQviWYeDL9+ZbKgA0Dn++1afHokqNM4+IgkPgiNTNPABKedag7is0CsAT+lenPNT9Q3ZaO+wopbHyo0hj3Q70fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+boTDJ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+boTDJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64651F000E9;
	Wed, 20 May 2026 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300491;
	bh=Pn4ebHCcQ/qxrvI7xGLGoIwEpywZc6KHfAahITNBgNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+boTDJ0L1PP+aSTqfYqEcD1CsKgy3TdFhV2DlfagtZ5ssQGts8y1Tv8VJuJM+Ms8
	 NHeuCUM9D1fDH5m22Q35SPIy3zhp+Tl6NbYIPP8qdpAL0i/38Rtxzgxv45p9FoQkEt
	 9tAOqNjiixcCanVTsvepAEEzsm2MrIt1Nzi7HsCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/666] drm/msm/a6xx: Use barriers while updating HFI Q headers
Date: Wed, 20 May 2026 18:16:45 +0200
Message-ID: <20260520162115.404692825@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit dc78b35d5ec09d1b0b8a937e6e640d2c5a030915 ]

To avoid harmful compiler optimizations and IO reordering in the HW, use
barriers and READ/WRITE_ONCE helpers as necessary while accessing the HFI
queue index variables.

Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/714653/
Message-ID: <20260327-a8xx-gpu-batch2-v2-1-2b53c38d2101@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_hfi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
index cdb3f6e74d3e6..b858e740ac7e5 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
@@ -31,7 +31,7 @@ static int a6xx_hfi_queue_read(struct a6xx_gmu *gmu,
 	struct a6xx_hfi_queue_header *header = queue->header;
 	u32 i, hdr, index = header->read_index;
 
-	if (header->read_index == header->write_index) {
+	if (header->read_index == READ_ONCE(header->write_index)) {
 		header->rx_request = 1;
 		return 0;
 	}
@@ -59,7 +59,10 @@ static int a6xx_hfi_queue_read(struct a6xx_gmu *gmu,
 	if (!gmu->legacy)
 		index = ALIGN(index, 4) % header->size;
 
-	header->read_index = index;
+	/* Ensure all memory operations are complete before updating the read index */
+	dma_mb();
+
+	WRITE_ONCE(header->read_index, index);
 	return HFI_HEADER_SIZE(hdr);
 }
 
@@ -71,7 +74,7 @@ static int a6xx_hfi_queue_write(struct a6xx_gmu *gmu,
 
 	spin_lock(&queue->lock);
 
-	space = CIRC_SPACE(header->write_index, header->read_index,
+	space = CIRC_SPACE(header->write_index, READ_ONCE(header->read_index),
 		header->size);
 	if (space < dwords) {
 		header->dropped++;
@@ -92,7 +95,10 @@ static int a6xx_hfi_queue_write(struct a6xx_gmu *gmu,
 			queue->data[index] = 0xfafafafa;
 	}
 
-	header->write_index = index;
+	/* Ensure all memory operations are complete before updating the write index */
+	dma_mb();
+
+	WRITE_ONCE(header->write_index, index);
 	spin_unlock(&queue->lock);
 
 	gmu_write(gmu, REG_A6XX_GMU_HOST2GMU_INTR_SET, 0x01);
-- 
2.53.0



