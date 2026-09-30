Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D1B51DE16;
	Wed, 30 Sep 2026 18:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793184; cv=none; b=pVXSdLbECp1nqBkIuyFif95k9pUfvsPYONq/63AlWMYWyK9pMTfTPf+6Od2d/hL/qojJDdBlye/JEQ9qZ8m9RbEgCbnwzmgvA2DVqQm4YyfPzegvCTCFHiL3L6xnK6qQ4/VdfcdEdKtQL5fI6xOMg7h6Qc///POJn7Qc58gnfCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793184; c=relaxed/simple;
	bh=rS6mRGHQgej854kIqzE5a6j5UuVJWucg/TdH53kOMnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfcH2ScWYNcArStq26OcUgPPQ9gq60XpSbW139U0jOfbPNJUx0/s/7DiyeUb3MJec4HeS6LJPmNkJ3XphxQN9hdfnB1i+u25fbpZXvNYF32G1JrM+cL6Nwg+eaqHTJ9EXCy2V6Qr+OI1Kac7xWJg185Danm8JKaFMGfd7TDk83E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0MB8FNW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0MB8FNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633AB1F000FF;
	Wed, 30 Sep 2026 18:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793183;
	bh=MgmZLg1ul65Hi5tGLqgj0fUCGecF8tu+jCS7jFn2lsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0MB8FNW1Vyy7c6Hh1BO2/45qxWGoZtdv28uN7Z3s1VOIqgtRHzObnJjsc2HlDsVn
	 DlMZv8MbO/QCkYW2j/1+uX5zp4wbIHTF08x/TqD6CcdH8vC1KyW+rGQLLKDM6vhOzD
	 rY5Ud9bodbIdRIv8Cmt3lQ+YLFQ/ccfxQv3YZK68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/395] net: stmmac: clear stale buf->page after recycling on skb build failure
Date: Wed, 30 Sep 2026 17:27:05 +0200
Message-ID: <20260930152344.185332089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 0a7822e34a0bfde31b194ac3da3253e5032b44cc ]

In stmmac_rx(), when napi_build_skb() fails the descriptor page is
recycled back to the page pool with page_pool_recycle_direct(), but
buf->page is left pointing at the recycled page, unlike every other
consumption site in the function which clears the pointer after handing
the page away.

With the stale pointer stmmac_rx_refill() skips the replacement
allocation and programs the already-recycled page back into the RX
descriptor.

Clear buf->page on the napi_build_skb() failure path to keep the buffer
lifecycle consistent with the other consumption sites.

Fixes: df542f669307 ("net: stmmac: Switch to zero-copy in non-XDP RX path")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260921-stmmac-fix-napi-build-skb-error-v1-1-3d54bf6d9bb6@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6a6cac88f7ecd..b9d4c2afc9a80 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5672,6 +5672,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			if (!skb) {
 				page_pool_recycle_direct(rx_q->page_pool,
 							 buf->page);
+				buf->page = NULL;
 				rx_dropped++;
 				count++;
 				goto drain_data;
-- 
2.53.0



