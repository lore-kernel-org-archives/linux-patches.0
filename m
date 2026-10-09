Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3815D3BB112;
	Fri,  9 Oct 2026 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556469; cv=none; b=SQq02oB2W78BvsLQ9hsqxCfIORFNpSdX2pJ85eJS4SpEHZCBHNw4OmklfxatFuSsx4PNHxSudwwXE98tmj8cTRXLJh/V21D7L4cFbkvdALLZxxLbVsj82OHvW3gAcEFPDPittN/g+J+LHhLYUegBbzPcmbcynOvlNf/qIPQMlDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556469; c=relaxed/simple;
	bh=aNadQIF+XT7nih7joovW4vZ4XPHuHjphiqeLE1TbYaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oyj/ZN/a+rgnIc7Xp2K0MVnczE3uIkh7fQJUe4/NZF+gFTeSdKeOsp166K/DCdNjnjRbewx7QaxVBvWbbh8VLEBfvtd5dGLrg8yiaEggP08lF8H0JUEexEBCnb8qk/+06VZcvhFdVdvHQ4xAQ7H7RCw1vLQm3J1ZV37+hsGFXkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeUlxs+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeUlxs+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9451F1F000FF;
	Fri,  9 Oct 2026 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556468;
	bh=Wpc3vwAKz+OaeHvmNKSFxM3YkiRykTadEp7FU1zgq58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WeUlxs+eAM3oalUKAAHPDr6oNS+NLOOyJ78m35yfXTkd1i8W2ZZRJBZqdG9ahfROa
	 Y5ntCeYvHBE5EBYxYcV8PRmEtMkGgwnIlcSd7jk5nwcbdwHVzQZ6EsV/+DikJMWnHd
	 3lSqvtwd+2kc0F3zEh/qn/QRkV8VEts4T2Skdgsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 238/403] mm/damon/core: do non-safe region walk on kdamond_apply_schemes()
Date: Fri,  9 Oct 2026 16:09:59 +0200
Message-ID: <20261009140957.732656838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/core.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0182cc8198d37..016d38c127d61 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1734,16 +1734,18 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
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
-		struct damon_region **rp, struct damos *s, unsigned long min_sz_region)
+		struct damon_region *r, struct damos *s,
+		unsigned long min_sz_region)
 {
-	struct damon_region *r = *rp;
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
 	bool skip = false;
@@ -1770,9 +1772,7 @@ static bool damos_skip_charged_region(struct damon_target *t,
 				sz_to_skip = min_sz_region;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			r = damon_next_region(r);
-			*rp = r;
-			skip = false;
+			skip = true;
 		}
 	}
 out:
@@ -2034,7 +2034,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
-		if (damos_skip_charged_region(t, &r, s, c->min_sz_region))
+		if (damos_skip_charged_region(t, r, s, c->min_sz_region))
 			continue;
 
 		if (!damos_valid_target(c, t, r, s))
@@ -2307,7 +2307,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r, *next_r;
+	struct damon_region *r;
 	struct damos *s;
 	unsigned long sample_interval = c->attrs.sample_interval ?
 		c->attrs.sample_interval : 1;
@@ -2330,7 +2330,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
-		damon_for_each_region_safe(r, next_r, t)
+		damon_for_each_region(r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
 
-- 
2.53.0



