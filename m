Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2958E43C7B4;
	Thu, 30 Jul 2026 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422959; cv=none; b=n3wTAWeSBzYjilmGNo9tcAUxDqJKeisZlfBCJ0uYM4lNceAA9YB6oqE2AodezFKErwQrmBMnh6iEoK4hU3YAicGEOS8Hihq0LO62Giz5bjqrmHW/x2uZhZXeqFSQAxjCgqHQM5Z+ovSV5JTKPtNGOyImvqmBwO/qezpyOC2uxP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422959; c=relaxed/simple;
	bh=vWZjDjc1GHVXi7wHc7HnGa1c1BKCnLzgP7eR4RhruLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQErh99jO6VLp5XcZQTiypVinGJP+2sB7T8RA+PtLmStlh4Tia/QPz/zKOGQkf2OJ1VPFqVO6h2Jb+dwAYH3eUpOl1xj2A2gDonkxvmawz1UGvjZfSVXGcOIkLaJpXsnMGilN63z5iTwU3VbCkRz0fVuhTcRLYNSNj6+lFmlzVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teoTn8sZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teoTn8sZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A3F1F000E9;
	Thu, 30 Jul 2026 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422958;
	bh=wn6rQduIUW8R0LwXF93DDrI5Cxk+w9FhgLtGqDmcIyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teoTn8sZfLy6Gfj2ojA+ZZsJ/7dfD/2QHoow2puteK+4JDRbDAG0vDPv9K6ZoDO+j
	 g9/o5QXCAxGBZ84TgsfoRcfGPEbFh8LfQyK6IYPjkc2bOEiidGR4xUkN2sNUIBDN67
	 irVjW70EuzetfNXcfRenYOYvBi1Bk0Q1H2XmvXwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 617/744] mm/damon/core: disallow overlapping input ranges for damon_set_regions()
Date: Thu, 30 Jul 2026 16:14:50 +0200
Message-ID: <20260730141457.388242478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 954157679ec34661c2e87e7eb796104a797c32db upstream.

damon_set_regions() assumes the input ranges are sorted by the address and
don't overlap each other.  Hence the assumption was initially to be
explicitly validated.  But commit 97d482f4592f ("mm/damon/sysfs: reuse
damon_set_regions() for regions setting") has mistakenly removed the
validation.

This can make DAMON behave in unexpected ways.  At the best, the
monitoring results snapshot will just look weird since there will be
overlapping regions.  DAMOS will also work weirdly, applying the same
action multiple times for overlapping regions, and make DAMOS quota weird.
More seriously, depending on the setup and regions updates sequence,
negative size regions can be made.  It will trigger WARN_ONCE() if the
kernel is built with CONFIG_DAMON_DEBUG_SANITY=y.  Depending on the
monitoring results, the negative size region can further trigger division
by zero in damon_merge_two_regions().

Note that some of the consequences including the WARN_ONCE() and the
divide by zero depend on commits that were introduced after the root cause
commit 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions() for
regions setting").

Fix the problems by checking the assumption and returning an error if
the input ranges don't meet the assumption.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260703165610.92894-1-sj@kernel.org
Link: https://lore.kernel.org/20260630041806.151124-1-sj@kernel.org [1]
Fixes: 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions() for regions setting")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -240,12 +240,19 @@ int damon_set_regions(struct damon_targe
 {
 	struct damon_region *r, *next;
 	unsigned int i;
+	unsigned long last_end;
 	int err;
 
 	for (i = 0; i < nr_ranges; i++) {
-		if (ALIGN_DOWN(ranges[i].start, min_region_sz) >=
-				ALIGN(ranges[i].end, min_region_sz))
+		unsigned long start, end;
+
+		start = ALIGN_DOWN(ranges[i].start, min_region_sz);
+		end = ALIGN(ranges[i].end, min_region_sz);
+		if (start >= end)
+			return -EINVAL;
+		if (i > 0 && last_end > start)
 			return -EINVAL;
+		last_end = end;
 	}
 
 	/* Remove regions which are not in the new ranges */


