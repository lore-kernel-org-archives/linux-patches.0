Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22A23C0A01;
	Wed, 30 Sep 2026 19:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794894; cv=none; b=VemzYpf2P2J1o6OhBOe9WtjZCfyArqLn6pmU4t7L+rA56uEoEz8FJ0N70NF+53x+31N2Pw9N0PEnFVDEap/oESAwbsx/W02hoMNPSY5CGBcenoONKNFVLsiQySya+viKHpV4IQGCdHXT3BRsJcUCRTmunIofEtBlV0ZIbSCJgrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794894; c=relaxed/simple;
	bh=WgUpCqNOxd8gVL2N4Y34TFXNYWNPzHAS/L3C6fkPu60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxlY3fpuTLpPYqHHM+ARpP07Edj7QhW/XePX4u+N4Q3E9QuOjozuCaWd/xE7U95fzPnCNXPvcnZpYZ1oPkd1NRm81vL/FpRg0PA8GxV1pWG5oR1S5ROIWRXQoEY033d7IRt4zhdIv0xwQg2X4YZZr05j5s0K6EIA6+jpA78+tg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqBIWOZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqBIWOZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EEA1F000FF;
	Wed, 30 Sep 2026 19:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794892;
	bh=6YLYTuE3ur46ZXUzImRCnIgV40U966UO0bVooARqLFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqBIWOZJRTn2DpZgSjvMlEo4hw/I6scct1Copq+0IUHs6wqmok00Cy1z/+dDsiaJd
	 Kxe7Qtzuv21TlWG2WHql5TGnNUve5jcHA7Skg0IOXUVrpr5WuYaUQmrDYWLLca8K1p
	 zkCXG5UzTngkeUYwpfvlYowPeA5D2O4ZwRUKALlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0368/1193] mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
Date: Wed, 30 Sep 2026 17:17:32 +0200
Message-ID: <20260930152442.353943116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit 123e4619ab6c8ab1c4cb1d7a58311a2af13929cd upstream.

Patch series "mm/damon: unurgent fixes for infinite loop, NULL de-ref and
races", v1.1.

Sashiko found a few issues in DAMON that could cause infinite loop, NULL
dereference and monitoring results degradation.  The first two sounds
scary but the infinite loop happens only under unreasonable user setup.
The NULL dereference is only in a unit test.  Monitoring results
degradation is trivial since it is only best-effort, and those happens
from only unlikely races.  Still those are bugs that better to fix if
possible.  Fix those.

This patch (of 6):

Due to online parameter update like events, the number of DAMON regions
could be higher than the user-set upper limit.  kdamond_merge_regions()
repeats merge regions until the number meets the limit, while doubling the
merge threshold up to the theoretical maximum threshold.  It is tried only
up to the theoretical maximum threshold because even the aggressive
merging can fail from reducing the number of regions under the
user-defined upper limit.  For example, there could be many user-defined
non-contiguous regions that cannot be merged.

The threshold based loop break condition is evaluated by comparing the
threshold for the next merging try against the theoretical maximum
threshold.  If max_thres is larger than UINT_MAX / 2, doubling the
threshold could make it overflow, and bypass the loop break condition.  In
the case, if the number of regions cannot be reduced under the upper limit
like explained above, the loop will run infinitely.

Prevent the case by doing the break condition check before doubling the
threshold.  Also, prevent the threshold exceeding the maximum threshold,
as it could overflow and apply the wrong merge threshold.

This issue is unlikely to occur in real world, since having the max_thres
higher than UINT_MAX / 2 require unrealistically large aggregation
intervals compared to the sampling interval.  Also, it requires an
unrealistically large number of uncontiguous regions setup.  Nonetheless,
the consequence is bad and the fix is simple.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-1-sj@kernel.org
Link: https://lore.kernel.org/20260715031002.108504-2-sj@kernel.org
Link: https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org [1]
Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.10.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0713fda22682c..fe91b296f4c66 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1240,7 +1240,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
-	do {
+	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
 			damon_merge_regions_of(t, threshold, sz_limit,
@@ -1248,9 +1248,14 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 			nr_regions += damon_nr_regions(t);
 		}
 		count_age = false;
-		threshold = max(1, threshold * 2);
-	} while (nr_regions > c->attrs.max_nr_regions &&
-			threshold / 2 < max_thres);
+		if (nr_regions <= c->attrs.max_nr_regions ||
+				max_thres <= threshold)
+			break;
+		if (threshold < max_thres / 2)
+			threshold = max(1, threshold * 2);
+		else
+			threshold = max_thres;
+	}
 }
 
 /*
-- 
2.53.0



