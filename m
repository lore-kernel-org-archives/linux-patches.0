Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DE81885A5;
	Wed, 28 Jan 2026 15:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614400; cv=none; b=ede8lHGBjfx+O/hZL9D5ydXkHGGjQENKMfYHNg0tGs1W1XKMV/4nWxGUV5sU2OGrpvx2B7S8H2foRIJLoMBLyq4ZEU/UVW3vGJ+nwKJJamIN1cxM9yMBfWkeINdPhT7SfIb32hev65ZQr5T+JJyztI6rZrxLcleuZAWtQbUJjXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614400; c=relaxed/simple;
	bh=3sNZ9/iJupjCCmHdu2XZXHe0swurwEijbTQWSaz6Rmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXgI9JwaIJrtgQvBloOmcZvx6hdv/sF4QTchNot8R72T0k/6tAgXdG8pRrsQUR99MqduDNq0ioE0Tk9dcJgCVisPzlB38rRJgO53PppYGwgk17Ri56AhuSAESBhHfS8RwHsW1M/IdTeooesx8iL8xg8PNrkLrNq1elgrqcz/dQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbn0GawU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbn0GawU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0022DC4CEF1;
	Wed, 28 Jan 2026 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614400;
	bh=3sNZ9/iJupjCCmHdu2XZXHe0swurwEijbTQWSaz6Rmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbn0GawUg+7zFFKO4F0VBERBdDOP4kOKcG5NyjHSfHFGOy1SY8MT8zPpK+dH+Sour
	 ecRIzC1ZwOWMjCKG5TbPMWqtiisTM5C1SRA/A5bx7n8ZHJlOpUFDU10HQWgkL/ADpW
	 k7MSzndBUkJ7iHV+bnaD+Ndcxe4wazkfCnxrj/wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/254] amd-xgbe: avoid misleading per-packet error log
Date: Wed, 28 Jan 2026 16:21:40 +0100
Message-ID: <20260128145349.283635450@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit c158f985cf6c2c36c99c4f67af2ff3f5ebe09f8f ]

On the receive path, packet can be damaged because of buffer
overflow in Rx FIFO. Avoid misleading per-packet error log when
packet->errors is set, this can flood the log. Instead, rely on the
standard rtnl_link_stats64 stats.

Fixes: c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Link: https://patch.msgid.link/20260114163037.2062606-1-Raju.Rangoju@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index b4d57da71de2a..3d6f8f3a83366 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2105,7 +2105,7 @@ static void xgbe_get_stats64(struct net_device *netdev,
 	s->multicast = pstats->rxmulticastframes_g;
 	s->rx_length_errors = pstats->rxlengtherror;
 	s->rx_crc_errors = pstats->rxcrcerror;
-	s->rx_fifo_errors = pstats->rxfifooverflow;
+	s->rx_over_errors = pstats->rxfifooverflow;
 
 	s->tx_packets = pstats->txframecount_gb;
 	s->tx_bytes = pstats->txoctetcount_gb;
@@ -2559,9 +2559,6 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 			goto read_again;
 
 		if (error || packet->errors) {
-			if (packet->errors)
-				netif_err(pdata, rx_err, netdev,
-					  "error in received packet\n");
 			dev_kfree_skb(skb);
 			goto next_packet;
 		}
-- 
2.51.0



