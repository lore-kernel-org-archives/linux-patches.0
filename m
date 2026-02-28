Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689D247CC8B;
	Sat, 28 Feb 2026 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301371; cv=none; b=dnWAuJAR8ZLXf6ZKptFrXcHLkw8w8bQNhbKhdQEYoUTsQ3xqbRPMGxLsUJxy8GMWaFGoR5cbaTSU3gBNgjvMru0rwE3PDGVKRUKPt5nCB2k/KMJoD0RxeXT6OWwSmO0WJkiHG2eAr4+KnEXfsCST7pL80qZ/SPAFyTGjrcHheSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301371; c=relaxed/simple;
	bh=SsTQtT95nhRfD4rfSWy0JtnaIw6wyjoP8Ex2NMbIeYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6MXo0ShpUaXgK2hmb9iTI9Uj+y9OHOg3faUxYzMRxUrGGQpCzeWzCrXVwO4Syb61eN/ygTLJKGRJ8X7+gqZy+0l7JhFCRuflgct/cJjniC2T3jPZPlNwtmSrBhImli72aTJ26sXN17nsxAC6s/Ri74uAKIuFsrvhxkq7Hws/XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e000TQZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e000TQZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A78C19423;
	Sat, 28 Feb 2026 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301371;
	bh=SsTQtT95nhRfD4rfSWy0JtnaIw6wyjoP8Ex2NMbIeYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e000TQZOARSZFO1htWr0IrzdhtKYk+Kfh470JRD6wlSCKUglN7SUVwQqeVdOlhx2F
	 FkzcO1Fz5BW3HmVbHo58AhFNecFE4GZPwnWpa7FLvKXKupK7yqPATD6BOwA8fQB3aI
	 yde0zYJBmNSxZfTKg5fI2spLSNnMVqRAhZYFymG6Cn27d7ll7tD8i503O5YzisBxnz
	 mCmhDm41T7IOK0FkRGPWl1Jv80qrGFtIz/HXpjvGkIAWW8pDwU1pIeJEK8DlsMEQfg
	 vKXuIptYteDhSa94jgIFds9eBgT6dmHAD48ieI9TiuvgQefUGlBfr/F35TWMNeqZgs
	 LhyfOJxj3OBrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matt Whitlock <kernel@mattwhitlock.name>,
	Mikulas Patocka <mpatocka@redhat.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 560/752] dm-unstripe: fix mapping bug when there are multiple targets in a table
Date: Sat, 28 Feb 2026 12:44:31 -0500
Message-ID: <20260228174750.1542406-560-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matt Whitlock <kernel@mattwhitlock.name>

[ Upstream commit 83c10e8dd43628d0bf86486616556cd749a3c310 ]

The "unstriped" device-mapper target incorrectly calculates the sector
offset on the mapped device when the target's origin is not zero.

Take for example this hypothetical concatenation of the members of a
two-disk RAID0:

linearized:       0 2097152 unstriped 2 128 0 /dev/md/raid0 0
linearized: 2097152 2097152 unstriped 2 128 1 /dev/md/raid0 0

The intent in this example is to create a single device named
/dev/mapper/linearized that comprises all of the chunks of the first disk
of the RAID0 set, followed by all of the chunks of the second disk of the
RAID0 set.

This fails because dm-unstripe.c's map_to_core function does its
computations based on the sector number within the mapper device rather
than the sector number within the target. The bug turns invisible when
the target's origin is at sector zero of the mapper device, as is the
common case. In the example above, however, what happens is that the
first half of the mapper device gets mapped correctly to the first disk
of the RAID0, but the second half of the mapper device gets mapped past
the end of the RAID0 device, and accesses to any of those sectors return
errors.

Signed-off-by: Matt Whitlock <kernel@mattwhitlock.name>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 18a5bf270532 ("dm: add unstriped target")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-unstripe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index e8a9432057dce..17be483595642 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -117,7 +117,7 @@ static void unstripe_dtr(struct dm_target *ti)
 static sector_t map_to_core(struct dm_target *ti, struct bio *bio)
 {
 	struct unstripe_c *uc = ti->private;
-	sector_t sector = bio->bi_iter.bi_sector;
+	sector_t sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
 	sector_t tmp_sector = sector;
 
 	/* Shift us up to the right "row" on the stripe */
-- 
2.51.0

