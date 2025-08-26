Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EC1352FEB;
	Tue, 26 Aug 2025 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217939; cv=none; b=d4yFRiK3rsxoa0jOhouXXRlp9cAS1yExHjS9XRrou31O0qSU4xVZaKvgWapy65Gr01IaJhJ+iOS+P/4XxJkH+QGMKsVE0T8MCyTC/oFlEVBVlM44rrg09dWD/9b8UmrwUhSPGTSNKO3speN24ethvXvRQNHX8D9OXZQDvPthtBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217939; c=relaxed/simple;
	bh=X1bQdOzbKmmX/sxL+SebnveMVHJ0LtK+YcKGzvDQyA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D38D8BAWy8q8izzutI/RjpV29ZOvDQ15pfRlPck32FtTAyszM8ci3ahH56lnStMZi7iDz80RQXqYfi0TixKxINCqOxJZWazrqgiBoikaxpXxxpcIB0QMMam4cQqXnVuECDa8u7a562Cqlz8X+PaOzIEtC1Gv837GV2YiyoXlPHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hA2WHfBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hA2WHfBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B88AC113CF;
	Tue, 26 Aug 2025 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217939;
	bh=X1bQdOzbKmmX/sxL+SebnveMVHJ0LtK+YcKGzvDQyA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hA2WHfBpJoMwDlZwSeCvXBLpNHr5s7fi2hPmPeyRa0rufhS/PAUnz/VYSNxbFu8Mo
	 k3LfjygIAG02BOacPSYSWKgUFrxLEQAhSOVrXKm7FxWauHtcdGKQxIe9Dth4MgKvYU
	 pfgBroUQeu1QwVB29zXLcDs7jCPm9OGe6YHSoLKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/523] block: avoid possible overflow for chunk_sectors check in blk_stack_limits()
Date: Tue, 26 Aug 2025 13:09:01 +0200
Message-ID: <20250826110932.640835552@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 448dfecc7ff807822ecd47a5c052acedca7d09e8 ]

In blk_stack_limits(), we check that the t->chunk_sectors value is a
multiple of the t->physical_block_size value.

However, by finding the chunk_sectors value in bytes, we may overflow
the unsigned int which holds chunk_sectors, so change the check to be
based on sectors.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250729091448.1691334-2-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index ebd373469c80..18855d4bfda2 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -605,7 +605,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	}
 
 	/* chunk_sectors a multiple of the physical block size? */
-	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
+	if (t->chunk_sectors % (t->physical_block_size >> SECTOR_SHIFT)) {
 		t->chunk_sectors = 0;
 		t->misaligned = 1;
 		ret = -1;
-- 
2.39.5



