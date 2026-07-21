Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EE5471268;
	Tue, 21 Jul 2026 20:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664327; cv=none; b=ij9Gb8W3XV3XsOOcfWeMJA7+bmJSZjOa3xWRygH0occHsSTq9eb7dOUhir9l7kw0kHT///laL0Rot6CUs2TW76cS5pMgbD1Y9uhgYw7CHMIZn0BDbwtY2d/8FruRS+qaoBVuojREBWqmHOnlgrYN55JnRUTOZzIQ7cTHKH6Z984=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664327; c=relaxed/simple;
	bh=ZsZieIqtg4vxOvG0FJdOjYb2yKMNC8PA+2cj/e70neU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qoeb/o2aCtE5CMG0ZjTrjNNb+ldSmyXsVK4gdTL3VOQnU2hewP0eS1WO0JcU3MhusgTcfd9YWSvtjwOH/j44XSSLVN50FkriVqOJSd2GGXAoxprrg4dH1yd5VzrKVS0farmf67ElHTDaPoBhnDm4tvNy3RFiC1b1TFRkrym4GC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEr4wSRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEr4wSRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9833E1F000E9;
	Tue, 21 Jul 2026 20:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664326;
	bh=puGyfvGtZr7P0I4MIbGKp1xEXzBcXoly1LmZAShzEyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEr4wSRla1+o/z6mxJelREWCk9JjzpnwWVIhlTz4BPUMSPYVok+pICEOdiaKrJ2uW
	 Ug6cGlSwLc1OUzxft5g7xpl39ANk46F7SUzqzRDPwzi0R3ie/GqTGI/leYbJQvhAwC
	 htRSON2z9eK3F1gaxx1CnxcMEEXwAg4A3DK6SPKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 1115/1276] memstick: ms_block: reject a card that reports too many blocks
Date: Tue, 21 Jul 2026 17:25:58 +0200
Message-ID: <20260721152510.945937637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


