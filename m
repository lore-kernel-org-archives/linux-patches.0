Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776EC1A76A9;
	Tue, 30 Jul 2024 17:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359985; cv=none; b=AAUyx7Wpd/6eLRlLRo1HLbJCDUuYLzLUu7p2wcXI4fPbmolF69DdjhaUPktfA1fjRc7n7PkYPIvofFd/PA4e7tug2b9nu8FtgGPbYpF0viOAaohLM3kssMYUHzB/ri5Onehb/0k7S/voe7zndzUEPAaPyioJ57tt5AbsMkb8Hro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359985; c=relaxed/simple;
	bh=jmhGjQrGN9mev/vtJ1wjShuayw6hkEW2UN/sEmYLOCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YINwfbZ6sonhu//13P2a1/qW64zmXc7265w5X1vGpFCYcQHvVhnPe9b8+jRMCyJA36/vOJbTZD34w1/eC+y8TZHBBn4viZ1N1ijJGicf435Q2RBkgWrlzSXE9JV//2Cl4Sq9mXiY7IRl5wLf1+HnVsMZ+m6mdLP92XjDdZ2GO9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmnwAuH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmnwAuH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC754C32782;
	Tue, 30 Jul 2024 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359985;
	bh=jmhGjQrGN9mev/vtJ1wjShuayw6hkEW2UN/sEmYLOCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmnwAuH+RsOylcL4Br1WwkIpi2zHwqeYk7ZDzQk74sAnaeSTymbP4GLUBHgq2oiey
	 VSR14NGyUKhALWOWgqCjLyA5W4dg9gCW6+H6t3m8Ew/VPe04RjARlHchQyyQ3E+h3t
	 LQZ9hdpotEqIgydq8mkEk/80J2H5BIIghaOfkWQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	Alexander Motin <mav@ixsystems.com>,
	Wei Xu <weixugc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 540/809] mm/mglru: fix overshooting shrinker memory
Date: Tue, 30 Jul 2024 17:46:56 +0200
Message-ID: <20240730151746.075525721@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhao <yuzhao@google.com>

commit 3f74e6bd3b84a8b6bb3cc51609c89e5b9d58eed7 upstream.

set_initial_priority() tries to jump-start global reclaim by estimating
the priority based on cold/hot LRU pages.  The estimation does not account
for shrinker objects, and it cannot do so because their sizes can be in
different units other than page.

If shrinker objects are the majority, e.g., on TrueNAS SCALE 24.04.0 where
ZFS ARC can use almost all system memory, set_initial_priority() can
vastly underestimate how much memory ARC shrinker can evict and assign
extreme low values to scan_control->priority, resulting in overshoots of
shrinker objects.

To reproduce the problem, using TrueNAS SCALE 24.04.0 with 32GB DRAM, a
test ZFS pool and the following commands:

  fio --name=mglru.file --numjobs=36 --ioengine=io_uring \
      --directory=/root/test-zfs-pool/ --size=1024m --buffered=1 \
      --rw=randread --random_distribution=random \
      --time_based --runtime=1h &

  for ((i = 0; i < 20; i++))
  do
    sleep 120
    fio --name=mglru.anon --numjobs=16 --ioengine=mmap \
      --filename=/dev/zero --size=1024m --fadvise_hint=0 \
      --rw=randrw --random_distribution=random \
      --time_based --runtime=1m
  done

To fix the problem:
1. Cap scan_control->priority at or above DEF_PRIORITY/2, to prevent
   the jump-start from being overly aggressive.
2. Account for the progress from mm_account_reclaimed_pages(), to
   prevent kswapd_shrink_node() from raising the priority
   unnecessarily.

Link: https://lkml.kernel.org/r/20240711191957.939105-2-yuzhao@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Alexander Motin <mav@ixsystems.com>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4915,7 +4915,11 @@ static void set_initial_priority(struct
 	/* round down reclaimable and round up sc->nr_to_reclaim */
 	priority = fls_long(reclaimable) - 1 - fls_long(sc->nr_to_reclaim - 1);
 
-	sc->priority = clamp(priority, 0, DEF_PRIORITY);
+	/*
+	 * The estimation is based on LRU pages only, so cap it to prevent
+	 * overshoots of shrinker objects by large margins.
+	 */
+	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
 static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *sc)
@@ -6701,6 +6705,7 @@ static bool kswapd_shrink_node(pg_data_t
 {
 	struct zone *zone;
 	int z;
+	unsigned long nr_reclaimed = sc->nr_reclaimed;
 
 	/* Reclaim a number of pages proportional to the number of zones */
 	sc->nr_to_reclaim = 0;
@@ -6728,7 +6733,8 @@ static bool kswapd_shrink_node(pg_data_t
 	if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
 		sc->order = 0;
 
-	return sc->nr_scanned >= sc->nr_to_reclaim;
+	/* account for progress from mm_account_reclaimed_pages() */
+	return max(sc->nr_scanned, sc->nr_reclaimed - nr_reclaimed) >= sc->nr_to_reclaim;
 }
 
 /* Page allocator PCP high watermark is lowered if reclaim is active. */


