Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EA133290A;
	Fri,  9 Jan 2026 11:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959925; cv=none; b=qCYrXcEXOR4Ath6oHc6ye6EcNuOgkj9UsBl3NVsWykrUPXvMJQ/MTf7gJidNAd1DL+r73E/R63YmYte4YklsDa79F29I4YKGs25w1JvWuq54RFlpgvQFx6lbQ00VNmoeMMs0aP+2s/MxDPkcRV+5/cWfrBzeZVkjjpFfoilpT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959925; c=relaxed/simple;
	bh=OyaFcdiOTFkypCbm/4ax+JgXqQ2Or2Qi5Y0i2DF7O+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mC9w0eKJeM8yu4+oz/yYlRnBVlEUPcPN4YkMHQ5JZ7i6ymGXLeTNAaSs9HynHDh7KOro/PmpyRLM0Ui7JiwW4z91sU51U5iz7WcfY2FjX6roLzZfDNBJcAWBiErKjAs/C23qebIC1WD3a984jlBxjQF8OHWaeAcETpmeksKp5lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDgHNkJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDgHNkJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CBEC4CEF1;
	Fri,  9 Jan 2026 11:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959924;
	bh=OyaFcdiOTFkypCbm/4ax+JgXqQ2Or2Qi5Y0i2DF7O+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDgHNkJFdJXPZ70JH6h/P84nyBQFzAAATbg4rNRdN3S8hA1Q4137ociB1f+T9vcB7
	 iaseBcwK4K3b8cU8m6gld9dqgJ+HjpHof+EKsMga2f7Ea/UjCbFx3WNB0W5mCpAaE/
	 fN3Z2sjwgSEIdnewhGrM2lzPebEjO66vY1mWtV3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/737] ext4: improve integrity checking in __mb_check_buddy by enhancing order-0 validation
Date: Fri,  9 Jan 2026 12:36:03 +0100
Message-ID: <20260109112142.428464208@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongjian Sun <sunyongjian1@huawei.com>

[ Upstream commit d9ee3ff810f1cc0e253c9f2b17b668b973cb0e06 ]

When the MB_CHECK_ASSERT macro is enabled, we found that the
current validation logic in __mb_check_buddy has a gap in
detecting certain invalid buddy states, particularly related
to order-0 (bitmap) bits.

The original logic consists of three steps:
1. Validates higher-order buddies: if a higher-order bit is
set, at most one of the two corresponding lower-order bits
may be free; if a higher-order bit is clear, both lower-order
bits must be allocated (and their bitmap bits must be 0).
2. For any set bit in order-0, ensures all corresponding
higher-order bits are not free.
3. Verifies that all preallocated blocks (pa) in the group
have pa_pstart within bounds and their bitmap bits marked as
allocated.

However, this approach fails to properly validate cases where
order-0 bits are incorrectly cleared (0), allowing some invalid
configurations to pass:

               corrupt            integral

order 3           1                  1
order 2       1       1          1       1
order 1     1   1   1   1      1   1   1   1
order 0    0 0 1 1 1 1 1 1    1 1 1 1 1 1 1 1

Here we get two adjacent free blocks at order-0 with inconsistent
higher-order state, and the right one shows the correct scenario.

The root cause is insufficient validation of order-0 zero bits.
To fix this and improve completeness without significant performance
cost, we refine the logic:

1. Maintain the top-down higher-order validation, but we no longer
check the cases where the higher-order bit is 0, as this case will
be covered in step 2.
2. Enhance order-0 checking by examining pairs of bits:
   - If either bit in a pair is set (1), all corresponding
     higher-order bits must not be free.
   - If both bits are clear (0), then exactly one of the
     corresponding higher-order bits must be free
3. Keep the preallocation (pa) validation unchanged.

This change closes the validation gap, ensuring illegal buddy states
involving order-0 are correctly detected, while removing redundant
checks and maintaining efficiency.

Fixes: c9de560ded61f ("ext4: Add multi block allocator for ext4")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Yongjian Sun <sunyongjian1@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251106060614.631382-3-sunyongjian@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 49 +++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9721ae0ff92ed..5304497c60e1f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -676,6 +676,24 @@ do {									\
 	}								\
 } while (0)
 
+/*
+ * Perform buddy integrity check with the following steps:
+ *
+ * 1. Top-down validation (from highest order down to order 1, excluding order-0 bitmap):
+ *    For each pair of adjacent orders, if a higher-order bit is set (indicating a free block),
+ *    at most one of the two corresponding lower-order bits may be clear (free).
+ *
+ * 2. Order-0 (bitmap) validation, performed on bit pairs:
+ *    - If either bit in a pair is set (1, allocated), then all corresponding higher-order bits
+ *      must not be free (0).
+ *    - If both bits in a pair are clear (0, free), then exactly one of the corresponding
+ *      higher-order bits must be free (0).
+ *
+ * 3. Preallocation (pa) list validation:
+ *    For each preallocated block (pa) in the group:
+ *    - Verify that pa_pstart falls within the bounds of this block group.
+ *    - Ensure the corresponding bit(s) in the order-0 bitmap are marked as allocated (1).
+ */
 static void __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 				const char *function, int line)
 {
@@ -717,15 +735,6 @@ static void __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 				continue;
 			}
 
-			/* both bits in buddy2 must be 1 */
-			MB_CHECK_ASSERT(mb_test_bit(i << 1, buddy2));
-			MB_CHECK_ASSERT(mb_test_bit((i << 1) + 1, buddy2));
-
-			for (j = 0; j < (1 << order); j++) {
-				k = (i * (1 << order)) + j;
-				MB_CHECK_ASSERT(
-					!mb_test_bit(k, e4b->bd_bitmap));
-			}
 			count++;
 		}
 		MB_CHECK_ASSERT(e4b->bd_info->bb_counters[order] == count);
@@ -741,15 +750,21 @@ static void __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 				fragments++;
 				fstart = i;
 			}
-			continue;
+		} else {
+			fstart = -1;
 		}
-		fstart = -1;
-		/* check used bits only */
-		for (j = 0; j < e4b->bd_blkbits + 1; j++) {
-			buddy2 = mb_find_buddy(e4b, j, &max2);
-			k = i >> j;
-			MB_CHECK_ASSERT(k < max2);
-			MB_CHECK_ASSERT(mb_test_bit(k, buddy2));
+		if (!(i & 1)) {
+			int in_use, zero_bit_count = 0;
+
+			in_use = mb_test_bit(i, buddy) || mb_test_bit(i + 1, buddy);
+			for (j = 1; j < e4b->bd_blkbits + 2; j++) {
+				buddy2 = mb_find_buddy(e4b, j, &max2);
+				k = i >> j;
+				MB_CHECK_ASSERT(k < max2);
+				if (!mb_test_bit(k, buddy2))
+					zero_bit_count++;
+			}
+			MB_CHECK_ASSERT(zero_bit_count == !in_use);
 		}
 	}
 	MB_CHECK_ASSERT(!EXT4_MB_GRP_NEED_INIT(e4b->bd_info));
-- 
2.51.0



