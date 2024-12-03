Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0581D9341;
	Tue,  3 Dec 2024 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237820; cv=none; b=mHEKStald5PIq0X6VsfOILLgGHwvNw9+hRaonSZPhP53ieq0OTaTaH+4bJW7ki8MyqrQBiPG60faE0qjb0FgdQNx9/8yz95/zIvueski+frm2D9ci18TXV00bsjB9ZT4hMK3JxNdRqvlmvNLF7TwNNowWWrFOnGYWblXmXexS+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237820; c=relaxed/simple;
	bh=ij+JZ8RHPVfAjbJBvczRLNuKVcsidG32FABWUHlPjsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZQ8+ROcyIoj3m7hMVjoPhddWp7PFTsOvSpGkq6cJIxrSazvdD6x1D5s0CA+X+uCLwANxtLALlvqP3Tsh7LnZ00nHzc61ss4+B8AJUBqXepfhpeMJ26L+2B0fzlXsWAkznPP0UUELnjcQla4QNhtsILq/naAQ5Ltu6boQyPtlm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oalYAlla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oalYAlla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F116C4CED6;
	Tue,  3 Dec 2024 14:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237820;
	bh=ij+JZ8RHPVfAjbJBvczRLNuKVcsidG32FABWUHlPjsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oalYAllavKUIcRD0fkUG87gT8OybXV5ArK57D4tmEFlaxXAVenGnURKdpWcd63dWo
	 PgenL+wR/pn2NH72560KIMdYyz5PIz8wxocbMHYeEJuIqT7nM320S0hw+OwlWbFPuM
	 U81Y8houNIm1dwqfrpKHKC5aD+/ahJ2l1uY5xJi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 080/817] block: fix bio_split_rw_at to take zone_write_granularity into account
Date: Tue,  3 Dec 2024 15:34:12 +0100
Message-ID: <20241203143958.820440972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f2b5f63e118bd..32d60294a44af 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -287,6 +287,14 @@ static bool bvec_split_segs(const struct queue_limits *lim,
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
  * bio_split_rw_at - check if and where to split a read/write bio
  * @bio:  [in] bio to be split
@@ -349,7 +357,7 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	 * split size so that each bio is properly block size aligned, even if
 	 * we do not use the full hardware limits.
 	 */
-	bytes = ALIGN_DOWN(bytes, lim->logical_block_size);
+	bytes = ALIGN_DOWN(bytes, bio_split_alignment(bio, lim));
 
 	/*
 	 * Bio splitting may cause subtle trouble such as hang when doing sync
-- 
2.43.0



