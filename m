Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A1C2236E3;
	Mon, 20 Apr 2026 16:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700865; cv=none; b=cES1FZCs1xOqfbGGt0A3g8Plc48Ul3nK06OLq5BUBLPmuXkTHaxBjEWbY8bF4lfSAJT9LqU+vAckbi3elxC/mSpbQNG6sQxT5MVZpUSeOOWbspwJCcoVlAq5EubY3/BDXaeZuYgKx+WcIuyqG38CmXPK0i+S46rdK1hPDOa1TyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700865; c=relaxed/simple;
	bh=aHq1HqcfWYUpJX55h8d+e3HtbiohR702znqdeZ9v3zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2yr95+VfT+7YGeFh5OPEGF1PE+LdlSecnUQgGi+Mq0bc0B9m8EhhE3H8+MtT+8I2HmLBevm5375o7cXk288OsQUVWci4FgihtQzZHwU9WXIVPYqB/+cR+H4WAVUr3EMoBn7pL3OdgScxB+jrDXy6vz1avRRO6s8BZ3YM0+HlOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqQAd7ri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqQAd7ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B64C19425;
	Mon, 20 Apr 2026 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700864;
	bh=aHq1HqcfWYUpJX55h8d+e3HtbiohR702znqdeZ9v3zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqQAd7ridI2hluIkyUI7BY+rN9meJuwzSlYBzQ87rhaU9YkquNPVVXazEBe+tzcwG
	 GqbqoZqBQW+I9gCeIh6tKhNKXA07Od3f8xP8ig8BgtDlXxuYSSz0qep5SCefeAYo7N
	 2zVh0M3e3ecfEVvOfWQh2NIgLMr0pHrSltMwEf/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/198] net: airoha: Fix memory leak in airoha_qdma_rx_process()
Date: Mon, 20 Apr 2026 17:40:51 +0200
Message-ID: <20260420153938.202858780@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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



