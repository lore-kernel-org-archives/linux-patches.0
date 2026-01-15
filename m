Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA2A258EC2;
	Thu, 15 Jan 2026 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497630; cv=none; b=ZV8RbRIfcO2Q1HADDYIgM3JCFcWDg6ZU2o3z29fEUUED9d1azkjij49PUbYfrDMz0YPFtmlzPRPZmBsBoh0Zo10wLAPubWaReIDEAIs9jO8y/XUuNSSQSIxeheVi3jrF3uc98Lk6KC7Y5ae4tzaJRtnumCLGQjcytPrREiGyHPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497630; c=relaxed/simple;
	bh=QEvX4oXcL9x4EDpMsSwsft4+yEbcx++dsbtjO1AvqvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3SI7OBQwwg8yhtnaWyQn4J0U/sc2lvjCCTetkJR8LWMa7WtdXFwtFOUolhlq192DKLyn4Uk84Y9Vsm0TEktWvIzwi0vg5x7OSW556WCn8jwCguIN8gNJY4wFX3OB2hf7jY/2HeVQtLfatBWXKQrC3uX9HA8q/rToSrZ/rZrtWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsb5Ayuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsb5Ayuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762E2C116D0;
	Thu, 15 Jan 2026 17:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497629;
	bh=QEvX4oXcL9x4EDpMsSwsft4+yEbcx++dsbtjO1AvqvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsb5AyuhmJMztV7WpE8xTHpV/Z8s8kFcJWtKtG3ln+czDs/rae8Llf1Az+/K2biys
	 tiobVdMrQs9pydOdxcqBnnG9E4wJVplyP7QYqG6Zdljf3CarOMx/cezInj5tTW5JUc
	 HIzgdus9s6QdFA8CO3xITv9JyEQ093VPD2WRAmJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/554] ext4: improve integrity checking in __mb_check_buddy by enhancing order-0 validation
Date: Thu, 15 Jan 2026 17:43:35 +0100
Message-ID: <20260115164251.652623015@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 93ff3220511e7..702a3229c39b0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -663,6 +663,24 @@ do {									\
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
@@ -707,15 +725,6 @@ static void __mb_check_buddy(struct ext4_buddy *e4b, char *file,
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
@@ -731,15 +740,21 @@ static void __mb_check_buddy(struct ext4_buddy *e4b, char *file,
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



