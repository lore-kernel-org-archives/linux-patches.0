Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CA8418A5D;
	Sat, 12 Sep 2026 10:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207729; cv=none; b=TJVzfZ5CQv5lHCMlas2pljgC+ZFYTpacetzHbK13td7cpMAY8WRYwucH85LpBdp3hxuJJGQIBoVA03yD0XpZ0MlbZ7ctlh4UQFxXzJtkZapG4sW7dVNxLy5wltePIlycd9Efltm83UPRq7sPH015wTI4h9CKInoXLtYANoZ7bU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207729; c=relaxed/simple;
	bh=rE1pNKfAPhqpeaOGLQZdNDt4TtWhdufRebGZHl6xk0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXHPixxcOyaBB+xVDJrl7lAnDf2CtvKdxJdgbd9KcIw+faJo3L9ieaTtb9ZAK6dF3Vwiq21Sn6O6j3chklgUy2pEakAU8a3597FSzTd8SroTo5ZQ+kU3be2t6sPBdnHkWiemkuZRirwD8Z6AsU8Nsyi22SuT7CFtE8Ih46SzneM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUNmJVVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUNmJVVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9777C1F00893;
	Sat, 12 Sep 2026 10:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207727;
	bh=nPCWecZ9e2RNBah4etZex6eD3BGttJwTjpRGGhEnowU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qUNmJVVF2drLq7+0Nl7GQ+mNDBQFMeuTjjhh9QbNo3IIemzWgmIZ8buOwLqia0L3B
	 e/vhI2UVtFtzMyy1gd708LfyK6JVbQznlbb7OuowhFylqY+RQur+fqSrVuXuzZephO
	 jucbKBNo2mxwFtXKYopB19Infgu+vkJVo1v7507o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0473/1518] dmaengine: dw-edma: Serialize abort state updates
Date: Sat, 12 Sep 2026 08:44:02 +0200
Message-ID: <20260912065634.148986167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b4f9d67726aad..bbbfdadfe3e6f 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -699,9 +699,9 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
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



