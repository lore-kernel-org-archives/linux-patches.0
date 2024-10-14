Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB791AC8AE;
	Mon, 14 Oct 2024 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917553; cv=none; b=lw2vJqqskAAz4cPwr3lYl85BgQSBPw8x8s+xHdmkCoxd7QKMnbugrR44Jifdd9uzlj74eUuQK4xsuJjPQ3p8mJLxjdWURLn3/+HSAy7h0BCHbXV/ETgruY1twAfGwI45dmBii8o5oqQjFo3hhV3L5583M2DSkkU0aWgnF35kqLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917553; c=relaxed/simple;
	bh=2gCH0eY9/sZ9YbGF3z/NMh0YCrY6TXPYmohEAZKzosk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flXLsXWt1WAMUb0PDl41ZzgNaPsKklazMQXkk7oFqBXKrsqHWhyHqWduzVbLHy9KJE8uqZxhnVYtvjdPPxAuRyyxlx9q86ROeYC2sLK7VOCqQSmrU2dEfYGtSS8B7l27gsbKTY2x6sU39kXX6f6A0H3KqHfw5ONT41A7Wy/MOPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmIhX2EY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmIhX2EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D9FC4CEC3;
	Mon, 14 Oct 2024 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917553;
	bh=2gCH0eY9/sZ9YbGF3z/NMh0YCrY6TXPYmohEAZKzosk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmIhX2EYA4aO5f1MR2oLfrgF8f1cHck20QkOicBAzMUUPRAmQI/pux9XLYpj2/UDm
	 6YdBGA0c/CX5XfkEUf8Ydz5xLMiBO1FJvN5ptAevaQpFHSJvn+sosGeM0LvjWKUoCA
	 BDyaY4KFxhtMVcIrqMMKj3UdscQ5NuiOfaoB2M88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riyan Dhiman <riyandhiman14@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/798] block: fix potential invalid pointer dereference in blk_add_partition
Date: Mon, 14 Oct 2024 16:10:21 +0200
Message-ID: <20241014141220.572637358@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index b71c0c2a6a73d..e4f6f56cadc41 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -580,9 +580,11 @@ static bool blk_add_partition(struct gendisk *disk,
 
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



