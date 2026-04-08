Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1118025A321;
	Wed,  8 Apr 2026 18:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674330; cv=none; b=Qi9DopPu91scGL0OL7NRr8REkWOK5yb9PmZpGx7ay0PG33l/+X3EkdK7ETJsAObCKrsO54YlsL37sjct1cippwHjlYbvGy9JQu22qqBIdskveLegHoxcpaRHwC3i68jiq5zJNqZ42kn1KHwiRoZpNccf4qjG+pMVbGwV0tEenKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674330; c=relaxed/simple;
	bh=Skrg26iwLCJ5jFXBxerSoGFyvqcAWk2W9mAbSOk425s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWI5Bn20bNOCLr/rvKnEG4ALGhpiUAET+i0evr3v14lD4ZCb8HKhLB9hj3UbFJxYrw/obuSrb9h7ukcCjUmOSVDzh5qI00TjKlGs7/HAwzCC+X6VBEq+km2o1giXjbR5xVNILifi7L6LQvQGbA0oHpNTppEqniEGTHrg3kJZRbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+xpHNQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+xpHNQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9CEC19421;
	Wed,  8 Apr 2026 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674330;
	bh=Skrg26iwLCJ5jFXBxerSoGFyvqcAWk2W9mAbSOk425s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+xpHNQMbAltLTW1BGuRvm/rnASqVfj2fsIZxtVfeFAmFTU812z+KOSsM/MvwU5hC
	 UBb0togwzBaoXH6dUasYDfTfuTe2CttyMWUyVj/wBXLV0KfuC0zGNyFbtDzqBExoey
	 AQDSL45WDnRLBT7kyFdfEIQrCQhGoGWX0IOy4EV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Daskalakis <daskald@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 055/311] eth: fbnic: Account for page fragments when updating BDQ tail
Date: Wed,  8 Apr 2026 20:00:55 +0200
Message-ID: <20260408175941.471444946@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Daskalakis <daskald@meta.com>

[ Upstream commit b38c55320bf85a84a4f04803c57b261fc87e9b4b ]

FBNIC supports fixed size buffers of 4K. When PAGE_SIZE > 4K, we
fragment the page across multiple descriptors (FBNIC_BD_FRAG_COUNT).
When refilling the BDQ, the correct number of entries are populated,
but tail was only incremented by one. So on a system with 64K pages,
HW would get one descriptor refilled for every 16 we populate.

Additionally, we program the ring size in the HW when enabling the BDQ.
This was not accounting for page fragments, so on systems with 64K pages,
the HW used 1/16th of the ring.

Fixes: 0cb4c0a13723 ("eth: fbnic: Implement Rx queue alloc/start/stop/free")
Signed-off-by: Dimitri Daskalakis <daskald@meta.com>
Link: https://patch.msgid.link/20260324195123.3486219-2-dimitri.daskalakis1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index e119526fce14c..cb0be88427f88 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -927,7 +927,7 @@ static void fbnic_fill_bdq(struct fbnic_ring *bdq)
 		/* Force DMA writes to flush before writing to tail */
 		dma_wmb();
 
-		writel(i, bdq->doorbell);
+		writel(i * FBNIC_BD_FRAG_COUNT, bdq->doorbell);
 	}
 }
 
@@ -2548,7 +2548,7 @@ static void fbnic_enable_bdq(struct fbnic_ring *hpq, struct fbnic_ring *ppq)
 	hpq->tail = 0;
 	hpq->head = 0;
 
-	log_size = fls(hpq->size_mask);
+	log_size = fls(hpq->size_mask) + ilog2(FBNIC_BD_FRAG_COUNT);
 
 	/* Store descriptor ring address and size */
 	fbnic_ring_wr32(hpq, FBNIC_QUEUE_BDQ_HPQ_BAL, lower_32_bits(hpq->dma));
@@ -2560,7 +2560,7 @@ static void fbnic_enable_bdq(struct fbnic_ring *hpq, struct fbnic_ring *ppq)
 	if (!ppq->size_mask)
 		goto write_ctl;
 
-	log_size = fls(ppq->size_mask);
+	log_size = fls(ppq->size_mask) + ilog2(FBNIC_BD_FRAG_COUNT);
 
 	/* Add enabling of PPQ to BDQ control */
 	bdq_ctl |= FBNIC_QUEUE_BDQ_CTL_PPQ_ENABLE;
-- 
2.53.0



