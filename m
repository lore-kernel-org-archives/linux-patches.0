Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFED46C4BD;
	Tue, 21 Jul 2026 19:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663217; cv=none; b=fd6IcejJrlSTr3wvqGPUCGwWkRuezofMrsuu6h5htc7UU4l+i0eSAXG2LWTQN5A9cht23dyB+Oe6HZgtzdvCZdlsUMQPSSccYTaLxCe9YQ5yQxJaYdxEdfWgN0sxc9m7QaOfwxwgzyrFgqFhnog9SjfDbdvLCUbWoNB9zSU0QEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663217; c=relaxed/simple;
	bh=fe6qiOixCzs0CAWAjbBxpsEs+/K+YxrdsddPRqRHYrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbaKfD0XiIpTRkPPaUAUYuXCETneaJdiP1EjVQ0UEbChyMRjtiz1MjYP0n5wP3O/0znjRspzCYi9/P2yomr4slftrLqTRPJTuu8qr/OLz8Xitsv+rnI/OwTAmFDDIL4Vy41Cnd/bbPpma8YNZ+jqeJn2OukOx4aevP5unyahB30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLYjWf+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLYjWf+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D1C1F000E9;
	Tue, 21 Jul 2026 19:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663216;
	bh=uYpEEqGVT5eSuypvlkkVBjwaMPbULbXDtWRfkaxsYao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLYjWf+xUnKwlnVbWwUReLXF0oiyLyn35GbHPQdYPvVbFozlMykb89YY3Fx5knGTL
	 GVYEEN0TDYPk31OdQh8DB0HuzUKHNkN+1IsPFsD36w0gTRQCVuI6wZui24pw2FWO2X
	 BLsVtzP1ma2BGuxP9MZkjIaMJwSN1ChEIZM9VKW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0695/1276] qede: fix out-of-bounds check for cqe->len_list[]
Date: Tue, 21 Jul 2026 17:18:58 +0200
Message-ID: <20260721152501.650065195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Matvey Kovalev <matvey.kovalev@ispras.ru>

[ Upstream commit f9ba47fce5932c15891c89c60e76dfaca919cb8d ]

Move index check before element access.

Fixes: 896f1a2493b5 ("net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()")
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
Link: https://patch.msgid.link/20260623144602.3521-1-matvey.kovalev@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index e338bfc8b7b2f2..33e18bb6977401 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -961,7 +961,7 @@ static inline void qede_tpa_cont(struct qede_dev *edev,
 {
 	int i;
 
-	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
+	for (i = 0; i < ARRAY_SIZE(cqe->len_list) && cqe->len_list[i]; i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 
@@ -986,7 +986,7 @@ static int qede_tpa_end(struct qede_dev *edev,
 		dma_unmap_page(rxq->dev, tpa_info->buffer.mapping,
 			       PAGE_SIZE, rxq->data_direction);
 
-	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
+	for (i = 0; i < ARRAY_SIZE(cqe->len_list) && cqe->len_list[i]; i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 	if (unlikely(i > 1))
-- 
2.53.0



