Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1084D1DE4EF;
	Sat, 12 Sep 2026 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222171; cv=none; b=UkAqqdilDTz+35J3zYYebKi5zI8Gisx29LThMMRmtW0xXX5JfhxJqDXxAOd5YYiB3cdgjc+Ea1QMATLCMN1e2FLVIvkv1UAxmdur5C1voWfTeJhBgJ+hYrWNGz0+CWC6Xvfk5l/VTvqcaE5qMLwTVRyEvogIWJ5C3vHduhd2gSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222171; c=relaxed/simple;
	bh=kAO8uFhjZEx+HKoEzW5AnDWqYzIFzHgIhxn5bz6Gl5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9zYcabw95rwc9JrdLNlAkJSIiuaOS85mvLl2nzPtbPAfoHMBO5LskO9njn/biJSN8xbmPYShzM+fZntRqct+wr95zqL3J13HbC8rEblFRXhKZwBW+H6HKD9cRP09KoQU8lQFD0AfG7WU6Z5bad7MASbr/mV+5RUXqEImV2iYbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOm0QGeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOm0QGeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07D81F000FF;
	Sat, 12 Sep 2026 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222170;
	bh=rpT4yqOCw5RvK9/p4yYu6hHUIwG7Fgi/VktQr6zA5+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOm0QGeu+7ztgX+3fU5EvuS2kdG+4NigodFqTYMk/UcQjKPDRIxwmzL/L80Qg016u
	 yhifqCSJUePW3dNjKZGn2F3JjGs5DVeZCs5xCvBstZ/y/EZBe/J7c15s/IgTfre5wy
	 F4Ew834ck+6O/9bNt115+B9dOIzaBSjT65MLgWKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0532/1424] mm/damon/core-kunit: check region count before testing in split_at()
Date: Sat, 12 Sep 2026 08:49:24 +0200
Message-ID: <20260912065619.207374216@linuxfoundation.org>
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
 mm/damon/core-test.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/core-test.h b/mm/damon/core-test.h
index a2aa410d6d0d0..f2f0978495086 100644
--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -162,6 +162,10 @@ static void damon_test_split_at(struct kunit *test)
 	}
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
+
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
@@ -169,6 +173,7 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 25ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 100ul);
 
+out:
 	damon_free_target(t);
 	damon_destroy_ctx(c);
 }
-- 
2.53.0



