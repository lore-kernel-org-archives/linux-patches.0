Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182051C07C2;
	Tue, 15 Oct 2024 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997127; cv=none; b=VTwfBayX2aYRZqmD/mpfLfldy+f6vx7dWA5CjKwgn00lBqAqaPP9uTwfxaOhYDfkJIKJH7J7jEaYF/zaicHpS1hLSH/CyqQUu2LB2vj3hhQYn4z6D97qtSkk9UJ7nrEka9PltlsEnrpwRk+L6pKbuozJga9cUK2BFSk+t8e1hcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997127; c=relaxed/simple;
	bh=7O5vRLaQi3xPhbdB26si609XS0iUcsKKTLb+dpHcOEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BApoRTMLm1N/yxwIhK4oC0LClEnK3VFi5KvHtFqTVNDoQlUTV4R8FZng6VNdYkt7YWGhvpVOp4GMf92NlYTvsKrkuNn1aM2oCGc8Adj4HpTczQcvD9drh0ebyJ2S6/Rv7QyO1Kx8f5X83li+CSE3coze5N2yv/4k8XmbfU05Gbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOV09qIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOV09qIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712BFC4CEC6;
	Tue, 15 Oct 2024 12:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997126;
	bh=7O5vRLaQi3xPhbdB26si609XS0iUcsKKTLb+dpHcOEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOV09qIjeT38rqN4xZZIZg0ZYCd1WzICOh1rgdiVtkFtSax39B2ebvjcXbd+jsSkE
	 LKBTQvrQiNwZtVREwa3/iA/1LF5iobAKpv6vOzLIWnLjPhbMu/+NCJW8+5nZpyN+ck
	 QrxuDUi5YWP4hnuhJvSMsRUSJ25dsUrnr5s7LIg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riyan Dhiman <riyandhiman14@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/518] block: fix potential invalid pointer dereference in blk_add_partition
Date: Tue, 15 Oct 2024 14:39:58 +0200
Message-ID: <20241015123920.630420765@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Riyan Dhiman <riyandhiman14@gmail.com>

[ Upstream commit 26e197b7f9240a4ac301dd0ad520c0c697c2ea7d ]

The blk_add_partition() function initially used a single if-condition
(IS_ERR(part)) to check for errors when adding a partition. This was
modified to handle the specific case of -ENXIO separately, allowing the
function to proceed without logging the error in this case. However,
this change unintentionally left a path where md_autodetect_dev()
could be called without confirming that part is a valid pointer.

This commit separates the error handling logic by splitting the
initial if-condition, improving code readability and handling specific
error scenarios explicitly. The function now distinguishes the general
error case from -ENXIO without altering the existing behavior of
md_autodetect_dev() calls.

Fixes: b72053072c0b (block: allow partitions on host aware zone devices)
Signed-off-by: Riyan Dhiman <riyandhiman14@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240911132954.5874-1-riyandhiman14@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index dad17a767c331..45fe4317fffa0 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -691,9 +691,11 @@ static bool blk_add_partition(struct gendisk *disk, struct block_device *bdev,
 
 	part = add_partition(disk, p, from, size, state->parts[p].flags,
 			     &state->parts[p].info);
-	if (IS_ERR(part) && PTR_ERR(part) != -ENXIO) {
-		printk(KERN_ERR " %s: p%d could not be added: %pe\n",
-		       disk->disk_name, p, part);
+	if (IS_ERR(part)) {
+		if (PTR_ERR(part) != -ENXIO) {
+			printk(KERN_ERR " %s: p%d could not be added: %pe\n",
+			       disk->disk_name, p, part);
+		}
 		return true;
 	}
 
-- 
2.43.0



