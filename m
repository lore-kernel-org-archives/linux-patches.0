Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D6635BDDB;
	Fri,  9 Jan 2026 12:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962881; cv=none; b=LFnVZKl9qNgIeyRvOK2A5GIGLQ6WfqKRmZHyKmG2ieh/VWRkgMW1AQ+fDwh3wOpK2LI6dkw//tqcUKrkGMAo/3ooFnGZZNQKtGvqIrOM29fjReiNpQOsAz4M8krJ463BG1u0cCD8neeYpgM0qzCsfzbVcYve7YRViEWsaH85Lv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962881; c=relaxed/simple;
	bh=r5XdO/b0EgL9Q9WI6e09DXZElVvDfMh9knnmSZfIVz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJdwgzh6IMpZgvSNCsMYqNS3poniaVaNmBJEPEaA42/oDVRrN+pItWzWhTSl0meOQO2Jhp9t+EegDvkE64I2PPJKVBGN+upfAM7YdTPt4ruOG7HOlCQFT/rew/pOIWj+PBWeuNXIWV+GMqlr2mtjjwCEiK4hnoaMTjj+dFPLOVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uri3KGx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uri3KGx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE04C4CEF1;
	Fri,  9 Jan 2026 12:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962880;
	bh=r5XdO/b0EgL9Q9WI6e09DXZElVvDfMh9knnmSZfIVz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uri3KGx+Bn5nvb/AFxfQb7kNJUAIklCsbd4fUFBurxlp9y5xLlJU/Vq7Dybms15nk
	 j2Go9EPRfNE1agHALJcr7kl/+a30M1HU3sLsi+cDCONh4/7UxNOBZ8qCs1mU22SlTm
	 J0p2Mxld2o9SkXVjX7vnAP0rnr0JykB907oLLwlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 519/634] mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()
Date: Fri,  9 Jan 2026 12:43:17 +0100
Message-ID: <20260109112137.088807603@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 5e80d73f22043c59c8ad36452a3253937ed77955 upstream.

damon_test_split_at() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-6-sj@kernel.org
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
@@ -129,8 +129,19 @@ static void damon_test_split_at(struct k
 	struct damon_target *t;
 	struct damon_region *r;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 100);
+	if (!r) {
+		damon_destroy_ctx(c);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);


