Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952BD266573;
	Tue,  8 Apr 2025 11:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110690; cv=none; b=o3/uB7JExnPBBnIqvYsfwRv0je7rtGDfT08v+RcuTOByJCzfMkpIs+M7AI7X4jkYf1QqmVcTCLWeSsXegLOjro2d55zbwNuNyty596tbARTL/1ffwElErN5H/EPjVQFBzfDK9/9r2Mpt1xf2K5tkT1SuArNTXNE07as5jGaKGv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110690; c=relaxed/simple;
	bh=/dTa5ue9caC6J1ySHgnV9Zo40jFQ2p4hnIfcOuDjGec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+INeOk8Nn5ca3yQVXDfYXDwslXp2PCO/CHuqtUlDsk+EWKETjG2fjeSPnJMO7vEVfjKyO0/Kx91cRs2dmY3FtpMaFIgqTTrZ5DZeB59YdiKCOWlID4Dq0PlXK+b8UbM+Nf/fhMzlc5oVk5Wer7ydLlCbZlgZRNuo8Xz1Ez1pd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDKpYjcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDKpYjcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43A0C4CEE5;
	Tue,  8 Apr 2025 11:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110690;
	bh=/dTa5ue9caC6J1ySHgnV9Zo40jFQ2p4hnIfcOuDjGec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDKpYjcqL1RHfFQkso4rzdHojAQ6swkv5IhYNQ5R+7tq9y5cCJLo2BhLdVwHWnz87
	 NiTIQ7ffjcc9j9xO5M2EdxMX58MdI+6O8ePOxZuKa2x5+mTm6TmtL0Dv165Rw0CFyw
	 G7MsSLV8D3+j/IYdzCQsQPnYcVhLmDiBEFUGF9t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 156/731] badblocks: fix missing bad blocks on retry in _badblocks_check()
Date: Tue,  8 Apr 2025 12:40:53 +0200
Message-ID: <20250408104917.904348292@linuxfoundation.org>
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

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 5236f041fa6c81c71eabad44897e54a0d6d5bbf6 ]

The bad blocks check would miss bad blocks when retrying under contention,
as checking parameters are not reset. These stale values from the previous
attempt could lead to incorrect scanning in the subsequent retry.

Move seqlock to outer function and reinitialize checking state for each
retry. This ensures a clean state for each check attempt, preventing any
missed bad blocks.

Fixes: 3ea3354cb9f0 ("badblocks: improve badblocks_check() for multiple ranges handling")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/r/20250227075507.151331-10-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c | 50 +++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 52206a42191da..f84a35d683b1f 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -1195,31 +1195,12 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 			    sector_t *first_bad, int *bad_sectors)
 {
-	int unacked_badblocks, acked_badblocks;
 	int prev = -1, hint = -1, set = 0;
 	struct badblocks_context bad;
-	unsigned int seq;
+	int unacked_badblocks = 0;
+	int acked_badblocks = 0;
+	u64 *p = bb->page;
 	int len, rv;
-	u64 *p;
-
-	WARN_ON(bb->shift < 0 || sectors == 0);
-
-	if (bb->shift > 0) {
-		sector_t target;
-
-		/* round the start down, and the end up */
-		target = s + sectors;
-		rounddown(s, 1 << bb->shift);
-		roundup(target, 1 << bb->shift);
-		sectors = target - s;
-	}
-
-retry:
-	seq = read_seqbegin(&bb->lock);
-
-	p = bb->page;
-	unacked_badblocks = 0;
-	acked_badblocks = 0;
 
 re_check:
 	bad.start = s;
@@ -1285,9 +1266,6 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 	else
 		rv = 0;
 
-	if (read_seqretry(&bb->lock, seq))
-		goto retry;
-
 	return rv;
 }
 
@@ -1328,7 +1306,27 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 			sector_t *first_bad, int *bad_sectors)
 {
-	return _badblocks_check(bb, s, sectors, first_bad, bad_sectors);
+	unsigned int seq;
+	int rv;
+
+	WARN_ON(bb->shift < 0 || sectors == 0);
+
+	if (bb->shift > 0) {
+		/* round the start down, and the end up */
+		sector_t target = s + sectors;
+
+		rounddown(s, 1 << bb->shift);
+		roundup(target, 1 << bb->shift);
+		sectors = target - s;
+	}
+
+retry:
+	seq = read_seqbegin(&bb->lock);
+	rv = _badblocks_check(bb, s, sectors, first_bad, bad_sectors);
+	if (read_seqretry(&bb->lock, seq))
+		goto retry;
+
+	return rv;
 }
 EXPORT_SYMBOL_GPL(badblocks_check);
 
-- 
2.39.5



