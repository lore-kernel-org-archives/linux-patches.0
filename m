Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1633C1FE0;
	Thu, 15 Jan 2026 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498394; cv=none; b=JzPWQfu/MgE3bO6WLJQhL6eDzFLQVLmqjSq60MJp8CDT+Up8nauKbPQolEA7sK2CRS15caQBmC6ALkGB2CHrVdsET6msfWKqxou/Q/ur4hjBNQ7WAcsrjEGe97Z1yumYa9pv8kjFz91N+8VtvtetYQT8Tgn02GUe4J8lt0Pffwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498394; c=relaxed/simple;
	bh=gJ59L8hCo+Adkyq+ZTMthQO2VWExKukWvpsWUcxo22s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmDLBlOQoKl0mQUmkY9fBWSIUuMf0obvkdRQFOSEXNgMx53DX4KXAUjK5Qy7r+6KZY6vEH9EY52SO/1gsnyBc99W+ScXAWcnDvRQKYNb4Sc7+awTH8preKHeu5vw0GZgH+LFnwLGZxqXrfzdURtACb1++fiCaAw2Cz47J/7Pmpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytHEPSx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytHEPSx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA05FC116D0;
	Thu, 15 Jan 2026 17:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498394;
	bh=gJ59L8hCo+Adkyq+ZTMthQO2VWExKukWvpsWUcxo22s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytHEPSx4zcCan7saONAM7wUdu0iQXnTXfdIS4wmkSyv6BPYi4y3wXO4tZvRwwgDHX
	 eSizCKDZJAFjQA2asEUtNsb1OyMbmxVZ3cJ4SWPUwLCcsKWOms3VYt/j0W7YCvIwG3
	 rcZ3cFihwQa5Vk00S3qRySsgVoYjeCJ1HpGvQ63o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 415/554] mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()
Date: Thu, 15 Jan 2026 17:48:01 +0100
Message-ID: <20260115164301.260543627@linuxfoundation.org>
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

commit 0a63a0e7570b9b2631dfb8d836dc572709dce39e upstream.

damon_test_split_evenly_succ() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-20-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr-test.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -290,10 +290,17 @@ static void damon_test_split_evenly_succ
 	unsigned long start, unsigned long end, unsigned int nr_pieces)
 {
 	struct damon_target *t = damon_new_target(42);
-	struct damon_region *r = damon_new_region(start, end);
+	struct damon_region *r;
 	unsigned long expected_width = (end - start) / nr_pieces;
 	unsigned long i = 0;
 
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+	r = damon_new_region(start, end);
+	if (!r) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 	KUNIT_EXPECT_EQ(test,
 			damon_va_evenly_split_region(t, r, nr_pieces), 0);


