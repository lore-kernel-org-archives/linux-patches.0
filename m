Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061964;
	b=URRbuzSrAG5x1A4YQClx3T5EKOUfG9dSYlMf4K788byA/0DWjwnwXLfEX3aajFtXgimx
	 nGB3ig4aFJe5TgZLr1xFjIKdjBtbk7cSFPAOOMoDOGjHmD1swLVOB4FX2K5xQ+6XlH7ez
	 i9qXiPHUhayIOkFZEj2Yk+ykupKFyOPAUe73wZUvB0b7z+VRtYgimdO5smzCf/pIElNhe
	 3t6Ys58Ed06VN1l17Y8BT5LCerldcb+8kuPdvVf1dxDSz6v1DhoP2BrEwOpMbaoNddagl
	 jKwEZ5Dz4s7mMoHHPvrxILKamXWHy89tWuE6Gq9J00semtxGoZA7Is68vC1rE0wNz1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P271iULdrm/+NSnmqfv54khHfiktDw0+x2wf199RHUE=;
	b=t9nZ/bRHpxX8vBFrd8CURE+GjHLmxE8c4Id6ztqu4qhN0WoLmMNyoQiWKiICxoJIxDJl
	 7dz96ESltnKriMqYlwLGk03GoZgPipOlvsGI4gTlLq6+HPnXJgR594bGLH7qtt01rJ0GB
	 7SS1a6fRvJSoUp6yR2R+hEgSv8ROEJ+Dhl4ODYhs1iVymWwEP5qofzZr1oO4pAD9C5eE4
	 lQuqjzOn7wkdi4KEuBE+oVc6R9uaNgYn54h10mIFGMpTT+Oy4/EVmQ/gjb9l16AV+Zq0z
	 NtMa37HPh2xmwq4XKODcnb5OQ5gXOBQoXJEB8r7m/m7FiF8KuBdjWf+GTHjkEZ32n+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sva3HeG1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EEB606A320;
	Thu, 19 Nov 2026 04:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sva3HeG1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CE61F000C4;
	Thu, 19 Nov 2026 04:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061964;
	bh=P271iULdrm/+NSnmqfv54khHfiktDw0+x2wf199RHUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sva3HeG1ZODPbkX4gnIfBoNPw6nqC868RvzjhhLlS4JaHIKyr9ThSYx4XlLCSj3NG
	 ovKdqIGisx/mnbpbeunl8nFYRi34+fVzOROkSx+j61myyNDvG4LrKHZBGmgC/qbv7Z
	 4c9IzuJ8v5WVhtEJ8fSJhpeXj/amjhLbLFTvPIYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1742/1848] ibmveth: wait for the RX poll to return before freeing the RX queue
Date: Wed, 18 Nov 2026 16:03:00 +0100
Message-ID: <20261118150032.455516915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingming Cao <mmc@linux.ibm.com>

[ Upstream commit 3f872b34368c7c1d2a8900950e0fee4cb4dd9a34 ]

napi_disable() returns once ibmveth_poll() has called
napi_complete_done(), but the poll is not finished: it then re-enables
the interrupt and calls ibmveth_rxq_pending_buffer(), which reads the
RX queue. ibmveth_close() can free that queue in the meantime, and the
late enable can leave the interrupt unmasked after close() masked it.
The request_irq() failure path in ibmveth_open() frees the same memory
after napi_disable() too.

Call synchronize_net() after napi_disable() on both paths. Every
caller of ibmveth_poll() runs it with bottom halves or interrupts
disabled, so this waits for the poll to return.

Found in review of the ibmveth multi-queue RX series and confirmed by
code inspection; also raised by the Sashiko review of the first version
of this series. The race was not reproduced. Tested on a POWER10 LPAR
under an incoming ping flood with 30 rapid link down/up cycles and 30
rapid MTU cycles (1500 <-> 9000); ran cleanly with no warnings or
faults. No kernel selftests cover ibmveth.

Fixes: bea3348eef27 ("[NET]: Make NAPI polling independent of struct net_device objects.")
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Link: https://patch.msgid.link/20261013182926.30417-9-mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 2a3e515f3edfe..ebd14562cd551 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -601,6 +601,7 @@ static int ibmveth_open(struct net_device *netdev)
 			 netdev);
 	if (rc != 0) {
 		napi_disable(&adapter->napi);
+		synchronize_net();
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
 		goto out_free_buffer_pools;
@@ -670,6 +671,11 @@ static int ibmveth_close(struct net_device *netdev)
 	netdev_dbg(netdev, "close starting\n");
 
 	napi_disable(&adapter->napi);
+	/* napi_disable() returns once ibmveth_poll() has called
+	 * napi_complete_done(), but the poll still re-enables the
+	 * interrupt and reads the RX queue after that.
+	 */
+	synchronize_net();
 
 	if (!adapter->pool_config)
 		netif_stop_queue(netdev);
-- 
2.53.0



