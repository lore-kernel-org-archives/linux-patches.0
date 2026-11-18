Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022335;
	b=Ur4WbpJBdxnYMPWXqP0WP8lRXzZ27BP71d5Z1DSOmDnICXxyGu6P2z0axyWqSQ45GsHD
	 9TFBwN9An8K+FPjz5iPo2fyQoOMWzZDx/toaE+i7pl5rJ56EckH01UTxBxACm7Dt8nc2s
	 X10uwgpx6G/23uYEgNJlRIt7qu5f64+q706taIOHX2xIHvwwcqABpO4q5xdQfcEDNloPo
	 SXs58zDu4MGIwTGE6yp4ynxcvEOqTJQzeQ7CI9AexG6YHb0UaRSZtz8L2DvHbVxU4C9O4
	 9yGdzEinm022FQWbKlux2JeLyPjNHmo7osfsIUmmE5BwqoondrNxMk5wFoC+apFsDaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1pJfIl9d+ACwWN5EmM+rR/MFU/qKjUJpM5ndlvWQrqg=;
	b=Mk5uKmlU1iAGMhAhe55DPDgQdvm8meZw5HTAoFLoh1L0F2ENADmTuV5rC+qKbnU3sq5d
	 gOg+d/GaJJ3y4F8gtf3ibiYiYWQ39W5FQiSqFA9TRu7jUyHF7WcIhfwvbEun5K9tCKFfD
	 Fv25AMAmNISCP4r5VJWBaeBXas6vIkM6K7wLKBugXQcqf50XaDOl8wKbIRjMI0s++Cm3U
	 e802POHFrS/zwa6nJpuCCTGof8CABzTI1LT+yMqJg1dTHMGXHpzVh6XaL+2xECEGSwwoR
	 xvxfHJvFpbgAs3hFXp78m4hmz3OnB/gczNaKQzNRqcMGuPJdG7sfQyZUuLOCtMobUBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sn96xz0m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB167606A31C;
	Wed, 18 Nov 2026 17:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sn96xz0m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4601F000C4;
	Wed, 18 Nov 2026 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022335;
	bh=1pJfIl9d+ACwWN5EmM+rR/MFU/qKjUJpM5ndlvWQrqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sn96xz0mRtyLGuHk+ZwS6b88BgAfmD46huvMLuZi6v5upvuPcONj70ukE/LJlQNc+
	 7y0QLksmwludDArtho1bkmsr8iDd/D97q0doCN3nVrremcfX4+vYNPh0S5wxXiOsnt
	 cBDhYq8mb+bf0p3SUBSHBTBvZjN+yV+M4BC/pO4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2585/2651] blk-mq-dma: initialize the dma state for P2P, too
Date: Wed, 18 Nov 2026 16:03:45 +0100
Message-ID: <20261118150417.367585617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 035236c9e135a2ce7d0f68cb56e63d4a3da2abe1 ]

blk_rq_dma_map_iter_start() promises that the caller need not initialize
the dma_iova_state, but the P2P bus address path returns before it does
so. The state then holds what the last request with that tag left, and
blk_rq_dma_map_coalesce() describes a transfer as one IOVA range that it
isn't. Clear it on that path too.

Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-33-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 88fd9cbc951f4..e0e7a18790b5b 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -181,6 +181,8 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
 	switch (pci_p2pdma_state(&iter->p2pdma, dma_dev,
 				 phys_to_page(vec.paddr))) {
 	case PCI_P2PDMA_MAP_BUS_ADDR:
+		/* don't leave the state of an earlier mapping to the caller */
+		memset(state, 0, sizeof(*state));
 		return blk_dma_map_bus(iter, &vec);
 	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
 		/*
-- 
2.53.0



