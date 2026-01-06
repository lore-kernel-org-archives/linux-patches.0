Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866E344055;
	Tue,  6 Jan 2026 17:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721178; cv=none; b=LGO97SfDGOPoN4uBAPUK9K6hAGApKFww28CVVoBUcIWh9DIDi81ixFjmNTs8ZooRHy4x7kWGZTgPJBBvvYkapsrNr6N+PqCgvSbgtE0OhvMNecN37vURy6m3SIhExfY0isXp8s29zGbXmwPPCCuNKLB7QcOf4UPO9X9SM19/qoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721178; c=relaxed/simple;
	bh=enSnuDizWLzYYQY78r1yT6p6MRTI7d2MnTeB00DkitI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+J5kl20xIzbVsLPcbG1fC8k5/iT54im1O5bHyZiQD1AS+YnE7Ej7TjbbqsqI6aODayk8I3PTsHR2zwRVU0jTreAbaklRLSo3TiKBcOHv1kGm4JA1r243OzbVr6LqVO6s/TSLmi7x6Z0UPGld/vijiUHgu3HFzwmkjrWfWqrKVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/4Ag6Rr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/4Ag6Rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49500C116C6;
	Tue,  6 Jan 2026 17:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721178;
	bh=enSnuDizWLzYYQY78r1yT6p6MRTI7d2MnTeB00DkitI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/4Ag6RrzPiT6Kli5a8TdxyN4nsLeL6HGh6ZE5MHYOtnzjHOqD00vY9Y9Hwcu7+NQ
	 4kGQQ3g9DeW0oEw4LW5GKvA0Thq0uf4zOAu+Kwt0qsK/Lkr4pf2hA8+eXX2iVlk82V
	 dECLiv4VWtesIF3wT7ESF4FSMtAMWpXbuJm6BM6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 426/567] mm/damon/tests/core-kunit: handle memory failure from damon_test_target()
Date: Tue,  6 Jan 2026 18:03:28 +0100
Message-ID: <20260106170507.105262628@linuxfoundation.org>
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
 mm/damon/tests/core-kunit.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -58,7 +58,14 @@ static void damon_test_target(struct kun
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	KUNIT_EXPECT_EQ(test, 0u, nr_damon_targets(c));
 
 	damon_add_target(c, t);


