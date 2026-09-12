Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA2D39BFFE;
	Sat, 12 Sep 2026 18:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238923; cv=none; b=XUvr2mzxfiW5DRznA7fP+DrLvnf0esaQBFV46hDah15w9nqkkRI1ulvU81qvaoY2A7ghPe309uqKoBE7Vb4PLOUYa8MY9fhS1rZYU4utSVBNpQPg5wVpgo3zregFhXAvxIVvZjG1TUZa2qnKOVgW8f9xxeJJCawSGFOexdh06o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238923; c=relaxed/simple;
	bh=yX+solLRrgDLAxmjrAZq1HYSPUltUs2xLHXFqTEilK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stO0varO2FQTyhsI4jpS7UKuc2CH6tK2mmhrpGxe2dwmaQHg6t2Mmuu0oGZOUVHHdjdTO84dlmBJPFGHUOt13kR8suHScEJQ5fOth8qpxYv4FSY/Of1Nx3BcDk/65wviQSX5k2LHj2DnP1QbXuRdTi4DVxtYRWHHupG0Q1Q/yg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAvGqsOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAvGqsOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE271F000FF;
	Sat, 12 Sep 2026 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238921;
	bh=YXZ0O9iphHaajtZVDNExr/fY4iP5J9GYwyhf+pQ+8nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAvGqsOZvTCAITsJYG8y0DOl+ZZ2Da6ypz0deZG2uDRVOM/y1zQ660s/4x9lZ1aEQ
	 W0C/MD3NYuoAE4/GfCd0hIPaPGO9CUYRSpljB2UG1a7LlF49Gr8mlfL8I6JjyofBjS
	 ycUKvbJV8B3PFW2l6A3QaBWzaCXZLKF67FiKkFk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 560/935] dmaengine: dw-edma: Serialize abort state updates
Date: Sat, 12 Sep 2026 08:59:50 +0200
Message-ID: <20260912065539.676033762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8f01d79d399b1..0d63b0e4d19d9 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -632,9 +632,9 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
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



