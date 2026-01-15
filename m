Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FA73D1CDA;
	Thu, 15 Jan 2026 17:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498403; cv=none; b=D6dtZxNCsoB83O8RKJMwsk90vfEdB9qPAeehginv86JRjL+eGUjsOgPT1XrLNkifvXlRrMBhqUIjDymJq503r9yYML+oJS0Zd6+lmkhKGC+Fg3URD2wrZrTvZ/I+e4WU5avLzfkdoVP0j6/8aeZyR3vXQ733XJ928C8YWSA8fQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498403; c=relaxed/simple;
	bh=epW6DfGnN/fJJhRI0W8i4/Vp0OlaEBb1tmcr/TdjFEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cW78gRUoUjp7O/XfV83KDx4ldWlRp2ijEwRrkAoiQSIjK92P4WWN60rE8tgpaVNB1DszypvAkDWdQxPDgfDXwBXzV4xwuLTbybSjjtoTqT6hZ1R5T9E/eGf/VlAeeED0LGDhoi9HpThxoxCsl5ZDUSpA6dECGEUXF/QkXeMhmpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSvoF0P7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSvoF0P7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D577C116D0;
	Thu, 15 Jan 2026 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498402;
	bh=epW6DfGnN/fJJhRI0W8i4/Vp0OlaEBb1tmcr/TdjFEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSvoF0P7dfcs2N+J7d5s3B81mDvdRC/L/6mrJ44akSyxnHrgz2N/BvO2i0YZHk3/Q
	 hSt/EPdsT0zcRDDli5K1X4cwTCC100fIIUsbsSChbacp6eT8HRAftBa9PHJhupXV0B
	 gxNI7B6S3k4v8jTOucU9K+GNYIfiL2m1EKlCTrOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 418/554] mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()
Date: Thu, 15 Jan 2026 17:48:04 +0100
Message-ID: <20260115164301.372523796@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 0998d2757218771c59d5ca59ccf13d1542a38f17 upstream.

damon_test_merge_regions_of() is assuming all dynamic memory allocation in
it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-8-sj@kernel.org
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
@@ -209,8 +209,14 @@ static void damon_test_merge_regions_of(
 	int i;
 
 	t = damon_new_target(42);
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
 		r->nr_accesses = nrs[i];
 		damon_add_region(r, t);
 	}


