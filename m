Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC98C357A50;
	Tue,  6 Jan 2026 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722252; cv=none; b=uVwj4KU80qKtD4Q7zDEEmjUssII1oGxav1Nd+/mJBsc5bdLpR+GWG2BJslpBbrtVW3LVtkh0pPaImat+wQrOZEORKUYHhLPKbzl2uwuSr+JHirLksnqngVZayUchx9Ryexw7vpOsSAr5uFygh2Coemn3yqiyqcIW/YWVCetQgw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722252; c=relaxed/simple;
	bh=SlNc75f9172npFMn+nyfCMeb4W9AThmEaAcg8NOH9/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhIQv2yeWfvNhigTbTLd3YtnttBiyw32+OTNNNr1XRFbXtyErKhjGv+tAs3tah+1BidJlBUK26IGJgTvfWAT3CQvq23NJuV54bvbEh9gf1xzxkVyUZrdvEJeU3NToMJjywYaMAkLXqgoWTnujaXjCVxEnHR844tozOzxMRrgGgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeuyY6Og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeuyY6Og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377ACC116C6;
	Tue,  6 Jan 2026 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722251;
	bh=SlNc75f9172npFMn+nyfCMeb4W9AThmEaAcg8NOH9/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeuyY6OgGqabxWSlcaRquSCrBdLlnjt8YeqCkxyiBeysUTw2QMfZHbu1KNx+J2CqR
	 3EPD52tu6A8Jxf9AYyU9SAt5YumchjaN2q7qja5IXOhF/7zPy3o1lNj7pB/jCtsL4S
	 8uZyHfswaWyoQQplzuJ94eu0qgvbGJW03rzJrbtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 209/312] mm/damon/tests/core-kunit: handle alloc failures on damon_test_merge_two()
Date: Tue,  6 Jan 2026 18:04:43 +0100
Message-ID: <20260106170555.397471803@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

commit 3d443dd29a1db7efa587a4bb0c06a497e13ca9e4 upstream.

damon_test_merge_two() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-7-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -188,11 +188,21 @@ static void damon_test_merge_two(struct
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	r = damon_new_region(0, 100);
+	if (!r) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	r->nr_accesses = 10;
 	r->nr_accesses_bp = 100000;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
+	if (!r2) {
+		damon_free_target(t);
+		kunit_skip(test, "second region alloc fail");
+	}
 	r2->nr_accesses = 20;
 	r2->nr_accesses_bp = 200000;
 	damon_add_region(r2, t);


