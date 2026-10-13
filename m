Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51F533A9CF;
	Tue, 13 Oct 2026 12:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895657; cv=none; b=V5IwoGIPPNr1wobYvGPFjWT22+zzzqCD/z/zFHg6dMyOy/hvkyi8kLVTJY4FkzRTzkUTNOIENsFdS5X/0ZyZxhCYag0sbSVDhTFz+D+J3IEspoPiyM3mtDOoft+K/pRPGIZEdsAwZayEEWJuCLZW9Ar3wcoVngfEANcLQ0HnXDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895657; c=relaxed/simple;
	bh=r14ecL9XU0BFrkOHSlbeaPDlw0ypGvkIfcn7XZctmJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyiiDUUKGFFPO2+rdTre8vYcec7VKw3qkSo67lBq6gCQCT5zqCLN5+GFZmChe+oU7v12u03d6hqx8OzUYKY8Kx7lW0berlwe3xSpU389bvjoHrIO7tmwhw6AunK1erwl1oGLIUWYTe8iRgxM3GGyuJYMGATlg4DiCUUyMkdre5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBW78KxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBW78KxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAC01F000FF;
	Tue, 13 Oct 2026 12:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895655;
	bh=htRmmEw+JDSup9hFX3FRZ1SnFZjf61HcrGSK+24wcWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBW78KxCWZZJ6FwEQh21dZBYYbaGvbmkw3htMADPp+NY2mKBFyx+3r1jxIfeYgZNY
	 AiX4obqUZBynW0m/Y3XFm7guhwQNv9e+QR70Toh6ioTpefWFeqLxtGNNvCuLtnCGeR
	 3KOmSbouLj2yfzcHmoflzo0uV3kaixzqxfUOZbzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 348/497] mm/damon/core: do non-safe region walk on kdamond_apply_schemes()
Date: Tue, 13 Oct 2026 13:38:35 +0200
Message-ID: <20261013112916.165259428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 1745ccbd2907db2bdaa843e4abccde4fdaccbe5d ]

kdamond_apply_schemes() is using damon_for_each_region_safe(), which is
safe for deallocation of the region inside the loop.  However, the loop
internal logic does not deallocate regions.  Hence it is only wasting the
next pointer.  Also, it causes a problem.

When an address filter is applied, and there is a region that intersects
with the filter, the filter splits the region on the filter boundary.  The
intention is to let DAMOS apply action to only filtered-in address ranges.
However, it is using damon_for_each_region_safe(), which sets the next
region before the execution of the iteration.  Hence, the region that
split and now will be next to the previous region, is simply ignored.  As
a result, DAMOS applies the action to target regions bit slower than
expected, when the address filter is used.  Shouldn't be a big problem but
definitely better to be fixed.  damos_skip_charged_region() was working
around the issue using a double pointer hack.

Use damon_for_each_region(), which is safe for this use case.  And drop
the work around in damos_skip_charged_region().

Link: https://lkml.kernel.org/r/20260227170623.95384-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2f6d60b9ca0f4..4c96582d827f8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1310,16 +1310,17 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
  * This function checks if a given region should be skipped or not for the
  * reason.  If only the starting part of the region has previously charged,
  * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow and saves the second
- * region in *rp and returns false, so that the caller can apply DAMON action
- * to the second one.
+ * area that not charged in the previous charge widnow, and return true.  The
+ * caller can see the second one on the next iteration of the region walk.
+ * Note that this means the caller should use damon_for_each_region() instead
+ * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
+ * the second region will just be ignored.
  *
- * Return: true if the region should be entirely skipped, false otherwise.
+ * Return: true if the region should be skipped, false otherwise.
  */
 static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region **rp, struct damos *s)
+		struct damon_region *r, struct damos *s)
 {
-	struct damon_region *r = *rp;
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
 
@@ -1346,8 +1347,7 @@ static bool damos_skip_charged_region(struct damon_target *t,
 				sz_to_skip = DAMON_MIN_REGION;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			r = damon_next_region(r);
-			*rp = r;
+			return true;
 		}
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
@@ -1514,7 +1514,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
-		if (damos_skip_charged_region(t, &r, s))
+		if (damos_skip_charged_region(t, r, s))
 			continue;
 
 		if (!damos_valid_target(c, t, r, s))
@@ -1728,7 +1728,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r, *next_r;
+	struct damon_region *r;
 	struct damos *s;
 	unsigned long sample_interval = c->attrs.sample_interval ?
 		c->attrs.sample_interval : 1;
@@ -1750,7 +1750,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		return;
 
 	damon_for_each_target(t, c) {
-		damon_for_each_region_safe(r, next_r, t)
+		damon_for_each_region(r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
 
-- 
2.53.0



