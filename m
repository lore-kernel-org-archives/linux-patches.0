Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98531478E25;
	Sat, 12 Sep 2026 16:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229793; cv=none; b=uXer+SFgsE7f6kbrXe2QkngySeLGK16CPKVf/T2mwLYQseTI6uy6TblW8Ir0q6wIjCLIX2hovpsr39kpSDxjNpaTLZlm4xe3C6/z2rSWEFLLbVIY8rAbmSl6SXzyCqlNBPhsSSo5BTngLE8wJwhvBDIH7KAhoVvr+N0eU+lKsZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229793; c=relaxed/simple;
	bh=E9qBkFK+ra9vskb93XE54Fb5FXRha3SAjjv+7KUanWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnMQd60tSWl4Bzri0MfOtdRBhBiEl13S32solc4uRTt8CoL6xZPuXVDbB1KDYny7icLCPTVNfyn1EVxoeQJ0GOwxPU4QkKEsyS7sQ8cw/JejuyIGNF3q3TxKhooHfqPLzu+agAL5XT6eMIpYfFPEDSwsje1doPjXUfNyaC4oYPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xERoZn9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xERoZn9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714181F000FF;
	Sat, 12 Sep 2026 16:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229791;
	bh=7SFWJEtKvNmve/S/UaXE4W+Xc+I3gE8TqjkhJ0mka8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xERoZn9XwCjyaM/ftzGiVIiJfJ8Gs45wNR+rzrQnNSerMDcsaYHXxuGcAbyi+ShyT
	 /Ngns6J7LNpuvlUt1GOOlrMqUtOyJLnBIhmgVcceiyMVaGMhGD8kHvRtUzvIr0mR4q
	 QBq2o8K9e+JisGEWzTG7KFffAhUWo+a2kEWnTs5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0663/1191] dmaengine: dw-edma: Serialize abort state updates
Date: Sat, 12 Sep 2026 08:56:31 +0200
Message-ID: <20260912065603.149150299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7625283e3780b..73d013278de28 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -649,9 +649,9 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
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



