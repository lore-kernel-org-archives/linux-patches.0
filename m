Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6057921FF5F;
	Tue, 17 Jun 2025 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178945; cv=none; b=BDilaMSh37mqzZ8G+tNzmu25vp60nx0p1FjZhUQpc8UGRUAjdb2wMJfF9zrHt9t9Tmc9zBTyA1FuqyEXJnvCdBXryJgnzD7JG2BPlIADhL4g6ZEkHu9dv4kD1t2W3T4jAOqnGnVQmDjK8IHfZh0+UEyFIqUf3UzxI/Caueq93fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178945; c=relaxed/simple;
	bh=/kWc70amw5cWEIxSDglFsdoosHbsUbsb/wyEDrhqU38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScnsM7gm9SZMceF7XaLFF9rxmJ1L6DFgTqL23ir6LCsTiAnkLbPZ38IkGWfZxXFnS9iIRgsdKKDmI70i+lZ2DDr2qkdkmVn34jglWK07e0KxPSMNWvX9hSUxlvaK+zgXWC69CKoHTPEzQFMxjxDK4694f1wigJLT5ir5n85EpTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scN4ybC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scN4ybC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5167C4CEE3;
	Tue, 17 Jun 2025 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178945;
	bh=/kWc70amw5cWEIxSDglFsdoosHbsUbsb/wyEDrhqU38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scN4ybC5QVX3J2bENQ08n3a6gxltrZznf6PgZpSJdpcDDaEhxiPAVjCWcYQAC1kVt
	 UzhxOQPBzKGs026hB4HQZh6xi6js2y2coyihBSGGSHIqQ4eRLPZhnDROrLIVBhlD5W
	 7f8hTLSLKau6ZEAPrSKEFB/7suKpdEc7Iu345830=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 600/780] block: flip iter directions in blk_rq_integrity_map_user()
Date: Tue, 17 Jun 2025 17:25:08 +0200
Message-ID: <20250617152515.917851091@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 43a67dd812c5d3de163c0b6971046b4a4b633d3f ]

blk_rq_integrity_map_user() creates the ubuf iter with ITER_DEST for
write-direction operations and ITER_SOURCE for read-direction ones.
This is backwards; writes use the user buffer as a source for metadata
and reads use it as a destination. Switch to the rq_data_dir() helper,
which maps writes to ITER_SOURCE (WRITE) and reads to ITER_DEST(READ).

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: fe8f4ca7107e ("block: modify bio_integrity_map_user to accept iov_iter as argument")
Link: https://lore.kernel.org/r/20250603184752.1185676-1-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index a1678f0a9f81f..e4e2567061f9d 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -117,13 +117,8 @@ int blk_rq_integrity_map_user(struct request *rq, void __user *ubuf,
 {
 	int ret;
 	struct iov_iter iter;
-	unsigned int direction;
 
-	if (op_is_write(req_op(rq)))
-		direction = ITER_DEST;
-	else
-		direction = ITER_SOURCE;
-	iov_iter_ubuf(&iter, direction, ubuf, bytes);
+	iov_iter_ubuf(&iter, rq_data_dir(rq), ubuf, bytes);
 	ret = bio_integrity_map_user(rq->bio, &iter);
 	if (ret)
 		return ret;
-- 
2.39.5



