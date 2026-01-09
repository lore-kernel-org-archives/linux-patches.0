Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D4435BDDB;
	Fri,  9 Jan 2026 12:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962878; cv=none; b=NndHD5TWHP5bK6C9KU2e3Sa3WasIrNm61H/mrf/Ex3vIBY/yP1xhIYApBXXrHgyGkrp3EtYlDFjXtG5Qb0d8iCqZ4dwixUne2TTMcXSOUG46TLwtXDCRj2XkIcJ4W0ly8Q8UkRmsdYvW6tCdKPh2mw2J9GpWyX9TsLtmWa1IKN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962878; c=relaxed/simple;
	bh=oC9TqyRypVH63q6tpcD9CSvmPnUyJhwQFmouiJE1+Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4oMEq/xjHJY4ZFyqJ5oyWHJLZeA6xqdMTTpWT+Fsye8dty1EesyaBMVdJHHsLnCJzfbPTLtg3iUAwLuNtyq3Ou20x+3SqKhDzSA8t7GtlWMjhZyuRrfLdH+Asq3UA+yhke/fAHnB9iD9Xh+UGK2htQsJcBmAnGevpooUdZts0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ejip169I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ejip169I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D5CC4CEF1;
	Fri,  9 Jan 2026 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962877;
	bh=oC9TqyRypVH63q6tpcD9CSvmPnUyJhwQFmouiJE1+Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ejip169I1/00l9/GsIe6Yz+QBnNS3OjYPwHHG5RbSl8hS/gyfIZbMX23J9KuAuBNH
	 QenCBG8UhiQyzRctdsev8pzsSUrJIIEmsQZKw1zzVhe05sYaFk5wPa72SmyF64jOEu
	 HFF8Qbf1TVXYcATm7HQTFWApaIYZMsu18ew2oP44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 518/634] mm/damon/tests/core-kunit: handle allocation failures in damon_test_regions()
Date: Fri,  9 Jan 2026 12:43:16 +0100
Message-ID: <20260109112137.049622388@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit e16fdd4f754048d6e23c56bd8d920b71e41e3777 upstream.

damon_test_regions() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-3-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core-test.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -20,11 +20,17 @@ static void damon_test_regions(struct ku
 	struct damon_target *t;
 
 	r = damon_new_region(1, 2);
+	if (!r)
+		kunit_skip(test, "region alloc fail");
 	KUNIT_EXPECT_EQ(test, 1ul, r->ar.start);
 	KUNIT_EXPECT_EQ(test, 2ul, r->ar.end);
 	KUNIT_EXPECT_EQ(test, 0u, r->nr_accesses);
 
 	t = damon_new_target();
+	if (!t) {
+		damon_free_region(r);
+		kunit_skip(test, "target alloc fail");
+	}
 	KUNIT_EXPECT_EQ(test, 0u, damon_nr_regions(t));
 
 	damon_add_region(r, t);


