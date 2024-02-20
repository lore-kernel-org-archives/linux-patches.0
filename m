Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701E8446C9;
	Tue, 20 Feb 2024 21:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464817; cv=none; b=n2QkN6FhOWpyBZ6tr6oglqG6bZiHsNj1XDi1TX5ViZQA+cXosD8PJwwS8lNW49XVpjBTrRl2pN9WAMDZf/wXPBEGLUIsvR1yLmhw5ZRH4TqaMmbGEIcp2SDlWcAvdkgxgFo3Rq2s9Dz/mSi+6X6t+6n5Golt3CT4pytkVsNrdgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464817; c=relaxed/simple;
	bh=UPEJiLEsLm81SwQF1NqcyIrwK+2kPavlp81CzPGQHs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yi8rsWKFMuLFdTiBh9C2WIiQvA0xL/c1GiCF5A+a+Ok3YUnJ2agYxwP8f9UHffqJXyR3H1iwzYMCz2pPWGqZBQBAge6QwV1vnG9+HB7kfw6N/0qlYLMHHeCL3wQT3NQ6wVfz2CtvX2fWy4vLemDaZcpISv2bJwLMzBvHNeuCiJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXPT0aQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXPT0aQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4232C433F1;
	Tue, 20 Feb 2024 21:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464817;
	bh=UPEJiLEsLm81SwQF1NqcyIrwK+2kPavlp81CzPGQHs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXPT0aQjJNDaV6SMQ2vTdE4ZxApEwZ2Xq8UZ4+dNwsyt0qj7Dfs5hOfXhUjWKQa6a
	 VKYhIHcO7wD/LR58tGAnx0rlOlbrRCd/guJ04rjVYBzvwrBUDvrgmvO9FfaZZnEsLD
	 rNRA11iKHTtfcKINu0LGEXRulY86iPccmAjWFE6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.7 146/309] net: stmmac: do not clear TBS enable bit on link up/down
Date: Tue, 20 Feb 2024 21:55:05 +0100
Message-ID: <20240220205637.739582618@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

commit 4896bb7c0b31a0a3379b290ea7729900c59e0c69 upstream.

With the dma conf being reallocated on each call to stmmac_open(), any
information in there is lost, unless we specifically handle it.

The STMMAC_TBS_EN bit is set when adding an etf qdisc, and the etf qdisc
therefore would stop working when link was set down and then back up.

Fixes: ba39b344e924 ("net: ethernet: stmicro: stmmac: generate stmmac dma conf before open")
Cc: stable@vger.kernel.org
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3869,6 +3869,9 @@ static int __stmmac_open(struct net_devi
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
 	buf_sz = dma_conf->dma_buf_sz;
+	for (int i = 0; i < MTL_MAX_TX_QUEUES; i++)
+		if (priv->dma_conf.tx_queue[i].tbs & STMMAC_TBS_EN)
+			dma_conf->tx_queue[i].tbs = priv->dma_conf.tx_queue[i].tbs;
 	memcpy(&priv->dma_conf, dma_conf, sizeof(*dma_conf));
 
 	stmmac_reset_queues_param(priv);


