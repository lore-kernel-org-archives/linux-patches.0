Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F00642373;
	Mon, 18 Dec 2023 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDWSr3G5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2411FC433C7;
	Mon, 18 Dec 2023 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908339;
	bh=Xu+RYb+e/6QLP5YBaU8V58Pyi0blE7tO9j4AsdHj58M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDWSr3G5wd+JMFlND/CRTJO2LVkKZUN5Q7Rp3vvUUiRZ/YwD4Tadhu9mVcVDZi/k6
	 UDMNQeO7/dwO1I6D11ovuRvSs5TAJmQmuHwnI7+aNjsbbM7uEu+1jz3CIapiSdgVi2
	 v25FSGlkKJSDkMIT/z2WPz8flvFsZriYLu5yPSak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Hillf Danton <hdanton@sina.com>,
	Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
	Kairui Song <ryncsn@gmail.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 140/166] mm/mglru: reclaim offlined memcgs harder
Date: Mon, 18 Dec 2023 14:51:46 +0100
Message-ID: <20231218135111.371534529@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhao <yuzhao@google.com>

commit 4376807bf2d5371c3e00080c972be568c3f8a7d1 upstream.

In the effort to reduce zombie memcgs [1], it was discovered that the
memcg LRU doesn't apply enough pressure on offlined memcgs.  Specifically,
instead of rotating them to the tail of the current generation
(MEMCG_LRU_TAIL) for a second attempt, it moves them to the next
generation (MEMCG_LRU_YOUNG) after the first attempt.

Not applying enough pressure on offlined memcgs can cause them to build
up, and this can be particularly harmful to memory-constrained systems.

On Pixel 8 Pro, launching apps for 50 cycles:
                 Before  After  Change
  Zombie memcgs  45      35     -22%

[1] https://lore.kernel.org/CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20231208061407.2125867-4-yuzhao@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: T.J. Mercier <tjmercier@google.com>
Tested-by: T.J. Mercier <tjmercier@google.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmzone.h |    8 ++++----
 mm/vmscan.c            |   24 ++++++++++++++++--------
 2 files changed, 20 insertions(+), 12 deletions(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -519,10 +519,10 @@ void lru_gen_look_around(struct page_vma
  * 1. Exceeding the soft limit, which triggers MEMCG_LRU_HEAD;
  * 2. The first attempt to reclaim a memcg below low, which triggers
  *    MEMCG_LRU_TAIL;
- * 3. The first attempt to reclaim a memcg below reclaimable size threshold,
- *    which triggers MEMCG_LRU_TAIL;
- * 4. The second attempt to reclaim a memcg below reclaimable size threshold,
- *    which triggers MEMCG_LRU_YOUNG;
+ * 3. The first attempt to reclaim a memcg offlined or below reclaimable size
+ *    threshold, which triggers MEMCG_LRU_TAIL;
+ * 4. The second attempt to reclaim a memcg offlined or below reclaimable size
+ *    threshold, which triggers MEMCG_LRU_YOUNG;
  * 5. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
  * 6. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
  * 7. Offlining a memcg, which triggers MEMCG_LRU_OLD.
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5291,7 +5291,12 @@ static bool should_run_aging(struct lruv
 	}
 
 	/* try to scrape all its memory if this memcg was deleted */
-	*nr_to_scan = mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
+	if (!mem_cgroup_online(memcg)) {
+		*nr_to_scan = total;
+		return false;
+	}
+
+	*nr_to_scan = total >> sc->priority;
 
 	/*
 	 * The aging tries to be lazy to reduce the overhead, while the eviction
@@ -5412,14 +5417,9 @@ static int shrink_one(struct lruvec *lru
 	bool success;
 	unsigned long scanned = sc->nr_scanned;
 	unsigned long reclaimed = sc->nr_reclaimed;
-	int seg = lru_gen_memcg_seg(lruvec);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* see the comment on MEMCG_NR_GENS */
-	if (!lruvec_is_sizable(lruvec, sc))
-		return seg != MEMCG_LRU_TAIL ? MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
-
 	mem_cgroup_calculate_protection(NULL, memcg);
 
 	if (mem_cgroup_below_min(NULL, memcg))
@@ -5427,7 +5427,7 @@ static int shrink_one(struct lruvec *lru
 
 	if (mem_cgroup_below_low(NULL, memcg)) {
 		/* see the comment on MEMCG_NR_GENS */
-		if (seg != MEMCG_LRU_TAIL)
+		if (lru_gen_memcg_seg(lruvec) != MEMCG_LRU_TAIL)
 			return MEMCG_LRU_TAIL;
 
 		memcg_memory_event(memcg, MEMCG_LOW);
@@ -5443,7 +5443,15 @@ static int shrink_one(struct lruvec *lru
 
 	flush_reclaim_state(sc);
 
-	return success ? MEMCG_LRU_YOUNG : 0;
+	if (success && mem_cgroup_online(memcg))
+		return MEMCG_LRU_YOUNG;
+
+	if (!success && lruvec_is_sizable(lruvec, sc))
+		return 0;
+
+	/* one retry if offlined or too small */
+	return lru_gen_memcg_seg(lruvec) != MEMCG_LRU_TAIL ?
+	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
 }
 
 #ifdef CONFIG_MEMCG


