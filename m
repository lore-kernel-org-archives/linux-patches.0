Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D68335BCD;
	Fri,  9 Jan 2026 12:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962643; cv=none; b=TLpN48EqUoxra/PWcoWoQe8JQa4nAh3AnAq/NtN/xbYx0SSy9IeSiS9cPlaaxs8lu5+OkQyfYs99rXpd34a3RjE7EEItcKr3NQbAZBUeKthGm7P/mN5VVq2LYCtZE+R9q8U27iVKgveMCIUY83WYZRestaJDroy6dDCKlAsBVAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962643; c=relaxed/simple;
	bh=ZftGsgRNAPAGNTEGYOFpd9AyJolWjDY3hsnCmXBNTls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTTBij8lXV+5RA9QzGX1FBoxFy+RqVGHgs6mLCg5lGvOJxNOk2X5uQ0H1pzDp3Y+qg2HwYijjJxEhPE/Gf+6bzi+vbxW5Bk921hC5kFcX3VNYQZSBEP2AcuR/K3DdVsFD9cm0CmOXcfvCG5mvU/zetz84Mco8usDErZa/5mfkIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r78hMEDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r78hMEDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24F7C4CEF1;
	Fri,  9 Jan 2026 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962643;
	bh=ZftGsgRNAPAGNTEGYOFpd9AyJolWjDY3hsnCmXBNTls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r78hMEDWYOwm/EsILHVpR0KioVZ15gmwdGyfkO0Aqp1pkk5d1oicZ3MuBvW2MEeOe
	 A0rq9jOB7FTeowhkSKvPHf/LXS1yuqIhg5XmJ/VoyNcZttckspU4jrwzjHvW8PoeWA
	 djlgX21ko5EIwmo3pXF94aT18/j7h0gWeVJUvXmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 437/634] RDMA/rtrs: Fix clt_path::max_pages_per_mr calculation
Date: Fri,  9 Jan 2026 12:41:55 +0100
Message-ID: <20260109112133.985209456@linuxfoundation.org>
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
index dac8ddfc89e7..7c81452d73cf 100644
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



