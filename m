Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A8B2C6AF;
	Sun,  1 Sep 2024 17:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210274; cv=none; b=oBjOtDU0yBqWdvVv9zn8R11GGhNw8ZMFCwOekZUBCbtX0mpI89pzuvtIdem2t33W26uKVccOPK8xuLSCp/zOj8nufldfAfQ0hK7Cjj1pPlxzKeh8CD5DhxytCvoCeXDhwW9VOpmo671yczGV8mrfsijEUKJTjdjen/cfOIYuqzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210274; c=relaxed/simple;
	bh=tfd57QXaSvl7Mp6m6jFVg6MG0Ax1JE1AlWtKgnNJa38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2zBx1hcXFv7HpLdTAtKt69JMQ/m7vo3U6Bw4YKkhII8QrreVg6Ey+ZBC6LT5GVLWxXquzqMGTv+Cy+WQDcqLnFXuvBqBOgKdJy2hCKIJvPONKTPKnytM5nQfcnQ3/JYdRt17loh/3qG88azcoBx2bjeK2FPGxrcTNW+hxZxWQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwSwUBbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwSwUBbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70051C4CEC3;
	Sun,  1 Sep 2024 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210273;
	bh=tfd57QXaSvl7Mp6m6jFVg6MG0Ax1JE1AlWtKgnNJa38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwSwUBbVUKyKlznOyjBfW60gXKqQs13cyYPqtbZry3yEpre9FPippVlnp0fy2eibF
	 jMm2t4OjE+twc5uZo6Z8MjH2/14V0qas7fNZsu7YI1wJ6/9Jjg9hcGfpNfYcb+JZTD
	 jEAFhfgrm/5sp/KIxxP8x8l0mroJQ3PfINnCDVjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	David Hunter <david.hunter.linux@gmail.com>
Subject: [PATCH 5.15 109/215] block: use "unsigned long" for blk_validate_block_size().
Date: Sun,  1 Sep 2024 18:17:01 +0200
Message-ID: <20240901160827.465536081@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 37ae5a0f5287a52cf51242e76ccf198d02ffe495 upstream.

Since lo_simple_ioctl(LOOP_SET_BLOCK_SIZE) and ioctl(NBD_SET_BLKSIZE) pass
user-controlled "unsigned long arg" to blk_validate_block_size(),
"unsigned long" should be used for validation.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/9ecbf057-4375-c2db-ab53-e4cc0dff953d@i-love.sakura.ne.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blkdev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -235,7 +235,7 @@ struct request {
 	void *end_io_data;
 };
 
-static inline int blk_validate_block_size(unsigned int bsize)
+static inline int blk_validate_block_size(unsigned long bsize)
 {
 	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
 		return -EINVAL;


