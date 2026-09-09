Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16513562612;
	Wed,  9 Sep 2026 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961869; cv=none; b=BCjAufGQyaUPWhYJt1m8+U0xcbnnkrRmAvS4PQKYQUuZXyhiBWHTqAcqwIbXtV9RWz5cZBqG4Tl55tJ2PHBbPN+f7+Oien1PQ9AWTDQWSPeFu8xD5MXikvK/5yeP2GnihBF/X3SVXz53DlGCSTilxiHU1DpgpPQ3ErQtxFYy6K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961869; c=relaxed/simple;
	bh=6VhB03/cW2WvYI9zwciWnn54pb5l8WIGjgx/9K6DNkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVKrwN1XcSANr65njfqtzl4La4DFmT23cT9W6Sf65tLJCY+SeuIQxaqveMcuP8RP4mz2go2FZIGOkkzpvYV+b7cTvDJKTt9cIx+f/zE+hvdM3KNKrmAdtH5K6Qzg3TiifM+AkS32IP5idIEtjO76G62CUx8TNnR9jvRmFJiCdZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpDS06eC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpDS06eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F81D1F00A3A;
	Wed,  9 Sep 2026 13:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961868;
	bh=6u/+svkQLVpJWoP0kwsDmzLJP6iQVUNyjBFEzYf7GRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpDS06eC7yGJnUQh76JwM7rqnsX41c8cgriN7IHe6TBdPn5trVO2MpoeNpD/d3q+7
	 gbucgun44rJdSldWTXbyE+0kZGS+ukm4ba22AxrjzxNpYYI7V3SCUN5OLJ2Na4iRZq
	 5nK87WHy0pH6WYhJv0VNOfDZPf4c/aF+xsj6keJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 095/556] mm/damon/core: handle region split failure in apply_min_nr_regions()
Date: Wed,  9 Sep 2026 15:36:15 +0200
Message-ID: <20260909134233.842373015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit c608748607620f331196ed0ba9fe4017892c1457 upstream.

damon_apply_min_nr_regions() repeatedly split each region until its size
becomes small enough to meet the user-defined low limit of the number of
regions.  The loop assumes the split operation (damon_split_region_at())
will always succeed and create the new region.  But the operation could
silently fail for memory allocation failures, for example.

If such failure happens and the region was the last region, the linked
list-based next region fetching returns invalid pointer.  As a result,
invalid memory dereference and corruption could happen.  Even if the
corner case is handled, it imposes stress to the allocator by trying split
regions for other targets.  Fix the issue by breaking all the loops for
any region split failure.

This means there could be a min_nr_regions violation.  It will only rarely
happen since the allocation is arguably too small to fail.  Even if it
happens, it is only temporal.  damon_apply_min_nr_regions() will be called
again after the aggregation interval.

The user impact of the issue should be minor, since the allocation is
arguably too small to fail.  But, it could still theoretically happen, and
the consequence is very bad.

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260719155442.88794-1-sj@kernel.org
Link: https://lore.kernel.org/20260717011834.120715-1-sj@kernel.org [1]
Fixes: b1029f29eb1d ("mm/damon/core: split regions for min_nr_regions")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1670,7 +1670,7 @@ static unsigned long damon_region_sz_lim
 	return sz;
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 /*
@@ -1696,11 +1696,13 @@ static unsigned long damon_apply_min_nr_
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			while (damon_sz_region(r) > max_region_sz) {
-				damon_split_region_at(t, r, max_region_sz);
+				if (damon_split_region_at(t, r, max_region_sz))
+					goto out;
 				r = damon_next_region(r);
 			}
 		}
 	}
+out:
 	return max_region_sz;
 }
 
@@ -3194,8 +3196,10 @@ static void damon_verify_split_region_at
  *
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
+ *
+ * Return: 0 on success, negative error code otherwise.
  */
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
@@ -3203,7 +3207,7 @@ static void damon_split_region_at(struct
 	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
-		return;
+		return -ENOMEM;
 
 	r->ar.end = new->ar.start;
 
@@ -3215,6 +3219,7 @@ static void damon_split_region_at(struct
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */


