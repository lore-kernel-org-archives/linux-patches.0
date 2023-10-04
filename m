Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110971D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F5AC433C9;
	Wed,  4 Oct 2023 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443227;
	bh=aZbVQytCSxzxgnIcq9XyAjkbNXBA9R/DXdQ0kkTIfAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ba9rprN9Dym82i9g00oA5juY+syKtcBnuJFicgWwFIPjeSVmC9hbNiIadJJ9YPDWO
	 n+xjPGuRNDrg9feD7qZ1IJVY1I7JXJRFjnHBK2dKhzkl8D8EwPiGeb2q5jgSyjj9FZ
	 /zpnwKK15uw4WXXnIP02nkqeXmjHE39ZhseX1yXc=
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
Subject: [PATCH 6.1 081/259] net: ena: Flush XDP packets on error.
Date: Wed,  4 Oct 2023 19:54:14 +0200
Message-ID: <20231004175221.084982177@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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
index 5ce01ac72637e..42a66b74c1e5b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1778,6 +1778,9 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	return work_done;
 
 error:
+	if (xdp_flags & ENA_XDP_REDIRECT)
+		xdp_do_flush();
+
 	adapter = netdev_priv(rx_ring->netdev);
 
 	if (rc == -ENOSPC) {
-- 
2.40.1



