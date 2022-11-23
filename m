Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8D61C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30E7C433D6;
	Wed, 23 Nov 2022 09:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194932;
	bh=Odw+5txMGFMaUrxUv5r22ashupFIb3WYBnLMKsTOdg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIvGTisqdM4TMZgOglQGF+cSslFkwEwvf8+zvgwuX0VUUUDgjoY0oZ9h404/RVYgZ
	 B6zsX8Ge0E5YJy5akgNoEud3kmpS8WQ9nqY+CldOYUYlJ8kd755Qi3Zs8Z9uf93Gk6
	 cX1Vi3MZLgXfvmj2z4ZRe0eJkYC6pWvRXgHezrx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 060/156] dmaengine: at_hdmac: Fix impossible condition
Date: Wed, 23 Nov 2022 09:50:17 +0100
Message-Id: <20221123084600.122044755@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 28cbe5a0a46a6637adbda52337d7b2777fc04027 upstream.

The iterator can not be greater than ATC_MAX_DSCR_TRIALS, as the for loop
will stop when i == ATC_MAX_DSCR_TRIALS. While here, use the common "i"
name for the iterator.

Fixes: 93dce3a6434f ("dmaengine: at_hdmac: fix residue computation")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-15-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -308,7 +308,8 @@ static int atc_get_bytes_left(struct dma
 	struct at_desc *desc_first = atc_first_active(atchan);
 	struct at_desc *desc;
 	int ret;
-	u32 ctrla, dscr, trials;
+	u32 ctrla, dscr;
+	unsigned int i;
 
 	/*
 	 * If the cookie doesn't match to the currently running transfer then
@@ -378,7 +379,7 @@ static int atc_get_bytes_left(struct dma
 		dscr = channel_readl(atchan, DSCR);
 		rmb(); /* ensure DSCR is read before CTRLA */
 		ctrla = channel_readl(atchan, CTRLA);
-		for (trials = 0; trials < ATC_MAX_DSCR_TRIALS; ++trials) {
+		for (i = 0; i < ATC_MAX_DSCR_TRIALS; ++i) {
 			u32 new_dscr;
 
 			rmb(); /* ensure DSCR is read after CTRLA */
@@ -404,7 +405,7 @@ static int atc_get_bytes_left(struct dma
 			rmb(); /* ensure DSCR is read before CTRLA */
 			ctrla = channel_readl(atchan, CTRLA);
 		}
-		if (unlikely(trials >= ATC_MAX_DSCR_TRIALS))
+		if (unlikely(i == ATC_MAX_DSCR_TRIALS))
 			return -ETIMEDOUT;
 
 		/* for the first descriptor we can be more accurate */


