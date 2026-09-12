Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5061FC110;
	Sat, 12 Sep 2026 07:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199229; cv=none; b=TaiC/pQuaOC2HbTUGnmDvB7HS7v4/4Nyjk2O0pKjjdONlvG7/fVL4oZBswns9DDUtzqFVBTEdBMWu0omUDEpvbYNiSSMDc7DkeJiR88kvGYpCM02hfQznx3EpSsemYIrcMaW8rczkdbzAWiGUCkNONpLnzZbMRw7OXdq19zhVNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199229; c=relaxed/simple;
	bh=xzwWhElZdJHm432fXE+8m9IxdyBiOyyCKl3ktrnbZBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8hS1nng4lbdNPWff2HnsBplN4V0UdDRuPGp2B1r3p6xF3rucTs/KTjQ/n7S0UmmlRhDOzI8OqqSintP87uP1QUEo0GBKyg3/J3/HynVud5P6NRcbO74i76ajRjte9X9rfyKynwaVsSQa8PGZOx9aSgwi1aDoDkZAPuTj1+EY5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrJlOz3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrJlOz3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEF11F000FF;
	Sat, 12 Sep 2026 07:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199228;
	bh=DfmlG+p8pcShRwv2JOaZis8unVY9eB1eDaegZF39/0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrJlOz3T9YyDkB9+YEyg2kD4SEcwvPoPp/bdKJVv+DZzYHSYIU/ZhTE+b6/7+4fhI
	 cxO7Mkil4HWxpB0dro5lhLR3eSS++u/QyLgGS05Qya1k/vzCz1XcA9P22JM9FYrrdv
	 CTMgomQzA9D8vgq+09aLuXQeffiyQMZrBWGn8RKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0540/1815] RDMA/hfi1: Propagate sdma_txinit_ahg() errors
Date: Sat, 12 Sep 2026 08:38:10 +0200
Message-ID: <20260912065701.558663340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8ea5ed918a028..be6b82ba93afc 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1026,6 +1026,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 				struct user_sdma_txreq *tx, u32 datalen)
 {
 	u32 ahg[AHG_KDETH_ARRAY_SIZE];
+	int ret;
 	int idx = 0;
 	u8 omfactor; /* KDETH.OM */
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
@@ -1130,11 +1131,13 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
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



