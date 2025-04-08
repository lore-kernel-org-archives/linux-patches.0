Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0BC266573;
	Tue,  8 Apr 2025 11:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110679; cv=none; b=pCbPTM37h2j1zDNsp6qqs8zzaw4SnUtw8gaxqbwZeVrgSw2W9SjLxPNvLAJtoFoY0qI2EHO1CwFoPZwgsQmVddPgN/6xaTk6J941OFovsowd1gplAs9i82mzK4XgqDKfTeGHqF8JQ47nY+p1/TJVM4YgQJ+shan9GIQDtD/JZk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110679; c=relaxed/simple;
	bh=5IsLCa/Y9e7b7ZPEBOKUpcy6gPFd9D/UP0lPC8iBD1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkF8rqihtlGS+bfFEgIEfmGfF9X4gqJhsTKHC/l/7x9cv6xKZ44ZJsCTEnVBlb4SS8LVIFIFpzrDiIdgx/otqs25Y2GH6Be+wCDDiCBAAcyDyEFHvQXpQJiTEX1EjKIDttvRNX2+IVW4cqbcOw4nozOMF/aFQkc+E7dI8f88yOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZv+GP4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZv+GP4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4823DC4CEE5;
	Tue,  8 Apr 2025 11:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110676;
	bh=5IsLCa/Y9e7b7ZPEBOKUpcy6gPFd9D/UP0lPC8iBD1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZv+GP4m5epLFC3Jvd9Xnhp1KZ9xnA2T9BTbLrNW6Lqlg5dspPZRnUEYv+bbXg/bg
	 DYTUBlqlTQflp03oRK9b7V5nQQjPrY7fCLMRM6SwVqvNy0PpZJbe6FUYdX2fDYU7hf
	 1GYMCu0FiW1YK76SPRRuIqipS1MrlBGjvu9hvwx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 152/731] badblocks: return error directly when setting badblocks exceeds 512
Date: Tue,  8 Apr 2025 12:40:49 +0200
Message-ID: <20250408104917.811356635@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 28243dcd1f49cc8be398a1396d16a45527882ce5 ]

In the current handling of badblocks settings, a lot of processing has
been done for scenarios where the number of badblocks exceeds 512.
This makes the code look quite complex and also introduces some issues,

For example, if there is 512 badblocks already:
  for((i=0; i<510; i++)); do ((sector=i*2)); echo "$sector 1" > bad_blocks; done
  echo 2100 10 > bad_blocks
  echo 2200 10 > bad_blocks
Set new one, exceed 512:
  echo 2000 500 > bad_blocks
Expected:
  2000 500
Actual:
  2100 400

In fact, a disk shouldn't have too many badblocks, and for disks with
512 badblocks, attempting to set more bad blocks doesn't make much sense.
At that point, the more appropriate action would be to replace the disk.
Therefore, to resolve these issues and simplify the code somewhat, return
error directly when setting badblocks exceeds 512.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250227075507.151331-5-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c | 121 ++++++++--------------------------------------
 1 file changed, 19 insertions(+), 102 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index ad8652fbe1c8f..1c8b8f65f6df4 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -527,51 +527,6 @@ static int prev_badblocks(struct badblocks *bb, struct badblocks_context *bad,
 	return ret;
 }
 
-/*
- * Return 'true' if the range indicated by 'bad' can be backward merged
- * with the bad range (from the bad table) index by 'behind'.
- */
-static bool can_merge_behind(struct badblocks *bb,
-			     struct badblocks_context *bad, int behind)
-{
-	sector_t sectors = bad->len;
-	sector_t s = bad->start;
-	u64 *p = bb->page;
-
-	if ((s < BB_OFFSET(p[behind])) &&
-	    ((s + sectors) >= BB_OFFSET(p[behind])) &&
-	    ((BB_END(p[behind]) - s) <= BB_MAX_LEN) &&
-	    BB_ACK(p[behind]) == bad->ack)
-		return true;
-	return false;
-}
-
-/*
- * Do backward merge for range indicated by 'bad' and the bad range
- * (from the bad table) indexed by 'behind'. The return value is merged
- * sectors from bad->len.
- */
-static int behind_merge(struct badblocks *bb, struct badblocks_context *bad,
-			int behind)
-{
-	sector_t sectors = bad->len;
-	sector_t s = bad->start;
-	u64 *p = bb->page;
-	int merged = 0;
-
-	WARN_ON(s >= BB_OFFSET(p[behind]));
-	WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
-
-	if (s < BB_OFFSET(p[behind])) {
-		merged = BB_OFFSET(p[behind]) - s;
-		p[behind] =  BB_MAKE(s, BB_LEN(p[behind]) + merged, bad->ack);
-
-		WARN_ON((BB_LEN(p[behind]) + merged) >= BB_MAX_LEN);
-	}
-
-	return merged;
-}
-
 /*
  * Return 'true' if the range indicated by 'bad' can be forward
  * merged with the bad range (from the bad table) indexed by 'prev'.
@@ -884,11 +839,9 @@ static bool try_adjacent_combine(struct badblocks *bb, int prev)
 static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			  int acknowledged)
 {
-	int retried = 0, space_desired = 0;
-	int orig_len, len = 0, added = 0;
+	int len = 0, added = 0;
 	struct badblocks_context bad;
 	int prev = -1, hint = -1;
-	sector_t orig_start;
 	unsigned long flags;
 	int rv = 0;
 	u64 *p;
@@ -912,8 +865,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	write_seqlock_irqsave(&bb->lock, flags);
 
-	orig_start = s;
-	orig_len = sectors;
 	bad.ack = acknowledged;
 	p = bb->page;
 
@@ -922,6 +873,11 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	bad.len = sectors;
 	len = 0;
 
+	if (badblocks_full(bb)) {
+		rv = 1;
+		goto out;
+	}
+
 	if (badblocks_empty(bb)) {
 		len = insert_at(bb, 0, &bad);
 		bb->count++;
@@ -933,32 +889,14 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	/* start before all badblocks */
 	if (prev < 0) {
-		if (!badblocks_full(bb)) {
-			/* insert on the first */
-			if (bad.len > (BB_OFFSET(p[0]) - bad.start))
-				bad.len = BB_OFFSET(p[0]) - bad.start;
-			len = insert_at(bb, 0, &bad);
-			bb->count++;
-			added++;
-			hint = 0;
-			goto update_sectors;
-		}
-
-		/* No sapce, try to merge */
-		if (overlap_behind(bb, &bad, 0)) {
-			if (can_merge_behind(bb, &bad, 0)) {
-				len = behind_merge(bb, &bad, 0);
-				added++;
-			} else {
-				len = BB_OFFSET(p[0]) - s;
-				space_desired = 1;
-			}
-			hint = 0;
-			goto update_sectors;
-		}
-
-		/* no table space and give up */
-		goto out;
+		/* insert on the first */
+		if (bad.len > (BB_OFFSET(p[0]) - bad.start))
+			bad.len = BB_OFFSET(p[0]) - bad.start;
+		len = insert_at(bb, 0, &bad);
+		bb->count++;
+		added++;
+		hint = 0;
+		goto update_sectors;
 	}
 
 	/* in case p[prev-1] can be merged with p[prev] */
@@ -978,6 +916,11 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int extra = 0;
 
 			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
+				if (extra > 0) {
+					rv = 1;
+					goto out;
+				}
+
 				len = min_t(sector_t,
 					    BB_END(p[prev]) - s, sectors);
 				hint = prev;
@@ -1004,24 +947,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 		goto update_sectors;
 	}
 
-	/* if no space in table, still try to merge in the covered range */
-	if (badblocks_full(bb)) {
-		/* skip the cannot-merge range */
-		if (((prev + 1) < bb->count) &&
-		    overlap_behind(bb, &bad, prev + 1) &&
-		    ((s + sectors) >= BB_END(p[prev + 1]))) {
-			len = BB_END(p[prev + 1]) - s;
-			hint = prev + 1;
-			goto update_sectors;
-		}
-
-		/* no retry any more */
-		len = sectors;
-		space_desired = 1;
-		hint = -1;
-		goto update_sectors;
-	}
-
 	/* cannot merge and there is space in bad table */
 	if ((prev + 1) < bb->count &&
 	    overlap_behind(bb, &bad, prev + 1))
@@ -1049,14 +974,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	 */
 	try_adjacent_combine(bb, prev);
 
-	if (space_desired && !badblocks_full(bb)) {
-		s = orig_start;
-		sectors = orig_len;
-		space_desired = 0;
-		if (retried++ < 3)
-			goto re_insert;
-	}
-
 out:
 	if (added) {
 		set_changed(bb);
-- 
2.39.5



