Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983EC36C0C8;
	Tue,  6 Jan 2026 17:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722278; cv=none; b=Wf+jRpBVhJLw9NdtC8NFPpOrt7i7Si1jIoOAexZnhpS+xCgb/TFuaHfQDl6x5lLZzaUxVy7drBXFXnH/ue2fFyqjXK8nHZ/VCPV7PY+16ydDd3OvEJqBQg1XjtwXRVUgO6BOxQ+wJTeXbN0lXCSj4SrtV8N5ZQR6Ws7Q7MLfc2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722278; c=relaxed/simple;
	bh=3sNxzPj5rFJx9FBU5fn3Cv6gcujmrGQ44W9L++O2QMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMK1yBPnjlNCu0IB5c6Ia7cnJaBQ2khCEoJg/JiBQMHYDh4K5BYM/DwplO0H2GsAouL6tLTeoMbfmtyj/cMX1L5ZJ+jMmFJjiYK915EhKhBpolh8aRnH17K+A4GiPbxf5xN5wSEloCcFHrtCeF41lwBQZoSAvVvUqrF5IawP3js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBDSvUD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBDSvUD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA767C116C6;
	Tue,  6 Jan 2026 17:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722278;
	bh=3sNxzPj5rFJx9FBU5fn3Cv6gcujmrGQ44W9L++O2QMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBDSvUD9Oh84Bvay4OBdZ8tno1JyOLOXTGs7AIiupcIMbsy4qrRK87uinHc1u5j4/
	 7dM1XBCmOXwC7rWzefcLarHUCDBPWfvrTbgitUVxN1XlDxEeeV/ePCkrk1rclOIyme
	 DIOOXzM1nYj4vPCMwu2G2Ekxiz0ESe4Q1XAstZW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 216/312] mm/damon/tests/core-kunit: handle alloc failure on damos_test_commit_filter()
Date: Tue,  6 Jan 2026 18:04:50 +0100
Message-ID: <20260106170555.656190020@linuxfoundation.org>
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

commit 3e5c4a1a1737bd79abaaa184233d0f815e62273b upstream.

damon_test_commit_filter() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-15-sj@kernel.org
Fixes: f6a4a150f1ec ("mm/damon/tests/core-kunit: add damos_commit_filter test")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -496,11 +496,16 @@ static void damos_test_new_filter(struct
 
 static void damos_test_commit_filter(struct kunit *test)
 {
-	struct damos_filter *src_filter = damos_new_filter(
-		DAMOS_FILTER_TYPE_ANON, true, true);
-	struct damos_filter *dst_filter = damos_new_filter(
-		DAMOS_FILTER_TYPE_ACTIVE, false, false);
+	struct damos_filter *src_filter, *dst_filter;
 
+	src_filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, true);
+	if (!src_filter)
+		kunit_skip(test, "src filter alloc fail");
+	dst_filter = damos_new_filter(DAMOS_FILTER_TYPE_ACTIVE, false, false);
+	if (!dst_filter) {
+		damos_destroy_filter(src_filter);
+		kunit_skip(test, "dst filter alloc fail");
+	}
 	damos_commit_filter(dst_filter, src_filter);
 	KUNIT_EXPECT_EQ(test, dst_filter->type, src_filter->type);
 	KUNIT_EXPECT_EQ(test, dst_filter->matching, src_filter->matching);


