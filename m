Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0282EBDC0;
	Tue, 17 Jun 2025 15:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174443; cv=none; b=hOKNIPIRJn+KUlgNXO1FjZnRK2KxZCiC3jsz0iLQSwwYy1N0tEuVWx41jARdfJZA8LVdiuWfbP8LadB8rrF/Zh+FOEFtFI8dG7+t/VjzX8hyrBeiiwzbBA8cHuMrszORF0HsP/brdN9TAH3/h3dfLoaOriquPHOMGnqpqGBtELk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174443; c=relaxed/simple;
	bh=GwouXKZHF3l7k9SXzPnWYUtBAT6+lkzArT21xUdOjqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieycPou/vTEjqf8IahBRUOZoK7hSDo/KjFwUuIsU6iWmMKc+p+P1PUb/dRQXTMQu0k8gef4SHrjT0/Dx8xOQkrpLPirIhGyDEKaUotnv03VGZqBahrwOXdZWBg4ZRiQqnlo1iZVOXOM7wA+EPZN+UBz8XxkkNKp+OItawZqrinw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rmlg0uq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rmlg0uq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1676C4CEE3;
	Tue, 17 Jun 2025 15:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174443;
	bh=GwouXKZHF3l7k9SXzPnWYUtBAT6+lkzArT21xUdOjqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rmlg0uqzN8sj/VzWUYeZxSBeyf8aSXVXokL+zzFbyr6zQBHSEQb/YNbz4/rYpJIH
	 bZ9/9Tk1NvOwXMQO7AJE/xG+CtyDPXJB/HDUAITH8i1thUw9EofagC1JaGl0EJ33AT
	 eOnZIqb7R/Y/GJlbWW7YEWKTXYUUeTHprhACA5LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/512] brd: fix discard end sector
Date: Tue, 17 Jun 2025 17:19:46 +0200
Message-ID: <20250617152420.349871890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit a26a339a654b9403f0ee1004f1db4c2b2a355460 ]

brd_do_discard() just aligned start sector to page, this can only work
if the discard size if at least one page. For example:

blkdiscard /dev/ram0 -o 5120 -l 1024

In this case, size = (1024 - (8192 - 5120)), which is a huge value.

Fix the problem by round_down() the end sector.

Fixes: 9ead7efc6f3f ("brd: implement discard support")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250506061756.2970934-4-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/brd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 9549cd71e083b..02fa8106ef549 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -225,18 +225,21 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 static void brd_do_discard(struct brd_device *brd, sector_t sector, u32 size)
 {
 	sector_t aligned_sector = round_up(sector, PAGE_SECTORS);
+	sector_t aligned_end = round_down(
+			sector + (size >> SECTOR_SHIFT), PAGE_SECTORS);
 	struct page *page;
 
-	size -= (aligned_sector - sector) * SECTOR_SIZE;
+	if (aligned_end <= aligned_sector)
+		return;
+
 	xa_lock(&brd->brd_pages);
-	while (size >= PAGE_SIZE && aligned_sector < rd_size * 2) {
+	while (aligned_sector < aligned_end && aligned_sector < rd_size * 2) {
 		page = __xa_erase(&brd->brd_pages, aligned_sector >> PAGE_SECTORS_SHIFT);
 		if (page) {
 			__free_page(page);
 			brd->brd_nr_pages--;
 		}
 		aligned_sector += PAGE_SECTORS;
-		size -= PAGE_SIZE;
 	}
 	xa_unlock(&brd->brd_pages);
 }
-- 
2.39.5



