Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B851E1DFC;
	Tue,  6 Jan 2026 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721090; cv=none; b=cS1RyA6d1sa5wCzeITaZzAN6kNtY2HmaBe0uvxtcf7ALDdJbFb4Z67g+1OjXABXBFKwJN3MjPX8uAGqCFbukHsTIrEkC1QRSeKty15Rqd8BtNrcZVynd7XW+06dHG7DpIf8YoRRthqrgSSrsZsK8JnsNitGEYaq/zv5qSeDjhhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721090; c=relaxed/simple;
	bh=HUwk31wNMJFRMoSbSG/2c/c+65QGU7Do49B0hx3LvIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaRVKldibRVQkuHgLWZ3qlBVlI6HrEsP6AQ7dSsd+W0zsbtLQye7YALRsxyeRuI1RlnKiM6+LcOiBNnIguHI8hLu+f4dHls1GlnPfcK6VxMlWGxdEw/Mw52oQlX1RE8D09pexBow+aDChayJPz+Y8zmy+6A/q5AiPW7rYp8h6hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjU7eZVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjU7eZVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664F3C116C6;
	Tue,  6 Jan 2026 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721089;
	bh=HUwk31wNMJFRMoSbSG/2c/c+65QGU7Do49B0hx3LvIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjU7eZVit1m45SHNDv3Xj0OXjs8CX1tD/2pB9nFINBGRvUJofm8hrisK/A6MNXAaR
	 xYdKowVW35s/RziCNBQIc3ZjdB2BgKG/DAlLqW6g9r7G1XH6BxqRDfaYBbUVQLZEEP
	 eFVfMVjeROtdz23nGBFhC77zEbIpXH3KDYjRgebI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 433/567] mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()
Date: Tue,  6 Jan 2026 18:03:35 +0100
Message-ID: <20260106170507.369222200@linuxfoundation.org>
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


