Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCA125783C;
	Wed,  9 Sep 2026 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961866; cv=none; b=TO3OVZyNJHpSaQe41k+NYX2AGDZEJp3bR6/ZQnmattNIjzZFFvbFp7L1eLWw3bAS12/5ls6JsQF2D39ASIdIgHO3BOS4g/SnArkU5LybTlO0hDZ5RZlkbzjxIQS9+JDbE8W6uCIxZc6gPAPeLibxWiwVmmmy7aWIeEP6il8wkEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961866; c=relaxed/simple;
	bh=qszVLXw3Op9VOdFPmT1PgdgoiARzL6CsLC5cvQn6UEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skDdJYp1E7XyJaiFCbWVvBrvzW390CcxJDNRp97/oFO3Ex7KmvLNpDGjFZ58+IBsCO+PTElpR468MhdMFxzwnAlm6HshIvixbdzMbNWF7KasjKcDyT7SFoIAL1EABZrTGjT5IDmzSLJyubhI730WBiY4Zv8a6ZALohv+cE7krOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7WXUkOP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7WXUkOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FED41F00A3D;
	Wed,  9 Sep 2026 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961865;
	bh=1k/xDBCUDu1SApwG4fYR/EOWvrVLhETTsvETcs7Dkx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7WXUkOPqfFnT3Qo6b2xmHiB+OhC7bSHhShTBSpMrlOuutJnLWn4xyWN5aUC/6wnL
	 zeI2DvMxBp3ZaiufpSjE+9HVjHk9JEc5n0txwrAiBIrrpsVJ6reiZujK5cYVL2pFgE
	 Khbo/imutGbxkQDJj0BI1t9LGr+wRC1N6F3RSwx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 094/556] mm/damon/core-kunit: skip wrong region walk in commit_target_regions()
Date: Wed,  9 Sep 2026 15:36:14 +0200
Message-ID: <20260909134233.807041287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 488cf81c49955f83b7682dda880e9920c173e617 upstream.

damon_test_commit_target_regions_for() traverses expected values array
after damon_commit_target_regions() call.  It assumes
damon_commit_target_regions() made expected number of regions.  It might
not.  Because the traversal is made based on the region count, it could do
out of bounds access to the expectation value array.

The consequent user impact (out-of-bound access) is quite bad.  The
realistic user impact would be limited, though.  It would affect only test
run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-8-sj@kernel.org
Link: https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org [1]
Fixes: 603f67eb91e0 ("mm/damon/tests/core-kunit: add damon_commit_target_regions() test")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1171,14 +1171,19 @@ static void damon_test_commit_target_reg
 		kunit_skip(test, "src target setup fail");
 	}
 	damon_commit_target_regions(dst_target, src_target, 1);
+
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
+	if (damon_nr_regions(dst_target) != nr_expect_regions)
+		goto out;
+
 	i = 0;
 	damon_for_each_region(r, dst_target) {
 		KUNIT_EXPECT_EQ(test, r->ar.start, expect_start_end[i][0]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expect_start_end[i][1]);
 		i++;
 	}
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
-	KUNIT_EXPECT_EQ(test, i, nr_expect_regions);
+
+out:
 	damon_free_target(dst_target);
 	damon_free_target(src_target);
 }


