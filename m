Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2BC35C1A7;
	Tue,  6 Jan 2026 17:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721557; cv=none; b=fkzm80gXblxStAGIFtC8vVMCRp6oM9h2UYoqCnn1G3nI7VGO8bRrV/8shrbUaFzUQGXHkB+xucrwok1XQWRRw8EZekPbnzA10wb+eRisiIqggfTzu7L9pn4j8P/x2HU8IxfRFa1j3RoO5FxpYavqgh4eTUxIOuEAdqW7X9yf/To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721557; c=relaxed/simple;
	bh=Ykt7qzcZ/Wb7uY9FBPhkBeJRTp56vhLEMqxTVNTrKEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2s8BSJTZaOPR5sqdw6EXiI/BXSXbIjI6g6A8b66I4/YHgeGJRk0deBFDIAP/GxhIQNI/KllhhUePOM5pLKyrMnOSEaw6ecxuSBXWwr36uhJCV+OOsqox3xbykRaBVRpZU+Nug7vP23uqqPyyiHVgjMmaAQS4oA0+mRzICJMiOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoOEwfNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoOEwfNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C5AC116C6;
	Tue,  6 Jan 2026 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721556;
	bh=Ykt7qzcZ/Wb7uY9FBPhkBeJRTp56vhLEMqxTVNTrKEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoOEwfNC81PbSDNpnM4I6sSt2ruwsE8IktPAMrainZm2IKRXrPizjivs2PucQ4t9e
	 A8/aLtPkwM4+PkfTN0aB5WGycblV3hdMhgzU+1BMvxNtp6ZdITAeJnFhk0bHpXZXKS
	 LLhBbZqhUxWy5ZNVg7fU3tPvQoTIObPTBxZ6o8+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 564/567] mm/damon/tests/core-kunit: handle alloc failres in damon_test_new_filter()
Date: Tue,  6 Jan 2026 18:05:46 +0100
Message-ID: <20260106170512.297289759@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -505,6 +505,8 @@ static void damos_test_new_filter(struct
 	struct damos_filter *filter;
 
 	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+	if (!filter)
+		kunit_skip(test, "filter alloc fail");
 	KUNIT_EXPECT_EQ(test, filter->type, DAMOS_FILTER_TYPE_ANON);
 	KUNIT_EXPECT_EQ(test, filter->matching, true);
 	KUNIT_EXPECT_PTR_EQ(test, filter->list.prev, &filter->list);


