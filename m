Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B1232E696;
	Mon, 20 Apr 2026 15:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700197; cv=none; b=MLUbtQrR2spgpTEFCMk7V14XUKsowPWlc4ly6r/IFlNWyiLBk3Otayn/M451FufLH823pF7k57JWPNOwmjL/0kfhiFYKqU3CQQdyliH250+fhSZEUIvC0C1JSSRYvtvbLJjFzgw6iDy9sUCnfhlpYu5WH28Wz46hjmZ+xx25EQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700197; c=relaxed/simple;
	bh=L0SGlk+iQt8HKB1dtVLq2fWEMM7g0t5c5/nCeVsM2xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlP4ugwXUPP6FpffMp6hhEGdhtNJ/0RIJVoSE8ue4xzJT1Tcb4F5+snPYDFKFlj98WICPR+MQ2ECRTmkqm4TIyiacuC90WKg8e+uNRRARm9YqyMG8AQl3L52A2j1OftYBQ8WRRuHWhjWquibf67q8TqOolv0+Bla/ekPyBh9fAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yN5SDggL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yN5SDggL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE11C2BCB4;
	Mon, 20 Apr 2026 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700197;
	bh=L0SGlk+iQt8HKB1dtVLq2fWEMM7g0t5c5/nCeVsM2xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yN5SDggLWLUCh99192Wx9sJ3WZcDwyMsTLAXsJUpuCjZE8L2WABmtsWIcLdl9RsIT
	 usNJH+iA2LT+esfpjxMl2Gh2mFVtMohnTHsymlkVN7qNJXxx1zbX2QGZsjWFRX3DSf
	 apl/rPrkGnxjDWSMkxFZvsNiWqLkOYJzxkPsBdjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 080/220] net: airoha: Fix memory leak in airoha_qdma_rx_process()
Date: Mon, 20 Apr 2026 17:40:21 +0200
Message-ID: <20260420153936.918538156@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/net/ethernet/airoha/airoha_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 454d7dcf198d9..fee5b2eddebb0 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -697,9 +697,8 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
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



