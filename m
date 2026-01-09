Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE8B15ADB4;
	Fri,  9 Jan 2026 12:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961354; cv=none; b=TIRgcb5ApswyZoquWmkwNQTrbOlnO3iJzpxQfpF0oAiZNEjjPwGhDRGPhHx7fuHeqCClTQi1dR8GPjmW/sDYETeCiU4jnt+Th858LJw7ehq4sxfJAO45PBG4iafQ0vG92KBl8GbQyTjVJS5AAltThCyvUCcavRcQIe/lfqeYrh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961354; c=relaxed/simple;
	bh=1etv07OoI+3AGORUJUBuXUXRc5JxRm63nKgezP7gQ9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4932tzefGqEzaxap3bSVz7kdEloPDaG6t8BgwzKBoVWZsJe2PdAkmrywC4Vm2+J3WkWpzyBJ/Thrzv7miU19N2XX3GyoWdB26/44It/HTU8wOAdnsu37nfPOp2cKBMcH+Va0XanYsAAddga17imULk5WTTrllc5o6SI358yAlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwDImtFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwDImtFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D2FC4CEF1;
	Fri,  9 Jan 2026 12:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961354;
	bh=1etv07OoI+3AGORUJUBuXUXRc5JxRm63nKgezP7gQ9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwDImtFvEBinQDd69Dpokuq6a+eFwOa50mu4Llxna0YE1ty/j8ZK9QdvCxAReO/ou
	 5rkESPe7LP4O3eKJVFPnc3auF3LG2qzK+jCTGmBU2VDN+C7ZDJmsKYr6U5A4cwE7zu
	 hIjmVPVumapD9DUQCllEqJVcpxrZQLV5y1hRsMaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 724/737] mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()
Date: Fri,  9 Jan 2026 12:44:23 +0100
Message-ID: <20260109112201.327695276@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit f79f2fc44ebd0ed655239046be3e80e8804b5545 upstream.

damon_test_aggregate() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-5-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core-test.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -97,8 +97,15 @@ static void damon_test_aggregate(struct
 	struct damon_region *r;
 	int it, ir;
 
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
 	for (it = 0; it < 3; it++) {
 		t = damon_new_target();
+		if (!t) {
+			damon_destroy_ctx(ctx);
+			kunit_skip(test, "target alloc fail");
+		}
 		damon_add_target(ctx, t);
 	}
 
@@ -106,6 +113,10 @@ static void damon_test_aggregate(struct
 	damon_for_each_target(t, ctx) {
 		for (ir = 0; ir < 3; ir++) {
 			r = damon_new_region(saddr[it][ir], eaddr[it][ir]);
+			if (!r) {
+				damon_destroy_ctx(ctx);
+				kunit_skip(test, "region alloc fail");
+			}
 			r->nr_accesses = accesses[it][ir];
 			damon_add_region(r, t);
 		}


