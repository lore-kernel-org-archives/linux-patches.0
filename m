Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12DD3016E1;
	Thu, 28 May 2026 20:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000913; cv=none; b=rR9Byc2Y4m84HM+YPvg6x/UE/ZTFaqe30hDQ9DUPvYFYBNMdKZrIjnJ95WZvn5i8uMCC0wIBCukSNtFyJB9S2Obc2pqbIiDK+F6YVTH5vctrngaofAdv1+8HC24PuElO5uLSbleFMugq5t+zKFKLZCm00mJ9UzZeXS6mcDinv7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000913; c=relaxed/simple;
	bh=qioKSYp+a5cgAR+VtvzKw/Fz7o5x2vtNOHva+dn3JJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uInVv24IMGUS9VkrnvgyMs3qhiopXkWiso8fYYFg9i1iKaU8jSLxWqj3+Ep5dBwY4cvRwRe+LuMZuMpcaRZUPD9Gs+2Pd7sN2tAjSrGW9T2C2puqX+86PA/h1W7Tk+VPxkctRnf/zcUm0oLrzesP3ZBuj3jhzHvEZw04YJeWCWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0s7S4uM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0s7S4uM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2FF1F000E9;
	Thu, 28 May 2026 20:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000911;
	bh=0ejHhOtW5tu267UASDXYFRKbMnjFuY+WcnSEWpnVAfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0s7S4uMosIVBbBFbJNpMp/cdvs14k3GjMXa5GEL/Yoil+hOA8ZbkZaxLFjdBRmUC
	 Df3GwqJIa0VszG62j+K8TTHQX7KIha8gx2y1vEVbEP51m6qs6E+ppmkb5ijzRgBDDq
	 EtKNej8Ytyu5IIHGhNYA+6JrCcdlXxD8aKD6037c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/272] block: drop direction param from bio_integrity_copy_user()
Date: Thu, 28 May 2026 21:49:48 +0200
Message-ID: <20260528194635.209643260@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit c09a8b00f850d3ca0af998bff1fac4a3f6d11768 ]

direction is determined from bio, which is already passed in. Compute
op_is_write(bio_op(bio)) directly instead of converting it to an iter
direction and back to a bool.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Link: https://lore.kernel.org/r/20250603183133.1178062-1-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 8582792cf23b ("block: bio-integrity: Fix null-ptr-deref in bio_integrity_map_user()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 785adefc5f3c3..6801754838bc1 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -196,10 +196,9 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 EXPORT_SYMBOL(bio_integrity_add_page);
 
 static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
-				   int nr_vecs, unsigned int len,
-				   unsigned int direction)
+				   int nr_vecs, unsigned int len)
 {
-	bool write = direction == ITER_SOURCE;
+	bool write = op_is_write(bio_op(bio));
 	struct bio_integrity_payload *bip;
 	struct iov_iter iter;
 	void *buf;
@@ -210,7 +209,7 @@ static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
 		return -ENOMEM;
 
 	if (write) {
-		iov_iter_bvec(&iter, direction, bvec, nr_vecs, len);
+		iov_iter_bvec(&iter, ITER_SOURCE, bvec, nr_vecs, len);
 		if (!copy_from_iter_full(buf, len, &iter)) {
 			ret = -EFAULT;
 			goto free_buf;
@@ -305,7 +304,7 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 	struct page *stack_pages[UIO_FASTIOV], **pages = stack_pages;
 	struct bio_vec stack_vec[UIO_FASTIOV], *bvec = stack_vec;
 	size_t offset, bytes = iter->count;
-	unsigned int direction, nr_bvecs;
+	unsigned int nr_bvecs;
 	int ret, nr_vecs;
 	bool copy;
 
@@ -314,11 +313,6 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 	if (bytes >> SECTOR_SHIFT > queue_max_hw_sectors(q))
 		return -E2BIG;
 
-	if (bio_data_dir(bio) == READ)
-		direction = ITER_DEST;
-	else
-		direction = ITER_SOURCE;
-
 	nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS + 1);
 	if (nr_vecs > BIO_MAX_VECS)
 		return -E2BIG;
@@ -341,8 +335,7 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 		copy = true;
 
 	if (copy)
-		ret = bio_integrity_copy_user(bio, bvec, nr_bvecs, bytes,
-					      direction);
+		ret = bio_integrity_copy_user(bio, bvec, nr_bvecs, bytes);
 	else
 		ret = bio_integrity_init_user(bio, bvec, nr_bvecs, bytes);
 	if (ret)
-- 
2.53.0



