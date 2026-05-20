Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B4517A2FC;
	Wed, 20 May 2026 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302084; cv=none; b=g9JdxA29iljIEw8qeHVf/L/57sfE4zc63D7hMtAXwhTTDWGxf7Q37YnciL0Lj/WCwUI8cT+bRO+mkG1tVBNkYL2HGYhKR/U0RzMqI5gX1afzDi+i5UZv9Vgc92uvKzIzh0qb5aUdMM1e3v6ek3Wd4UzoQ+mVtY3L6ZvmNwyvZ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302084; c=relaxed/simple;
	bh=hSx7WweUziJovEjwrTDrUJAbRWdo5jmYkkr2zObZDrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/RWuQ2tPio4BeELjp34zTdTdditWaZSDT08Dgka1bqiHFUKbrkFSf/atc24CGqPxuKWon9I6tYHODzENhSfWeoDhqT6sR1KAByw3v+lcc4tgEJmJ1HCM1PATwlhTy1UFVau2WHuuWhq5rICmlfp3ZOsYT8/Naef1eBnMJcTzuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qz8dmtW8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qz8dmtW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5702F1F00893;
	Wed, 20 May 2026 18:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302082;
	bh=UowALS50zSRRQMhNbLuRDqFyHVW9B8x0P08aKRGbsao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qz8dmtW8avbxlLQSGD9gtdc6AjLt99c+yp3BllIUl3/nN334SSM/ono7eUF7wn1DH
	 K4k5S2Rxr1gGAzKap004a6rZC4aanUoYn0Qn5s3RVEb5C7GyXtKs9cPCc/QXlnV+ec
	 cEEPvsp4Apub+++ibhd5SmNTN1lo8i5DyR1vcAbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/508] drm/msm/a6xx: Use barriers while updating HFI Q headers
Date: Wed, 20 May 2026 18:19:16 +0200
Message-ID: <20260520162101.511410185@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 25b235b49ebc2..14a0ec4a56fda 100644
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



