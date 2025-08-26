Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2016D148850;
	Tue, 26 Aug 2025 13:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213283; cv=none; b=bVBnBP2xtdDpWB2xKykMyi/koZzYVjY49F3LZecyBTJyB+/mUPOEcFbfqN+TunBIwugaiKQA796ZsNNCu3rVdBkrP6OGKleGJFUzra9hYY27uhGqx1S47GyvPv5JypL22vfMeCCLG/qhDgmlI5QVG9R7uJfPXmd/9maudFCWaJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213283; c=relaxed/simple;
	bh=PaPNy88rgm01dZDfPwLy/3sa7XWm3ftIFjM93c4MCnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiL2iKOL6Frf66zFobqFHRyAFh7ipQh8UQI5P4k6b+y3HhnJfoDj2kms7V7SdRJiQJZtPiNZKOY/bKwx8mbrEwyBu13XQaGS8WHXZPiXUGBBlHKOIEPr1wu55GT1rxPo99/5tnunK+8nbVj6dTE+lf8JOko9sWx0gQF+jMcTuY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAKe+6LC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAKe+6LC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4569C4CEF1;
	Tue, 26 Aug 2025 13:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213283;
	bh=PaPNy88rgm01dZDfPwLy/3sa7XWm3ftIFjM93c4MCnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAKe+6LC/MgyArdAGOQr6vBrsKVVGD0U0AbT6n6Gku4vRs2sm38d8MzCn7hwPYy9/
	 tGR1KScwHBAuLgkTHvcGAQysU8To2GrZ07JGIRLFz9a6P0Avlf4FPAa/g+Mhjk3nPy
	 e+OUGtLY7r1O0LOdWMd79mKuk4X51N+DOYsJfTYw=
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
Subject: [PATCH 6.6 288/587] block: avoid possible overflow for chunk_sectors check in blk_stack_limits()
Date: Tue, 26 Aug 2025 13:07:17 +0200
Message-ID: <20250826111000.256912235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7019b8e204d9..021994f6d2d8 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -634,7 +634,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	}
 
 	/* chunk_sectors a multiple of the physical block size? */
-	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
+	if (t->chunk_sectors % (t->physical_block_size >> SECTOR_SHIFT)) {
 		t->chunk_sectors = 0;
 		t->misaligned = 1;
 		ret = -1;
-- 
2.39.5



