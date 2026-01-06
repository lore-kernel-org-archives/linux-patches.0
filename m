Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A6D230BCC;
	Tue,  6 Jan 2026 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722274; cv=none; b=sVurspnuMqUBQgtbq7DT8nXrJcodLcUuWn7ZH1G4lqLh7Ulq9zn2prVqJvQ4iH4jpUqllwg+xwRukOoAzeoRGrFSGDQ8HbgFs0quM+iJb3c2elePEvrTHCZaJqYdXUilYIwaPSsW9eCePUU+jmQbKTng7eI/58K9pzWZCfFL8Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722274; c=relaxed/simple;
	bh=l2YVH/beIEOcNmEv63vFaryBh2a8IPG8K3l0Jm69f0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n137Gvz/pBvvib+awWRYUa1TSXMnAtaHPyLU3pcwwNEeFlAia484M0UoqCwQI9WKG64xWI9MJ9UlJA8delefZ+gR05u1fraSoBk0eyUYrtkiU5JJ28buQU97Etp0dwpNltQhYLDQS91KwPbuQtzcCZRFGWb7Xyc9zh8uCX8ubko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBI+BTJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBI+BTJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3241BC116C6;
	Tue,  6 Jan 2026 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722274;
	bh=l2YVH/beIEOcNmEv63vFaryBh2a8IPG8K3l0Jm69f0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBI+BTJRuApntisoUcg4He9f4+HTE5DB6TGMyZ8WPswlvRF31dK1Y+7ZyhGyTYyAs
	 t8H10pl0B/J0AsnuT0YmSpS8LciEK5aIxyDpGNBX5q7/7o516u4UCqRjUdXlXJhZIf
	 T8gMPz1CwE8JIsyu5iAN6dyRoIL7y7gADNUYuOqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 215/312] mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()
Date: Tue,  6 Jan 2026 18:04:49 +0100
Message-ID: <20260106170555.619331439@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 915a2453d824a9b6bf724e3f970d86ae1d092a61 upstream.

damon_test_set_attrs() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-13-sj@kernel.org
Fixes: aa13779be6b7 ("mm/damon/core-test: add a test for damon_set_attrs()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -445,6 +445,9 @@ static void damon_test_set_attrs(struct
 		.sample_interval = 5000, .aggr_interval = 100000,};
 	struct damon_attrs invalid_attrs;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &valid_attrs), 0);
 
 	invalid_attrs = valid_attrs;


