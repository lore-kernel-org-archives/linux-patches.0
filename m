Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CE1334C24;
	Fri,  9 Jan 2026 12:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961340; cv=none; b=itvRuANmpY19Ds0GWmWXPhCSFkzHxlyKNF+cKMBAC94m1dSjtnQGCT4V+LD877nQkggVwwGXws40QKpqWsp/l0NpyH6dq3Ai3wnGYmyFIGhSMZ2h9CBaYMnw0AR3UMJzLnn1B9/LH8LgD5wfX+6ImrfRV/JY6kGN0rvqtAXNHGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961340; c=relaxed/simple;
	bh=BaXPHQw34HIx1+7K0KDlfwX2bi9FGq1vMMnuySKL/1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsNq/Ul4dbMRC33E1nzWJTQoAA4bb/Qx6//kS4NmUjBj17Wnc5j8924ySsYKF13c6UBbTb3GyUQWB0ITJLPVHQtrq0Ka2gp91ZX/m+j2JIb8xFN4Kiy+eRQz/bWv7RTrxn5MaRynTJi4cb2m7TjvAIzMnZKBNywgh2QirQkLZgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2j8Nzle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2j8Nzle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEEAC19421;
	Fri,  9 Jan 2026 12:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961340;
	bh=BaXPHQw34HIx1+7K0KDlfwX2bi9FGq1vMMnuySKL/1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2j8Nzle+JBWqNGH1BnoTTGFBN7zC5s3t1MH3Wq8PVz/hTe3NbhuibTZve3ilRhOT
	 cQnIKD3ESVg30cfgtV280Do25pOGCOLHwag3kufFcmto1+5MCUN6lAywsFc3skBFFp
	 caDswOwNq/hble5inTFS5ECskMD1zN9RCMzp9TcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 719/737] mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()
Date: Fri,  9 Jan 2026 12:44:18 +0100
Message-ID: <20260109112201.133258497@linuxfoundation.org>
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


