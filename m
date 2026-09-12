Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88F938F255;
	Sat, 12 Sep 2026 19:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242766; cv=none; b=hJKFgGouy658M6NoI2QDgyH43437RRuhYvRll6ariUz4vQR2k+B/jLMwP4ElqQJKh9A/KFV+VgdCJYDnIS3vGmxFYu4fjlo4tW8g1VMkiYl7yr1te8k5qqbCvOUGnB9rB8eobK+0vQxlXFVxcX1jTXwzROoD8ofhN4jeE7qxFq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242766; c=relaxed/simple;
	bh=qsmxAjYI7KYODbK04dxRT56smlL2InZ9kGgoBD0tCgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKwb0jBZJnddfqgRhYAQoM3v622wN7+DKeFb49vTzeaNHFrmEJQOfzk5v/lnGQ+1PQWrtVPPAQ5NIA0LmckRtaZBmfLT0Ap2ROdYDq0qOM5P2y356Va4+/ItpmqEWFY3kZrSzef7g6JnnJlUnL2/woRwH0Og4torLW7+QH0P73c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JNoEz6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JNoEz6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F6E1F000FF;
	Sat, 12 Sep 2026 19:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242765;
	bh=lqk6WOdkm+yjIoqZIzjfYGlbeBZdtrpcLXwpnS4PriY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JNoEz6LHJf4WSg5zpDsuyDc/mK6daZp5woiujYvRbWR1wbic2CSqg4o9QMaqX7MA
	 7YHtEd7fhQHSVV8QgTVEQBhClJhPqWWKndtzQJMpkm7MiUt3+a3y0DkdHYyqOP0kiF
	 Ic//yWtMOhnmlso/F1NKfuyG1X3danfilF56/IVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 476/798] dmaengine: dw-edma: Serialize abort state updates
Date: Sat, 12 Sep 2026 09:01:44 +0200
Message-ID: <20260912065528.052956572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 644d8ca894a0a..b740dbc878f5c 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -579,9 +579,9 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
 	}
-	spin_unlock_irqrestore(&chan->vc.lock, flags);
 	chan->request = EDMA_REQ_NONE;
 	chan->status = EDMA_ST_IDLE;
+	spin_unlock_irqrestore(&chan->vc.lock, flags);
 }
 
 static irqreturn_t dw_edma_interrupt(int irq, void *data, bool write)
-- 
2.53.0



