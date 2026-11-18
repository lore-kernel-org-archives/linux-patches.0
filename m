Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042199;
	b=M/cHZPPFQu+AmqTHoHU7Od9JiEerHQVThYJ0Ov1wsof64ETtlACKtFBs7j2OjcxYp4Ta
	 Y/POkUENHW5SgjD0wDz6BGUKWanEjkLlF+4J60y+S5bt4ZfUPzomox9OncYVDg/bkPP83
	 Vi2T1j30rmIyOkPaj06D5V6eNlvAZ/5PRzRWgc4E+/LQWqwAe02ONu1hUy5VXwesL2KDC
	 49D8NL/Tj3RqrZbBzcDZ6N+mt52AZSdVL6gwm6Ky/c/mgROXMQJ30WtzxSc70azkCJeL0
	 oEZMIU1mbR14MxM6zmoxhzANVbGv7jCkqw7TzWDebQo72suFlWiZigZ9b6cUNJOdvzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=72HilfA+aKLOyFq6t0rxWQ7c2c5idT098QJdjUp7RY4=;
	b=XaBaYwJCdvg47hjH4ijsr204Je4lb6giaOujgYa1oxh/GHMEWlW3JMGJqAC7w8thJbUR
	 fIsrVsejSGm4MylmwkncagUbcJxFsdbV3wGdrwknDXIiZ64MRWG+O+Z46LrZ5dGWkHMgE
	 vuYaPuZo6zEjJA8wra/RuvrVHHpp3QDXO0w0t7WsYosDBswIphpgW2ECuouRN+D9bNtDs
	 R4P2r9pSfUVq7KoFtPxX8b5QqmdF2NI5mTqrsOMjsJdTVVM7WXjRbJeyWy53NHLwwDwRk
	 bB11BG4lxSe0VH/H1Nl2YSvTWDGCCPEN3KcObRjhS61h30STNt5KFuqw2hapPmJZGOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDq4lSW0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A6B606A325;
	Wed, 18 Nov 2026 22:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDq4lSW0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4AF1F000C4;
	Wed, 18 Nov 2026 22:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042199;
	bh=72HilfA+aKLOyFq6t0rxWQ7c2c5idT098QJdjUp7RY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDq4lSW0BLoDTufZq6y4031NG2I39Qak5uTwA/FU+RpLFR9Yin3fnQs32XA+g224p
	 EXA6cG9f9/5k8ntAsz6ca/Q4xi8SkWijXGQu7hAezH3qEKM9C3FN7O4IYv2b3pRfMG
	 /9NDeHakjsw5zbM/yhcsPI7m36RnbTWvxvfyFtLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3086/3318] ibmveth: wait for in-flight transmits in ibmveth_close()
Date: Wed, 18 Nov 2026 16:01:48 +0100
Message-ID: <20261118150452.632156783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



