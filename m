Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AF034214A;
	Tue,  5 May 2026 09:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974772; cv=none; b=I9+qX7K3caTdIVQzwJ11wCNWZVexGoBiclcBBk/Kw3EbguOlYJFHFD83RcyndSngsrZzaq4MKSZMHQX5t3eGeHQzhCLLxHsvAqPC8lorX8ZyGLhtQKyHnFgX10/JaSX7D4AyoK8/cRiX7YixNRsOipk8bkfRZli1lYpAZf4hcpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974772; c=relaxed/simple;
	bh=xWUVlSEXrrQTdEkyahofVZTTn5RdBOnBaLZeQTBm4uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KuOS5jV2GgIZ6LuJ/hCSmfzE7blXRWEyM8JUO5Qkhak1S/zrs85C9G8eCJIwiQBRxufPgQB5Yojhe8rj0l7DV+ChGny9DONEWnqd1EdRKi7XnBDeuqOeHCU18ec6IrTOO8BZsCz+KRg8F9R/yqDRqiimoA+GVozxor7vzPTQICU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQKpCN2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQKpCN2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B172C2BCB9;
	Tue,  5 May 2026 09:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974771;
	bh=xWUVlSEXrrQTdEkyahofVZTTn5RdBOnBaLZeQTBm4uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQKpCN2qd3LMK5zFywiwy5yB71eO2EMwtehHJ4QsiuX/g03PPqDjNBPIvVgY6J8Cx
	 2y/F2xye6gSboL0aba7WsCHWibbl+v86jfM92BT7BSbxbftXFX3gyLKLZ1nq+vAWXA
	 //9bDCD7B8pBp8Zjkz+T/Dxt8aZwa/thhtgd+EO2lDkPpGAzImScbmCkf2ASxqjzeA
	 pO2D406jFn6rUla9FXkY5FhyPngMFXVKcHlcaXVYMDdMOMoHPXtNgQGg56cmA0X0p7
	 F5/u3vqdOo5LVeRzkeoD6HXi+VJBuUwG3UfMP4kmSknJObUv0quiXYP7a9CbWd2C5k
	 VkSMuNcuudTDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] md/raid5: Fix UAF on IO across the reshape position
Date: Tue,  5 May 2026 05:51:35 -0400
Message-ID: <20260505095149.512052-19-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 418b3e64e4459feb3f75979de9ec89e085745343 ]

If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
raid5_make_request() will free the cloned bio. But raid5_make_request()
can call make_stripe_request() multiple times, writing to the various
stripes. If that bio got added to the toread or towrite lists of a
stripe disk in an earlier call to make_stripe_request(), then it's not
safe to just free the bio if a later part of it is found to cross the
reshape position. Doing so can lead to a UAF error, when bio_endio()
is called on the bio for the earlier stripes.

Instead, raid5_make_request() needs to wait until all parts of the bio
have called bio_endio(). To do this, bios that cross the reshape
position while the reshape can't make progress are flagged as needing to
wait for all parts to complete. When raid5_make_request() has a bio that
failed make_stripe_request() with STRIPE_WAIT_RESHAPE, it sets
bi->bi_private to a completion struct and waits for completion after
ending the bio.  When the bio_endio() is called for the last time on a
clone bio with bi->bi_private set, it wakes up the waiter. This
guarantees that raid5_make_request() doesn't return until the cloned bio
needing a retry for io across the reshape boundary is safely cleaned up.

There is a simple reproducer available at [1]. Compile the kernel with
KASAN for more useful reporting when the error is triggered (this is not
necessary to see the bug).

[1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa5

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/r/20260408043548.1695157-1-bmarzins@redhat.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
1. Commit message forensics
Record: subsystem `md/raid5`; action verb `Fix`; intent is to prevent a
use-after-free when RAID5 IO crosses a reshape position and
`make_stripe_request()` returns `STRIPE_WAIT_RESHAPE`. Tags found:
`Signed-off-by: Benjamin Marzinski`, `Reviewed-by: Xiao Ni`, lore
`Link`, `Signed-off-by: Yu Kuai`; no `Fixes:`, `Reported-by:`, `Tested-
by`, or `Cc: stable`. Body describes a real UAF, a KASAN-aided
reproducer, and the root cause: a cloned bio can already be linked into
earlier stripe `toread`/`towrite` lists when a later stripe path frees
it.

2. Diff analysis
Record: 3 files, `14 insertions/25 deletions`; functions changed are
`md_end_clone_io()`, `md_clone_bio()`, removed `md_free_cloned_bio()`,
and `raid5_make_request()`. Before: `STRIPE_WAIT_RESHAPE` directly
called `md_free_cloned_bio(bi)`. After: it sets `bi_private` to a stack
completion, calls `bio_endio(bi)`, and waits until the cloned bio’s
final endio completes. Bug category: memory safety/UAF, caused by
freeing a clone still referenced by stripe bio chains. Fix is small and
contained.

3. Git history investigation
Record: upstream commit is `418b3e64e4459`. Blame shows the problematic
`STRIPE_WAIT_RESHAPE`/`md_free_cloned_bio()` path came from
`41425f96d7aa` (`dm-raid456, md/raid456: fix a deadlock...`), first
contained in `v6.9-rc1`/`v6.9`. That introducing commit was itself
stable-marked for `v6.7+` and is present in checked stable branches
`6.12.y`, `6.18.y`, `6.19.y`, and `7.0.y`; the specific buggy
helper/path was not found in `6.6.y` or `6.1.y`. No `Fixes:` tag exists,
so blame was used instead.

4. Mailing list and external research
Record: `b4 dig -c 418b3e64e4459` found `[PATCH v2]` at
`https://patch.msgid.link/20260408043548.1695157-1-bmarzins@redhat.com`.
`b4 dig -a` found v1 RFC and v2; committed patch matches v2. `b4 dig -w`
shows `linux-raid`, `dm-devel`, Song Liu, Yu Kuai, Li Nan, Xiao Ni, and
Red Hat participants were included. Thread review: Xiao Ni gave
`Reviewed-by`; Yu Kuai replied “Applied.” Reviewer asked about
`WRITE_ONCE`; author explained it was unnecessary but harmless on the
slow path, and Xiao accepted keeping it. No NAKs found. WebFetch for
lore was blocked by Anubis, but b4 retrieved the mbox. The gist
reproducer uses dmsetup/LVM RAID5 reshape loops.

5. Code semantic analysis
Record: `md_submit_bio()` reaches `md_handle_request()`, which calls the
RAID personality `.make_request = raid5_make_request` for RAID4/5/6.
`raid5_make_request()` calls `make_stripe_request()` repeatedly over
stripe bits. `add_all_stripe_bios()` calls `__add_stripe_bio()`, which
links the cloned bio into `toread`/`towrite` and calls
`bio_inc_remaining()`. `bio_endio()` only invokes `bi_end_io` after
`__bi_remaining` reaches zero, so the completion wait correctly waits
for all earlier stripe references to drain.

6. Stable tree analysis
Record: buggy code exists in `stable/linux-7.0.y`, `6.19.y`, `6.18.y`,
and `6.12.y`; not in checked `6.6.y`/`6.1.y`. Patch applies cleanly to
current `7.0.y` with `git apply --check`. Direct upstream patch does not
apply cleanly to `6.19.y` and `6.12.y` because nearby context differs
(`ctx` allocation/field access and older bitmap helpers), but the same
core code is present, so a small backport adjustment is needed.

7. Subsystem context
Record: subsystem is software RAID / MD, `drivers/md`; MAINTAINERS lists
Song Liu and Yu Kuai as maintainers and `linux-raid@vger.kernel.org` as
the list. Criticality: important storage subsystem, with data
availability and kernel memory-safety impact during RAID reshape.
Activity level is high; recent logs show multiple md/raid fixes and
refactors.

8. Impact and risk assessment
Record: affected users are md/dm RAID4/5/6 users doing IO while reshape
is blocked/interrupted. Trigger is specialized but real; reproducer
exists. Admin privileges are generally needed to create/reshape the
array, but ordinary IO can hit the path once the system is in that
state. Failure mode is UAF after freeing a cloned bio still referenced
by stripe lists; severity HIGH/CRITICAL because it can crash or corrupt
memory. Benefit is high for affected stable users; risk is low to
medium: small fix, no API change, but it touches bio completion
semantics in a storage path.

9. Final synthesis
Record: Evidence for backporting: explicit UAF, reproducer, KASAN
usefulness, small contained patch, reviewed by linux-raid reviewer,
applied by md maintainer, buggy code present in active stable trees from
`6.12.y` upward. Evidence against: not applicable to older
`6.6.y`/`6.1.y`; older applicable trees need a manual backport rather
than direct cherry-pick. Stable rules: obviously correct by code
inspection and review; fixes a real serious bug; small and contained; no
new features/APIs; applies cleanly to `7.0.y`, needs minor backport for
older affected branches. Exception categories: none needed.

## Verification
- Phase 1: `git show --format=fuller --stat 418b3e64e4459` verified
  subject, body, tags, reviewer, lore link, and line counts.
- Phase 2: `git show --no-ext-diff 418b3e64e4459` verified exact changes
  to `drivers/md/md.c`, `drivers/md/md.h`, and `drivers/md/raid5.c`.
- Phase 3: `git blame` verified `41425f96d7aa` introduced
  `STRIPE_WAIT_RESHAPE` freeing via `md_free_cloned_bio()`.
- Phase 3: `git describe --contains 41425f96d7aa` and tag checks
  verified first mainline containment around `v6.9`.
- Phase 4: `b4 dig -c/-a/-w/-m 418b3e64e4459` verified v1/v2 series,
  recipients, review, and applied response.
- Phase 4: WebFetch verified the raw gist reproducer content; lore
  WebFetch was blocked by Anubis.
- Phase 5: `rg`/file reads verified call chain, stripe list insertion,
  `bio_inc_remaining()`, and `bio_endio()` final-callback semantics.
- Phase 6: `git grep` verified buggy code in `6.12.y`, `6.18.y`,
  `6.19.y`, and `7.0.y`, absent from checked `6.6.y` and `6.1.y`.
- Phase 6: `git apply --check` verified clean apply to `7.0.y`; worktree
  checks showed direct patch conflicts on `6.19.y` and `6.12.y`.
- Unverified: I did not run the reproducer locally or test a built
  kernel.

This is stable material for affected trees, especially `6.12.y+`, with
backport adjustment where context differs.

**YES**

 drivers/md/md.c    | 31 ++++++++-----------------------
 drivers/md/md.h    |  1 -
 drivers/md/raid5.c |  7 ++++++-
 3 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ce6f9e9d38e6..4318d875a5f63 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9215,9 +9215,11 @@ static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 
 static void md_end_clone_io(struct bio *bio)
 {
-	struct md_io_clone *md_io_clone = bio->bi_private;
+	struct md_io_clone *md_io_clone = container_of(bio, struct md_io_clone,
+						       bio_clone);
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
+	struct completion *reshape_completion = bio->bi_private;
 
 	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
@@ -9229,7 +9231,10 @@ static void md_end_clone_io(struct bio *bio)
 		bio_end_io_acct(orig_bio, md_io_clone->start_time);
 
 	bio_put(bio);
-	bio_endio(orig_bio);
+	if (unlikely(reshape_completion))
+		complete(reshape_completion);
+	else
+		bio_endio(orig_bio);
 	percpu_ref_put(&mddev->active_io);
 }
 
@@ -9254,7 +9259,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	}
 
 	clone->bi_end_io = md_end_clone_io;
-	clone->bi_private = md_io_clone;
+	clone->bi_private = NULL;
 	*bio = clone;
 }
 
@@ -9265,26 +9270,6 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
 }
 EXPORT_SYMBOL_GPL(md_account_bio);
 
-void md_free_cloned_bio(struct bio *bio)
-{
-	struct md_io_clone *md_io_clone = bio->bi_private;
-	struct bio *orig_bio = md_io_clone->orig_bio;
-	struct mddev *mddev = md_io_clone->mddev;
-
-	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
-		md_bitmap_end(mddev, md_io_clone);
-
-	if (bio->bi_status && !orig_bio->bi_status)
-		orig_bio->bi_status = bio->bi_status;
-
-	if (md_io_clone->start_time)
-		bio_end_io_acct(orig_bio, md_io_clone->start_time);
-
-	bio_put(bio);
-	percpu_ref_put(&mddev->active_io);
-}
-EXPORT_SYMBOL_GPL(md_free_cloned_bio);
-
 /* md_allow_write(mddev)
  * Calling this ensures that the array is marked 'active' so that writes
  * may proceed without blocking.  It is important to call this before
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd7..5d57fee22901f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -917,7 +917,6 @@ extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
 void md_account_bio(struct mddev *mddev, struct bio **bio);
-void md_free_cloned_bio(struct bio *bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a8e8d431071ba..dc0c680ca199b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6217,7 +6217,12 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 
 	mempool_free(ctx, conf->ctx_pool);
 	if (res == STRIPE_WAIT_RESHAPE) {
-		md_free_cloned_bio(bi);
+		DECLARE_COMPLETION_ONSTACK(done);
+		WRITE_ONCE(bi->bi_private, &done);
+
+		bio_endio(bi);
+
+		wait_for_completion(&done);
 		return false;
 	}
 
-- 
2.53.0

