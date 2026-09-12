Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EA335DA40;
	Sat, 12 Sep 2026 18:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238006; cv=none; b=b203ACadQkBxslPUvG+Wt5w6mdLHLPNgtJwnLEX9/fagzeIePcHcnQPljJ5FUAdtNbaCug7XpxZuBAdiGnrcSIceHl6G8mtlrqrjJsP9vbkT9iFUm0yi8+EhNoo95JeQNiKdkDDxS4AnPjIBWy44ZYi5UI4VI6gfeZg7DVPBZ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238006; c=relaxed/simple;
	bh=6pksGpHTI8digsMx7iFYznyXKMVBg13J9g6zQzDdqOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDVFGCmZMiCAAC2h5zzfaABUCJ7stWB64oUkaSIowpMf1ksTYy6CZyfSXZI9NbBOWz7oF2WCuG8Dpt0Ee7ONYQKbjBmK00o5v3LiA2CrpXpFnuJJdFvYEZ7v9hU+UEaOcJW68JTRRmSjyHsC1xf+ZjksYxF9Gn1gh5fp0qmAgR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNJA61Sh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNJA61Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAB81F000FF;
	Sat, 12 Sep 2026 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238005;
	bh=54Gx7KVFhuP1sWvZlLClCs7gyMBBJ6Oq3WTbtrOwJWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNJA61Sh9qidn+kBv+f1kTJYjCUFmIb/DAHiOndR4tNeXRq9DwqAZq/hClqfPbQFu
	 HvQFcaM/oQTN40AJED1QjY4PaecTrkgLbrTMZFqVZUMcee7/mgCudZ3r7g/EzOw2n6
	 qcLhTZdyE6kjVIuthPMic84FG08JDB2Z+2ITwjYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 374/935] mm/damon/vaddr-kunit: check region count in three_regions test
Date: Sat, 12 Sep 2026 08:56:44 +0200
Message-ID: <20260912065535.390188960@linuxfoundation.org>
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
index 72206dda95ecf..ffa76998dd63c 100644
--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -155,12 +155,17 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 
 	damon_va_apply_three_regions(t, three_regions);
 
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
 	damon_destroy_ctx(ctx);
 }
 
-- 
2.53.0



