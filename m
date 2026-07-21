Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE93471264;
	Tue, 21 Jul 2026 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659471; cv=none; b=vAzWfcMTSqvd1JYb/pmwwNfPK2Khs1qogxnZk6L8mLo0aRZB2PrW3gqvAsIPhYKV9OtCT+k7c8Z1TMQyUgHQV8f5xVjblo7Hktv7Bq0udjzUawLH4YrorY8mZJyccak9UpsZ+NwvdGzwBFO4A9VJ4nfm3GxrgZgZHQcx8ZW4NcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659471; c=relaxed/simple;
	bh=uiA9n00EPYu5hAlgNzYsZPMGOXXRB0mnoVeQMzWWcLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBoLocg3eb0E51O92QnVhcQ/oMGXSPyLa9AYxeXxI8A8URTjV7DYw1tFL8i1+FCXShbX4UocYgma3x5aaUDGDA5RG5RoVLett07myphiKg8eIGs+v7ImJrQChOQXzphWuDX9ewD6i4/vq/6Bg8zqSRE4oSjK1rgRjQMZbsxaxAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3ugHdWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3ugHdWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E351F00A3D;
	Tue, 21 Jul 2026 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659470;
	bh=W+0g5ZGjdndxkJo4nBRnbHjMFjyFfSwBcqH/KlGFklE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3ugHdWccdogn3kCskbaI1/UHKqgtU21C5JWfxND4gfat9HwF6Gkwkkwr64IzFl52
	 gF59y7nABbcgPxcqxz2jy55Lln/+XZiGTSQ4kiKi4UiqtRsLMrKC+h4efUqgj2Moi+
	 4R2tw9OTNboq4AUb7hM4hKcu08pUF9XzI/OT1jZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 1490/1611] memstick: ms_block: reject a card that reports too many blocks
Date: Tue, 21 Jul 2026 17:26:46 +0200
Message-ID: <20260721152548.958043826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 718178f524b98bc920d74bc771aed823c8b81425 upstream.

msb_ftl_initialize() computes the zone count from the card block count
with no bound:

	msb->zone_count = msb->block_count / MS_BLOCKS_IN_ZONE;
	...
	for (i = 0; i < msb->zone_count; i++)
		msb->free_block_count[i] = MS_BLOCKS_IN_ZONE;

msb->block_count is a card value. msb_read_boot_blocks() reads
number_of_blocks from the card boot page and byte swaps it.
free_block_count is a fixed int[MS_MAX_ZONES]. MS_MAX_ZONES is 16, so the
valid indices are 0 to 15. The init loop above indexes it by zone_count.
msb_mark_block_used() and msb_mark_block_unused() index it by
pba / MS_BLOCKS_IN_ZONE, for pba up to block_count - 1. A card may report
up to 65535 blocks. A block_count above 8192 (MS_MAX_ZONES *
MS_BLOCKS_IN_ZONE) lets the pba index reach 16. That writes past
free_block_count[] and corrupts struct msb_data. A larger count runs the
init loop past the end too.

A real Memory Stick has at most 16 zones. So it has at most 8192 blocks.
msb_ftl_initialize() now rejects a card that reports more than
MS_MAX_ZONES * MS_BLOCKS_IN_ZONE blocks.

Fixes: 0ab30494bc4f ("memstick: add support for legacy memorysticks")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/ms_block.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -1339,6 +1339,10 @@ static int msb_ftl_initialize(struct msb
 		return 0;
 
 	msb->zone_count = msb->block_count / MS_BLOCKS_IN_ZONE;
+	if (msb->block_count > MS_MAX_ZONES * MS_BLOCKS_IN_ZONE) {
+		pr_err("Too many blocks: %d\n", msb->block_count);
+		return -EINVAL;
+	}
 	msb->logical_block_count = msb->zone_count * 496 - 2;
 
 	msb->used_blocks_bitmap = bitmap_zalloc(msb->block_count, GFP_KERNEL);


