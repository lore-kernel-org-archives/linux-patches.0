Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8BB27FB02;
	Tue, 27 May 2025 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367194; cv=none; b=EwJ/KnWZEeZpqPdorMVhbbIVoqyHdyGwaSe/qM+PHW/3WZB9PdGH4dCIcXvVC5LOjAR6jouSP6Y6R0SulRtLoKfpkXeAp63W1mh6mBn3hp7PvYDQJlmQKrLPJpXxqc8YbdxPK5Dfd59sUTuD1k42FumqpajrdHLfEY3hTOGN8aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367194; c=relaxed/simple;
	bh=u8LOYIyJnUm4/xLULUx0+uLb4UBswtJhsS843zeYSlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnqyvYp4byNeCJT+ZeE5utsXndiA4m/z58ca23vUOahTs4Uyak1EDCBVFFsBvFXlL1c4ZTx8p5xo9niNAhjvEhbE5SAfX5NovEnRXUz7RNqc50AXEzDXk65VGddbjRL3mRWRweicp1llDDFhYY/zjfIIF2ilrSeZ3rbHbhG61+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0j1OR9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0j1OR9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBD0C4CEE9;
	Tue, 27 May 2025 17:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367194;
	bh=u8LOYIyJnUm4/xLULUx0+uLb4UBswtJhsS843zeYSlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0j1OR9bE06wiyCdQt4zvXxARiem47+e58KbOt2nMx9wmb+57Ay+pB/vXq9oYQ1a4
	 p8WNfOB48FpeG8MbqFu3VeyohLc/GCde9UwiRMjkSYUqbAKFbsj2puFCw98iHhC3Lg
	 LRGIAT2BgiEKOHxMflSrE/+WwBMVHnzXpFYeLHL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 308/783] block: mark bounce buffering as incompatible with integrity
Date: Tue, 27 May 2025 18:21:45 +0200
Message-ID: <20250527162525.611757131@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 5fd0268a8806d35dcaf89139bfcda92be51b2b2f ]

None of the few drivers still using the legacy block layer bounce
buffering support integrity metadata.  Explicitly mark the features as
incompatible and stop creating the slab and mempool for integrity
buffers for the bounce bio_set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20250225154449.422989-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 5 +++++
 block/bounce.c       | 2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 67b119ffa1689..c430c10c864b6 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -124,6 +124,11 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 		return 0;
 	}
 
+	if (lim->features & BLK_FEAT_BOUNCE_HIGH) {
+		pr_warn("no bounce buffer support for integrity metadata\n");
+		return -EINVAL;
+	}
+
 	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY)) {
 		pr_warn("integrity support disabled.\n");
 		return -EINVAL;
diff --git a/block/bounce.c b/block/bounce.c
index 0d898cd5ec497..09a9616cf2094 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -41,8 +41,6 @@ static void init_bounce_bioset(void)
 
 	ret = bioset_init(&bounce_bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 	BUG_ON(ret);
-	if (bioset_integrity_create(&bounce_bio_set, BIO_POOL_SIZE))
-		BUG_ON(1);
 
 	ret = bioset_init(&bounce_bio_split, BIO_POOL_SIZE, 0, 0);
 	BUG_ON(ret);
-- 
2.39.5



