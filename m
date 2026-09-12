Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E8BCA6F;
	Sat, 12 Sep 2026 14:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223644; cv=none; b=IDKUABnRGpQNWdznNxLBL/7Gnl3VyQa78qRgHgRxPkhfSu5iU971IfpXUqLgfpPKzsEiTomzZiin8ku/zG1ZZRfKNwgh+G3cmy0t0MDvTYeTMAu5vBmPok9o1DZia9bzk3n5ZHCIhTsZKfXqPsPhavATWKafzk1bEdm8qmLtZRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223644; c=relaxed/simple;
	bh=D1xRgCfX99b2TBJfXOg0D46RMqIaJ5udJECpHFy0v9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIz2kee6IjgYSqu7bjvpGvS7qLllJ4Az3n4y6TBBuyMKTEwzJjZe98lSzPNo/Qh+DqWKZJ/swlyfajAuLfyNgkHWdw2hsVK0/cRtLcVKD8QblNWH4JiK6H05ZO5PyZR6eOidPKGYJjCjVkEzNJrF1GjcKwgcx0T/d4VHY4RAMBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWOYQK4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWOYQK4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED071F000FF;
	Sat, 12 Sep 2026 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223643;
	bh=pB7R8LPIowcEVNsw73X4ZTy5kssX46WvbLAvdcHFdNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWOYQK4YClF+tiXSj+obsuUvP8vhQOGnpyLM4jn5KuvFV5/l4Jhc034ek7DBoMBmu
	 4YM9bOcRqeVkwk7Dz/XWULrQMV9T2/lApxWvwfWOgzsAfhmtxhCeO+HYZupVifC+iz
	 Ao/jONSBRHp8pe2UKOvu5Q4kN2VGPfLiR0FomYkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0814/1424] dmaengine: dw-edma: Serialize channel state checks
Date: Sat, 12 Sep 2026 08:54:06 +0200
Message-ID: <20260912065625.528658358@linuxfoundation.org>
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

[ Upstream commit f7d1619f3e10c619b62c6cd6d95371b5c526c85a ]

pause() and resume() read and update channel state without holding vc.lock,
while the interrupt handlers update the same state under it. Take the same
lock around those state checks so that request, status, and configured stay
consistent.

For example, pause() can observe EDMA_ST_BUSY right before the interrupt
handler completes the final descriptor and moves the channel to
EDMA_ST_IDLE, and then record EDMA_REQ_PAUSE on an already idle channel. No
further interrupt will acknowledge the request, and since issue_pending()
requires EDMA_REQ_NONE, the channel is wedged for good: terminate_all()
leaves the stale request behind, so even reconfiguring the channel does not
recover it.

issue_pending() already runs under vc.lock, but it tests configured before
taking it. Move that test under the lock as well, so configured, request,
and status are evaluated as one channel-state snapshot.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260717180639.2643243-6-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index 7e1b270738ce0..2526dad096332 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -276,6 +276,8 @@ static int dw_edma_device_pause(struct dma_chan *dchan)
 	struct dw_edma_chan *chan = dchan2dw_edma_chan(dchan);
 	int err = 0;
 
+	guard(spinlock_irqsave)(&chan->vc.lock);
+
 	if (!chan->configured)
 		err = -EPERM;
 	else if (chan->status != EDMA_ST_BUSY)
@@ -293,6 +295,8 @@ static int dw_edma_device_resume(struct dma_chan *dchan)
 	struct dw_edma_chan *chan = dchan2dw_edma_chan(dchan);
 	int err = 0;
 
+	guard(spinlock_irqsave)(&chan->vc.lock);
+
 	if (!chan->configured) {
 		err = -EPERM;
 	} else if (chan->status != EDMA_ST_PAUSE) {
@@ -343,11 +347,9 @@ static void dw_edma_device_issue_pending(struct dma_chan *dchan)
 	struct dw_edma_chan *chan = dchan2dw_edma_chan(dchan);
 	unsigned long flags;
 
-	if (!chan->configured)
-		return;
-
 	spin_lock_irqsave(&chan->vc.lock, flags);
-	if (vchan_issue_pending(&chan->vc) && chan->request == EDMA_REQ_NONE &&
+	if (chan->configured && vchan_issue_pending(&chan->vc) &&
+	    chan->request == EDMA_REQ_NONE &&
 	    chan->status == EDMA_ST_IDLE) {
 		chan->status = EDMA_ST_BUSY;
 		dw_edma_start_transfer(chan);
-- 
2.53.0



