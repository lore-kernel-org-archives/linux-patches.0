Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D22D389108;
	Tue, 10 Mar 2026 11:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142054; cv=none; b=YyKEHa2WFIoAWUF/uGmiGqvwLKvQXCV00XtyOmwWuHLjJy6uPDiaLdmTskbGSLgeZ3KqdgN6FYX3MBEQCIsM2LNcONYkAklKN93XoE7dSQaZFGxWx8GWFVn1PDb46JDnwMwcztFEKOE4VsH85b9GUocOcdzhH1XkkeZcXa8GXG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142054; c=relaxed/simple;
	bh=+zMfqGAY3xLqlYjmm7ORAWW4o7686WshFHLsB2IxDx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U9/mwHZJFlmA4Sm7VIjZ7FEymH4gbwDPqkpxqeIxORQrp5x51XEo+iUPQEQbQCZ5COHyAcP/Wtdy5E1oeazuKKVkLWOdSD/Ei86vbVI2Fqhvjb5pivWzFHMbrAR/uYpOkPKyRgGHon4jkNpH5yyh+QGtbDYH6ybyYLADyBul0js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyMDh7Cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyMDh7Cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B483C2BC86;
	Tue, 10 Mar 2026 11:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142054;
	bh=+zMfqGAY3xLqlYjmm7ORAWW4o7686WshFHLsB2IxDx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyMDh7CuIIqhaF+UlCEVgBbapPo5ZKWUpkpig0wbZFoil6jRuUKUOP44rLckL2+Qz
	 JcAL9izci3MmzXr5tlorxcWTJSysQplyqRDLzOBLEaI3jyRVYHufSywZWPuk3o1h7u
	 mEC/SasPqGSTdRzcP4EAP1sYjAvap/TpcybqemR3ShnkmoJPy6avyTrg69gXBaQhof
	 hatybZPmcRzbkucitJP2MbMDfuDA3KhmOf4T1BzX9G0c09cH1RQJ+BUKlvXQz38mIo
	 oo0lCSREQGPbm2yCEk1Du7QVlLEmSE9p553JAnvKMDptPsDFw4BEOKRXQsBDoVaeGs
	 r9dGJlhHR5SAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 180/314] drbd: fix "LOGIC BUG" in drbd_al_begin_io_nonblock()
Date: Tue, 10 Mar 2026 07:17:19 -0400
Message-ID: <3d6be746fbe07932793297400d81ed8326c357e8.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

