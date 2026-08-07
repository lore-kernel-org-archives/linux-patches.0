Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB2B471D1C;
	Fri,  7 Aug 2026 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114739; cv=none; b=d3Y7bieNgDy47U9/UTg+GRFu61TT78TOOc2qAFIa8bELXI50IDxHuCvBUFp+dK40Wtw20JBX/T/HMc8GWV1lNJmneJZR5qUz31Geb563Yd02t5X8hZfsZwAsyU11CgAiWkEQwW5jm/2WQFAQHerilcaJyQDAzq+p/UkV/I2QXKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114739; c=relaxed/simple;
	bh=xaPdwjrItIbv1c0/piEHUyEN0dPmaDqhT36ebTzZtwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPf1rIHeWCJ2bf+VeVo0mpXRl7F5wKJpsiWmzmDTprJBTBG9KXnyGuZXEhEKxsJdZcG3RDDbg0h5uQUenypsGEz2gxdGabpwcKZd8niFpUaC5IDOHdnjH9glPEHulSkhJIH+CRSLGx93EHTeGYAtN4ErdBWW15QU9w/+Aj7ytvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixAcPiHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixAcPiHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004FF1F000E9;
	Fri,  7 Aug 2026 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114738;
	bh=4CTw6uJuFWr+gPJG3bavwts+1DmEDVa+4iAoX4tqyog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixAcPiHqBVjb0Aqq5O6iVzgmhVNv+ZhdCA7jPr5MCVJW9+tKvpG2hcQNksoHNAonD
	 JomCqjBTFHcladaJlbacmlUqe8u1pymGClY/vo7m3fynDCc7K5apHUDTlVLv0m/+Xk
	 bess2cGKI2brwzDCAYahhywDqWLU2ayPiC6vZt/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/396] btrfs: zoned: reset meta_write_pointer on zone reset
Date: Fri,  7 Aug 2026 16:33:10 +0200
Message-ID: <20260807143424.922462195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 5fabb1cf25d723274009d7b759545fd59f230c9d ]

btrfs_reset_unused_block_groups() resets a block group's zone and sets
alloc_offset back to 0 so the space can be reused, but it leaves
meta_write_pointer pointing at the previous end of the zone.

Once the block group is reactivated and reused for metadata, newly
allocated tree blocks live before that stale write pointer.
btrfs_check_meta_write_pointer() then sees them behind the write pointer,
so they can never be written out in sequential order: the dirty extent
buffers are stranded and pin their btree_inode folios until unmount.

Reset meta_write_pointer back to the start of the block group for
metadata and system block groups.

Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting")
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 340380dbe81d1..0dfbb28b7445c 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3171,6 +3171,17 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		reclaimed = bg->alloc_offset;
 		bg->zone_unusable = bg->length - bg->zone_capacity;
 		bg->alloc_offset = 0;
+		/*
+		 * The zone was just reset to empty, so alloc_offset went back to
+		 * the start of the zone. For metadata/system block groups the
+		 * write pointer must follow it back to the start of the zone;
+		 * otherwise it stays stale at the previous (finished) zone end,
+		 * and metadata written into the reused zone would sit behind the
+		 * write pointer, could never be written out in sequential order,
+		 * and would be stranded (pinning its folio) until unmount.
+		 */
+		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+			bg->meta_write_pointer = bg->start;
 		/*
 		 * This holds because we currently reset fully used then freed
 		 * block group.
-- 
2.53.0



