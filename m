Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C567B24C08D;
	Tue, 29 Apr 2025 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945890; cv=none; b=UmwWklB3H8AIZFmkblVJbMkR0I8zX7OxW21XEnEjV4iN8q/7tsr5gjp7RqyLPgEP3bse5dIy0bEYLf6K1gjgI2VMGWTcalEYtckffiiUnlg0eJfKWBdGLJGJO//6KiTOkhiOx1ym4H/wmiJ5w5X9SkH8Sfqa+h8VQHbz7aEMIBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945890; c=relaxed/simple;
	bh=5rzX3y+JdtT2mGV7cRTuKF0U8Z1ockkDdyRUg3HEkeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6zbg1/g/N/ZUHTCV9vPERiwK+HAwutDsPjZxV/e6qKWVp6bnI/6slOMJdl3PqHiHNm18oICMdltBWFqcECjtyQDhQukEO56ScJ8sx4IPKVxdziE0uXwmnX7ZueRv283X2zJryDuiX8vXmiWtKFMU0/Xa6gGPunzJBSZBq3xZTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axUqHnxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axUqHnxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594C2C4CEE9;
	Tue, 29 Apr 2025 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945890;
	bh=5rzX3y+JdtT2mGV7cRTuKF0U8Z1ockkDdyRUg3HEkeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axUqHnxXBJO3lwvtfMXBh/SGNqoeEbw7VULdjCxBO5eYZu+py91SnSc0rgBeXI3+o
	 dK7rceXKZLRyumEzkapeF3LKyd30Fb/OEEd30s4DFrjGCBlSjmwOw4XFFKxPk4htdN
	 HGKBv6rjahXW9RXNffOPzVF67YTPqsQSkpTkM7GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 054/311] net: enetc: register XDP RX queues with frag_size
Date: Tue, 29 Apr 2025 18:38:11 +0200
Message-ID: <20250429161123.253379934@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 2768b2e2f7d25ae8984ebdcde8ec1014b6fdcd89 ]

At the time when bpf_xdp_adjust_tail() gained support for non-linear
buffers, ENETC was already generating this kind of geometry on RX, due
to its use of 2K half page buffers. Frames larger than 1472 bytes
(without FCS) are stored as multi-buffer, presenting a need for multi
buffer support to work properly even in standard MTU circumstances.

Allow bpf_xdp_frags_increase_tail() to know the allocation size of paged
data, so it can safely permit growing the tailroom of the buffer from
XDP programs.

Fixes: bf25146a5595 ("bpf: add frags support to the bpf_xdp_adjust_tail() API")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250417120005.3288549-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 2106861463e40..9b333254c73ec 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -3362,7 +3362,8 @@ static int enetc_int_vector_init(struct enetc_ndev_priv *priv, int i,
 	bdr->buffer_offset = ENETC_RXB_PAD;
 	priv->rx_ring[i] = bdr;
 
-	err = xdp_rxq_info_reg(&bdr->xdp.rxq, priv->ndev, i, 0);
+	err = __xdp_rxq_info_reg(&bdr->xdp.rxq, priv->ndev, i, 0,
+				 ENETC_RXB_DMA_SIZE_XDP);
 	if (err)
 		goto free_vector;
 
-- 
2.39.5



