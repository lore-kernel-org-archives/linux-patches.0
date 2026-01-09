Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A622359F8C;
	Fri,  9 Jan 2026 12:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960914; cv=none; b=WrUdFxYAGwa0O+4ywjdgMwE+hk4ua8hwrmY1yrq0Q9NJ96FKSuJhHpUan66n2kVorZtqlzGmSt1fY1saFUrRRwCIWE+yv8QeWVV3kAt8qq/LDOWgB4i7WK9Po7s+iXmiPIoNgKvMEeJso1rdRBk24Ee67Gs5Yx9gh2UhJDBCIDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960914; c=relaxed/simple;
	bh=pbgMsS581G9G9blVxPSwugjtB5eQg2LmOKAkDp3Kmnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyesZIBGg+MjheXlzLApGoLVWrFV0qPb3V3/mi1wrXe/n90csF9o7foAAQw8yUYPVRi89SLHMiWLsjxtEgiReYWKYKKZr8UGicAkhiy73rUb+pn9P4j0oCA8/c4hSCE9A61ndHw8kHqLdsZ+SQ0rwiDhBUsiVpxdFCXXvzA/FZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvA2FSti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvA2FSti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB168C4CEF1;
	Fri,  9 Jan 2026 12:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960914;
	bh=pbgMsS581G9G9blVxPSwugjtB5eQg2LmOKAkDp3Kmnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvA2FSti3kPvmZJB0l3ZFCstobuPkU2NZbueq0Iui8Kra3/VNo8AboX0L/q4YBe01
	 /mhn53NCGNNQsREQuOajAKECsT75hhs+CUkhxanksP7VXueEF9RCtazbGMlhR04OXu
	 olaGfsNsNqlawLlgrfncbcGJRMbONi2duk+k9bF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 536/737] RDMA/rtrs: Fix clt_path::max_pages_per_mr calculation
Date: Fri,  9 Jan 2026 12:41:15 +0100
Message-ID: <20260109112154.158663118@linuxfoundation.org>
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

From: Honggang LI <honggangli@163.com>

[ Upstream commit 43bd09d5b750f700499ae8ec45fd41a4c48673e6 ]

If device max_mr_size bits in the range [mr_page_shift+31:mr_page_shift]
are zero, the `min3` function will set clt_path::max_pages_per_mr to
zero.

`alloc_path_reqs` will pass zero, which is invalid, as the third parameter
to `ib_alloc_mr`.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://patch.msgid.link/20251229025617.13241-1-honggangli@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 82aa47efb807..eaf911e2ffa9 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1465,6 +1465,7 @@ static void query_fast_reg_mode(struct rtrs_clt_path *clt_path)
 	mr_page_shift      = max(12, ffs(ib_dev->attrs.page_size_cap) - 1);
 	max_pages_per_mr   = ib_dev->attrs.max_mr_size;
 	do_div(max_pages_per_mr, (1ull << mr_page_shift));
+	max_pages_per_mr = min_not_zero((u32)max_pages_per_mr, U32_MAX);
 	clt_path->max_pages_per_mr =
 		min3(clt_path->max_pages_per_mr, (u32)max_pages_per_mr,
 		     ib_dev->attrs.max_fast_reg_page_list_len);
-- 
2.51.0



