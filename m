Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AE236CE19;
	Tue,  6 Jan 2026 17:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722331; cv=none; b=Tqojr4FVrazuSF9K8Gj/qn5Er2HTkF1vhyhPLEHYZc5PZg0R4FewFZkBnJKuXd2z2t3jrNsRnutZYTSe3syeZ8mmqzISOCwnJ1MFEtJIhIpzeK/hsmmDpKb/Tp1f+082Ue9Sx2awRYh3+EvpJzaikDlo5f1SVoFZiCQJjpy4GKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722331; c=relaxed/simple;
	bh=qmRwZYQBS2Idxu8j/2Y8VZCsQhw7EOn/7eOBDoAJ3Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVABWypm3C1PIr0e/ekA3bB8Fig+nVDl5JIdvhKlRjOD6EgkKo2fpisAqI3kEQ7009ZtGaZg+WIYU0ZQdWGWJXTJJ0IgQBZ46NlosqRrO5XJIvTU5tTfcNFjloFklrBNJNGQAm9EeDJ5CFZbXBONGVxWXJbKpE2debwXNJwcam0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOD4ETP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOD4ETP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD61C116C6;
	Tue,  6 Jan 2026 17:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722331;
	bh=qmRwZYQBS2Idxu8j/2Y8VZCsQhw7EOn/7eOBDoAJ3Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOD4ETP1KNrnVRuRjO0IwV9Z4ftoebJY7I4sx2ZZ0Z1EUXxgGx/r1AigaV0QAjEeX
	 aULaQpXn6YGhymFG0NdTreuVX9brTP9l9lq9dDRE6Kng3qrbuRnU2XKUFTSp55TU/r
	 Ur5saOWvrPTmB+BLXAXjirsRNYpIihWkD45/z9Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 200/312] mm/damon/tests/vaddr-kunit: handle alloc failures in damon_test_split_evenly_fail()
Date: Tue,  6 Jan 2026 18:04:34 +0100
Message-ID: <20260106170555.064084882@linuxfoundation.org>
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

commit 7890e5b5bb6e386155c6e755fe70e0cdcc77f18e upstream.

damon_test_split_evenly_fail() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-19-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/vaddr-kunit.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -256,7 +256,16 @@ static void damon_test_split_evenly_fail
 		unsigned long start, unsigned long end, unsigned int nr_pieces)
 {
 	struct damon_target *t = damon_new_target();
-	struct damon_region *r = damon_new_region(start, end);
+	struct damon_region *r;
+
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+
+	r = damon_new_region(start, end);
+	if (!r) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 
 	damon_add_region(r, t);
 	KUNIT_EXPECT_EQ(test,


