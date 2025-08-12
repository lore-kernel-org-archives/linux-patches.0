Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA88926FA77;
	Tue, 12 Aug 2025 19:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026010; cv=none; b=M+rl2T3BShhsxwYiHjwTM522l/DP/DGxy1Vub47kVKhP3VTtQPo8Qg/CPonABjAsZFOUn6TXCCcSve7jcBVit72QnPjSy8kEYYGESJRSukfsFuqHXT7mD//IhdtAd9T5h4vGMv+LCITbPFlW1A/No3EjRu9ZZl+mgNdFCFc2s0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026010; c=relaxed/simple;
	bh=CNuR4CEPmzRIQtppZgaXLdooGhndLUpcpos0K1C/gwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7g3uzg4uQi4Nn/fzkYJU45PF3ULo16gVP3d2Q6pVj+JwrkYTwLmXnUHuY76R5qE2Jc/bQD4hJkf+olT/dKXq0RzE6DzuF2u91hjZJbpqje5j4X88jj7yr6OFv8zZhJnQASAyjAv/z1NCa6+xMHS9DPkDQE+U7lYEqdwM2MhnHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7+naSJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7+naSJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383F7C4CEF0;
	Tue, 12 Aug 2025 19:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026010;
	bh=CNuR4CEPmzRIQtppZgaXLdooGhndLUpcpos0K1C/gwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7+naSJD7ujfyaAiLG8XvYcklJ4IYyx+iuAhUMcYyyn8QonKVVNp5U9UUNodUgI0d
	 x+yZbmIbljm4dYaPJsn47SjNA0tRRH93gsgefSKeR7hgO0CcDgHzAzGxtzaCIowBj3
	 /h/zOupOXAdHsIBRQEhbW4lgfKADe0Ac17wEe/AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 210/480] stmmac: xsk: fix negative overflow of budget in zerocopy mode
Date: Tue, 12 Aug 2025 19:46:58 +0200
Message-ID: <20250812174406.127880953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 2764ab51d5f0e8c7d3b7043af426b1883e3bde1d ]

A negative overflow can happen when the budget number of descs are
consumed. as long as the budget is decreased to zero, it will again go
into while (budget-- > 0) statement and get decreased by one, so the
overflow issue can happen. It will lead to returning true whereas the
expected value should be false.

In this case where all the budget is used up, it means zc function
should return false to let the poll run again because normally we
might have more data to process. Without this patch, zc function would
return true instead.

Fixes: 132c32ee5bc0 ("net: stmmac: Add TX via XDP zero-copy socket")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20250723142327.85187-2-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1d716cee0cb1..77f800df6f37 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2585,7 +2585,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 	budget = min(budget, stmmac_tx_avail(priv, queue));
 
-	while (budget-- > 0) {
+	for (; budget > 0; budget--) {
 		struct stmmac_metadata_request meta_req;
 		struct xsk_tx_metadata *meta = NULL;
 		dma_addr_t dma_addr;
-- 
2.39.5



