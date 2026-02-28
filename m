Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F2043636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301165; cv=none; b=nusyGzL9WeMclJ7sQwCqcpmyDalRXve8gYBoW0CC3pqgeKZd4tInJVFVit5vX9l4U1IfBt3rIaRLWM1F9dlgo09PJXUNGz/iKfIzqWvr4vJohOX1IpKdOOSGwxx+RER3NlesFznR1tz4bgWQJmkQIydADEnCPB1o44R5dvvCBa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301165; c=relaxed/simple;
	bh=QT7k5Yx8S4mIz0mDONZEoZmlqOPLD2C4OTwYpUqprks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgbtSjf6dfPrJCa9wApTKplGNS3/bz3RSrVvENXvmWpGUOqaGxEIkpozQ47HJVTywLGToFfvGTA3er2cEEpLf0/HJkWoTNKPFn67qwvteVhJOuKHt9AzNWHTi+tZkEJvsc+MDvYF1ZTFbCQhB2rRTJersa1I90Fu4Dof2Huun2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CcbrNDli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CcbrNDli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329B6C116D0;
	Sat, 28 Feb 2026 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301165;
	bh=QT7k5Yx8S4mIz0mDONZEoZmlqOPLD2C4OTwYpUqprks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcbrNDlinWxHu84l3u2q3cPhsM7XWJp0QkzWmuF+V6d4KucTlPSMGxcfOfirjKsGz
	 VzO3JPYTZqaqsC4xblqBqIpzEu3k3EbBXgsAFzr84LbVcv1BU3vInsu06lyu9B+oaS
	 9Pcg9gEbRaLdBDY+976aT7wgR3ffJ4tuGbwqVPXJqf4v1BXK0oz8QM1UPmrwKh5B32
	 sKozZ5hRXsBWTtRmHfF6dB4eiJAMFMtldVM9XvQWrU+5HPSx/9GLss6JlCX3kC2Zmm
	 rIUSNLeZUCMs3IfxneOvHvdZzT1Af0sh6nGwTCpdganb5zkBskkyu9C8036QbHMkyk
	 UZXtgK2WcyIwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 331/752] dmaengine: sun6i: Choose appropriate burst length under maxburst
Date: Sat, 28 Feb 2026 12:40:42 -0500
Message-ID: <20260228174750.1542406-331-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit 7178c3586ab42693b28bb81014320a7783e5c435 ]

maxburst, as provided by the client, specifies the largest amount of
data that is allowed to be transferred in one burst. This limit is
normally provided to avoid a data burst overflowing the target FIFO.
It does not mean that the DMA engine can only do bursts in that size.

Let the driver pick the largest supported burst length within the
given limit. This lets the driver work correctly with some clients that
give a large maxburst value. In particular, the 8250_dw driver will give
a quarter of the UART's FIFO size as maxburst. On some systems the FIFO
size is 256 bytes, giving a maxburst of 64 bytes, while the hardware
only supports bursts of up to 16 bytes.

Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20251221080450.1813479-1-wens@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sun6i-dma.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 2215ff877bf7d..f9d876deb1f05 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -583,6 +583,22 @@ static irqreturn_t sun6i_dma_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
+static u32 find_burst_size(const u32 burst_lengths, u32 maxburst)
+{
+	if (!maxburst)
+		return 1;
+
+	if (BIT(maxburst) & burst_lengths)
+		return maxburst;
+
+	/* Hardware only does power-of-two bursts. */
+	for (u32 burst = rounddown_pow_of_two(maxburst); burst > 0; burst /= 2)
+		if (BIT(burst) & burst_lengths)
+			return burst;
+
+	return 1;
+}
+
 static int set_config(struct sun6i_dma_dev *sdev,
 			struct dma_slave_config *sconfig,
 			enum dma_transfer_direction direction,
@@ -616,15 +632,13 @@ static int set_config(struct sun6i_dma_dev *sdev,
 		return -EINVAL;
 	if (!(BIT(dst_addr_width) & sdev->slave.dst_addr_widths))
 		return -EINVAL;
-	if (!(BIT(src_maxburst) & sdev->cfg->src_burst_lengths))
-		return -EINVAL;
-	if (!(BIT(dst_maxburst) & sdev->cfg->dst_burst_lengths))
-		return -EINVAL;
 
 	src_width = convert_buswidth(src_addr_width);
 	dst_width = convert_buswidth(dst_addr_width);
-	dst_burst = convert_burst(dst_maxburst);
-	src_burst = convert_burst(src_maxburst);
+	src_burst = find_burst_size(sdev->cfg->src_burst_lengths, src_maxburst);
+	dst_burst = find_burst_size(sdev->cfg->dst_burst_lengths, dst_maxburst);
+	dst_burst = convert_burst(dst_burst);
+	src_burst = convert_burst(src_burst);
 
 	*p_cfg = DMA_CHAN_CFG_SRC_WIDTH(src_width) |
 		DMA_CHAN_CFG_DST_WIDTH(dst_width);
-- 
2.51.0

