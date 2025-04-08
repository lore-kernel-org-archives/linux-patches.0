Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BDE374C4;
	Tue,  8 Apr 2025 11:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110671; cv=none; b=ZAUhNhUr3jvfHd0NtWDGtxrP6M13Cd0ZZkN464V7P9KOKk5zHrM9LFjYxqVQScCq2f94qycoURqALnA+/PVEqhwj9XHFW9S3jDCYZOhh+atab9icHJ7X9pcrYP99wNagbbatHcBeTyXSgJfP/IIPp4NgCbK5jGIb2DWrucu4H5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110671; c=relaxed/simple;
	bh=6KnTq2QhFGlamNOtc3JfbQYi6ecvfSaN8MTmZJqa31s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMoodxz2zPYy07vgR2QqlBifiTK8JwjAEXzOX3uT7MOdWw4Xgq6c/p6qib9HaILinfDYHsVD4APpRW2Ym9LCMSA/o4hnZixTmxIQglNZdeXYxnIQiQ6tUeSlnjJYjF7ECV7q1tAyctEYZ1k35GfM94HoovEHCJLigPIvYAqmFPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttbX/uS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttbX/uS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03942C4CEE5;
	Tue,  8 Apr 2025 11:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110671;
	bh=6KnTq2QhFGlamNOtc3JfbQYi6ecvfSaN8MTmZJqa31s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttbX/uS4aG7NJTZAsU2C+5enRQRfqSK1f5UXxnH6JWUsD2rmXSEqzZBLJNEyS9lh/
	 NumwnqDXrxBPz+VzsNSeXa9UWP80nSwx2uTcgRvR6LxTq70LYBX4WcLTA6SyjInWJm
	 dijdLPhL8l2ZT/LyT8bed8NkhgV/9YeEMjPWQpOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 150/731] badblocks: factor out a helper try_adjacent_combine
Date: Tue,  8 Apr 2025 12:40:47 +0200
Message-ID: <20250408104917.764399876@linuxfoundation.org>
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

[ Upstream commit 270b68fee9688428e0a98d4a2c3e6d4c434a84ba ]

Factor out try_adjacent_combine(), and it will be used in the later patch.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250227075507.151331-3-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 32e9ad4d11f6 ("badblocks: attempt to merge adjacent badblocks during ack_all_badblocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index bcee057efc476..f069c93e986df 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -855,6 +855,31 @@ static void badblocks_update_acked(struct badblocks *bb)
 		bb->unacked_exist = 0;
 }
 
+/*
+ * Return 'true' if the range indicated by 'bad' is exactly backward
+ * overlapped with the bad range (from bad table) indexed by 'behind'.
+ */
+static bool try_adjacent_combine(struct badblocks *bb, int prev)
+{
+	u64 *p = bb->page;
+
+	if (prev >= 0 && (prev + 1) < bb->count &&
+	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
+	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
+	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
+		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
+				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
+				  BB_ACK(p[prev]));
+
+		if ((prev + 2) < bb->count)
+			memmove(p + prev + 1, p + prev + 2,
+				(bb->count -  (prev + 2)) * 8);
+		bb->count--;
+		return true;
+	}
+	return false;
+}
+
 /* Do exact work to set bad block range into the bad block table */
 static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			  int acknowledged)
@@ -1022,20 +1047,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	 * merged. (prev < 0) condition is not handled here,
 	 * because it's already complicated enough.
 	 */
-	if (prev >= 0 &&
-	    (prev + 1) < bb->count &&
-	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
-	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
-	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
-		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
-				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
-				  BB_ACK(p[prev]));
-
-		if ((prev + 2) < bb->count)
-			memmove(p + prev + 1, p + prev + 2,
-				(bb->count -  (prev + 2)) * 8);
-		bb->count--;
-	}
+	try_adjacent_combine(bb, prev);
 
 	if (space_desired && !badblocks_full(bb)) {
 		s = orig_start;
-- 
2.39.5



