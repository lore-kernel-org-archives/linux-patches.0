Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DD815ADB4;
	Fri,  9 Jan 2026 12:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961351; cv=none; b=or4amFQRrrNFbbGRUe4vjZ6EXd1n7NGNw0rDsg3MPhOJxt8SBt6RFSroyAs4uyczDuGYLpv7DLII73jbkk+YgoEP4Ndi9f+rhzPZpaWuAkf0bib1bzSPTgAbK5jUjlWcc0cT4xXrNK3aex3z0gFcR8ziaiTMSWkCnjUR3cll9Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961351; c=relaxed/simple;
	bh=2ivRWkFfKJLg73qQj76xj1Q1NaXLv+qukFxHpfdv9As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3ppeY+vkD9WNfiqIRRkG6A5ysdrVWwlJiYBfC08iZ/502NdjPEMz0kV9x8xiQMuLBYR4+HUTbbWKXZj8Nbhq/F3Ev7JiwEa7W1NJZW+N9o/vJoCQu+90rU+X7FZ9799Hfjk9/Iae8l1Fq+YkKtAjhABTh4mqVHrYG+4+WWDU2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRh9yNy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRh9yNy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56381C4CEF1;
	Fri,  9 Jan 2026 12:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961351;
	bh=2ivRWkFfKJLg73qQj76xj1Q1NaXLv+qukFxHpfdv9As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRh9yNy32Tu8oP+wevgSN9HJAJTgwtu0eMJY/NI6cu2s6PyyHaMW5xwvArER4UjGQ
	 p2gXqlPmQUZIM08TAyfCNaGNYr+fCJ6yaqpkEA4rcvCxkdHemjzJlx2hPTmIOFSYOu
	 o+vSmfLneUt5WGpU3FFNrpr/QE3btcIG9eTyi7k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 723/737] mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_regions_of()
Date: Fri,  9 Jan 2026 12:44:22 +0100
Message-ID: <20260109112201.288685839@linuxfoundation.org>
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

commit eded254cb69044bd4abde87394ea44909708d7c0 upstream.

damon_test_split_regions_of() is assuming all dynamic memory allocation in
it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-9-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core-test.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -256,15 +256,35 @@ static void damon_test_split_regions_of(
 	struct damon_target *t;
 	struct damon_region *r;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 22);
+	if (!r) {
+		damon_destroy_ctx(c);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 	damon_split_regions_of(t, 2);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "second target alloc fail");
+	}
 	r = damon_new_region(0, 220);
+	if (!r) {
+		damon_destroy_ctx(c);
+		damon_free_target(t);
+		kunit_skip(test, "second region alloc fail");
+	}
 	damon_add_region(r, t);
 	damon_split_regions_of(t, 4);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);


