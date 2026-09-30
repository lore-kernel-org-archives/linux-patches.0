Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AF951E441;
	Wed, 30 Sep 2026 17:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790311; cv=none; b=Bc6De58do1z4CyoEdFyvSjZgRSjNVKeSRBJp9cgp0NbivzWHseg8sP4FpAT2N6w1T9MR0jlDPuV5dJflugwcHz9P6G46sYYGveSBhSuBIt9jKH8SpVbwme+y6Cte/L48jtDJVIKoUY7N1zZSNg83FP1bdDzM+TZ/d+mKBON8xKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790311; c=relaxed/simple;
	bh=CnC3q1XafiVwPf0lEt3FBSz4vRMgu1kMQB4nyn5zCRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PklpfemeDHcS7oToOlEVDqbqlrzsT9yhY5xGnoI1BsK2uXfmDokHARBeY+TOEykalHpFmPz3vN7Rv/6Ng3y27T00+yobN1TMn5U/ErETFXWHwI2IJfd3FY42I16SZyKSZy4KosQh0XeZOLSJ5oCXOTyO7LdCv/N8VvdI0waiEhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bS3NlGYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bS3NlGYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6BA1F00898;
	Wed, 30 Sep 2026 17:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790310;
	bh=nFa1y9YcLMV2v9YIGPSi710Mj8o6a0R71pOuon9D6CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bS3NlGYQW9yn54sN9mL15KdVjyXH+PWxnWZ6Zf3rKZ3ep/NYBNYL2iURVgdgkju/v
	 qF9DGEmku8Fa0/ohslNpzIGxjIhPe6+N9BLo/iRvdp1I+iY/HDihVVDsYYUBMm42vu
	 TWqt01BM1w4g2sMmciWmSg2leuYgwOTSjW4OWFLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 739/877] net: macb: Use netif_napi_add_tx() instead of netif_napi_add() for TX NAPI
Date: Wed, 30 Sep 2026 17:27:30 +0200
Message-ID: <20260930152430.638350953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit c321b5676d0c41de9155c1966aa6af8b7ca35091 ]

The TX NAPI should be registered via netif_napi_add_tx() to avoid
unnecessarily polluting the napi_hash table.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Link: https://patch.msgid.link/20260403-macb-napi-tx-v1-1-08126a60c65e@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e1406330d70e ("net: macb: initialize PTP state before registering clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4240,7 +4240,7 @@ static int macb_init(struct platform_dev
 		queue->bp = bp;
 		spin_lock_init(&queue->tx_ptr_lock);
 		netif_napi_add(dev, &queue->napi_rx, macb_rx_poll);
-		netif_napi_add(dev, &queue->napi_tx, macb_tx_poll);
+		netif_napi_add_tx(dev, &queue->napi_tx, macb_tx_poll);
 		if (hw_q) {
 			queue->ISR  = GEM_ISR(hw_q - 1);
 			queue->IER  = GEM_IER(hw_q - 1);


