Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EB23BFE43;
	Thu, 15 Jan 2026 17:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498249; cv=none; b=nbPDMw4pn7m/xBSgTMIRWaKCeBtLDRPjOqtP1+jLnv3HKEBmXYrgat6yo7wULrjiviVKiIimYB0YIvBYbDB+AizVTKUkv4jDHNicKqdALHXHCAUsb/urmlXlNnbzRsuUxD5fPqhan8x64Bhbwtc4+EoG/6DBbaYFyCJmYwZqN+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498249; c=relaxed/simple;
	bh=kFYh4SE7VRIwiNxf9NKDxPKm9vSHKd8PYmhCdgk7wZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEtWgY8Mus5UiXXkyoYqmITSJlQC09fOOb2R7Dp84hklXoKvDL9LzDgCJ0BPP4zbrs97EFSNFc0gP8WHNlfmOJjrbGcYSfgwat26IzsYi+cjlw8R3W+VB2AqjNPEWbspYHBi9Zo2i1kNfndNn44JxaE0huYIsCzMtcqYijlTIYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxBWP6Ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxBWP6Ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1403FC116D0;
	Thu, 15 Jan 2026 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498249;
	bh=kFYh4SE7VRIwiNxf9NKDxPKm9vSHKd8PYmhCdgk7wZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxBWP6MaHm9UPO+XETJ6P+iKByJSpUdgy7jIDSnI7TYMQLb0nuPpMMcLXIr8iv3Us
	 y3pMEU+PfJ8mtKiwLbzPZ3LITx0Tv60QFI3qTonBhrC7dRF6W0eUAbnzcly2UTSdyS
	 H1uJ0QleQ3pjmNMXVbpbXcLDeTWL4uCxhOH1Qxk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 366/554] RDMA/rtrs: Fix clt_path::max_pages_per_mr calculation
Date: Thu, 15 Jan 2026 17:47:12 +0100
Message-ID: <20260115164259.473531990@linuxfoundation.org>
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
index e8f5a1f104cf..cda7849e2133 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1469,6 +1469,7 @@ static void query_fast_reg_mode(struct rtrs_clt_path *clt_path)
 	mr_page_shift      = max(12, ffs(ib_dev->attrs.page_size_cap) - 1);
 	max_pages_per_mr   = ib_dev->attrs.max_mr_size;
 	do_div(max_pages_per_mr, (1ull << mr_page_shift));
+	max_pages_per_mr = min_not_zero((u32)max_pages_per_mr, U32_MAX);
 	clt_path->max_pages_per_mr =
 		min3(clt_path->max_pages_per_mr, (u32)max_pages_per_mr,
 		     ib_dev->attrs.max_fast_reg_page_list_len);
-- 
2.51.0



