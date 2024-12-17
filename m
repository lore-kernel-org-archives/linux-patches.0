Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279541F76BC;
	Tue, 17 Dec 2024 17:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455412; cv=none; b=XfoT79yl7kAWKTD6pTKGK8jtn1cuuD/Sn1wVMVYBED4YydPegpQ9d3goSvxNfhJ1xXxL5Qc0Mik4FhaXSbFKCZ1rB03l7YYYU0oXA1cyjiOCgN8I6qbprqH6Nz/ygylwS5gV6aGGC2pqoShFJEyhOZMmt3E9gsS3hCqFWwlkpMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455412; c=relaxed/simple;
	bh=elGTsfMEDWpDJ17t6/2pYCl5722U4uYwVzPxWI+S6qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZhOIpyZ4BV21O73wwC4W6HYbZaP4Wci94gWItAMFKNqqcqnbr60/vGpsK8IQ/Q0dH9YlLIKEakXT6QmAnJMlnSVOl/Pqqyl2OweMEEs+TMMXeAPl2CF3KgRCuvbhwFDOP4HNYOiPUjSOgkIjmpNtJ14XP3mXy3BKNl8/9t8YlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osYj290e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osYj290e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614C2C4CED3;
	Tue, 17 Dec 2024 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455411;
	bh=elGTsfMEDWpDJ17t6/2pYCl5722U4uYwVzPxWI+S6qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osYj290ezvE0ArAcR0XJLi8/r82n/DbpUkdBLG5KZfQ9EtMrTl4DKTixQSjJcwqNj
	 h079/OUHne2BwYjUE6U3YQjdWpAxJ28oQqva/bqDfA4CFZNFJZVSeMK1rEzxDAx8vq
	 UTuDmvAb9UQxS9y+Z4GcZWoKibyeSn1bf/9L4ci4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Dan Schatzberg <dschatzberg@fb.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/24] blk-iocost: fix weight updates of inner active iocgs
Date: Tue, 17 Dec 2024 18:07:17 +0100
Message-ID: <20241217170519.790791205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit e9f4eee9a0023ba22db9560d4cc6ee63f933dae8 ]

When the weight of an active iocg is updated, weight_updated() is called
which in turn calls __propagate_weights() to update the active and inuse
weights so that the effective hierarchical weights are update accordingly.

The current implementation is incorrect for inner active nodes. For an
active leaf iocg, inuse can be any value between 1 and active and the
difference represents how much the iocg is donating. When weight is updated,
as long as inuse is clamped between 1 and the new weight, we're alright and
this is what __propagate_weights() currently implements.

However, that's not how an active inner node's inuse is set. An inner node's
inuse is solely determined by the ratio between the sums of inuse's and
active's of its children - ie. they're results of propagating the leaves'
active and inuse weights upwards. __propagate_weights() incorrectly applies
the same clamping as for a leaf when an active inner node's weight is
updated. Consider a hierarchy which looks like the following with saturating
workloads in AA and BB.

     R
   /   \
  A     B
  |     |
 AA     BB

1. For both A and B, active=100, inuse=100, hwa=0.5, hwi=0.5.

2. echo 200 > A/io.weight

3. __propagate_weights() update A's active to 200 and leave inuse at 100 as
   it's already between 1 and the new active, making A:active=200,
   A:inuse=100. As R's active_sum is updated along with A's active,
   A:hwa=2/3, B:hwa=1/3. However, because the inuses didn't change, the
   hwi's remain unchanged at 0.5.

4. The weight of A is now twice that of B but AA and BB still have the same
   hwi of 0.5 and thus are doing the same amount of IOs.

Fix it by making __propgate_weights() always calculate the inuse of an
active inner iocg based on the ratio of child_inuse_sum to child_active_sum.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dan Schatzberg <dschatzberg@fb.com>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org # v5.4+
Link: https://lore.kernel.org/r/YJsxnLZV1MnBcqjj@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 57e420c84f9a ("blk-iocost: Avoid using clamp() on inuse in __propagate_weights()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 75eb90b3241e..1acd96c9d5c0 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -907,7 +907,17 @@ static void __propagate_active_weight(struct ioc_gq *iocg, u32 active, u32 inuse
 
 	lockdep_assert_held(&ioc->lock);
 
-	inuse = clamp_t(u32, inuse, 1, active);
+	/*
+	 * For an active leaf node, its inuse shouldn't be zero or exceed
+	 * @active. An active internal node's inuse is solely determined by the
+	 * inuse to active ratio of its children regardless of @inuse.
+	 */
+	if (list_empty(&iocg->active_list) && iocg->child_active_sum) {
+		inuse = DIV64_U64_ROUND_UP(active * iocg->child_inuse_sum,
+					   iocg->child_active_sum);
+	} else {
+		inuse = clamp_t(u32, inuse, 1, active);
+	}
 
 	if (active == iocg->active && inuse == iocg->inuse)
 		return;
@@ -920,7 +930,7 @@ static void __propagate_active_weight(struct ioc_gq *iocg, u32 active, u32 inuse
 		/* update the level sums */
 		parent->child_active_sum += (s32)(active - child->active);
 		parent->child_inuse_sum += (s32)(inuse - child->inuse);
-		/* apply the udpates */
+		/* apply the updates */
 		child->active = active;
 		child->inuse = inuse;
 
-- 
2.39.5



