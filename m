Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA6A30568E;
	Sat, 12 Sep 2026 14:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223588; cv=none; b=HPJQZgkRl1bJu5BNNGP9xmlkGNQNPv6nMvpgLkr24B8ipNgjaD9dhbmczQDzYm5ZEUuXOu7P1vHiDgkyU4EmktK5Fg5fASTMZvhD+OCAwF1v0qviv2ZkGEvPmBD6BOhy5kJzS1VMRPlYVV4NXEu2/S8yKW6E5N6jXSl61sBsVvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223588; c=relaxed/simple;
	bh=M4ufhDR1wR+GOZCFrIM/oEKXsYLqf3I4gcjeUOr48fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEc/SeZXDUBcQ/FP7cz9SLp9iLPdKJ1q3wmpHOBS7eBNjzRvzTdrfKB3XxChJPNYpbi7WdvMolGO/h+hl4Q6By2tjJx66a5bs0hoz9Rnm0mB2q6MvLXV6KY19r5rp/8QTzPnTx7/BCWQXcdi3tV0sTU11IquOZGh2bdfJ1xSdfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHVYt375; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHVYt375"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0A61F000FF;
	Sat, 12 Sep 2026 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223587;
	bh=6NW6fLpexxYY9XEAjZLFBPsDu8kWQizH3anPW3TfPIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHVYt3753KPRsJPbDUESuGF7AHVlfgNXHqsQnvXfVlkJzuMic1KVdrjW1QEaoXOO8
	 qtLQLKkXKhnvSVC86oSywb/yAlGwrr9WYGVv3fnAeI3XdXqYhyO3b5sMNHb6vGNmYu
	 tfpFD2f4yXEKfkTeXumxWvBQNRgt7fmGCO3K/B7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0813/1424] dmaengine: dw-edma: Serialize abort state updates
Date: Sat, 12 Sep 2026 08:54:05 +0200
Message-ID: <20260912065625.501902910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit dd80e259f65d932634e26d366570d71669ef6654 ]

dw_edma_abort_interrupt() drops vc.lock before changing request and
status. issue_pending() can acquire the lock in that small window,
observe the old busy state, and skip starting queued descriptors. Then
the abort handler overwrites the channel status as idle, leaving the new
descriptors stranded for good.

Keep descriptor completion and the state transition in the same critical
section.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260717180639.2643243-4-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index e8ac14e7691e2..7e1b270738ce0 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -710,9 +710,9 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
 	}
-	spin_unlock_irqrestore(&chan->vc.lock, flags);
 	chan->request = EDMA_REQ_NONE;
 	chan->status = EDMA_ST_IDLE;
+	spin_unlock_irqrestore(&chan->vc.lock, flags);
 }
 
 static inline irqreturn_t dw_edma_interrupt_write(int irq, void *data)
-- 
2.53.0



