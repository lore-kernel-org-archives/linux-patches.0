Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA943BF2EA;
	Thu, 15 Jan 2026 17:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498425; cv=none; b=QBo1kUJBwpbVjsIDU/SckBVwf8njAvc2z+xBHQW64QbFkMGagF91USHfIrzG08xXbzeqMD82dEiUs/zPx8mW+Lpqyrsg4AJ2ZWA6YVLVrlqR0srq3jtncnCIfNiSHA+Tmd1lrjRSuGBN4j4ykC1A5zpp9RsqGiXL9q+kMPHQi1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498425; c=relaxed/simple;
	bh=+VXjLMispNyYRg50jHGXqJgWBUK4XbthuAikC4vOvvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJCgYG7wWkdv7kfMeUC+iUZHTzhPLu4U6qtvHacu64ezcWSF8Ff1vlFS/BFC7U/NDFIiSXwfvnnZ9y34yNlfUZIXSEQwSv/EaEZCTzpBf0HRp5JcfQJ7zF7SHHeX8CQL1set29uO7p+ZMQ7uzvvz/Y/1bLKVye1lmlvG7bTs5b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8mlhgGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8mlhgGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F44C116D0;
	Thu, 15 Jan 2026 17:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498425;
	bh=+VXjLMispNyYRg50jHGXqJgWBUK4XbthuAikC4vOvvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8mlhgGew0gwBE0IBTMO/OUjPZb7F8mzoOs0OsVhAeBr5VquQrnXaKStdW7cbespn
	 8h1UsaDl3pwkRa+EnhBG/9lXBUIAnpe+GUr/0tI9QqO0km4wwT/XoO2/YOZ2UyHX8j
	 R2zK9+n0RErZ0mEg9ss6ZmMcqCBUqxPf33+jW3lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 420/554] mm/damon/tests/core-kunit: handle memory failure from damon_test_target()
Date: Thu, 15 Jan 2026 17:48:06 +0100
Message-ID: <20260115164301.446472860@linuxfoundation.org>
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

commit fafe953de2c661907c94055a2497c6b8dbfd26f3 upstream.

damon_test_target() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-4-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core-test.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -58,7 +58,14 @@ static void damon_test_target(struct kun
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target(42);
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	KUNIT_EXPECT_EQ(test, 42ul, t->id);
 	KUNIT_EXPECT_EQ(test, 0u, nr_damon_targets(c));
 


