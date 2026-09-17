Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16D54B7A59;
	Thu, 17 Sep 2026 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664509; cv=none; b=Bzsd+6+sgH6WdcOCwGv7h6Lfuv1x078yMxNQfXVSn2R3//2AsdTeBsfEFlJskPMFWH2MzJB+wXRo+4F2HrEx7HGSg8JjjhuDzNBfddJb1+stQAf3RteXtcGonU+QlVlzo4xYEmIPe/d9d5MhQWWhgvVBCmmLlPWn4EzLDwLh5JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664509; c=relaxed/simple;
	bh=52RLECVWT2b3ivfFRpEI4LqUMQ94vtzhC+5dAnUPPSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VERx77XC7xSnpgiTsy0hCYDLeFKF2gzGJ49NcUvg7tLbpV8GbBKj/PzNp0Jef6C++sm+rE/uTHDSN2UpAQuIaIxdMuUpZh5P1r+rIz/kIvV7ynfA2EByZdN6Y/o4R9m0+TYCrmG/m7PNQG4OgXP6DrPYvYXgyQjdae4LgUSCmTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1nMyFb4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1nMyFb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304551F000FF;
	Thu, 17 Sep 2026 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664507;
	bh=xsfgLiuvSgshbuRP5FtyTheEAUBm6peBRNSJEwkkgsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P1nMyFb4KEMtiI2oFJNHHOIKmwlq9mwgSk4p59u9Fr5sa4/8J5BJQU4gej6EZjr0F
	 QM9ahnfj2IxGfY/dy6zH3To6gdZPNfkbk/cnRFMwyiXuhXuv5uE3p1zKWHlw0a9dwn
	 ykblYc1jDoVA8n/GWwNRM5E633T1HuCmZkGqxxkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0388/1250] dmaengine: altera-msgdma: Use memcpy_toio for descriptor FIFO writes
Date: Thu, 17 Sep 2026 16:03:03 +0100
Message-ID: <20260917151602.554660824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>

[ Upstream commit 94963138cce29f85605d76c94fa1d43a0335ead9 ]

The descriptor FIFO requires that all words of a descriptor are written
in order, with the control word written last to flush it into the DMA
engine. Using memcpy() with __force to __iomem is not the correct API
and does not guarantee appropriate MMIO access on all architectures.

Replace the descriptor body copy with memcpy_toio(), using
offsetof(struct msgdma_extended_desc, control) to exclude the control
word. This matches the previous sizeof(desc->hw_desc) - sizeof(u32)
length only when control is the last struct member; add a static_assert
to enforce that layout so a future field after control cannot silently
break FIFO ordering.

Keep writing the control word separately with write barriers, so it
remains the final word pushed into the FIFO.

Signed-off-by: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>
Signed-off-by: Tze Yee Ng <tze.yee.ng@altera.com>
Link: https://patch.msgid.link/f6f3b4a2e2eb0eb1a51976de3f5d1ef5bab9bd76.1779697226.git.tze.yee.ng@altera.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/altera-msgdma.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/altera-msgdma.c b/drivers/dma/altera-msgdma.c
index a203fdd84950e..e1811a9be0bbe 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -498,6 +498,11 @@ static void msgdma_copy_one(struct msgdma_device *mdev,
 {
 	void __iomem *hw_desc = mdev->desc;
 
+	/* Ensure control is the last field — required for correct FIFO flush ordering */
+	static_assert(offsetof(struct msgdma_extended_desc, control) ==
+		      sizeof(struct msgdma_extended_desc) - sizeof(u32),
+		      "control must be the last field in msgdma_extended_desc");
+
 	/*
 	 * Check if the DESC FIFO it not full. If its full, we need to wait
 	 * for at least one entry to become free again
@@ -506,17 +511,18 @@ static void msgdma_copy_one(struct msgdma_device *mdev,
 	       MSGDMA_CSR_STAT_DESC_BUF_FULL)
 		mdelay(1);
 
+	/* Ensure control is the last field — required for correct FIFO flush ordering */
+	static_assert(offsetof(struct msgdma_extended_desc, control) ==
+			sizeof(struct msgdma_extended_desc) - sizeof(u32),
+			"control must be the last field in msgdma_extended_desc");
+
 	/*
-	 * The descriptor needs to get copied into the descriptor FIFO
-	 * of the DMA controller. The descriptor will get flushed to the
-	 * FIFO, once the last word (control word) is written. Since we
-	 * are not 100% sure that memcpy() writes all word in the "correct"
-	 * order (address from low to high) on all architectures, we make
-	 * sure this control word is written last by single coding it and
-	 * adding some write-barriers here.
+	 * Copy the descriptor into the descriptor FIFO of the DMA controller,
+	 * excluding the control word. The FIFO is flushed and the descriptor
+	 * becomes valid once the control word is written last.
 	 */
-	memcpy((void __force *)hw_desc, &desc->hw_desc,
-	       sizeof(desc->hw_desc) - sizeof(u32));
+	memcpy_toio(hw_desc, &desc->hw_desc,
+		    offsetof(struct msgdma_extended_desc, control));
 
 	/* Write control word last to flush this descriptor into the FIFO */
 	mdev->idle = false;
-- 
2.53.0



