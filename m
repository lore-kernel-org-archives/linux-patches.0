Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFDC270540;
	Tue,  6 Jan 2026 17:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721175; cv=none; b=Ev14DlsHf5QdCt2V6S8bHa/335VNelkh+/gGq6ML1fIXnRivfbdrNMxeReXS9Iiq6HhUkFQEdHYqrrgYtAjAPaM5Zm7/bzyyhokyJyu15uOnpfmWvL98+q8Lke/gLPBHrkL7XE8I8g53sl3hJqHY6K9XICcU5hGDVgDdfvRGXHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721175; c=relaxed/simple;
	bh=QPefrTGrFZsFC/WRzobjqXB1IdXYe0JvNjYkvxWcw7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUDss3AVOKQ3NaYx1Kr1mvTMJQg3OjqZzqnLr+G9rOy4qsYkIKeBnApjWejtzmRhxZ3eu0QpjiBQJP51xJxus0gDbAWZ5RiZdLSGppbAfa++Notn+CVFdItdKVrRX4wIHLIcfqTJtVgtIRhvQSLNM3CT7oh9r1nrEugXEw5KR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svJxZ5nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svJxZ5nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30D7C116C6;
	Tue,  6 Jan 2026 17:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721175;
	bh=QPefrTGrFZsFC/WRzobjqXB1IdXYe0JvNjYkvxWcw7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svJxZ5njLymfToqhBEru/o0IJ6Id9K4Ov1bzNcc4dlwNeaBvKeDYyPiFWsCI+ce4R
	 jKOVwX5U1ROPJdo5ddE7/A8ksTPASUCbK1nMvGTNBdyjmrSfOt6RAakBXGW8Ig2rQN
	 puNb9iEUAI+cDbT0gDA2btOkq9vk/4ZBqn9szbsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 425/567] mm/damon/tests/core-kunit: handle allocation failures in damon_test_regions()
Date: Tue,  6 Jan 2026 18:03:27 +0100
Message-ID: <20260106170507.066916318@linuxfoundation.org>
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

commit e16fdd4f754048d6e23c56bd8d920b71e41e3777 upstream.

damon_test_regions() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-3-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -20,11 +20,17 @@ static void damon_test_regions(struct ku
 	struct damon_target *t;
 
 	r = damon_new_region(1, 2);
+	if (!r)
+		kunit_skip(test, "region alloc fail");
 	KUNIT_EXPECT_EQ(test, 1ul, r->ar.start);
 	KUNIT_EXPECT_EQ(test, 2ul, r->ar.end);
 	KUNIT_EXPECT_EQ(test, 0u, r->nr_accesses);
 
 	t = damon_new_target();
+	if (!t) {
+		damon_free_region(r);
+		kunit_skip(test, "target alloc fail");
+	}
 	KUNIT_EXPECT_EQ(test, 0u, damon_nr_regions(t));
 
 	damon_add_region(r, t);


