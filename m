Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B721D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtPUd92h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99017C433C8;
	Wed,  4 Oct 2023 18:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444010;
	bh=d70MElHA/YyHeV4aO5k1uQoNi+ygopKb91YzslE70aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtPUd92h9m7TweBJ6LemRqkaM5zVklRU6jKYBpta27jhkXj7YXsnC8opeEeNX9VmX
	 spzOw+hC4htHxlt/xB9Q7pOeHN3BYgryB1s2Hiv/xcp9KOycpckwEtlzbrhY3Dzwr6
	 FzbK8vcwpQeWISJU7ab1l5gC7vE23n+ATEqW3JOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Kiyanovski <akiyano@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Noam Dagan <ndagan@amazon.com>,
	Saeed Bishara <saeedb@amazon.com>,
	Shay Agroskin <shayagr@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 099/321] net: ena: Flush XDP packets on error.
Date: Wed,  4 Oct 2023 19:54:04 +0200
Message-ID: <20231004175233.814236521@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 6f411fb5ca9419090bee6a0a46425e0a5060b734 ]

xdp_do_flush() should be invoked before leaving the NAPI poll function
after a XDP-redirect. This is not the case if the driver leaves via
the error path (after having a redirect in one of its previous
iterations).

Invoke xdp_do_flush() also in the error path.

Cc: Arthur Kiyanovski <akiyano@amazon.com>
Cc: David Arinzon <darinzon@amazon.com>
Cc: Noam Dagan <ndagan@amazon.com>
Cc: Saeed Bishara <saeedb@amazon.com>
Cc: Shay Agroskin <shayagr@amazon.com>
Fixes: a318c70ad152b ("net: ena: introduce XDP redirect implementation")
Acked-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d19593fae2265..dcfda0e8e1b78 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1833,6 +1833,9 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	return work_done;
 
 error:
+	if (xdp_flags & ENA_XDP_REDIRECT)
+		xdp_do_flush();
+
 	adapter = netdev_priv(rx_ring->netdev);
 
 	if (rc == -ENOSPC) {
-- 
2.40.1



