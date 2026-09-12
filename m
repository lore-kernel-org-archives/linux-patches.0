Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6443E309EF2;
	Sat, 12 Sep 2026 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229823; cv=none; b=J5AY9nTpB7TSc7fdUahSgfX03PohpD4KFF2FjdWtuChIDau05ZPhNuFz5sZu12IH6lYNXRW95LCMZWJAKvmc1a6SDakgg+2XSrK6TVUqgNSSIXd6OBZCt682cZRck38tOh8wrYYBuO00OXHkp8oTuwkgnY8WL+Rp59BuZu/c/44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229823; c=relaxed/simple;
	bh=aqpLfINxNaaK4sZl059kZKbulNsP1G2VevznhUTyvEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stNuQKuhx4GJxEwN+2aKwpVXs35x9ykg9kvYjyM7YVM3+fq/CfrJq/CkwuPWHqK5lSz1mHEgvRTdOxN+NTK2HrLOSfUVSgMJtC91UzEUOwmOJxZOffxRa3nydFJtMnWhP05ZXL8WFDdyl9+VgeQFukz+iwd5llh0T2q/UM1AB9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAy/zDla; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAy/zDla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EB51F000FF;
	Sat, 12 Sep 2026 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229820;
	bh=EoSyzG4air+wWhcHQl8xhgwmy1OrzS3Qv34q+ZLHJgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAy/zDlalK5b6KVvUJ/bnZ/KqT25mi5uDeR1x4ddOO5J+7OJF+wju+5A1rHO2nq5R
	 BaixbrL/zOk5Vl/EBeBMyiQstX9RciP4HL0nYOYq7P4Gao5OZb7PaycbhpoUK2epqf
	 ++U586mxXo8k+iNjYlWXtOlMvNV2MdpAA82uQvjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0668/1191] RDMA/hfi1: Propagate sdma_txinit_ahg() errors
Date: Sat, 12 Sep 2026 08:56:36 +0200
Message-ID: <20260912065603.259151501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 02bd62b857b75..b04e079490b76 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1059,6 +1059,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 				struct user_sdma_txreq *tx, u32 datalen)
 {
 	u32 ahg[AHG_KDETH_ARRAY_SIZE];
+	int ret;
 	int idx = 0;
 	u8 omfactor; /* KDETH.OM */
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
@@ -1163,11 +1164,13 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
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



