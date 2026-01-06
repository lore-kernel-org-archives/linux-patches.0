Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03D636CE1D;
	Tue,  6 Jan 2026 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722341; cv=none; b=K9yxqb4FHVFPbYGUblJYXYg4anmLE6LmtM15tXWNDC+ar+TBTo6a7t/5hBDDR/89e97rMEQf+Z5sRDa9Vx7UkxCXy64M9LTjKpIPt0J74C7tsb/XNwkPZqFiuZAnf4HcoQbE70FU9cNK0v8aEcJi52cx+YKFtvBzuj3LeIVP9OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722341; c=relaxed/simple;
	bh=ujyMk63gvXWuz7JABW29ceRrY4Er/e8XHUYeY5fZyYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFq5Ks0A/6vJMBGUCNLtHa8K8TwMLF6t0E9GVlqt3ADkqsGWd87TxrkT/FYGXWy6AFTiPKDcm9IVWdJiOhzRGM9+Frr05DmhLS8u+IfnC3PpHwuJd4+jIe8At9gyerKH7cGG6KzJa4fgXuyvsN5nIuwNO3IPOM1KRgPG2clI6rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obec4VE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obec4VE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56775C116C6;
	Tue,  6 Jan 2026 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722340;
	bh=ujyMk63gvXWuz7JABW29ceRrY4Er/e8XHUYeY5fZyYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obec4VE6SC67xb8aoxVkI0dUy/+frz9Ee2wUk+hI9TGLGQOCHGInGEymJkwoVxaTh
	 +tV0ovKKTN1qLalEoPsfAvJcgxVjWxX8GOA55Ul0xZEyIYqnbwiZwWV1SBIzbyEn02
	 6xb4IWhsy0M9DU3l0Nk56UI6WVwO0XKM30wmCbEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 203/312] mm/damon/tests/core-kunit: handle alloc failres in damon_test_new_filter()
Date: Tue,  6 Jan 2026 18:04:37 +0100
Message-ID: <20260106170555.176618270@linuxfoundation.org>
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

commit 28ab2265e9422ccd81e4beafc0ace90f78de04c4 upstream.

damon_test_new_filter() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-14-sj@kernel.org
Fixes: 2a158e956b98 ("mm/damon/core-test: add a test for damos_new_filter()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -412,6 +412,8 @@ static void damos_test_new_filter(struct
 	struct damos_filter *filter;
 
 	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, false);
+	if (!filter)
+		kunit_skip(test, "filter alloc fail");
 	KUNIT_EXPECT_EQ(test, filter->type, DAMOS_FILTER_TYPE_ANON);
 	KUNIT_EXPECT_EQ(test, filter->matching, true);
 	KUNIT_EXPECT_PTR_EQ(test, filter->list.prev, &filter->list);


