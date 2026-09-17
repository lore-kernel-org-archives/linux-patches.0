Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C461113D51E;
	Thu, 17 Sep 2026 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667075; cv=none; b=bHsDh6TgHgSCePZ68ZoVyGoVXvMtmAtYwWxWxAqc6pnLUkioBpxJuAvS1VjUkjFU+d+ZadqHnAnvoOyve0kf9xTPIX/332GA27zuBXEQiXdCKTtZkWUmabUTvC1qx98k8NSZF9PLDEK024NjAt1W8DiL51hx52MEJ8T15pUn9iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667075; c=relaxed/simple;
	bh=WSGVb1PZ3AGyOFITnf6dbAAzpN66C9IupiQKFJQoHJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6GPUPFykZ8gmlfhd+oRAyXBHfAXJ7fLf+2ec2pYTFBhAG4Jl4R3l3Pn3P8k1xvaBk5PetaQcl1/U9akqjk62f0lRA2CQJMDDmoRPM8+C4RqPR9Z2M3C36DdNw5oi8etG501jQQcILITXqNeboQBWN/ixBJYDrn1pNpXD/7nbPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8M5zebo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8M5zebo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1625C1F000FF;
	Thu, 17 Sep 2026 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667074;
	bh=5PkdYLhKnGqmDduDk12vjy9HaouGek2gPVvDFB5vrEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8M5zebotqzGNSAXSvmruH7I3lPH46WnUxzUHTLFLLYKfY97yqwzI/31sPUIvGIWP
	 867Oo3qm2n6iYckmBlEdQvscmfBZTDs7wQB34Q7FAmtz6o7AAib5spk27n4nb32/i2
	 PGS6wgJizOXupEQMUEN1vJ3wU6cL6YV48kA1g2ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1219/1250] net: macb: Use netif_napi_add_tx() instead of netif_napi_add() for TX NAPI
Date: Thu, 17 Sep 2026 16:16:54 +0100
Message-ID: <20260917151625.325400720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -4650,7 +4650,7 @@ static int macb_init(struct platform_dev
 		queue->bp = bp;
 		spin_lock_init(&queue->tx_ptr_lock);
 		netif_napi_add(dev, &queue->napi_rx, macb_rx_poll);
-		netif_napi_add(dev, &queue->napi_tx, macb_tx_poll);
+		netif_napi_add_tx(dev, &queue->napi_tx, macb_tx_poll);
 		if (hw_q) {
 			queue->ISR  = GEM_ISR(hw_q - 1);
 			queue->IER  = GEM_IER(hw_q - 1);


