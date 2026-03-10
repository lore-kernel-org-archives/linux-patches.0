Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4871743CEF0;
	Tue, 10 Mar 2026 09:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133320; cv=none; b=DAOi+K3nFygHrCpIqDigJQ9d8vJRwCgz/wemp2Wy1q4wlD7MnMmPikRFo8gIIJbB2arQvzAA2FN/ulrUrbTupbiWgR7FwxEeoBeHIlzoHF6THD+WyeywmhtgEYJ1U7SlnPp/MQoqnUucL4W+M3InFPQfzP8XLaB+NICEX666xlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133320; c=relaxed/simple;
	bh=ZYzDc+vI/hMkWC6CX1qm1YhK+pw7uB7KPtXG2eIbW0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kqlQ4VJv5J8VTO5dZkXgV1B5A2C86PWguVdHJST+wc9o8KLmtiJkdieXh/NWUvAh3EtQFpwFjUJBH4ZWPxyNvOE5N3831/NuFbFSlj0J8ZdCxZVDn2ysEOU4yDlkYzPstJJFLYDkB/PEMwiR/2EiQ4cfKBcw4x9BkyqDeSWb0lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHReEEsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHReEEsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5133C2BC87;
	Tue, 10 Mar 2026 09:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133319;
	bh=ZYzDc+vI/hMkWC6CX1qm1YhK+pw7uB7KPtXG2eIbW0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHReEEsdXqrkbsZ5oUAG+tr+Y9qoSEL67c1z9+EbFovv+wFXqt77asim+Ev1BxiFR
	 ePyiX3YV+wOsQ0RBGysQv1J+O6pzhCeJsuOTLwN7xXNv6St+/mmCosLz1oKeBcTteW
	 UU/5PmaE3y7KEiMEipvGygcAeQVH1Yt8xKB1qQD0hktEptKAJcTjxb+JQOWNrh3cV0
	 0n6MnQRc+8wwKJK9NC7u6QIr1P8up6yQwroag777aWZS3NgSZ/yDB/6n/RuOgh2/RT
	 pR5VgK5Js1Y33aY17utipHrc4HZSO6LE5Wybf8PnbmtLLCeM888JI+bv0HGOsRqIop
	 ZeVJyH2IlAYnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nilay Shroff <nilay@linux.ibm.com>,
	Yi Zhang <yi.zhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] block: break pcpu_alloc_mutex dependency on freeze_lock
Date: Tue, 10 Mar 2026 05:01:09 -0400
Message-ID: <20260310090145.2709021-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 539d1b47e935e8384977dd7e5cec370c08b7a644 ]

While nr_hw_update allocates tagset tags it acquires ->pcpu_alloc_mutex
after ->freeze_lock is acquired or queue is frozen. This potentially
creates a circular dependency involving ->fs_reclaim if reclaim is
triggered simultaneously in a code path which first acquires ->pcpu_
alloc_mutex. As the queue is already frozen while nr_hw_queue update
allocates tagsets, the reclaim can't forward progress and thus it could
cause a potential deadlock as reported in lockdep splat[1].

Fix this by pre-allocating tagset tags before we freeze queue during
nr_hw_queue update. Later the allocated tagset tags could be safely
installed and used after queue is frozen.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/all/CAHj4cs8F=OV9s3La2kEQ34YndgfZP-B5PHS4Z8_b9euKG6J4mw@mail.gmail.com/ [1]
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
[axboe: fix brace style issue]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me write the analysis.

## Analysis

### What the commit fixes

This commit fixes a **potential deadlock** in the block layer's
`__blk_mq_update_nr_hw_queues()` path. The deadlock involves a circular
lock dependency between:

1. **`freeze_lock`** (held when the queue is frozen)
2. **`pcpu_alloc_mutex`** (acquired internally by `alloc_percpu_gfp()`
   during tag allocation via `sbitmap_init_node()`)
3. **`fs_reclaim`** - if memory reclaim is triggered while
   `pcpu_alloc_mutex` is held, and the queue is frozen, forward progress
   is blocked

The fix pre-allocates tagset tags **before** freezing the queue, then
installs them after freeze. This breaks the circular dependency.

### Bug severity and evidence

- **Lockdep splat**: Reported with a concrete lockdep trace by Yi Zhang
  (Red Hat)
- **Tested-by**: The reporter confirmed the fix works
- **Multiple reviews**: Ming Lei, Yu Kuai, and Jens Axboe (block layer
  maintainer) all reviewed/signed off
- **Block layer core path**: `blk_mq_update_nr_hw_queues()` is called by
  many storage drivers (NVMe, SCSI, etc.) during hardware queue
  reconfiguration
- **Deadlock type**: Not a mere theoretical concern - lockdep actually
  fired, indicating the lock ordering violation is real

### Dependency analysis - CRITICAL ISSUE

The commit's diff is entangled with a **long chain of prerequisite
commits** that heavily restructured `__blk_mq_update_nr_hw_queues()`:

| Commit | Description | First in |
|--------|-------------|----------|
| `596dce110b7d` | simplify elevator reattachment | v6.16-rc1 |
| `2d8951aee844` | unfreeze queue if realloc fails | v6.16-rc1 |
| `5989bfe6ac6b` | restore two stage elevator switch | v6.17-rc1 |
| `04225d13aef1` | fix deadlock (sched_tags outside freeze) | v6.17-rc1
|
| `2d82f3bd8910` | fix lockdep warning | v6.17-rc3 |

The function in **v6.12** (latest stable tree) looks completely
different:
- v6.12: freezes queues first, then calls
  `blk_mq_realloc_tag_set_tags()` inside the frozen state
- v7.0 (this commit): has batch sched allocation, restructured elevator
  switching, new flow

The **underlying bug** (allocating tags with `GFP_KERNEL` while queues
are frozen → `pcpu_alloc_mutex` inside freeze) **exists in all stable
kernels**. In v6.12, `blk_mq_realloc_tag_set_tags()` is called at line
4818, well inside the freeze started at line 4803.

However, this exact patch **will not apply** to any current stable tree
without significant rework due to the restructured function flow (the
`blk_mq_alloc_sched_ctx_batch`, `blk_mq_alloc_sched_res_batch`, and the
new elevator switching pattern all don't exist in stable).

### Scope and risk

- **Files changed**: 1 (block/blk-mq.c)
- **Lines changed**: +30/-15 (net diff), but significant structural
  refactoring of two functions
- **Risk**: Moderate - the core logic is sound and well-reviewed, but a
  backport would require crafting a simpler version for the older code

### Verification

- `git show 539d1b47e935` confirmed the upstream commit exists and
  matches
- `git describe --contains 539d1b47e935` → v7.0-rc3 (very recent)
- `git show v6.12:block/blk-mq.c` verified the v6.12 function structure
  differs significantly (freeze before realloc at line 4803-4818)
- `git describe --contains` for prerequisites confirmed they are all
  v6.16+ or v6.17+ (not in any stable tree)
- `git show v6.12:block/blk-mq.c | sed -n '4474,4510p'` confirmed the
  old `blk_mq_realloc_tag_set_tags` function matches the "before"
  version in the diff
- The lore.kernel.org link in the commit references a real lockdep splat
  report
- Traced the allocation chain: `blk_mq_alloc_map_and_rqs` →
  `sbitmap_queue_init_node` → `alloc_percpu_gfp` → `pcpu_alloc_mutex`
  (verified via agent analysis of sbitmap.c)
- Could NOT verify whether a simplified backport has been prepared
  separately (unverified)

### Decision rationale

This is a real deadlock fix in core block layer infrastructure, reported
with concrete lockdep evidence, well-reviewed, and tested. The bug
affects all stable kernels. Despite the dependency chain making the
exact diff incompatible with current stable trees, the fix warrants
backporting - either via this commit with its prerequisite chain, or via
a simplified targeted backport. The deadlock involves the per-cpu
allocator mutex and queue freeze lock, which can cause system hangs
during NVMe/SCSI hardware reconfiguration events that are common in
production.

**YES**

 block/blk-mq.c | 45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 968699277c3d5..3b58dd5876114 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4778,38 +4778,45 @@ static void blk_mq_update_queue_map(struct blk_mq_tag_set *set)
 	}
 }
 
-static int blk_mq_realloc_tag_set_tags(struct blk_mq_tag_set *set,
-				       int new_nr_hw_queues)
+static struct blk_mq_tags **blk_mq_prealloc_tag_set_tags(
+				struct blk_mq_tag_set *set,
+				int new_nr_hw_queues)
 {
 	struct blk_mq_tags **new_tags;
 	int i;
 
 	if (set->nr_hw_queues >= new_nr_hw_queues)
-		goto done;
+		return NULL;
 
 	new_tags = kcalloc_node(new_nr_hw_queues, sizeof(struct blk_mq_tags *),
 				GFP_KERNEL, set->numa_node);
 	if (!new_tags)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (set->tags)
 		memcpy(new_tags, set->tags, set->nr_hw_queues *
 		       sizeof(*set->tags));
-	kfree(set->tags);
-	set->tags = new_tags;
 
 	for (i = set->nr_hw_queues; i < new_nr_hw_queues; i++) {
-		if (!__blk_mq_alloc_map_and_rqs(set, i)) {
-			while (--i >= set->nr_hw_queues)
-				__blk_mq_free_map_and_rqs(set, i);
-			return -ENOMEM;
+		if (blk_mq_is_shared_tags(set->flags)) {
+			new_tags[i] = set->shared_tags;
+		} else {
+			new_tags[i] = blk_mq_alloc_map_and_rqs(set, i,
+					set->queue_depth);
+			if (!new_tags[i])
+				goto out_unwind;
 		}
 		cond_resched();
 	}
 
-done:
-	set->nr_hw_queues = new_nr_hw_queues;
-	return 0;
+	return new_tags;
+out_unwind:
+	while (--i >= set->nr_hw_queues) {
+		if (!blk_mq_is_shared_tags(set->flags))
+			blk_mq_free_map_and_rqs(set, new_tags[i], i);
+	}
+	kfree(new_tags);
+	return ERR_PTR(-ENOMEM);
 }
 
 /*
@@ -5093,6 +5100,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 	unsigned int memflags;
 	int i;
 	struct xarray elv_tbl;
+	struct blk_mq_tags **new_tags;
 	bool queues_frozen = false;
 
 	lockdep_assert_held(&set->tag_list_lock);
@@ -5127,11 +5135,18 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		if (blk_mq_elv_switch_none(q, &elv_tbl))
 			goto switch_back;
 
+	new_tags = blk_mq_prealloc_tag_set_tags(set, nr_hw_queues);
+	if (IS_ERR(new_tags))
+		goto switch_back;
+
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_freeze_queue_nomemsave(q);
 	queues_frozen = true;
-	if (blk_mq_realloc_tag_set_tags(set, nr_hw_queues) < 0)
-		goto switch_back;
+	if (new_tags) {
+		kfree(set->tags);
+		set->tags = new_tags;
+	}
+	set->nr_hw_queues = nr_hw_queues;
 
 fallback:
 	blk_mq_update_queue_map(set);
-- 
2.51.0

