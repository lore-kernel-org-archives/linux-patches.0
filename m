Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3249E3148DA;
	Sat, 30 May 2026 17:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161111; cv=none; b=CBjTf+uvmuG1PnihdmwWr0/zSG4xAA2Lw2LiP+JwTlE8gZmKCSbuoFnKcBPElKK5EujNZA4W7sYlu0Tj81OZB94N6DaePCRGGnEhc3crst5HYIZElSC7oaHr5B5F92pBVuHDLQWDEnLhWRoPkQn7kKGrvvZb1ovf2i7fzEnKtRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161111; c=relaxed/simple;
	bh=hO4BnrTcpgUpEvn286iUGhtDqVHbds/R2rnjxRxHU8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAvah2GOEEv/4rP+on1z4aXNvC8N4yq38I8bRm2/6NHuHmh78Bh4LBPuAM+urH6omoaUiYcJfNUj6S3Gkoyvp0Uwao+SDc+oq7PA/RXnn3p+cfobqKG3oAWeDkutpck8MfydOmLGS09Y1PyDXJbafYlo6f4Tok11v6IOKtI9GdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IT7TdwtS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IT7TdwtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C141F00893;
	Sat, 30 May 2026 17:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161110;
	bh=9bzMnpprKtnyVfpHlkvJDKTBqYzTfBO1pWYm5KdtliE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IT7TdwtSrzxiDTpSWsnXgsFdRKD9iC1RTHZdKZz3BTMPmgCrmMziN/ug1aot9GXUX
	 GhF4K2u6GzQ5jyrP3Int/WhBw58GIL5VZA4lgvZ1uv6vsnu846UBFmu/elCcVtF/UK
	 DFc1LboThUbB9tq9obKBEjInw9jqLXrLpQ+6jd1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 528/969] drm/msm/a6xx: Use barriers while updating HFI Q headers
Date: Sat, 30 May 2026 18:00:52 +0200
Message-ID: <20260530160314.939574530@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2cc83e0496133..753a1bcc835cb 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
@@ -29,7 +29,7 @@ static int a6xx_hfi_queue_read(struct a6xx_gmu *gmu,
 	struct a6xx_hfi_queue_header *header = queue->header;
 	u32 i, hdr, index = header->read_index;
 
-	if (header->read_index == header->write_index) {
+	if (header->read_index == READ_ONCE(header->write_index)) {
 		header->rx_request = 1;
 		return 0;
 	}
@@ -57,7 +57,10 @@ static int a6xx_hfi_queue_read(struct a6xx_gmu *gmu,
 	if (!gmu->legacy)
 		index = ALIGN(index, 4) % header->size;
 
-	header->read_index = index;
+	/* Ensure all memory operations are complete before updating the read index */
+	dma_mb();
+
+	WRITE_ONCE(header->read_index, index);
 	return HFI_HEADER_SIZE(hdr);
 }
 
@@ -69,7 +72,7 @@ static int a6xx_hfi_queue_write(struct a6xx_gmu *gmu,
 
 	spin_lock(&queue->lock);
 
-	space = CIRC_SPACE(header->write_index, header->read_index,
+	space = CIRC_SPACE(header->write_index, READ_ONCE(header->read_index),
 		header->size);
 	if (space < dwords) {
 		header->dropped++;
@@ -90,7 +93,10 @@ static int a6xx_hfi_queue_write(struct a6xx_gmu *gmu,
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



