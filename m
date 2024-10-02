Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE5C1D0E06;
	Wed,  2 Oct 2024 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879352; cv=none; b=PcfPrtyL2NyrghyW/lH/lXnk6LKPL6H2JW6TApDCMmPYIg4Rrcm1LdNodksqZlL1XWT1/FGWPPNtJZSMbEP1wVOmUiYg1tIbCNz3t/g2d6leeXezjLU+ks83x8nUliux+oTfKqYt407YAHa6pJOhTEzS1xKSCJ+9fil4PvQ9uNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879352; c=relaxed/simple;
	bh=lcgmMQjj9+gMJcdXvhPLrshe7nPfHuVzCHwfpdtWJDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5qT0L4BGP92YWAzrAjQlbysiRITDvEUK3a9uLJ3sqEJD2LvFaGlEejd1IgmH0vP9uBLcnxVsbQyFHzrp6JyVlk+6k+FTc96isKhkZ2D/HKn2OoC93aRnYsZCi22UNClxP3QFsYalKnMor4jp9aiqZy+oKoZ6fVGCF9xj3u8Hsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXIBmXwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXIBmXwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AD8C4CEC2;
	Wed,  2 Oct 2024 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879352;
	bh=lcgmMQjj9+gMJcdXvhPLrshe7nPfHuVzCHwfpdtWJDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXIBmXwukhW3M9a7E9Dp4W9AOrwg/VKXTFFDh2EWc9wVd81lNhnhPK9wHElsPfHTp
	 SDfLyZxC8Wbcgf+U4jkT1Ex4KlOL7sBPc3CsVU62mI2g18+JXh0NHM8tmCbjNar4tU
	 3ylZ4vcyXrC5TqDeGRzuIz/E28IunM0cfwPCFqxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riyan Dhiman <riyandhiman14@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/538] block: fix potential invalid pointer dereference in blk_add_partition
Date: Wed,  2 Oct 2024 14:55:27 +0200
Message-ID: <20241002125755.698162032@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 6b2ef9977617a..fc0ab5d8ab705 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -574,9 +574,11 @@ static bool blk_add_partition(struct gendisk *disk,
 
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



