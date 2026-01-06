Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012B8343D88;
	Tue,  6 Jan 2026 17:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721077; cv=none; b=kWnV3HE/UigSYbFQnsgPjAH7t4CPHiogNd4G4sH5MsJoMBNeqjDN4BKnW2yLjIu4TVNRTYXIuUmVhFLa2eIg8ywmAVsKgYoY2BrmlwX3ZhCXrKee0ELFiu5YFPvoHufB1bbl877Er/0l5zykXq978utl8Rq6psRNchE/sG/2Q+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721077; c=relaxed/simple;
	bh=Sjo6MgDdpmQLKH2hX0r9w5bQ7+/Sf91gVrwNnXSbb5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb6YpPekSJXsNeIPwUVuUp9zckQfOGV6tv1ADYWnLk1wGvmeM4wsR6FPZVCKhV9q5m/REa9Qs9Lj5IM3NIsSrPwQR4rfnWFS5/vMx+BR1ze/AdB3q1MMRYUyyRy+9cJozX10xpECZJ4EcWWWMgwMhgH2mbfFjTooxveE5jgm548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKvfqlaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKvfqlaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8094EC116C6;
	Tue,  6 Jan 2026 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721076;
	bh=Sjo6MgDdpmQLKH2hX0r9w5bQ7+/Sf91gVrwNnXSbb5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKvfqlaVjHuwqshJwNTEDdVL6AEhm8h0u4SuRJ0nkKkEyuj06jiAC8dEfOaB8soyO
	 D+N7u+fAdo0HLHbXmyQMK67+kCydgaTSFrTx9UwRalVWq18Yd1lBQ8XdZ06UPOKE/L
	 uz+8Tfn0h7asCUyHn0Ai57ZFvwiKAHhIu9rq9aGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 429/567] mm/damon/tests/core-kunit: handle alloc failures on damon_test_merge_two()
Date: Tue,  6 Jan 2026 18:03:31 +0100
Message-ID: <20260106170507.218812910@linuxfoundation.org>
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


