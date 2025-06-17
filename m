Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ADC20F090;
	Tue, 17 Jun 2025 15:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174915; cv=none; b=maFolk/zE8skqrMhGqwaRU+q0g7k7p2BtVGq3YeSTDpD+0trBOsUsrNJbTGQqWQEQ1vKYVQ87FNmgR5J8gTCbMjUR06ZyRASk5DYE2KA53Zs36pC5abMaS2kyz1pEO0dfjSHDtDFe0HxQ5//uRKjJKu1cnCToeQvzQFLAdiUxPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174915; c=relaxed/simple;
	bh=3rdCwV/DTOUr1vgIT3VFP198Ij8UGvTP9yM3tLilKwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ce+jOF9BsnSslFbL6UKpqIB+fYSGRkP9y1JC/zDAqvLbAt4sbcwV11aDmEm8pWDMVYL1ATRHa201aMXDCeR0dh0T/zxmrJlfjPHcfMZRgaCw85ioxwi8CmlBb5EUUftY5/9N4vnnQWFgTeZ5PTSKMsW1dN/c5SfmZp49/g5zaLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJsU2BQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJsU2BQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB56FC4CEE3;
	Tue, 17 Jun 2025 15:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174915;
	bh=3rdCwV/DTOUr1vgIT3VFP198Ij8UGvTP9yM3tLilKwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJsU2BQ6uBNX9Yz0u1NUFTdhJ+xrgLeGZIO/8/rBqDL6S5QDQsUo/+rkhOPM1Z5gM
	 nBS7TtJg4hfctssj1pcZkWcGoTRo+S2jMvwmNycS6vHf2fh6ICuxVjpSktc/KDVlJU
	 eKLaGf7Bola1dKdq0nLzN05Fn95wBoeRA97MRVPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 033/780] brd: fix discard end sector
Date: Tue, 17 Jun 2025 17:15:41 +0200
Message-ID: <20250617152452.853035819@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



