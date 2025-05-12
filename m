Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7162980CE;
	Mon, 12 May 2025 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073053; cv=none; b=nk9/lTwTLmG8wPsreMNZsOF5v6pVZ54NoHN0P1in7CN2iP+E9eP7heERLLiggMtdljG4T01BMHgVBVmV8WQInG4N+1SIqQJV/4e9rHvHOgHt+qlPNiB9KYWrOvQQIhN7LRaRRnn/4YQk3G1ZdF1OVfK0BPZHFO8ZFIUhcTSAIMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073053; c=relaxed/simple;
	bh=qOIcH3ak1A9M3AaJQDUgMu8qVOBr872dWL8FRpxZAao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8tB1FTEgfKK648m9cG7en3Qp4UujRilag0PDhOzTyD0Kw1OPNAUKQQ9KvLcVKfxFjbW+o5+WOlJlWiXWM26CNdDBVjOgOW22K7rregJEvN7nyRePxAIz5w74g+tI4pP6uY9bMI5L10gTWcow0KdjOkrcvYQyzRKuxGO1shRXkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmcYByM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmcYByM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A327C4CEF1;
	Mon, 12 May 2025 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073052;
	bh=qOIcH3ak1A9M3AaJQDUgMu8qVOBr872dWL8FRpxZAao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmcYByM4ElpIzUmTuCzKt/N42/4QQSJeRQ9uXNTxgLPde4ERBCtgqjpksm92PXLPH
	 QKE5PiCMfzal4aQIU+WM9u0Yyeoe3DdogH5NMjGZzyJ/82NnXsDBLXuPAs3eVSHXKo
	 Okmi/tKWiwR/SYz35XUSTkYNT5UjuIXpUvZbjxk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/184] loop: Simplify discard granularity calc
Date: Mon, 12 May 2025 19:45:41 +0200
Message-ID: <20250512172047.512743461@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit d47de6ac8842327ae1c782670283450159c55d5b ]

A bdev discard granularity is always at least SECTOR_SIZE, so don't check
for a zero value.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241101092215.422428-1-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: f5c84eff634b ("loop: Add sanity check for read/write_iter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b3355a8d78965..1f55ddef53f3d 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -713,8 +713,7 @@ static void loop_config_discard(struct loop_device *lo,
 		struct block_device *bdev = I_BDEV(inode);
 
 		max_discard_sectors = bdev_write_zeroes_sectors(bdev);
-		granularity = bdev_discard_granularity(bdev) ?:
-			bdev_physical_block_size(bdev);
+		granularity = bdev_discard_granularity(bdev);
 
 	/*
 	 * We use punch hole to reclaim the free space used by the
-- 
2.39.5



