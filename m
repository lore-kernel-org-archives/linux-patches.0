Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496132737EE;
	Fri,  9 Jan 2026 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961366; cv=none; b=FMzYTfwBq5W3rKipEJuF2M6ge1AnIOggMIz6DKTN2tud1u+2YSjN34K4ewGRm1jUrvN+HVLWq/mxwd/ctKzGFsVbdbLcltxLVgKFTMQk86T2awSfkafxKG9zZpjFaMxJVZdGKf/TdKwHlkhCxOKktxp7PuRu0JcRhwdno/gFe8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961366; c=relaxed/simple;
	bh=dmDHAPWscGXhu5UhFlZHaBGiNILzhzq/rPBm25D+5Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3l9Qq0EJtPVtO2ekE1ciS7kxkZLkIshaHGa8mLtF5J//FsJh/vLCWLgU9Tkrb4pishKzzqsPJUExqx5jbl9EIVummDGRGRtWKmVgeIymZtWROymM7evsieT61HGnvI5i/c6pILvaRWIRGa0xLD9fE4+BQkjgW7GEMzyLQxlPUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhAAahSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhAAahSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87BDC4CEF1;
	Fri,  9 Jan 2026 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961366;
	bh=dmDHAPWscGXhu5UhFlZHaBGiNILzhzq/rPBm25D+5Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhAAahSLomzNA7+h6sCd/rEZAmPrRbE+8d2DdMVTMSC2RKFca0lrsrt7BTtQiesNd
	 mVs9EF/O+GRYcdZk13vlzqaX82bawGmmejKG9hM0LohEtDd/rLMgKBzlLOBdZEZxHQ
	 dhmmBokDWfCBVaNFIX6/i8jcJjv2n+axaTV75R5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 727/737] mm/damon/tests/core-kunit: handle alloc failures in damon_test_ops_registration()
Date: Fri,  9 Jan 2026 12:44:26 +0100
Message-ID: <20260109112201.451315088@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 4f835f4e8c863985f15abd69db033c2f66546094 upstream.

damon_test_ops_registration() is assuming all dynamic memory allocation in
it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-10-sj@kernel.org
Fixes: 4f540f5ab4f2 ("mm/damon/core-test: add a kunit test case for ops registration")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core-test.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -308,6 +308,9 @@ static void damon_test_ops_registration(
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_operations ops, bak;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	/* DAMON_OPS_{V,P}ADDR are registered on subsys_initcall */
 	KUNIT_EXPECT_EQ(test, damon_select_ops(c, DAMON_OPS_VADDR), 0);
 	KUNIT_EXPECT_EQ(test, damon_select_ops(c, DAMON_OPS_PADDR), 0);


