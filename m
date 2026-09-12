Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E62837FF50;
	Sat, 12 Sep 2026 18:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238011; cv=none; b=cV8x/Dhsen2+i/sQu59BNJ3xs0QByEMDqaE9RnksLoubuYCIkFfeftm2iU662I/3tq9cDVHeQ/ekywwcj3K1QbRRt+inHUacmTaP60AnmK0MJaptDPQWvJNyA/bWdR2tG9KzZpdMXmbevowjJS64AAq0fO9e4cWvyA1MY+eZVgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238011; c=relaxed/simple;
	bh=L5cM2MiutkBDWoiMc6TXYAnx52X2FV6mICYw0RASh4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hH5AerN7uzoa2+yPt4+EjWxV40wziNKMi9S/EnfPcz0KCAEUmihnd/kN6MbVdDjUlJV1YhwEN7qVLQ7dIWsi5wGUq9a9Ha3oSfw3H1teFjghfGpgLxjXsgDvyWYWBX3fdCFxLsJPqfXLo3lIEm4rtSeG5LyGAMuM+3Yhk/srOdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XE3fj7lm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XE3fj7lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B47E1F000FF;
	Sat, 12 Sep 2026 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238010;
	bh=Ah8/uLEL9tcUkqib0c9dtiInRw13HXiQQe/ZHpHO95E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XE3fj7lm5DgnlywCG2/XCSO5OC1Qwv0bVySnuu4eR/ppmuGKAuow7E3sgCmMrxE/Y
	 WHrb0zeZ9FKMvyOWYaDlgVBsaSk9u4X0VbAKfO5KwfUQIu2uHM5xgJ3j5A7ygUyswL
	 5KT0XS/axZeToaX0/VpV6TJvW7U1i/ibVH884TVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 375/935] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Sat, 12 Sep 2026 08:56:45 +0200
Message-ID: <20260912065535.418051909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit b640708929aa956235866bf7717d89018c661083 ]

KUNIT_EXPECT_EQ() does not abort the execution of test code when the
expectation is not met.  But damon_test_merge_regions_of() code after its
initial KUNIT_EXPECT_EQ() call assumes the expectation is met.  It does a
per-region test with a hard-coded number of regions that is correct only
if the expectation was met.  As a result, __nth_region_of() could return
NULL, and the test code can dereference NULL pointers.  Fix the issue by
catching the expectation failure and skip the per-region tests.

The user impact on realistic setups should be negligible, as it is a unit
test.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-3-sj@kernel.org
Link: https://lore.kernel.org/20260710144937.26981-1-sj@kernel.org [1]
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core-test.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core-test.h b/mm/damon/core-test.h
index b0d11a208fcd3..d1f009836779f 100644
--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -256,11 +256,14 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	damon_merge_regions_of(t, 9, 9999);
 	/* 0-112, 114-130, 130-156, 156-170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
+	if (damon_nr_regions(t) != 5)
+		goto out;
 	for (i = 0; i < 5; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
 	}
+out:
 	damon_free_target(t);
 }
 
-- 
2.53.0



