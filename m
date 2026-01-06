Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF3E26E6F2;
	Tue,  6 Jan 2026 17:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720784; cv=none; b=URapCePbDyi9XXFjuPkiJr0j3MlxVA1mxvvGSB7iSkSGj+5SMKE9uiFv0WVl2JRi1NcW8feuLlt9z0WhVw4a31SR5wphxGtdyicUH3Wl1y1ubO8ICzVUgYwPY8aCIeZYGIuBm1fKoR03GRs17F028sPX1/m+0zz2bqXKcI1tUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720784; c=relaxed/simple;
	bh=fY8wKI1QdO63+7/ICiV5wXuuNP0Ary/DzcaOrrfAPvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYANevBEtdDzW1D0DnqhGB03gouKyh0zCY2mOAA2p0/UHIxq1W9oM/c4oSECHEupejtOG3DwfSVCLxKnQgIusnUsTGsqZZaBSWJU0Uo/KwIRGZuLUpxuFIqtsT/K7ubaCT6C8DbH8MBDHN/H8Z2/amY+APFSSmo/YbOhcg+aOQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03pb1/A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03pb1/A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC624C116C6;
	Tue,  6 Jan 2026 17:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720784;
	bh=fY8wKI1QdO63+7/ICiV5wXuuNP0Ary/DzcaOrrfAPvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03pb1/A5jENX3QQ7684NFjHg2q39YaWKhHgn/xvoABVUHrhyHFbxtStx0yoTQhsxu
	 GWksrRHk7HJW4NEuZcUba/Fo7W++zfgmaij0WwIrvvgGSlnolAdd0nH9fghYA5wMsz
	 r8vFoFUpSNR0s7DynQpjrbeUNEveNtK/n5X3A4mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/567] RDMA/rtrs: Fix clt_path::max_pages_per_mr calculation
Date: Tue,  6 Jan 2026 18:02:02 +0100
Message-ID: <20260106170503.905068198@linuxfoundation.org>
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
index 71387811b281..2b397a544cb9 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1464,6 +1464,7 @@ static void query_fast_reg_mode(struct rtrs_clt_path *clt_path)
 	mr_page_shift      = max(12, ffs(ib_dev->attrs.page_size_cap) - 1);
 	max_pages_per_mr   = ib_dev->attrs.max_mr_size;
 	do_div(max_pages_per_mr, (1ull << mr_page_shift));
+	max_pages_per_mr = min_not_zero((u32)max_pages_per_mr, U32_MAX);
 	clt_path->max_pages_per_mr =
 		min3(clt_path->max_pages_per_mr, (u32)max_pages_per_mr,
 		     ib_dev->attrs.max_fast_reg_page_list_len);
-- 
2.51.0



