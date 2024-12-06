Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E1032C8B;
	Fri,  6 Dec 2024 14:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496664; cv=none; b=DfafVCVMBURtpUKQabU7hUP8LV0dP0Sq4cJoy6jAoQ8hUz1j3byKlpqPQLqKH085707NNTPuoH6yC6wNtjDKqic3SIETEEheB6El+DWhSJ6SEil3qzIrFMS/NsN49+KmfqaQUU7Dea4jJUb5/K+tY/+3pYdQrrWBMyv2Z1wI+R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496664; c=relaxed/simple;
	bh=yO6Q+Fan2Cky1QWkEwqLaY3pj6FPdgeaF1BNWRp3IHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJdAv36dRSKbK/XDm+7NwgPNoPewqFZTr6lMoKK0fH/NfMgYT1ONYjoL+KEyZGoY8ndrQ9AYPtRb5UTctILLDBNtVnJig4e/SoJVtPzI/g6BQuWLL09o+5yWCX2MTH91r4twXT3anKIzG6rE7UvYEdjLQDIPR1MwqOYuQg928LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6oDKfmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6oDKfmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04ACC4CED1;
	Fri,  6 Dec 2024 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496664;
	bh=yO6Q+Fan2Cky1QWkEwqLaY3pj6FPdgeaF1BNWRp3IHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6oDKfmqO2nYe76HhN+dcQEOxxcqN1VUs968wGBWOzvKFCIlcwwtOiNxQKkEvSl/O
	 gf64Kc5H2/PIqpMomv+wLDF2vOUFyhpKObw+/wdnbU/R6Zxi1EiMmG19TEuvX98BQZ
	 zMRI5bYgr1X07hjtF+4pRVvOb2xq+MjA4xB5MYvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/676] block: fix bio_split_rw_at to take zone_write_granularity into account
Date: Fri,  6 Dec 2024 15:28:07 +0100
Message-ID: <20241206143656.017303979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7ecd2cd4fae3e8410c0a6620f3a83dcdbb254f02 ]

Otherwise it can create unaligned writes on zoned devices.

Fixes: a805a4fa4fa3 ("block: introduce zone_write_granularity limit")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20241104062647.91160-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 07bf758c523a9..889ac59759a26 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -256,6 +256,14 @@ static bool bvec_split_segs(const struct queue_limits *lim,
 	return len > 0 || bv->bv_len > max_len;
 }
 
+static unsigned int bio_split_alignment(struct bio *bio,
+		const struct queue_limits *lim)
+{
+	if (op_is_write(bio_op(bio)) && lim->zone_write_granularity)
+		return lim->zone_write_granularity;
+	return lim->logical_block_size;
+}
+
 /**
  * bio_split_rw - split a bio in two bios
  * @bio:  [in] bio to be split
@@ -326,7 +334,7 @@ struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 	 * split size so that each bio is properly block size aligned, even if
 	 * we do not use the full hardware limits.
 	 */
-	bytes = ALIGN_DOWN(bytes, lim->logical_block_size);
+	bytes = ALIGN_DOWN(bytes, bio_split_alignment(bio, lim));
 
 	/*
 	 * Bio splitting may cause subtle trouble such as hang when doing sync
-- 
2.43.0



