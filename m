Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E999129A2;
	Tue, 30 Jul 2024 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354839; cv=none; b=EtWwqG6CSGzIfyKdM4P3otDVKC0yEx/XieE7bIfMw34JUBR9XLNxqzCBB5/u3UEercW1JHNwL0XIGwzM3Bgs2KrhYW/jZNMr2pJrVqU79BqcDzvmZW26w9PlQ8Ds+IicjvPSFWXDNLwOblIv9lDYuz6nkVJXKCbvD5xfwftcxFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354839; c=relaxed/simple;
	bh=qQoEzpyeE2G75bXH/2Mx1yBN1DLiFbSPR+Q2EBUhhmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1rRjdzggE0+q9hNW7moNbjHbVlO7XiRmdjWYbmiRpvFy1P6quAi8FUqfuv5163lLWARWFpYjuyaeTQKUYCdDsEPh47a7+zXnDEQ55XxceLRUG0+TOu0T74GMmKXp/yimvoxptBZSVL8Moy4YqLLhb5LuY76nPkQvBRrnbO0wXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/vdRoIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/vdRoIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F99C32782;
	Tue, 30 Jul 2024 15:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354838;
	bh=qQoEzpyeE2G75bXH/2Mx1yBN1DLiFbSPR+Q2EBUhhmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/vdRoIbTkCjVbBPLxhEtZkPZ+O45AVuU5MPquRgfJJrqdrteWlQjir+Oso/v9mPF
	 B1ycjPXhRxtGwXR6nLYbvEqMbSyZODsqHgJWRzCOqEtmxXEXOotcKw/fdGbjoCMVx3
	 1bY68WEYRMLJvkoQl732nfdchzKStDjK5M/OeXPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jinyoung Choi <j-young.choi@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/440] block: cleanup bio_integrity_prep
Date: Tue, 30 Jul 2024 17:44:03 +0200
Message-ID: <20240730151616.163030823@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinyoung Choi <j-young.choi@samsung.com>

[ Upstream commit 51d74ec9b62f5813767a60226acaf943e26e7d7a ]

If a problem occurs in the process of creating an integrity payload, the
status of bio is always BLK_STS_RESOURCE.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jinyoung Choi <j-young.choi@samsung.com>
Reviewed-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20230725051839epcms2p8e4d20ad6c51326ad032e8406f59d0aaa@epcms2p8
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 899ee2c3829c ("block: initialize integrity buffer to zero before writing it to media")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8f0af7ac8573b..045553a164e0c 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -199,7 +199,6 @@ bool bio_integrity_prep(struct bio *bio)
 	unsigned long start, end;
 	unsigned int len, nr_pages;
 	unsigned int bytes, offset, i;
-	blk_status_t status;
 
 	if (!bi)
 		return true;
@@ -227,7 +226,6 @@ bool bio_integrity_prep(struct bio *bio)
 	/* Allocate kernel buffer for protection data */
 	len = bio_integrity_bytes(bi, bio_sectors(bio));
 	buf = kmalloc(len, GFP_NOIO);
-	status = BLK_STS_RESOURCE;
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
 		goto err_end_io;
@@ -242,7 +240,6 @@ bool bio_integrity_prep(struct bio *bio)
 	if (IS_ERR(bip)) {
 		printk(KERN_ERR "could not allocate data integrity bioset\n");
 		kfree(buf);
-		status = BLK_STS_RESOURCE;
 		goto err_end_io;
 	}
 
@@ -270,7 +267,6 @@ bool bio_integrity_prep(struct bio *bio)
 
 		if (ret == 0) {
 			printk(KERN_ERR "could not attach integrity payload\n");
-			status = BLK_STS_RESOURCE;
 			goto err_end_io;
 		}
 
@@ -292,7 +288,7 @@ bool bio_integrity_prep(struct bio *bio)
 	return true;
 
 err_end_io:
-	bio->bi_status = status;
+	bio->bi_status = BLK_STS_RESOURCE;
 	bio_endio(bio);
 	return false;
 
-- 
2.43.0



