Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC2515ADB4;
	Fri,  9 Jan 2026 12:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961369; cv=none; b=kTZBhKTeyDXFXsMzAlKbage+tQuywjAvO/NKNRWis3Svimv7eMGCS8X+ls2fPbVKuxNuSk+6D8xfg1Ee6OlUhZ+vwCIbh7hhWDCT9ekt+2d6HqnwUqcJMd6zush/S83pRyCuyMbArrB0Wz4PBBPeiKb7BGNupCuATBfCneQ19H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961369; c=relaxed/simple;
	bh=6o6opTAy12UVqvLeUysvUtjNqis+16t9IcM2/Tbt2tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRUmQam+BjBfpt+DWBzkfv+EN0OMr2EPoE1g4oOo85FFJXU/9uA6PY2oCRkiWWjJtaGQHb7WC4xtpumS5/J5wAX1d1jRwGUMYYx0SU9AFJRmwh+FbPqGJIqKcihhcneTN9UqjjSluRPD0ysI3ddghPmnaWplgZkUYJznOFxEd/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwPNTzWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwPNTzWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92297C4CEF1;
	Fri,  9 Jan 2026 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961369;
	bh=6o6opTAy12UVqvLeUysvUtjNqis+16t9IcM2/Tbt2tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwPNTzWOKAlFPcT5VNqoNdZPCtKhQekfhoYGAiR6MGRY4wpja6Ick60toITuoBY+P
	 t2aegwIoI9tzqTU67HH8bRK+KDrBWe22BlvymQFQCHMxWfeaJSx12P9yARzEdhDic0
	 uOTJHLMf896r1moFBuhOlLFtG8XLAx6leyH2S530=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 728/737] mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()
Date: Fri,  9 Jan 2026 12:44:27 +0100
Message-ID: <20260109112201.489727629@linuxfoundation.org>
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
 mm/damon/core-test.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -413,6 +413,9 @@ static void damon_test_set_attrs(struct
 		.sample_interval = 5000, .aggr_interval = 100000,};
 	struct damon_attrs invalid_attrs;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &valid_attrs), 0);
 
 	invalid_attrs = valid_attrs;


