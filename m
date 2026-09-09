Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68BE49890A;
	Wed,  9 Sep 2026 13:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961854; cv=none; b=kDeCNB9GX6QslkG2VZ7KGpe493MG9FK2HDsKsI8POhQXBoijYWzsjBGahPr8PZorRA4Q/L/z/YV4LiEjmE9VunUV08/E7Jf+Ossq9NJBSt34hsgF26AuAah3SWiTCmOOi4kXX3ednOc2qYGNGAlkHr2ZLz8LqHo3BQ4QsvPTvgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961854; c=relaxed/simple;
	bh=yHLTgjtN4ATdU1nmkP9hY47kjd59OiWtQf81TioxbUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZTVQQQAcCabwCETjaA9G24BdKenfZZIbCq5I+vsuQ3fV9Vdpjll10nlm49eQ0lVWrfBYqJNL9wt7NH1FYMqY43Rh41JnBMB5YnKZr9jTmntF6tLI7mzSi1j3wKbGNBr2C6JdvT9IIOP8RthE5/7AsHn57AA8lIiVXIXiMunhcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEzzlTd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEzzlTd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4871F00A3A;
	Wed,  9 Sep 2026 13:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961853;
	bh=cECkguVginFFcSz9C7QeDjv6K14RlvETVzFMwrOCUHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEzzlTd49ZEVuaIODWD4DCsSSJhO023qr+tLkP8Chlpn1tQ/Bq7pxOTe/xsdS3P4G
	 JRecvsqDNxofwZtUweFQloDQoAXIdoSUCUF7OrBpp9IXrTc6BT5UIP+OG/oWeIJj0s
	 y7zsr/cicVO3vrPJ7Y1IA6AX+mRHlqVZEWMaVk+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 090/556] mm/damon/core-kunit: check region count before testing in split_at()
Date: Wed,  9 Sep 2026 15:36:10 +0200
Message-ID: <20260909134233.670653548@linuxfoundation.org>
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

commit 9b18ef3c3aa1ce24176e340061caf15fa2742564 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -157,6 +157,10 @@ static void damon_test_split_at(struct k
 	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
+
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
@@ -169,6 +173,7 @@ static void damon_test_split_at(struct k
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
+out:
 	damon_free_target(t);
 }
 


