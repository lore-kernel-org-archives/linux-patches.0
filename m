Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D59637F01B;
	Wed,  8 Apr 2026 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672959; cv=none; b=pAAQ1ZeZ9NiaFvotZZ7ip7iAnSlkUuluQo5SWqwFJ3OHPOqf1haSTMCJxw//XQPjf/M0SFQs2XK7YK5Q/DG+pdDp8Pz6SiuuRs5/rcV4UZx5EBJ5YrDVUGpZFfGb65Ubiq3mx1KetwnlkakoeuqT9sECxFEf1/h0zFXq8JTxeH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672959; c=relaxed/simple;
	bh=9Yvqiy0mpOIQzXJR6X9nEWNjqVVGGc36E7/QJFdHh30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNpg+ZIpcJQDTQ7YlhTBhgAP8qfuyAcquvCUnmPsR3Am9lFYZrVnJrgY1QNCrkxvoPVPF654yphqKx8swPjw1qKavNVpKqu6Uqo8bcMItLqFhlk9z/vlLMNfzKXxBGO0U62ZGqKBqUJpMGUTi4P4x8xECMsNRfdPYlvgT77XRS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWKZz6UI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWKZz6UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91DCC19421;
	Wed,  8 Apr 2026 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672959;
	bh=9Yvqiy0mpOIQzXJR6X9nEWNjqVVGGc36E7/QJFdHh30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWKZz6UIpHUYvqfchwEySvmpTDN9HmYG9i+7hVyipceriYDEpHJoFDi9ufF5w2Q5D
	 a/C45oJqq1MuKvhTZUK0DRLvx0GwHyZjLwEEgXKUpn6jICB25KmgSLDRE+VgFa+Tl8
	 6YAysR+wmMiDl0kztq/pRfwpGcK+6AkoeRwvZ/cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Daskalakis <daskald@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/277] eth: fbnic: Account for page fragments when updating BDQ tail
Date: Wed,  8 Apr 2026 20:00:24 +0200
Message-ID: <20260408175935.315699089@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
index fbdf79b6ad2de..6e21f6c17c658 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -925,7 +925,7 @@ static void fbnic_fill_bdq(struct fbnic_ring *bdq)
 		/* Force DMA writes to flush before writing to tail */
 		dma_wmb();
 
-		writel(i, bdq->doorbell);
+		writel(i * FBNIC_BD_FRAG_COUNT, bdq->doorbell);
 	}
 }
 
@@ -2546,7 +2546,7 @@ static void fbnic_enable_bdq(struct fbnic_ring *hpq, struct fbnic_ring *ppq)
 	hpq->tail = 0;
 	hpq->head = 0;
 
-	log_size = fls(hpq->size_mask);
+	log_size = fls(hpq->size_mask) + ilog2(FBNIC_BD_FRAG_COUNT);
 
 	/* Store descriptor ring address and size */
 	fbnic_ring_wr32(hpq, FBNIC_QUEUE_BDQ_HPQ_BAL, lower_32_bits(hpq->dma));
@@ -2558,7 +2558,7 @@ static void fbnic_enable_bdq(struct fbnic_ring *hpq, struct fbnic_ring *ppq)
 	if (!ppq->size_mask)
 		goto write_ctl;
 
-	log_size = fls(ppq->size_mask);
+	log_size = fls(ppq->size_mask) + ilog2(FBNIC_BD_FRAG_COUNT);
 
 	/* Add enabling of PPQ to BDQ control */
 	bdq_ctl |= FBNIC_QUEUE_BDQ_CTL_PPQ_ENABLE;
-- 
2.53.0



