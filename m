Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82E71D0946;
	Wed,  2 Oct 2024 13:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875527; cv=none; b=mWQCXhL1aqymNauyKXtUIeEgmSdzA9+l3VLy2yZDCJDFJo+EpN0vVBMfTjY06TB4IsXgpOgEqI6eKGSz8Q0Kqe6so2ylmlh6CVoTx8dGJb3EQgJpf1WsGVW1Z8c+eAGLYAPiUjewxZA3MjmjBV3SVy9fi3zOa4tNBywvSW8EH+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875527; c=relaxed/simple;
	bh=8bozVNXKHXqJTHT1H28SA2L1q32TJQb8Em3tnS/e8cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/HnsBJrXWDp3EJdozqvVg3p6YBnrnqp2lGOsERdinNNhz1RAjchqTx4OxGoK025cmNO6iSx0dIsRjZtZlM0Yx9ufCXUTjx2jJkVmXJGfdT3Y8x400IHPDzMIaE6j1P3e3dGWwIpV8/NcSGcm519p5Zit+gYiVfPkg6i0Maqx1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQUnV2Y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQUnV2Y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ED8C4CECD;
	Wed,  2 Oct 2024 13:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875526;
	bh=8bozVNXKHXqJTHT1H28SA2L1q32TJQb8Em3tnS/e8cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQUnV2Y5KFFoJO1Ix11NQo9tzt0OioW0MhjdKpOKFvCphX6XYjAuUUK+Xn3Xd25dN
	 PbQloxsm2uZG55KNg3iSZFkzy89BEX+mlV1Z10ZDrOS8fTM+T/ZCiLGw2E4tPuFnTb
	 uQ2xcPamgpZ9rEDzKn67BeARwZNDLs8yHehr228E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riyan Dhiman <riyandhiman14@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 132/695] block: fix potential invalid pointer dereference in blk_add_partition
Date: Wed,  2 Oct 2024 14:52:10 +0200
Message-ID: <20241002125827.750909854@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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
index ab76e64f0f6c3..5bd7a603092ea 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -555,9 +555,11 @@ static bool blk_add_partition(struct gendisk *disk,
 
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



