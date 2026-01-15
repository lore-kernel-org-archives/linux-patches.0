Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BD93C1975;
	Thu, 15 Jan 2026 17:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498488; cv=none; b=QuZ4Tb7oPIOYcyvHMtxZJJO2WWhPrQx2qD1J3/7//zGPK3GIv5RnqPAQG2N+O3aikVXOa4ChpmoTMN/viZeGPyE4dvANfjEqp+55FctZmGkUc78cXZm1y/j4bHZKrK0qrm8xhDtloJgwpVbk8qaiB3+NUAMxkCYaAtXYIsFdSV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498488; c=relaxed/simple;
	bh=jW+UizdYD/6i6EdynZ483e57E6cQ3TDzgB1t3/iktjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNn3AuYuxwxxSuf7te0yUcybEgB3K5pxZBnV702XMfLf/lcHaOR0HKWTdV3ldZLGT2laTgYgzE6rNXKyNK11fUimfcONt7fcFt/vHVCPEpzry44K3BPBZ6wSdT04sptvA2208884m07oy9yE9wOsx3X2+rSfdbklXc+VGEGZYaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gd8VDhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gd8VDhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8820C116D0;
	Thu, 15 Jan 2026 17:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498488;
	bh=jW+UizdYD/6i6EdynZ483e57E6cQ3TDzgB1t3/iktjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gd8VDhj6rThLLXBHeGUly/NNig7kjAJ4znHH+ClDwF4GUyUj+u4zFqo+UOjmQ5qv
	 Jz/ViETiTLdxHOQZtYJ0ZEO7sYggs35zjspG7uCj8WZfLF/UbhnykKillDPaBs5Bqr
	 hYNFCIq6LxsqqV5BEqp6t7J962qfHp628h3fBY/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 422/554] mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()
Date: Thu, 15 Jan 2026 17:48:08 +0100
Message-ID: <20260115164301.531958817@linuxfoundation.org>
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
 mm/damon/core-test.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -99,12 +99,22 @@ static void damon_test_aggregate(struct
 	struct damon_region *r;
 	int it, ir;
 
-	damon_set_targets(ctx, target_ids, 3);
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
+	if (damon_set_targets(ctx, target_ids, 3)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc fail");
+	}
 
 	it = 0;
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


