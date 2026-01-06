Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB89270540;
	Tue,  6 Jan 2026 17:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721185; cv=none; b=paejB4lrbLYaqJWgCdA6uUqWt+UmUcTN7GBqjiO+Ezi7bXu6t/YZG0niI9v2EMMjHYFkCN5e8q23rzrlHFXeFsSfNpn2rI97iGJKsVlXXcjDDQweI22LJJ8X7Idlf16ohyJTFD/1owiui2YuH47BhLFb5nvPBQ70tJ1otopGhAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721185; c=relaxed/simple;
	bh=1u+JGeqcj2jHQtg4zed0Rf6IVml8VXWieY2SBoYU3sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPIwqmJZyy7jTny407S4FvIecTNSRTKPVmNJjqlt85qxAJq9p51XwsrsI+rAA27XnpeErtc6G1XYoAl5cYuwt4YH9LtV8PmE9R72xjqFN1pXICEdMh2zy0HfO1vw0qRmV2mb6VjboldcqoZRH7Z4sbXE5wPxfACVzLStt1sQxZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDYz6/kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDYz6/kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D31C116C6;
	Tue,  6 Jan 2026 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721185;
	bh=1u+JGeqcj2jHQtg4zed0Rf6IVml8VXWieY2SBoYU3sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDYz6/ktlGoSDh90NGoTslCwVBBbZH2KStSUFPrFoO1qIYkbQxIRT/MFnmya6+sIQ
	 LYEwl1lt+FLPaQ6P3UaBV5RhtKpIEB21Pc74DNQX1FK3jWTvBehCuTqwma+22lheZO
	 DuJJH8veAbu9aR3yJ92GC3Jn9pCrya3cUgyIOWLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 428/567] mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()
Date: Tue,  6 Jan 2026 18:03:30 +0100
Message-ID: <20260106170507.180504189@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

commit 0998d2757218771c59d5ca59ccf13d1542a38f17 upstream.

damon_test_merge_regions_of() is assuming all dynamic memory allocation in
it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-8-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -238,8 +238,14 @@ static void damon_test_merge_regions_of(
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
 		r->nr_accesses = nrs[i];
 		r->nr_accesses_bp = nrs[i] * 10000;
 		damon_add_region(r, t);


