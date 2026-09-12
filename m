Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10A634252D;
	Sat, 12 Sep 2026 07:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199179; cv=none; b=RTtIipWt3czYqCUJPJ247NkCqKGl1uPqBarhFPOFUBaqSINvG+CRaqbumeA8ghpTUtwhznh3lxCUFHauvRaUqRwm7FyVCrTY0HJuViHv8Sa4qYA6E70+2bDrL1FZD3kTLFoTJC1zrfBg4uXcBRgv5pNBR1LBzAL6waB6d0/Xfq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199179; c=relaxed/simple;
	bh=plUNXug/pPra/IfNhQ10c1v2+RTDL2sXn7uZhYI6Jqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQ4nsrAb73xHFxYwWi0879yuy33OsO2ja3m29BHlOoA/2ZwJDHZv8AuowBMYoGZmeF63jf4pSJz20uVeH3Ue1xzOMUcOtC5srkIDZlJkcRo4LXWtG+mW/K/EX/PK9PdC3e9WqOq4drfFiOOxSgkAfa9Wiij78D8e+4QtZndftGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO6qnlth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO6qnlth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54041F000FF;
	Sat, 12 Sep 2026 07:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199178;
	bh=nvi7hWXebmB6CuWrvz/zxamMFQrAaP7oEvCq0UvxKwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XO6qnlthtndTPx7UXTlabGEyrsRm/Y4TNNxfFRIzL/cTEoxHikUTGg73s/lMl75q4
	 wwRHjegQMuGI16kLag099VOjs8VD0ksaeRk3TpBRIhMU6dO/KeauwiMY/I1llVph8P
	 SBbhpow6QnvDxaB1XpDHcpFMoC1VdF/1G57m1LEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0531/1815] dmaengine: dw-edma: Serialize abort state updates
Date: Sat, 12 Sep 2026 08:38:01 +0200
Message-ID: <20260912065701.346350065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 64e7d7403ab4f..011ec20810be4 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -744,9 +744,9 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
 	}
-	spin_unlock_irqrestore(&chan->vc.lock, flags);
 	chan->request = EDMA_REQ_NONE;
 	chan->status = EDMA_ST_IDLE;
+	spin_unlock_irqrestore(&chan->vc.lock, flags);
 }
 
 static void dw_edma_emul_irq_ack(struct irq_data *d)
-- 
2.53.0



