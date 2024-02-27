Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6637C13AA2F;
	Tue, 27 Feb 2024 13:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040536; cv=none; b=J22Jq5Sc4QFTgAx5uSuLdQy/IekjwOv4nmiCo+nDeqSy0UynikR1Wffwz4rph2qvuoxeym7qK+UCnKa7+yThOkMVa9j0CzCtkzaKdFXJvZSK1LPJ2xRKKgTCsbDC1Li6sgTW6Hp+HvAd898qprXikwEM5DU4b8h9MHJSEabCweE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040536; c=relaxed/simple;
	bh=oQ7IwB2QqVAcb6l2VTKUAKTEz4OcBXh6wwvKcdMWgso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tPqbn075QbK6EevTejb/h9Zcl7RFggV2iQ3dDSBZg0kiuf9dQ3bqHXxdBxOfvCgJRCZVavGQB3JK+aEHGBKQ9N4RZOYa+JyFMwaVX3XGn72ljUhedbWJrCl5AzHJHQxdDLMWYfaSMPgg94QUcTkx3HHvaHz/413Y3YF6cdgs5yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTdS9q54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTdS9q54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E506EC433F1;
	Tue, 27 Feb 2024 13:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040536;
	bh=oQ7IwB2QqVAcb6l2VTKUAKTEz4OcBXh6wwvKcdMWgso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTdS9q54NsFRfNWneLdeFcTwqhg8wj7IHHRjeniLDRhtFLHEFIXQwxd6tJb3sHkoe
	 /Ue3AZ0ODxLSHPrdzJ2fm9QntCTolsC9Blppw3hY6Bl6sF/Az2bgsT/VauOZ8y0ihQ
	 HP52u4In+1Zu9QZ4POlAGEtGzCNugnS+ODnrypz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 002/334] dmaengine: apple-admac: Keep upper bits of REG_BUS_WIDTH
Date: Tue, 27 Feb 2024 14:17:40 +0100
Message-ID: <20240227131630.717823321@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 306f5df81fcc89b462fbeb9dbe26d9a8ad7c7582 ]

For RX channels, REG_BUS_WIDTH seems to default to a value of 0xf00, and
macOS preserves the upper bits when setting the configuration in the
lower ones. If we reset the upper bits to 0, this causes framing errors
on suspend/resume (the data stream "tears" and channels get swapped
around). Keeping the upper bits untouched, like the macOS driver does,
fixes this issue.

Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Martin Povišer <povik+lin@cutebit.org>
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20231029170704.82238-1-povik+lin@cutebit.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/apple-admac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/apple-admac.c b/drivers/dma/apple-admac.c
index 5b63996640d9d..9588773dd2eb6 100644
--- a/drivers/dma/apple-admac.c
+++ b/drivers/dma/apple-admac.c
@@ -57,6 +57,8 @@
 
 #define REG_BUS_WIDTH(ch)	(0x8040 + (ch) * 0x200)
 
+#define BUS_WIDTH_WORD_SIZE	GENMASK(3, 0)
+#define BUS_WIDTH_FRAME_SIZE	GENMASK(7, 4)
 #define BUS_WIDTH_8BIT		0x00
 #define BUS_WIDTH_16BIT		0x01
 #define BUS_WIDTH_32BIT		0x02
@@ -740,7 +742,8 @@ static int admac_device_config(struct dma_chan *chan,
 	struct admac_data *ad = adchan->host;
 	bool is_tx = admac_chan_direction(adchan->no) == DMA_MEM_TO_DEV;
 	int wordsize = 0;
-	u32 bus_width = 0;
+	u32 bus_width = readl_relaxed(ad->base + REG_BUS_WIDTH(adchan->no)) &
+		~(BUS_WIDTH_WORD_SIZE | BUS_WIDTH_FRAME_SIZE);
 
 	switch (is_tx ? config->dst_addr_width : config->src_addr_width) {
 	case DMA_SLAVE_BUSWIDTH_1_BYTE:
-- 
2.43.0



