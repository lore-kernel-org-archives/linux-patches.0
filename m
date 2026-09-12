Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD15357D10;
	Sat, 12 Sep 2026 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238953; cv=none; b=KOpkMl8J3P56DHasQ/7shHifT5ZX97KMIm8OlS0EEuvDx9/NWBlGBnCNwWBXHBw3rLDM4KsyL/VQB3LfefFbXGyuv4OGW6htaez6eQe06oe3PLkKUTElOsox6OjNCZGlzZfgMRDI58TWg1yFhq7D6occGukHWwzubmyxekachuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238953; c=relaxed/simple;
	bh=K2y2KzXAFKjcyX7L1OvX1B5Cc/Pnm/g+pk7wlHkMTYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtdPNb67WorbUbQMOt15NfogPL6YErHcZl7DPQEdYiiIfBUaZau0NYD4nsTymn058eRunJ9SZULXSlqo89JX5eJHHLY5FKFdjNZeWdI5P4/X2juU+vXVw5nlwSFfyajVS4WoAlO52Ffgok0WoMfzJxWXGIqRYqa8pTDj/cktIfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQxMH9I9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQxMH9I9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB061F000FF;
	Sat, 12 Sep 2026 18:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238951;
	bh=6UfX7oabl0z3mFF5rRV9DPdMIhgr2ew/gkZYarZiUwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQxMH9I9pdLeudId0BSY0gnIUSqafgAurDMWoLSK0oIhSaHnTUIRZfbfglYMx3AqH
	 cStlsH9KxrV8Cu/r5zQBWW1QcEyRHJXNkHqq6LjjlXGaNUevSlqws4a67Ry1kvX2DE
	 KPuVV9400w/SzERq/nDwbYgIoLa9ub9ghpNweOi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 565/935] RDMA/hfi1: Propagate sdma_txinit_ahg() errors
Date: Sat, 12 Sep 2026 08:59:55 +0200
Message-ID: <20260912065539.794298444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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



