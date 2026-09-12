Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AFE32B9B5;
	Sat, 12 Sep 2026 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222454; cv=none; b=fVSwMb6+RXNPZyEL5EybKGeSe2n/jxFAkNrv2ycvsTe1RTBrXHxELYsHAoQF/Lp9jqjrBp5I/kKwfZAFJNYCZRO3uX/Db2Sr6/N+UWDWS/EdSRK6rq8O4/qdHBqi40R5rCpIAVHq7xFlkO5YGnjP/jcsSogI8OscT+JP+atbrvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222454; c=relaxed/simple;
	bh=z6/dSsqwfSx8wO56uH4AqtABfjDrcMPkDH+4OBo98rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InxEhs0q9QgMf1bbP8wsDnv5jF5ocZqbJpqXwEdFng/FDVBrhTTqrgj7Lf05z2uQOwjMJhIP49FwuGj6ZNHzLJkENxLtrfuun9sVHWMED7lhwSNGp2wa88tBYkiOusNJEjpBJco5pqY6OYFxb8iOYu+0BRxPfDgb5WcuQjl3dZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QegdWd2K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QegdWd2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2491F000FF;
	Sat, 12 Sep 2026 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222451;
	bh=2D8HzdqIjJuYJ7Tw0KYFcdSmU0YMkSsoUwKo1AmDY+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QegdWd2KpKzt76D7et2y5NY/zDri/ARVuL0+yTBbLqjSDRrKVEq/W25L71PMCaSWy
	 1T59EK73ZFkoBRBvOKZzv5MY+kZvSFuWgW3ucpbne8VR7YxdeFmcbzf5XwGBOdan2w
	 y9+4ZxUap04Je0GstpRDLX3j8pRGbxnwUEGN79VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0537/1424] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Sat, 12 Sep 2026 08:49:29 +0200
Message-ID: <20260912065619.326408793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 53212bcc9eda7..e6c19a23b0806 100644
--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -258,11 +258,14 @@ static void damon_test_merge_regions_of(struct kunit *test)
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



