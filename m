Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51CF34216C;
	Thu, 15 Jan 2026 17:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498456; cv=none; b=Pr5ovapHO1svLsPLpwja5dtCEaBTExX8M+p51hduzEjFhCRG37s4CSrSIxqEzNmZydmLltt30ER6chvraSA13z5yeuXr7CCBsA2o1PtjnuP677d+1aL97nkIn8eMzP/mJRW7wvILIjF5GE6yEDH7plSNdrX9MjHUfFQlDmmirWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498456; c=relaxed/simple;
	bh=E4vAsc9W7ss6I+Ivk0bvvCcOibVDoaW5R7dLF23PRpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0M1wmH+XSP0Rwxq56pPb24mYMBuBtcn1kF3LA8NpRlfStdJWJ1pcCPsdYE+UvHyu2Tn5Hqi7m/1f8BZn0Bcx3xE7/X0updRskhzs4YYj8hZ3hpL5g6AtkYd7UR/d8ZhenpYHFQvjJzpqdnNT6SMM05Pl3h6KXkrlPpjKXng0jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqgPwpm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqgPwpm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E82C116D0;
	Thu, 15 Jan 2026 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498456;
	bh=E4vAsc9W7ss6I+Ivk0bvvCcOibVDoaW5R7dLF23PRpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqgPwpm+WU7fElC1K1UVh4QzeODsvuk5OuOA2cvrmApn889rOR7uawS0L8P3e18Ka
	 iDyHwpxg5TO6ii+HtfAa2A1+JkdGcvwwBij/2dQskJPrYYGwzbOfY/QRBFWUBeWjfn
	 ENyGNtHTkS5mUmvR0Kd/UWEkQuD9OvEy5KSjGu5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 421/554] mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_regions_of()
Date: Thu, 15 Jan 2026 17:48:07 +0100
Message-ID: <20260115164301.485295083@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/core-test.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -255,15 +255,36 @@ static void damon_test_split_regions_of(
 	struct damon_target *t;
 	struct damon_region *r;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target(42);
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
 	damon_split_regions_of(c, t, 2);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
 	t = damon_new_target(42);
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
 	damon_split_regions_of(c, t, 4);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);


