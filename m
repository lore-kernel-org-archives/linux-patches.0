Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9E1399D0B;
	Thu, 17 Sep 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668150; cv=none; b=PBcGV+ICx5XBfxr3YW9XJ4bczA8JBRRYD4tIRFmvUoFwcjrt6JnsRs22MmoYO9qn+Hqr0o+W3HSTLmMtu2HLYLh45VpPOg5yGan/1BTT1v4kQi6yEa7h8Zw+maMmDM1mMadJQSoyHLGoluLZzaKPzszH7xMwY1IDhtKVAFdz1xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668150; c=relaxed/simple;
	bh=QKHlrT2Xh7OAiBeBSwzomdH7Sm2B8LpIdOA066EkJdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aD86dcFXx0V1LUfZdMvdJbtkZVrcpvI2Nur5m3aRY3OGivwD+SrWtxmefJqpZykpHVGSyVyO3v1rLUjEbLrVsE7o5+aCHrrOMCnc14E7iaz3nqh4kB0m9XKtaO7bjFZd/kf6KW+c08s95ECjxvmJERoKqQKnVSdL67Lbyqod+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wyMEiTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wyMEiTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131481F000FF;
	Thu, 17 Sep 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668149;
	bh=ufrJD7Xvwdnsn0naJrtWXW0tRS75INbOCjLBcMVjgkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wyMEiTD/usvBEwrwULXchqUm4wDunIXGPD2hUi/rWbuUwJWYLwlcBG9ryY/YS/4R
	 cPjftErpqvHiluhN19UfqBfclqLnkLzsRj153Bnb8eLtKx9NIbXcM+YSrzHCj2WQqK
	 XyPVEFvdVVf6RZqr2eEcjw1nEQxh3pmOUgFe32fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0282/1102] dmaengine: altera-msgdma: Use memcpy_toio for descriptor FIFO writes
Date: Thu, 17 Sep 2026 16:03:45 +0100
Message-ID: <20260917151546.691678749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e6a6566b309ee..5b1be7162b432 100644
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



