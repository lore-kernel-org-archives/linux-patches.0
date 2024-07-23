Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2272042067;
	Tue, 23 Jul 2024 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759587; cv=none; b=o1qZyDWDaGtjE33HGOYQn7lsFY8p9Jq/RavpgsJI8rICbbvC4H5adN5IbMsmzIS2DUdl7vb83+M1WlKdlI3Ns56VsaKBfJ/BNnBUq+PInEhRlFaCX8JoUoO2x1fpIMJNFK7u4JLLgoyzGL1a2pe4mjtQ2TbZA+oCzMNIdw+Bs0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759587; c=relaxed/simple;
	bh=2DjtY3q4cEIcc/YBtEq+pBiuH3UfLO6szk+F3ObDTL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsJa++pRVkztTWciGL8Dnri29+14hwVpHwAV3ZT+2OUB65YorDDcIFqmWzKG18XrcsxIcT37Q3Zt/egGn9PXVCYRBSacRhn/AVJBAHge3jYfLcevbuJX1gP4YLcxtL+A2MISX5526kdz6Qp2nkw3qbeKkRKB9JXsIG2MIw8e1JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvVWDH8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvVWDH8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB1CC4AF0A;
	Tue, 23 Jul 2024 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759587;
	bh=2DjtY3q4cEIcc/YBtEq+pBiuH3UfLO6szk+F3ObDTL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvVWDH8Tz30zcUvwm75D5HqN9SmviWnSBoxcJtzHLvkCIKBlooVk38AgNHK/A+Ccb
	 wX8KjDP9IJfCkMzHcl3m6GgTfCBbHojSR6RyI7cLS8f7UDa0PvZ8Itq+fC+iZNkRaa
	 YRTCI/jhwqZ/8M1QujHk+uZ3nxFcYAGE6Xpvr1js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/129] null_blk: fix validation of block size
Date: Tue, 23 Jul 2024 20:22:58 +0200
Message-ID: <20240723180405.954924978@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 561706fc2cd8e..f1b7d7fdffec8 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2013,8 +2013,8 @@ static int null_validate_conf(struct nullb_device *dev)
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



