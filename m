Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623343ACEFE;
	Tue, 21 Jul 2026 21:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670424; cv=none; b=M9FpaoUYwd+T5vJDMHkFUBSEPuAjnHixfLvYcbMYqCTCYtuqaBhUt6guYcUG7/gQme72kMoOaNXPONwdEvlkFc6vqPDyxP3IvWIfBrBATApOXpbRgEY+vmTQhcPXrU5YSwj/K5MiGBL6CXui8LtkkcffsK2u53y1Xij7iDdB/gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670424; c=relaxed/simple;
	bh=6UgDMIoVBoueCR424AJTqOWQtDDEabEFKG9OHo/XuGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnPj1xuSncBEJ/71xd+8FXYBcBNSKzxuEfzN00Hoq/w+yoNW2BlFRfcIKDbfuV3AZElo0ty6iURv9yo7fKgynLd43gqQs8YAJ1OAAchZY7ZsZx0dSICBdRlrSQ++afuPQwO/1WC9Rfs/E9X1q07yqyt6GjTWAGhgIES2NTKeTfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgcGWa7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgcGWa7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33AD1F000E9;
	Tue, 21 Jul 2026 21:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670423;
	bh=hRJQu2XKi9tgsfM9q4ZL7byfw0uBCjpfdkiYC3m4CN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgcGWa7oK4bkxAjhM1O+QmSLH6PJXdKcee3/QCs+j+O4IrSNjbN75MILBemq7YAn+
	 KB/w6t4ld2ucQPQ40gIyYxjEgwkm6aHRf13RaWvrYdWNroP1jSetZ4ALtGV+KBc7BL
	 efJHtDqOEuzeMlt5d37LfZZwNPD0C9WilPZVP3/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 0925/1067] memstick: ms_block: reject a card that reports too many blocks
Date: Tue, 21 Jul 2026 17:25:26 +0200
Message-ID: <20260721152445.226575370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


