Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386A61509BF;
	Tue, 20 Feb 2024 21:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463720; cv=none; b=Iuo2e5LWFwcGr8TKda62jWt3bmSXCiNFpjolgTyfXMSd61j9i8UlQ9cCILxwk113Aj7fGA/BXYSGC/vd0+nOBgtmVB8m9Z/9UAFyLBJ27I5xSevQqkjqATQAXZwInj9cERADbpilP6ESPIMt+ID/vRc8asxkaqNQYNKMIeZ0wtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463720; c=relaxed/simple;
	bh=h5L/o1rGVJtGm4klshIEvcna77zEToYD/tAJNshcehE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KARb4swi008AewrA9MXjFozTW8qy5m1EJUrxctBd71ZXUQMabMxS37rMvVbEABeuSkxPlK4ikez1RqTzE8+SmOis9mHZR5qKEB2Zvi9anqTM2slffx8AOn6Up+XasKZAg4DlFx/0rsQBTP/n82BMLcl8n0+XbSRRKvgTZQOOnk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPQUqyNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPQUqyNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D477C433C7;
	Tue, 20 Feb 2024 21:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463720;
	bh=h5L/o1rGVJtGm4klshIEvcna77zEToYD/tAJNshcehE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPQUqyNZLotYoHCTxT6IFLWbCsPUzH45WWhfAVOgKBmuYJUH7oH+3CPgFWbo3Kj0g
	 Xn5NSUIKtYTvGEVmj2Fqnr+NxvF7ULlXniV5kEKrWVkowPndM8vyMbgTnDL8ESnTpQ
	 CHayDAnEhUNDsAHdZ9HYcW0EK7OZ30ziD8w8daBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 132/331] net: stmmac: do not clear TBS enable bit on link up/down
Date: Tue, 20 Feb 2024 21:54:08 +0100
Message-ID: <20240220205641.722462141@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3853,6 +3853,9 @@ static int __stmmac_open(struct net_devi
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
 	buf_sz = dma_conf->dma_buf_sz;
+	for (int i = 0; i < MTL_MAX_TX_QUEUES; i++)
+		if (priv->dma_conf.tx_queue[i].tbs & STMMAC_TBS_EN)
+			dma_conf->tx_queue[i].tbs = priv->dma_conf.tx_queue[i].tbs;
 	memcpy(&priv->dma_conf, dma_conf, sizeof(*dma_conf));
 
 	stmmac_reset_queues_param(priv);


