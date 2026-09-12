Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB72F30DD22;
	Sat, 12 Sep 2026 08:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200444; cv=none; b=BxZuBX3oybO8rI6R1I9rk7iimPHYxIAMUGaPjzqv4DsxDn5h9sR1rPvM6zQU76z2wKtgKHYnkiTbn8GJ0IfkMBOXcnuhMaVCMvtX49zXuu2YPzO7VAfcdsjP0SK3uTweLrAItwK1u9JbezBM2HlUnxU/efhPVnwSymaYtVFLt1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200444; c=relaxed/simple;
	bh=F/J0szvmMQxQbRCvy3R6E3eYgx2V2zCaiDzsjOLp0zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ufu4VeYpvvEZB85kJYtnNHpoBwd6VeStkNo5XnY2+qZ9PfOq6QMlluqDG0WYDItSPxqUiYkwBU4CJCZkia9po2FBI6ZyilTONynqzksQGVBfl1YPEu1rYqPGqeTL7JgTJsuFqAZMfm89sz3YS0dBK22piny/M7ndgsIOSfDYYcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nx7S0syQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nx7S0syQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4AE1F000FF;
	Sat, 12 Sep 2026 08:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200443;
	bh=sZSm4sVgr8Ukya9SiCSy47TY7XfdI/+kNEKpuYgXaAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nx7S0syQweCa/15yHH82dmg4UqzwF0pCBeQh7qic+cWELyl4tifz8zJ+pxwqxlwaP
	 2t0QzdYcCABfFig8Bx8yGidSqHo/7J+dUP7gW1q6wirZDdeFiN9uKiYpcSqgS5n1/0
	 o7x1iK2hqEmPuDYQ3Qvfrvev4YUWNfocKmxhvVjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0792/1815] block: fix dio leak on metadata mapping error
Date: Sat, 12 Sep 2026 08:42:22 +0200
Message-ID: <20260912065707.503886996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 702a2a9f3dfe066a7481698c858371112f3cb697 ]

A failed integrity mapping holds a dio reference, so we need to go
through the full bio ending in case there were previously submitted
bio's in the sequence.

Fixes: 2729a60bbfb92 ("block: don't silently ignore metadata for sync read/write")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Link: https://patch.msgid.link/20260720201057.1862857-3-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index a84450d79b3cc..cb919dea00411 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -238,8 +238,10 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		}
 		if (iocb->ki_flags & IOCB_HAS_METADATA) {
 			ret = bio_integrity_map_iter(bio, iocb->private);
-			if (unlikely(ret))
-				goto fail;
+			if (unlikely(ret)) {
+				bio_endio_status(bio, errno_to_blk_status(ret));
+				break;
+			}
 		}
 
 		if (is_read) {
-- 
2.53.0



