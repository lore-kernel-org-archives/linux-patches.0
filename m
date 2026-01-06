Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C7D357A50;
	Tue,  6 Jan 2026 17:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722258; cv=none; b=Or2bboYfcK5PkS+hjwmWQb1nIJzaVdx072TpTyZbRza6IUK191sSLLYfuD9UjeSgwa0TcQmHQOdIpYn0WnLqhfFQ1ub4r2qCmapeu+/RYWt4LdlmWRGiDLhhCAqOH75Qd+rX4AdYnNyiFEFZ95YQYKUIPme/B3uc29BeWwAdsls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722258; c=relaxed/simple;
	bh=eg7O+KpQzgGvcXo7XM9YolpqRPi4HGC36D3rWVbXpqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgpOEquYPUSacQATzVc0zbdEdmljA9d/H0L+l52MVbSAgeuv6bhlgqtq1p6Ib1Uw1Hx7tRkNVpMtBOd4LM7gXg9Gjh0BtdqcNuBE6+FJTCrcXkRK3Pkh5r9+8uWv/RNIFdwpDnenGVETIAJraWij/K6I8oVnIvLQwjzfn8EVkFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqLAJ0hf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqLAJ0hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B34C116C6;
	Tue,  6 Jan 2026 17:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722258;
	bh=eg7O+KpQzgGvcXo7XM9YolpqRPi4HGC36D3rWVbXpqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqLAJ0hf8XAPcFltkTVdHMRJU60jLCsYJRUscdPDV991xQQF/yj6lDcwOoj91E3CG
	 g/1/ZkUr0hjmdaZ8jXQQyZ2PAAb5WdLOSqcxyWkAdj3Q4sPkpBMXIRddk/eBUXThLw
	 +HULzMrXagxHkN3JwNGohSpsdrnp3f4Sn1l3Mh0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 211/312] mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()
Date: Tue,  6 Jan 2026 18:04:45 +0100
Message-ID: <20260106170555.471912869@linuxfoundation.org>
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

commit 8cf298c01b7fdb08eef5b6b26d0fe98d48134d72 upstream.

damon_test_update_monitoring_result() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen.
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-12-sj@kernel.org
Fixes: f4c978b6594b ("mm/damon/core-test: add a test for damon_update_monitoring_results()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -406,6 +406,9 @@ static void damon_test_update_monitoring
 	struct damon_attrs new_attrs;
 	struct damon_region *r = damon_new_region(3, 7);
 
+	if (!r)
+		kunit_skip(test, "region alloc fail");
+
 	r->nr_accesses = 15;
 	r->nr_accesses_bp = 150000;
 	r->age = 20;


