Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032723;
	b=z9TzH/IUMtQYpcWyg3O26ZvkB0C1xnMb+rH5UPrh2XSHMwCSslrvnp1RdbxXrF5d6ZPp
	 v7jJ3YYY/+11LWHWDJnIl+Jqod7ZYXxhAV1QhrlcRf1zKmbvzOBY+GUMtoC3QlCVIjWnZ
	 p+wZb1iowVzGW/QUmgK62an1Y+5VtST+DCrb/eq0yrBPzDlqkgtjZpwE2ylVzTcCeUzsy
	 dpoKup9euZND9T7JIkJOMl4FB8Y1dKPP4iV5hZNXobjTV0c1RS1ZYWfUBbCzcqliipeN8
	 nDJ0tyXWx3Rh7bbuDCHHYKLOt/AIp3eczYfMmPDXWVDF0z2B1XXS68slqQ2xDaFxWBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SFUudP7RB2xLTCBFdYkscnH1eXFQFB7BzjHbIgogYkw=;
	b=0ghot6QwsUHKnDbfo/zdHVLW1SrCtJ3LzUw+kg8i3COrBm/riOyT+IJQ0Mu+d/HXI/Vz
	 Ld2YWV9Pgk3LQ8E46sYMaFnPQTwHjv0NKrr5mDudaAuDtnAFMZNVC14JzEr2SOyefzdKy
	 GkQyww+TBcd9JC8wmxme0JTwtGzi3xvX98SnQ1r5+yVVcwKG+j2VKa6fUB//WX9pX88Xf
	 H6Sl0xNrBHfBVnaCVzq/1s5dwhgxwUIyoqCjdqMcGGGC3vb+6S6vq+8c2PqjwJW5OwRHG
	 2SiMG/UD1p1nF/PNmtvVmurhvrmpScfDaN1yfuKwHZBK7ei/5D1gK6/VoX9BEt6xJAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oI19L5L2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9F4606A331;
	Wed, 18 Nov 2026 20:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oI19L5L2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2B91F000C5;
	Wed, 18 Nov 2026 20:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032723;
	bh=SFUudP7RB2xLTCBFdYkscnH1eXFQFB7BzjHbIgogYkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oI19L5L25PnwmqZ7WlFCZz00Y6h/fV1HcqCbPoeepIYP9n3Xab7EsLDfSwfvXLiDC
	 E8oNEqnCXYIDomE8/dCnxyOZheDTQnuRH2aPX9nPG0r34ufcdtXw8O6s1nIS6sRUqV
	 Eu6VZc8cxv9vUy555zjBrGtn+tf0Q13oNNS3xUEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1469/1756] ibmveth: wait for in-flight transmits in ibmveth_close()
Date: Wed, 18 Nov 2026 15:59:56 +0100
Message-ID: <20261118150107.505061117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bb7c21db535c3..1a42d26027e7b 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -674,7 +674,7 @@ static int ibmveth_close(struct net_device *netdev)
 
 	napi_disable(&adapter->napi);
 
-	netif_tx_stop_all_queues(netdev);
+	netif_tx_disable(netdev);
 
 	h_vio_signal(adapter->vdev->unit_address, VIO_IRQ_DISABLE);
 
-- 
2.53.0



