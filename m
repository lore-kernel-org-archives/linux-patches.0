Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F22C29DB64;
	Sat, 12 Sep 2026 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228679; cv=none; b=Y37k7RW8H1kaPhpdw/gexMvU2/CK2puDdIQmvm1kh6/XdkRhAllugKgOIPVHriKZBB3kNgA/ykf6fLvr5FUMqOJhOb7g3UbxMlM4B1q046+XsaYkFX2XU2R5zRLvVu1gLIyaSucFqC7XoT8gr56MEX9yic3L/vqUiSgqHoHGsqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228679; c=relaxed/simple;
	bh=AF9AFnzBZzry1FqdyZ54ipViSFuAkw2Ieh/vhXenBKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2kGGzZeJjaSl0+CjtjbCok+bQzp5DmuAmndE7Wmruq6wBXimIexeOcpG6EmhKVaa/kVZxtjg4ZyTPdLy5G/zv/h+aaQq7YAqjhw77kPmJY9ELBqU8Yx/n4INi9O7Iabva1LUjcaG0xSXjRPleGpKTxddM5Pn9chVEGSWu6qqXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4N0VdKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4N0VdKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D53F1F000FF;
	Sat, 12 Sep 2026 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228677;
	bh=1zrjuAwcdCWFme8MISc/v2/iwIPv6/jPrV1K/EGfX4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4N0VdKjEj97WY5kJJLVekEm2a0lhbvmqoxc9EFSZR1ha/e7VcLTIjC0eupyUBrr9
	 x3lE74GFlU6TyadPwutbj1l8rSCfSHZ8WVlt7tq1EfGm5oPa/d6pQijopfk5Zj8+B3
	 xmh/tlgMLdExMbF8+/odsoCbX6/VW8f+0/i2vIBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0435/1191] mm/damon/core-kunit: check region count before testing in split_at()
Date: Sat, 12 Sep 2026 08:52:43 +0200
Message-ID: <20260912065558.004210826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 9b18ef3c3aa1ce24176e340061caf15fa2742564 ]

damon_test_split_at() test next region that is assumed to be created by
damon_split_region_at() invocation.  But the split might fail.  In this
case, the succeeding test may dereference invalid pointers returned by
damon_next_region().

The invalid pointer may not cause a really bad user impact, because of the
implementation detail.  It would only read wrong contents in the belonging
damon_target struct.  Depending on the future change of the offset from
the link header to the accessing field, this could also be really
dangerous, though.  Still, the realistic user impact would be limited.  It
would affect only test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-3-sj@kernel.org
Link: https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org [1]
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core-test.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/core-test.h b/mm/damon/core-test.h
index d8fef225930a5..069c9032b98bc 100644
--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -162,6 +162,9 @@ static void damon_test_split_at(struct kunit *test)
 	}
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
@@ -169,6 +172,7 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 25ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 100ul);
 
+out:
 	damon_free_target(t);
 	damon_destroy_ctx(c);
 }
-- 
2.53.0



