Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CD941E6DB;
	Sat, 12 Sep 2026 10:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207773; cv=none; b=vBRaYR0bMW3wtQ4VWECuTEnZ035J9dXiY+ILKMy4SGSdd6lp0rAys+Lkr6WBjLoOkCzslXyMaTtlzbZAaNcqyAdjwhIk8FvIpqslPqFtUpGBxFvNmtJmxn51Qvf6Lvv/NelDYFByQwqvc4y9b1medLmv4kf3OyvtD35O06JJeYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207773; c=relaxed/simple;
	bh=NStHtwP7GNXld1GnQ64lEZKXraIH8T0gyJRwpQo43MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smQs+trrqY7Mjt/sd/KQk4tDjpnHLvcoH1xrg/oqnBncwOj4MXl/5xn/SgHpDqMsFPN5mYqB2R+1y56yIHCw+a616fIi1IbSJ+uC4NycVz+UA5A+QteDw5cFqNmpjiEfgFYJWQA4MDX3bPEbQNJT0h4DnTpZkkHcltamvLOI2FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5fXcrwF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5fXcrwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9901A1F000FF;
	Sat, 12 Sep 2026 10:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207770;
	bh=dD+6Vt3Db5ZwBCLEzfW9PrNlBaYJnj2Q3XUew5s7prE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5fXcrwFCjWt4+Gw9c+uDxv3xMl7m3HQlFlG+Y87pj16BPiarpn6MPWJT3D32h4xi
	 PE2D9PhnHTf9eBHoR8TL6NUwlARpCrWCurUpuoNX9ejbvjkRU/LfTv5ZECw1HqF4Ne
	 P6DfP9TkCpHCrH2z+qXtKBHwZP4NtVJRs6D4gTZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0481/1518] RDMA/hfi1: Propagate sdma_txinit_ahg() errors
Date: Sat, 12 Sep 2026 08:44:10 +0200
Message-ID: <20260912065634.328063771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 091c6162c022cbdfb64219708a71728cfd1d4600 ]

set_txreq_header_ahg() ignores the return value of sdma_txinit_ahg().

If sdma_txinit_ahg() fails, it returns before initializing tx->txreq.
However, set_txreq_header_ahg() ignores the error and returns the AHG
change count, causing the caller to continue processing the request as
though initialization had succeeded.

Propagate sdma_txinit_ahg() failures to the caller and abort request
processing when initialization fails.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e3304b7cc4f1 ("IB/hfi1: Optimize cachelines for user SDMA request structure")
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Link: https://patch.msgid.link/20260708162252.936634-1-listdansp@mail.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 9b1aece1b0800..ae8ff7d5a37ce 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1028,6 +1028,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 				struct user_sdma_txreq *tx, u32 datalen)
 {
 	u32 ahg[AHG_KDETH_ARRAY_SIZE];
+	int ret;
 	int idx = 0;
 	u8 omfactor; /* KDETH.OM */
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
@@ -1132,11 +1133,13 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 	trace_hfi1_sdma_user_header_ahg(pq->dd, pq->ctxt, pq->subctxt,
 					req->info.comp_idx, req->sde->this_idx,
 					req->ahg_idx, ahg, idx, tidval);
-	sdma_txinit_ahg(&tx->txreq,
-			SDMA_TXREQ_F_USE_AHG,
-			datalen, req->ahg_idx, idx,
-			ahg, sizeof(req->hdr),
-			user_sdma_txreq_cb);
+	ret = sdma_txinit_ahg(&tx->txreq,
+				SDMA_TXREQ_F_USE_AHG,
+				datalen, req->ahg_idx, idx,
+				ahg, sizeof(req->hdr),
+				user_sdma_txreq_cb);
+	if (ret)
+		return ret;
 
 	return idx;
 }
-- 
2.53.0



