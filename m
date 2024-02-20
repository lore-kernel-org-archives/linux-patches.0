Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0B91509BC;
	Tue, 20 Feb 2024 21:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462937; cv=none; b=fQRr0LD9b1TU9BcfoRlpYq4cAv/mFYcpSpL8uqAmimqYRA2kRwdQnRvMsA6K/Ag9DpUT/BwZdTGsNfcRgbXSX38y76eUbeCp3jmaVbtOL8rRsNn/HKdn/YuVgmLcnQROZFcMwlIU46ydGPDAo9ThdnhWU0qs3V1RQldEEq6U1ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462937; c=relaxed/simple;
	bh=1Rcu5Km3RSK+vjxBZrxQLXO8JvKiVEoih4PzsSRO2Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsM5xzySWvbO590Yzpxc0bPlwk/RLm0M8YA8GkgsWRmpYrr8aHBnhL3l8fIUoaJmmVJrL2ExzLB8k1niqF3Y3fChjWgutWNHwat6YxEuDqKn7TYWz4E0jGOeDDqOZGlG8gTuNgeQ/VQ8RK24Dl7Ok6YJ2UshsN+5i+pKAaHOYDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsKXzuv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsKXzuv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106FCC433C7;
	Tue, 20 Feb 2024 21:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462936;
	bh=1Rcu5Km3RSK+vjxBZrxQLXO8JvKiVEoih4PzsSRO2Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsKXzuv3QO564lQTSs62MxjS36t4fDi0YsMHP+WoDWQXe++gLmJVfoEkkavOGQIug
	 2mqwF9ag4VwwKXmZS/mdatrShAyQqZ2sz9UlfTUdMczxkuX136P+r5Q/vrPwRRN5Wn
	 f0Rljcpz5bVvwULXpCaYKnDJndpE1h3wwg2Ryouo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 084/197] net: stmmac: do not clear TBS enable bit on link up/down
Date: Tue, 20 Feb 2024 21:50:43 +0100
Message-ID: <20240220204843.600729587@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3826,6 +3826,9 @@ static int __stmmac_open(struct net_devi
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
 	buf_sz = dma_conf->dma_buf_sz;
+	for (int i = 0; i < MTL_MAX_TX_QUEUES; i++)
+		if (priv->dma_conf.tx_queue[i].tbs & STMMAC_TBS_EN)
+			dma_conf->tx_queue[i].tbs = priv->dma_conf.tx_queue[i].tbs;
 	memcpy(&priv->dma_conf, dma_conf, sizeof(*dma_conf));
 
 	stmmac_reset_queues_param(priv);


