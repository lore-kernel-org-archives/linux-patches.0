Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4657C3128DF;
	Sat, 12 Sep 2026 12:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215777; cv=none; b=OMwvByXTeQz9IIMtHHg90rrRnXsFDxZsv1xQAwa9fP/f6kPY33CLFCNYsdVPcnBkjQbI7vpFrL+9pomQufVjhe9uocDTAGbtDmHSL2NtBaEOIirQJJTw7ZrxNmL4Y0EKmQaeQ1nQp4/2q0qHOdBIXrkb2akrD2LIhvUvfWBforY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215777; c=relaxed/simple;
	bh=rD8uIBJ2oHy9rkrnhB5QB0IjIjxRgZtUu1Q9+Dh6UMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoMzNuiIBBN+cSKKHgejS3ii4szMFZ8D3sYvLZFSn3HFfZ5oqyo3L/XfsuNRm75AYxF1v84Yxvt5TL/Jg7anuLN0Enaax7r1Z47MNoJ3BJDmSYJMY62uvha/Kia/uR+yXrIK1vs11vC+ZFstf6t1yLk2knqKMfnS3pJIr5T3W/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqj22g4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqj22g4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B0C1F000FF;
	Sat, 12 Sep 2026 12:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215776;
	bh=YZwkQMz7Rs/zn5VZ/suybhY/OLSgxhRvxAD2VKFODL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqj22g4Hzx2/2I2uQdhQYQSdR6+rpdihxCaqi61XY5bL1ZvcMb1j/Uzt5OpxP50qB
	 klygJV32eZ1Z4r053+TUOWpoYFi0X8ILr7qhOHGKen3WUUPUwLA0E85PndtwacykNi
	 6Xoz7V5h4mpsnbDvpBl1D+l4M8URISp7fQcRcKl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0599/1376] dmaengine: dw-edma: Serialize abort state updates
Date: Sat, 12 Sep 2026 08:50:25 +0200
Message-ID: <20260912065620.883502472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



