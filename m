Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12B51DE4EF;
	Sat, 12 Sep 2026 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222189; cv=none; b=MIIHFh/NDO1Vcq6X/d7WsMNidJD7bB0p5wf3UCgXSa03Zp/QkNv2TJG5fQUnefX3a2m2nuvkCkwCzLSOwiwYGPwYAky54yGrwYd0qvvZ5DPown4/Ej/4H17FLOJUsNpyFBIuvLCkuZHapzRivdh+UtOhx8r2sSN7m3IUjF+c8DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222189; c=relaxed/simple;
	bh=p2N032J63oCkXqgX/WDM71rvxfshUwoCIkY01yvWc+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyBg00LvLY7GCUEq+ti/J8GwggXMUsY/VjAc4WhnjHk8KAVG75+Y/seCeZnVlHEpEwqi/MehkhaQnEOVu1nHIR8f1fc+qHA3czYTtdv2Zc5/dfmdTB9u9FlhIRIGivME3yB/bBqz0o73rHHwoxJKo2GehnX87lZ6EmqQsQKUN48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aV89KGYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aV89KGYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826A91F000FF;
	Sat, 12 Sep 2026 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222188;
	bh=UJgUtkSANCZFStG9782l2qK2lp16AFEJm84Q/cNjiAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aV89KGYwZPGQKHFIyAlGiCnZugx6cRYNNT5zgN0qmm7dPZILrMBmvjMFG3i2zk3af
	 I4TJPh2FxL26VCe/jukmzI6/Ja4hlEoYvcMmNxJbi86rQHBdXHe1rAkbMFflnUH+sP
	 4DWFiaWR/wT4G1FIxe08Naozu0fBnypDd0+xh5iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0535/1424] mm/damon/vaddr-kunit: check region count in three_regions test
Date: Sat, 12 Sep 2026 08:49:27 +0200
Message-ID: <20260912065619.280628548@linuxfoundation.org>
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

[ Upstream commit 5fea07e460874c8c7cf00f728efbe22abc62c8d8 ]

damon_do_test_apply_three_regions() iterates regions after
damon_set_regions() call assuming the function would succeed at setting
the number of regions the same to the expected one.  It might have failed.
In this case, __nth_region_of() in the iteration could return NULL and
NULL dereference can happen in the test.

The consequent user impact (NULL dereference) is quite bad.  The realistic
user impact would be limited, though.  It would affect only test run
setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-4-sj@kernel.org
Link: https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org [1]
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/vaddr-test.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/vaddr-test.h b/mm/damon/vaddr-test.h
index 292736d3f3954..c0546447b21e6 100644
--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -149,12 +149,17 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 
 	damon_set_regions(t, three_regions, 3);
 
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_expected / 2);
+	if (damon_nr_regions(t) != nr_expected / 2)
+		goto out;
+
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, expected[i * 2]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
 
+out:
 	damon_destroy_target(t);
 }
 
-- 
2.53.0



