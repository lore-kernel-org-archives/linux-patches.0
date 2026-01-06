Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E63B2C3245;
	Tue,  6 Jan 2026 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721168; cv=none; b=uJyeO2OeB6FtT+/hhQ1I3lSV9bIqy7zTN2iMi6a0dgShxp6a376x8QNt0NHQ3sXtzEB5+gOvFR3sO6xlN/GuoMq80OWIFuS6t84yne0BPfYKZ+k+kSsnp/KtDoxaMKFRz0nS8wUwU9E4HDAC6dL39tc4hOq1p2HFrRISu4AyiMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721168; c=relaxed/simple;
	bh=vb36rdwt0k/ilmQiF6O/hcZSKLm1rCUdpRquUYhLfIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDr6vU1XVlBjgU6Jm0p72fQyvFethkPBJeOLwm3APT/XYMd4l4Cz4AfsIWuak5LmM2mMgIFetTFwrYvy7g+69P9jt7CeC8L3x+pa2WuMJ0xlydHH+OvhyEWeWPdlMCNXxO1DuPHT6ku82YxT9CzlOmNJwU2wEfH6wCUy1tWMOj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvBeZDEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvBeZDEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC63C116C6;
	Tue,  6 Jan 2026 17:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721168;
	bh=vb36rdwt0k/ilmQiF6O/hcZSKLm1rCUdpRquUYhLfIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvBeZDEzNWX75aR3FwiHAGUI836KkzglPzopU0tglynnNBI7p2UUriwSJpJ0ztJ6b
	 t6XG7OsKLPXQ43cuSay07gu13t3oCvnx05s+0YJkNof/t+AdrhWjEq/5TkeZe2m8Oj
	 y7E5dtb+PhObN/LA/dkP9XAXkUHI20gUKi3Wy/F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 423/567] mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()
Date: Tue,  6 Jan 2026 18:03:25 +0100
Message-ID: <20260106170506.990819705@linuxfoundation.org>
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
 mm/damon/tests/vaddr-kunit.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -278,10 +278,17 @@ static void damon_test_split_evenly_succ
 	unsigned long start, unsigned long end, unsigned int nr_pieces)
 {
 	struct damon_target *t = damon_new_target();
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


