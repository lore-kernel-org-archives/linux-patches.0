Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B5A22323;
	Thu, 18 Jan 2024 10:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575110; cv=none; b=eBI9C/3POPXqHI/wdt0cSafrk447rpPSiPxCzEVgd15iqy+vyCnMln18ba76P6IysXYrlLK/sKjyzAkktIC6hNZ8oFoyhKL68T1Yc379CJUpy7+eB+lQw5AkR6/kiCo7mLck0Hcyehp08wpPtkgQvVm5HC4iZfndBWKW7CM9Z1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575110; c=relaxed/simple;
	bh=c3MIZAyNHNavcfjdFA0pjcuhKjz4DA0vVUjcdcpDK6o=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=ZjS72g/6i2R/cqz5SFk880ukQptJBFqo3sc008LL3Af4MsSMDEnZGWAmpcivjwoD6RwXltCzotubkEXsmkuJgZQzUCW3WObL5NLXrGRF1UAluPJeygcrSVg/WZDvusFRC4YPHPq39gCk0rZZNPp+DxhAqInytwZmKOnNTGW1NqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnKwivPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnKwivPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F0AC433C7;
	Thu, 18 Jan 2024 10:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575110;
	bh=c3MIZAyNHNavcfjdFA0pjcuhKjz4DA0vVUjcdcpDK6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnKwivPoWzkz3N/OfYyPkD9ItQW065LINVH3cpx+nDdPI0ifmT8qHwLqLKcgW+/7c
	 ldmdNPEQH9nPxYCh+XMmo67im4d1civjXj7ohR5twVEiG0zI4OjGHSy+zPxdO5fX8T
	 HDlEWiqyT3luaK1WgLIK/NOyz22ny1apO6AZN4ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/150] block: warn once for each partition in bio_check_ro()
Date: Thu, 18 Jan 2024 11:47:17 +0100
Message-ID: <20240118104320.746966036@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 67d995e069535c32829f5d368d919063492cec6e ]

Commit 1b0a151c10a6 ("blk-core: use pr_warn_ratelimited() in
bio_check_ro()") fix message storm by limit the rate, however, there
will still be lots of message in the long term. Fix it better by warn
once for each partition.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231128123027.971610-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c          | 14 +++++++++++---
 include/linux/blk_types.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fdf25b8d6e78..2eca76ccf4ee 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -501,9 +501,17 @@ static inline void bio_check_ro(struct bio *bio)
 	if (op_is_write(bio_op(bio)) && bdev_read_only(bio->bi_bdev)) {
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return;
-		pr_warn_ratelimited("Trying to write to read-only block-device %pg\n",
-				    bio->bi_bdev);
-		/* Older lvm-tools actually trigger this */
+
+		if (bio->bi_bdev->bd_ro_warned)
+			return;
+
+		bio->bi_bdev->bd_ro_warned = true;
+		/*
+		 * Use ioctl to set underlying disk of raid/dm to read-only
+		 * will trigger this.
+		 */
+		pr_warn("Trying to write to read-only block-device %pg\n",
+			bio->bi_bdev);
 	}
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d5c5e59ddbd2..92c8997b1938 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -69,6 +69,7 @@ struct block_device {
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	bool			bd_make_it_fail;
 #endif
+	bool			bd_ro_warned;
 	/*
 	 * keep this out-of-line as it's both big and not needed in the fast
 	 * path
-- 
2.43.0



