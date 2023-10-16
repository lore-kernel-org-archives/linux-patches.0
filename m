Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872991A58C
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6hJSMtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0AFC433C9;
	Mon, 16 Oct 2023 09:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447157;
	bh=VrhvyE5sI/23x2bz0AWFAXzoc1lQjEpgCeo5/BfsKpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6hJSMttk+/g5gMXgew3L7yOfyrFztZ2F7shKqaJJy4gycV5X5ZUWTn9gtVtqamBA
	 JaxUPIFBmRKpYrVBcQEuYwkHFNcNV10p1ZeJLyJTNhDgmzGTUVZEfaYY8uM3rRQ+Ij
	 PtXfyD8H2LA3zR1DVffghiKQHBHPeRWNitTn5kjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Eugen Hristev <eugen.hristev@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/131] dmaengine: mediatek: Fix deadlock caused by synchronize_irq()
Date: Mon, 16 Oct 2023 10:41:51 +0200
Message-ID: <20231016084003.250951332@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 01f1ae2733e2bb4de92fefcea5fda847d92aede1 ]

The synchronize_irq(c->irq) will not return until the IRQ handler
mtk_uart_apdma_irq_handler() is completed. If the synchronize_irq()
holds a spin_lock and waits the IRQ handler to complete, but the
IRQ handler also needs the same spin_lock. The deadlock will happen.
The process is shown below:

          cpu0                        cpu1
mtk_uart_apdma_device_pause() | mtk_uart_apdma_irq_handler()
  spin_lock_irqsave()         |
                              |   spin_lock_irqsave()
  //hold the lock to wait     |
  synchronize_irq()           |

This patch reorders the synchronize_irq(c->irq) outside the spin_lock
in order to mitigate the bug.

Fixes: 9135408c3ace ("dmaengine: mediatek: Add MediaTek UART APDMA support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Eugen Hristev <eugen.hristev@collabora.com>
Link: https://lore.kernel.org/r/20230806032511.45263-1-duoming@zju.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-uart-apdma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/mediatek/mtk-uart-apdma.c b/drivers/dma/mediatek/mtk-uart-apdma.c
index a1517ef1f4a01..0acf6a92a4ad3 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -451,9 +451,8 @@ static int mtk_uart_apdma_device_pause(struct dma_chan *chan)
 	mtk_uart_apdma_write(c, VFF_EN, VFF_EN_CLR_B);
 	mtk_uart_apdma_write(c, VFF_INT_EN, VFF_INT_EN_CLR_B);
 
-	synchronize_irq(c->irq);
-
 	spin_unlock_irqrestore(&c->vc.lock, flags);
+	synchronize_irq(c->irq);
 
 	return 0;
 }
-- 
2.40.1



