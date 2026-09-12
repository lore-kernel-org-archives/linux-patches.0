Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472903537FF;
	Sat, 12 Sep 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228708; cv=none; b=r0lRJM4oSKRk3KqIsyznlfABUdsrUZ3E14uZCi9M/jJb1w/IvOqI/rAiIPjsP4tiv6jkzkyb+EqX6ncBWKB9cSFALn4/q3sBj2RmE5Lp867jvISdMRqs89Tl7GoloZ14aMw4SzbfZWGyKdyZN3cDZ1jyfbs4XTFybpqOB6GC98E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228708; c=relaxed/simple;
	bh=i+ooehBgIZvZvuTg8Q/1KL3+VxKoLfDaIBXlKnLaoU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmwsK8nlCfVAzCDMbNtOYfeTzMMNAn6erIZrlvyvZvosJAUB4MA0g7kJl4CQ15b+OUFpw3q1I7YYPsGvDTeVu6pbn85KhZHyNCjz+ZlZz5smXjMTWIaw21RpxLwEEEnUxSAsn0WkD7668IE2IMCoyHSk5LfkVsM4lnozpjFb0ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjibkeac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjibkeac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4601F000FF;
	Sat, 12 Sep 2026 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228706;
	bh=35gLvMqsrDj6SnAZFDmqBdeaxm5u1k3ufR2GgD2U+oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjibkeacijZM4hPE0ouDTwP3vnpeuLIXgNw/ZHi5xe4LgfPbYNLt7ZgAKyrIkiE55
	 4sGbcGoSYjmQylrkw/Iy8FPAwlYNwcqNET3DY4IXgnf/h+h7oPwy9bTn/XurN4fXsN
	 EmZ563U4rbN+XKxyDX3Bft+FDKSFMZ3iLDz7Zj9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0440/1191] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Sat, 12 Sep 2026 08:52:48 +0200
Message-ID: <20260912065558.115999380@linuxfoundation.org>
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
index 069c9032b98bc..21112ed10392e 100644
--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -257,11 +257,14 @@ static void damon_test_merge_regions_of(struct kunit *test)
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



