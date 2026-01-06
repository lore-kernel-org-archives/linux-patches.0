Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404AA36D4ED;
	Tue,  6 Jan 2026 17:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722344; cv=none; b=casNfaa3/h/g3Vxd8s3PvOg79Ai4+DH/W9wR6Y4YkqNaqg8vK4kN6QjBXZxLf02p7ca8jFXXFi8Uhtk8QPCWD6i7lNWiMWc5BB5++6s3vJHsm3cPaWN+F2Z3Y73xSFlA1Rn7C5TbV/sWoRXB2I+3rVrAZrHe/Yk4qAY7mecR2IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722344; c=relaxed/simple;
	bh=mcMJc+9UHVYMWE1DeyGsXR6LM2Ymm6rlsLjFeWvtfgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHEVKug11GTsgacAPZQIpmbGUWce9uDEQLon5liZ5m6QHqKic/421ivSJe0kU6wcyMeki7zrq/1QEQzYXfRSwAB8FYhDqCuguStqVkapL9Chf8J1B48wBfS3sK2TZ33QFbsyJqPRIIfliEf+DxropFWlsf9j37wfYt0s3MGUtDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJKIXU48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJKIXU48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63304C19423;
	Tue,  6 Jan 2026 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722343;
	bh=mcMJc+9UHVYMWE1DeyGsXR6LM2Ymm6rlsLjFeWvtfgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJKIXU484AXDsW7mlNw+VLIDzxnNpkvg+tgksk+80DThdbllirzBQigNgb0ph7Lbb
	 QOuNn8Vq9SA5aEXeGXAfCaUo5g75slBIAKmHK7pNsaeehfLk8PeIdHeadPKNZX4alL
	 QdsNKy599cYCCx/gk7LbGvCwG6OSRCE1A24cUsxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 204/312] mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()
Date: Tue,  6 Jan 2026 18:04:38 +0100
Message-ID: <20260106170555.213390091@linuxfoundation.org>
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

commit 5e80d73f22043c59c8ad36452a3253937ed77955 upstream.

damon_test_split_at() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-6-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -124,8 +124,19 @@ static void damon_test_split_at(struct k
 	struct damon_target *t;
 	struct damon_region *r, *r_new;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 100);
+	if (!r) {
+		damon_destroy_ctx(c);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;


