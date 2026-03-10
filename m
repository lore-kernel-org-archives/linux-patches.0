Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CFF2BF3E2;
	Tue, 10 Mar 2026 11:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141150; cv=none; b=OlOAkx5bMe4WvzG6baAslsgyPDEgi2o106gm5tHoNIteS1hwIwUedyaPwEoSgVpfQBvQybKhjAc8pqQ+o9NdlV2p3zugrJNJHN5OHPoEit8UCSorkDbuW0YEv3+14n6PppurVMtXmiHogn5XbmD1uQsS2Juy+fBsA0f3kx44osc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141150; c=relaxed/simple;
	bh=+zMfqGAY3xLqlYjmm7ORAWW4o7686WshFHLsB2IxDx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eV7uYxSPhwC6OlkzcosHIEMgnsJzrXLZPQnDdEJVCsRzh74wJNt5H+h3GcIdD3WklLctirEYpNkf0C0q1KIw1LPUU5O8ZXhwh85mkj3LmzYYP3ZbahSUXblpH3osINwJsEzREIv8tIkVSMiY8xwjqMoQQRZt+nQIXTGRrOZ6F9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sUAPmUm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sUAPmUm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28982C19423;
	Tue, 10 Mar 2026 11:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141149;
	bh=+zMfqGAY3xLqlYjmm7ORAWW4o7686WshFHLsB2IxDx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUAPmUm90ukopPWudJCI80vVw2V80ILFY4MObCQpTBGh5K8+xw0+h4Xcr83deyjre
	 IimuC8bVEDxvliFOvlffk4Q1T9c2jGyfLUiqVkYotmhjt55h1Bddgs20IKKlyQULqx
	 zJmwjR1SaLBoqvjF6lTMHkOG8gPVNF+acNohvazeHYtihCoRSKhJuQaTPlbfh3nMiD
	 FwxMWetjD+3UIYP2NPXy3IEMJqlnq2gJ2z9/UNMmUmb+h4hDhmPNGGT/mJZkR98JMM
	 HRgStHldG0xmqa/9suzYo1oKs8s+SAOGglz1dB+qFteMaInTw7u83YTs68Nx483cT0
	 4sEm5XP7nuQoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 152/311] drbd: fix "LOGIC BUG" in drbd_al_begin_io_nonblock()
Date: Tue, 10 Mar 2026 07:03:19 -0400
Message-ID: <24f935b8ebf3f797b22b083df069f298f0ab8faa.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lars Ellenberg <lars.ellenberg@linbit.com>

commit ab140365fb62c0bdab22b2f516aff563b2559e3b upstream.

Even though we check that we "should" be able to do lc_get_cumulative()
while holding the device->al_lock spinlock, it may still fail,
if some other code path decided to do lc_try_lock() with bad timing.

If that happened, we logged "LOGIC BUG for enr=...",
but still did not return an error.

The rest of the code now assumed that this request has references
for the relevant activity log extents.

The implcations are that during an active resync, mutual exclusivity of
resync versus application IO is not guaranteed. And a potential crash
at this point may not realizs that these extents could have been target
of in-flight IO and would need to be resynced just in case.

Also, once the request completes, it will give up activity log references it
does not even hold, which will trigger a BUG_ON(refcnt == 0) in lc_put().

Fix:

Do not crash the kernel for a condition that is harmless during normal
operation: also catch "e->refcnt == 0", not only "e == NULL"
when being noisy about "al_complete_io() called on inactive extent %u\n".

And do not try to be smart and "guess" whether something will work, then
be surprised when it does not.
Deal with the fact that it may or may not work.  If it does not, remember a
possible "partially in activity log" state (only possible for requests that
cross extent boundaries), and return an error code from
drbd_al_begin_io_nonblock().

A latter call for the same request will then resume from where we left off.

Cc: stable@vger.kernel.org
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_actlog.c   | 53 +++++++++++++-----------------
 drivers/block/drbd/drbd_interval.h |  5 ++-
 2 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 742b2908ff686..b3dbf6c76e98f 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -483,38 +483,20 @@ void drbd_al_begin_io(struct drbd_device *device, struct drbd_interval *i)
 
 int drbd_al_begin_io_nonblock(struct drbd_device *device, struct drbd_interval *i)
 {
-	struct lru_cache *al = device->act_log;
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
 	unsigned first = i->sector >> (AL_EXTENT_SHIFT-9);
 	unsigned last = i->size == 0 ? first : (i->sector + (i->size >> 9) - 1) >> (AL_EXTENT_SHIFT-9);
-	unsigned nr_al_extents;
-	unsigned available_update_slots;
 	unsigned enr;
 
-	D_ASSERT(device, first <= last);
-
-	nr_al_extents = 1 + last - first; /* worst case: all touched extends are cold. */
-	available_update_slots = min(al->nr_elements - al->used,
-				al->max_pending_changes - al->pending_changes);
-
-	/* We want all necessary updates for a given request within the same transaction
-	 * We could first check how many updates are *actually* needed,
-	 * and use that instead of the worst-case nr_al_extents */
-	if (available_update_slots < nr_al_extents) {
-		/* Too many activity log extents are currently "hot".
-		 *
-		 * If we have accumulated pending changes already,
-		 * we made progress.
-		 *
-		 * If we cannot get even a single pending change through,
-		 * stop the fast path until we made some progress,
-		 * or requests to "cold" extents could be starved. */
-		if (!al->pending_changes)
-			__set_bit(__LC_STARVING, &device->act_log->flags);
-		return -ENOBUFS;
+	if (i->partially_in_al_next_enr) {
+		D_ASSERT(device, first < i->partially_in_al_next_enr);
+		D_ASSERT(device, last >= i->partially_in_al_next_enr);
+		first = i->partially_in_al_next_enr;
 	}
 
+	D_ASSERT(device, first <= last);
+
 	/* Is resync active in this area? */
 	for (enr = first; enr <= last; enr++) {
 		struct lc_element *tmp;
@@ -529,14 +511,21 @@ int drbd_al_begin_io_nonblock(struct drbd_device *device, struct drbd_interval *
 		}
 	}
 
-	/* Checkout the refcounts.
-	 * Given that we checked for available elements and update slots above,
-	 * this has to be successful. */
+	/* Try to checkout the refcounts. */
 	for (enr = first; enr <= last; enr++) {
 		struct lc_element *al_ext;
 		al_ext = lc_get_cumulative(device->act_log, enr);
-		if (!al_ext)
-			drbd_info(device, "LOGIC BUG for enr=%u\n", enr);
+
+		if (!al_ext) {
+			/* Did not work. We may have exhausted the possible
+			 * changes per transaction. Or raced with someone
+			 * "locking" it against changes.
+			 * Remember where to continue from.
+			 */
+			if (enr > first)
+				i->partially_in_al_next_enr = enr;
+			return -ENOBUFS;
+		}
 	}
 	return 0;
 }
@@ -556,7 +545,11 @@ void drbd_al_complete_io(struct drbd_device *device, struct drbd_interval *i)
 
 	for (enr = first; enr <= last; enr++) {
 		extent = lc_find(device->act_log, enr);
-		if (!extent) {
+		/* Yes, this masks a bug elsewhere.  However, during normal
+		 * operation this is harmless, so no need to crash the kernel
+		 * by the BUG_ON(refcount == 0) in lc_put().
+		 */
+		if (!extent || extent->refcnt == 0) {
 			drbd_err(device, "al_complete_io() called on inactive extent %u\n", enr);
 			continue;
 		}
diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
index 366489b72fe97..5d3213b81eede 100644
--- a/drivers/block/drbd/drbd_interval.h
+++ b/drivers/block/drbd/drbd_interval.h
@@ -8,12 +8,15 @@
 struct drbd_interval {
 	struct rb_node rb;
 	sector_t sector;		/* start sector of the interval */
-	unsigned int size;		/* size in bytes */
 	sector_t end;			/* highest interval end in subtree */
+	unsigned int size;		/* size in bytes */
 	unsigned int local:1		/* local or remote request? */;
 	unsigned int waiting:1;		/* someone is waiting for completion */
 	unsigned int completed:1;	/* this has been completed already;
 					 * ignore for conflict detection */
+
+	/* to resume a partially successful drbd_al_begin_io_nonblock(); */
+	unsigned int partially_in_al_next_enr;
 };
 
 static inline void drbd_clear_interval(struct drbd_interval *i)
-- 
2.51.0

