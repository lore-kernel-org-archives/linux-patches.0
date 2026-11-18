Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050297;
	b=WYQ7zQlHE6ijWDIwQ2cWfJAUqw88c3nJ8/S+Ane14e4Z6cVmNcA9idf47J90qa/XGVdB
	 6WRT8pOPt1Np5kuRSh9bJAln3AXG4YoTOYCsRa55oM4CIrKg7khnQEJcwxiqUCF640HZe
	 Onc6IUdCFvhfhRz5CbB8MsU1jAzmsPVWtMImRHmBnDxQy36PbYAyQZjTsn8UuoNXDruZF
	 xRHSn+w6yT4FSVBnV6uV7+M9maJxpVkxk/iVSBdcOedT9meXsAqpwP3NyvnuGvltmvvwJ
	 PIaa1rLCmh3aLs2FY3nHzmmLNPMYX6L/bPU+Zc5h3TimR4Npcsvp2gdccR/A05kfcFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kQRxeZyE2gFHvozKmu7wt8el3VhjVaRUDBE0l0lnKZQ=;
	b=jwkmF0kMIPpyu2A41ohObsGHcX2JbnmiOlNJcenpT80WFwO4/n1j6E5FqvQnMRh4xDLq
	 KZvc6y1S2iy/TuZNeSHrfDBEqbfv8ova5lTUwK3gzZj29Qg2VkDWuaprcYJTFrMY4k+Iy
	 Z1zd3d8ghDHDD+hP68lJiQ6ZFiYccq0Um1fHkTIQKLlRQBWlOKByLXyfuXprvRHyFJzYm
	 KM6E/C5i9esuG2D9EVAW9wyUj6HaatI9kzU7BXZsUunyWw+29urW6960pfPkh4W4TpddC
	 ORXXwhK92rFmdtzMB8iuiOo1J98DQ7H6NE4TUdVAZgVH10zFjUMN/LaWfwmbA9J5alg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZsRTRV3y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D434606A33A;
	Thu, 19 Nov 2026 01:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZsRTRV3y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF72F1F000C5;
	Thu, 19 Nov 2026 01:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050297;
	bh=kQRxeZyE2gFHvozKmu7wt8el3VhjVaRUDBE0l0lnKZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZsRTRV3yvkSqzwHH/4jnOpKqJSGpsnB1FiRgd1bNspM/dVMLxbbIBy/OuKZFxcTrY
	 wpVl5BxPSsDsWcfDHhg6aJ80543F0x+bREak7g7OIhoJBJRmtFOSPn4QHKo2Bl0YEx
	 E+g0TpAlQ5QFgJzNtgpabB3ASDl3pAiQJE516yT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2657/2857] ibmveth: wait for in-flight transmits in ibmveth_close()
Date: Wed, 18 Nov 2026 16:01:31 +0100
Message-ID: <20261118150337.246885031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingming Cao <mmc@linux.ibm.com>

[ Upstream commit c807573ea58e615339a9c72675c45c157ffe245c ]

ibmveth_close() frees the TX buffers after netif_tx_stop_all_queues(),
which does not wait for an ibmveth_start_xmit() already running on
another CPU. That transmit can copy into a freed buffer and hand PHYP
a stale DMA address.

MTU, csum/TSO and buffer pool changes call ibmveth_close() directly
while traffic flows. ifdown and the reset work go through dev_close(),
which waits for running transmits only when the qdisc has an enqueue
function, so with noqueue they race the same way.

Use netif_tx_disable(), which waits for running transmits.

Found in review of the ibmveth multi-queue RX series and confirmed by
code inspection; the race was not reproduced. Tested on a POWER10 LPAR
with MTU changes during a ping flood, with no warnings. No kernel
selftests cover ibmveth.

Fixes: d6832ca48d8a ("ibmveth: Copy tx skbs into a premapped buffer")
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Link: https://patch.msgid.link/20261013182926.30417-8-mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 1475913c2541f..04dfeb5ea7f94 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -697,7 +697,7 @@ static int ibmveth_close(struct net_device *netdev)
 
 	napi_disable(&adapter->napi);
 
-	netif_tx_stop_all_queues(netdev);
+	netif_tx_disable(netdev);
 
 	h_vio_signal(adapter->vdev->unit_address, VIO_IRQ_DISABLE);
 
-- 
2.53.0



