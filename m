Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA751E89C;
	Thu, 25 Jul 2024 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918866; cv=none; b=Io4us4vkHY26Z3nSDvsxDtlh5BLF2MggbtBCV6HwJ98ZzFnE0+Yie0hm9za7kh3KBaM+XgCY3F8Y74lbRR6irhPq2lAvXoeUjBchV5EkIIYSc429GhycZY5P5LpKsPde1ZDoR8UrWwo+ai868raNsjIbccw0tm/MribLQjohawU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918866; c=relaxed/simple;
	bh=TMY1QeAuJW32Mlt15jDfhvTO7/n5DtFsYdyBY17074c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=of7AXI5U9gbUzWAjtAwuSuyBaASoFWK3V4aNS59/2bl2CUJZKt7S6K6VvGxrdJ6lXIYFf3i/MwCYDs48vZWa446aIpO+0qAeQw00t5OV90gsJI70624PdZxY2tZP0ShBw0EY0xqj0Yf6n0vn82zccueG/7SsfNYZ/81sJnKF1eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7aD3NWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7aD3NWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA398C116B1;
	Thu, 25 Jul 2024 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918866;
	bh=TMY1QeAuJW32Mlt15jDfhvTO7/n5DtFsYdyBY17074c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7aD3NWzdLz1G5Mz7tkeTWPe7scXKaJDBAwL4X3CcBiC3Ng6rVNGjC1CvFUzwlz4q
	 UXEYeM8j0jjzZwi54n7/okZJcekuRzIbETUV/lbjPwptHDbh3u+IcXwC9vkXyD8rOr
	 LzD5hMIt3JQJIzRS6LbxccUTi9aqfuC8LOsWCX+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/59] null_blk: fix validation of block size
Date: Thu, 25 Jul 2024 16:37:03 +0200
Message-ID: <20240725142733.767770757@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andreas Hindborg <a.hindborg@samsung.com>

[ Upstream commit c462ecd659b5fce731f1d592285832fd6ad54053 ]

Block size should be between 512 and PAGE_SIZE and be a power of 2. The current
check does not validate this, so update the check.

Without this patch, null_blk would Oops due to a null pointer deref when
loaded with bs=1536 [1].

Link: https://lore.kernel.org/all/87wmn8mocd.fsf@metaspace.dk/

Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240603192645.977968-1-nmi@metaspace.dk
[axboe: remove unnecessary braces and != 0 check]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 862a9420df526..8e24fb93324cb 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1743,8 +1743,8 @@ static int null_validate_conf(struct nullb_device *dev)
 		return -EINVAL;
 	}
 
-	dev->blocksize = round_down(dev->blocksize, 512);
-	dev->blocksize = clamp_t(unsigned int, dev->blocksize, 512, 4096);
+	if (blk_validate_block_size(dev->blocksize))
+		return -EINVAL;
 
 	if (dev->queue_mode == NULL_Q_MQ && dev->use_per_node_hctx) {
 		if (dev->submit_queues != nr_online_nodes)
-- 
2.43.0



