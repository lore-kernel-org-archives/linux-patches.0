Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D5A33B6E1;
	Tue,  6 Jan 2026 18:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722591; cv=none; b=OmFH+lvGaX7nrJAaXuIjcivTYd1kAzju/gllUI7jJxQzCokDBq9vScKm9JSP1DTYZcp9ewLkG+4VkOGxt33Ns0dvNEDzCMCe/DVnyi3oNYWy28kJwEu3HqNLtVZy7RnAzMAGYVOuQh+okAa7HloWe34B9F8WbuaxJUKJCfpegsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722591; c=relaxed/simple;
	bh=ccdmvEBZ+VTeSXJjzpbDWvecnLeYn8dq/kBPvsOllm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmbReGhmGQoMkxuBgJrxRbXIelotjX3+CyS/JOHTlhwyZNIy8/P26lhF8P/Edd7L7mjO8w6FH3G0E5WgGt9v4loLQUHCy21sVnTM1ZSFbSDIX+vTybuWQVqsUm+0iB1Fs4ZdNNguiTKn5SwPOfRgolJ8ZQ4J2UOvQhvWDp8DjVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+6JXTVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+6JXTVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37477C116C6;
	Tue,  6 Jan 2026 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722591;
	bh=ccdmvEBZ+VTeSXJjzpbDWvecnLeYn8dq/kBPvsOllm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+6JXTVaJAVZMXdWw96wVtp47Rni8WX1oMaKcEkbh5SpNlaMNdfxhSXiP5Tnk01MI
	 /bGtTo5HvuFtxZJuTG9+B2IKcUg172ToTkIVDbSh8aws+sZJBzQ3WJyWs9uGWEd90S
	 TJrBeSA3nbVSHYiE9BWf9NXMBzF9JQ+kgbiVBm0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 311/312] mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_regions_of()
Date: Tue,  6 Jan 2026 18:06:25 +0100
Message-ID: <20260106170559.111588295@linuxfoundation.org>
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
(cherry picked from commit eded254cb69044bd4abde87394ea44909708d7c0)
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -278,15 +278,35 @@ static void damon_test_split_regions_of(
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
 	damon_split_regions_of(t, 2, DAMON_MIN_REGION);
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
 	damon_split_regions_of(t, 4, DAMON_MIN_REGION);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);


