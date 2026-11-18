Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021452;
	b=MQI7wYLPFu4ZwOyN1jPRTAb0er9tuZxOUHEKTdaF4t/1Dq06tcDq2mOcuf+rUMDbo+5s
	 uW7e6cJluNrF+zn2BU5vsGfoWU5M/FFl+BGVEGevaWIxiu3nGwPPOTBoSbW1AikmUIZYa
	 YxzOX/HsDsu/T4lwkhCOzX62dBrP1k6AT9cFyECsPVnO94yAiQsGf74Hs6P8UweklRtiM
	 xoZhlL5ErUzIR2amAnZfI8ll/ZN2KsNus/fnbR8TQBjC5f3OFvE3CNgDAetqSsLShrJTn
	 OZp9LPQZGnPxoQtogjzD5Xog2OFtplPX5SqpUQgZcBbDrA+2mE99Io0+t9uvK0jHjWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NJ1ssW8LZodLMUkxyOcyYEamdktouBEwZxjS6y8k/I8=;
	b=rHRKI2F58YHtYFRU3CfmmgWi/DxR+jmsw+tRPiFZ+3ydWYA2rKUu2fcOfBcnZQk/ZmBg
	 WU/PPgv9sEEe+JUdLYjeOEXjlPqbHABex6sueyHKdjr0X+m+fN65DNAN+FEDAc9+qqvV7
	 bkvZHY71QQ2dMmZarYUli0onn9UJQCfO3ihDkeK8/PZO97uRdogGB/3Cn7vkzVQOD6AvS
	 ORsbA2g7n/nBvJ6TU8Xtudez45ddUThjb3ULxxlTHGZKHljS58WrRKj/xSZc9xxVMTI2e
	 ANQDFm4rjWBmn6bLddqQfApdpn3k29Y4Kg4aLt7hw17STffBBC3Sn4qj66ljJykxAzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piTIgbIT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F140606A33A;
	Wed, 18 Nov 2026 17:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piTIgbIT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06011F000C4;
	Wed, 18 Nov 2026 17:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021452;
	bh=NJ1ssW8LZodLMUkxyOcyYEamdktouBEwZxjS6y8k/I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=piTIgbITY2ZzoJ+7xkzCKDhGC+VoZchl9fUY3nR+g9c6u//g3+C7vVXF2Exo8MrCb
	 USR7x9GTPxyc9hPoXpZFjzH9oNuFNk66ngplQDcwPv1mk/kNKrv/fDaMlgfe7Bq1ap
	 ZkREdvKSWBNUucoGR05XjXlTlGh5Hfnf+MiLAqkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2275/2651] ibmveth: wait for in-flight transmits in ibmveth_close()
Date: Wed, 18 Nov 2026 15:58:35 +0100
Message-ID: <20261118150407.232777411@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 48bc4406396bd..f2570d637301b 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -835,7 +835,7 @@ static int ibmveth_close(struct net_device *netdev)
 
 	napi_disable(&adapter->napi);
 
-	netif_tx_stop_all_queues(netdev);
+	netif_tx_disable(netdev);
 
 	h_vio_signal(adapter->vdev->unit_address, VIO_IRQ_DISABLE);
 
-- 
2.53.0



