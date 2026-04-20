Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B734DD6E6;
	Mon, 20 Apr 2026 13:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692035; cv=none; b=FWWZYQsmGEzGCtcNCEbqxXrngDbqkLFtDkUice4IXb/wpTo2d/to64Q9wsJq/KvCS+4Q/eQ8vTSs3tN3AUoQd5RZHnxF7INx6yzzSiWAFuNxT7NPswKAFAaPYIkjWDD6MWeP6KwdB5g0DuefT1Dup4OrsKiZXHCrhKp7ZEEntWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692035; c=relaxed/simple;
	bh=i3rhWaKMYSrIbCXhEhMYTiNtIcwSGsFJBwm31q++mJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzQ0hCKSEnIrrEWs5NPxtUVUEeQPigoaFxteLOtwHa38EBY6BZR+bHXBB1kDWXeJ5+n7Y6d+JiY51yB/MCn+V6nFcEtck2ghjedeyx0d1LNP3g2J8Scs3H6TiCqFPq4oH3gG/27EfXax8EHd6ohYLTpMnFjWcIsNR945RVsMfAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SO8niLhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SO8niLhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8263C2BCB6;
	Mon, 20 Apr 2026 13:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692035;
	bh=i3rhWaKMYSrIbCXhEhMYTiNtIcwSGsFJBwm31q++mJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SO8niLhRl4/p2u024WoM113oBgra7Xun4h8QLhr0rqQ9bh34YcGR611Pu01jqRNBN
	 XVBRQMdV7Xd7LBmlfWhGqPP7Y32KH8joxiGxMqVZCdTTi9+a1Ume7Ou9osBK89ZoEc
	 FcJHNyx8DlR8lH83SHwU11WSDS3ECH1sLIqLL6Z9wzPokibUO0MTHuaZAGwKfrrDr0
	 kCBB3S3XBR/X7iKYcx5E4UCIustFJYzTtTwxyB8gNLe1y8AYgVTywOpk7iphb5Pcyc
	 K3NqBtECZfRGdvgvTDLZ9V+Ap3UPMzRzDDwZ2OBNBAyLJqs85hPkZafHq55pFXHXCL
	 X+7FQgoN384XA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: airoha: Fix memory leak in airoha_qdma_rx_process()
Date: Mon, 20 Apr 2026 09:22:10 -0400
Message-ID: <20260420132314.1023554-336-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 285fa6b1e03cff78ead0383e1b259c44b95faf90 ]

If an error occurs on the subsequents buffers belonging to the
non-linear part of the skb (e.g. due to an error in the payload length
reported by the NIC or if we consumed all the available fragments for
the skb), the page_pool fragment will not be linked to the skb so it will
not return to the pool in the airoha_qdma_rx_process() error path. Fix the
memory leak partially reverting commit 'd6d2b0e1538d ("net: airoha: Fix
page recycling in airoha_qdma_rx_process()")' and always running
page_pool_put_full_page routine in the airoha_qdma_rx_process() error
path.

Fixes: d6d2b0e1538d ("net: airoha: Fix page recycling in airoha_qdma_rx_process()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260402-airoha_qdma_rx_process-mem-leak-fix-v1-1-b5706f402d3c@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/ethernet/airoha/airoha_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 4fc6bd282b465..bdf600fea9508 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -709,9 +709,8 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
 		if (q->skb) {
 			dev_kfree_skb(q->skb);
 			q->skb = NULL;
-		} else {
-			page_pool_put_full_page(q->page_pool, page, true);
 		}
+		page_pool_put_full_page(q->page_pool, page, true);
 	}
 	airoha_qdma_fill_rx_queue(q);
 
-- 
2.53.0

