Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E36283121;
	Fri,  8 Aug 2025 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754667084; cv=none; b=CNJW98i7qZuh0EnqV1uZbBSt+AcuKDHEJX0q8HJrLEn4llCY9dTItRbNlBOz846NpLA1Y/oCnjnKGc+yhFo+qejpSHrWyW4mhyB/x/AQFCLOeff/jmO/zBYHyVN7BnC6J2h1dlBgN5kLIsTz8Fny2GzSHzBSXe2Qj7piqcwQb+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754667084; c=relaxed/simple;
	bh=Y11vxnZnErMKWzi90S2/AaTrg5r1Cx7XqGqGKWBX9zI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R6HRT3DYgku7WT0iHO5Aa4uA1fmUUnT31d+7jBH5GUX6SthBUh+IE93Uqvnz12SiHTLQjULpq+l4sZxoDI0d/ObYAw+QcqYy0ZV77ochSnzDNEoTsa4XAQbuvmXbLXZLyNeog8cIPxsiKzWIVVooaFxaXUWBpRRp4zzx/yilHYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWRULHsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWRULHsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F9CC4CEF6;
	Fri,  8 Aug 2025 15:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754667084;
	bh=Y11vxnZnErMKWzi90S2/AaTrg5r1Cx7XqGqGKWBX9zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWRULHsD7ej2ZTeHg1bnb/sC+rv7iuwQhsW3RMZbLQweaIDMZoUnaQT1AGC6P1wKV
	 01f8uRoD1fz+i//Hf1n39r28xqsMvLueKdoDn9TxWMpg4H57G9+41T7vBtz0mNm0VR
	 W/227MzSvNFJUWo6NPeFAgsKyoJuz71EpwaOO00V3P3ydc7Y+AG32CgAHje+4lNcbz
	 j0Ylzd3ZgQ36ZbX9qLC58YdKJdxoFkxcezvNo65ANXwY0ggjN1nkHMtsacQBxST3rY
	 v3um21lH+aYPR3Ibyp9yllBDgcogMV9Qh8RPxk38gGGQX1aM7ROnN3Tp8VwYAFp3Nr
	 3jNNOADYVT4FQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.16-6.1] dm-table: fix checking for rq stackable devices
Date: Fri,  8 Aug 2025 11:30:53 -0400
Message-Id: <20250808153054.1250675-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808153054.1250675-1-sashal@kernel.org>
References: <20250808153054.1250675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 8ca719b81987be690f197e82fdb030580c0a07f3 ]

Due to the semantics of iterate_devices(), the current code allows a
request-based dm table as long as it includes one request-stackable
device. It is supposed to only allow tables where there are no
non-request-stackable devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the code context, here's my
assessment:

**Backport Status: YES**

This commit fixes a clear logic bug in the device mapper table
validation code that could lead to incorrect device stacking
configurations. Here's the detailed analysis:

**1. The Bug:**
The original code had inverted logic when checking if devices are
request-stackable:
- The function `device_is_rq_stackable()` returned `true` (non-zero) for
  stackable devices
- But `iterate_devices()` stops iteration on non-zero returns and
  returns that non-zero value
- The check `!ti->type->iterate_devices(ti, device_is_rq_stackable,
  NULL)` would pass if ANY device returned true (stackable), not if ALL
  devices were stackable

**2. The Fix:**
- Renamed function to `device_is_not_rq_stackable()` to clarify its
  purpose
- Inverted the return values: returns `true` for non-stackable devices
- Changed the logic check to `ti->type->iterate_devices(ti,
  device_is_not_rq_stackable, NULL)` without negation
- Now correctly fails if ANY device is not stackable

**3. Why This Should Be Backported:**

a) **Fixes a real bug**: The current code allows invalid device stacking
configurations where request-based DM tables could include non-request-
stackable devices, potentially leading to:
   - Data corruption
   - System crashes
   - I/O failures

b) **Small and contained fix**: The change is minimal (4 lines changed)
and only affects the validation logic without changing any core
functionality

c) **Clear semantics**: The fix makes the code's intent clearer by
renaming the function to match what it actually checks

d) **No architectural changes**: This is purely a bug fix that corrects
validation logic

e) **Critical subsystem**: Device mapper is a critical component used in
production environments for LVM, encryption, and other storage features

f) **Follows stable rules**: This is exactly the type of fix stable
kernels want - important bug fixes with minimal risk

The commit message clearly explains the bug: "the current code allows a
request-based dm table as long as it includes one request-stackable
device. It is supposed to only allow tables where there are no non-
request-stackable devices." This could lead to serious issues in
production systems using device mapper.

 drivers/md/dm-table.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 24a857ff6d0b..79ba4bacd0f9 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -899,17 +899,17 @@ static bool dm_table_supports_dax(struct dm_table *t,
 	return true;
 }
 
-static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
-				  sector_t start, sector_t len, void *data)
+static int device_is_not_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
+				      sector_t start, sector_t len, void *data)
 {
 	struct block_device *bdev = dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
 
 	/* request-based cannot stack on partitions! */
 	if (bdev_is_partition(bdev))
-		return false;
+		return true;
 
-	return queue_is_mq(q);
+	return !queue_is_mq(q);
 }
 
 static int dm_table_determine_type(struct dm_table *t)
@@ -1005,7 +1005,7 @@ static int dm_table_determine_type(struct dm_table *t)
 
 	/* Non-request-stackable devices can't be used for request-based dm */
 	if (!ti->type->iterate_devices ||
-	    !ti->type->iterate_devices(ti, device_is_rq_stackable, NULL)) {
+	    ti->type->iterate_devices(ti, device_is_not_rq_stackable, NULL)) {
 		DMERR("table load rejected: including non-request-stackable devices");
 		return -EINVAL;
 	}
-- 
2.39.5

