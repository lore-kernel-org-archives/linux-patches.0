Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056833;
	b=lJgb32ACbSWJQvE6nSiK0EezUznOgWXkex4jch2GB25WUVYZXTEDpeuiHmF30zep1gLf
	 AjM004irhjl1uat1I796iTWRaHrWiqSuEuo3Qwh91VivGPM2hWTyIyukSr2M0qFzemNtF
	 543jA09CQ5Z1lnVs4dmKSiVAxdxP+R6+nuYaTzhDMU7ha98Pq8lsGWzvNcCzgSQmWmQPF
	 yWQHqoE0K589GxTP5UKNxakKn8ymak4lJB6L1lwUxMby5xeADOXQ6YwU+zGjI/tuZMN6U
	 T+x6MDoe4kIoxggjiFzZpNNg9av8E/iUtzrmWMd6T1O7eLBvtLiQkZUnGsMIkC20NAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Tt26JC9EdfzGHvv/Kk5Sr5Z7s1DIbz9T4TXnnmnDOM=;
	b=XCkA8e3H90gxX7lvDUn4+jUDV33hu7BzIP4QE707ZHhDDAbIFQBwDPvpXRTo2WyoPrKY
	 fSaK9ohSznQlK9hXro6adsuvPMTrLAvC7I7aACKPiSC2g7ilhAmZzLJ/xTEJP4Vuvkgqz
	 qa8KaA9df17xRpwtqKch71vyRsL7/KxRLdWzxFTNa0zNzxfEfpz25k3ziOAJozGqcp7Pa
	 EMKGugTCsMt51BTMZH59MZR/RoFU3mGAYcbdnwewy0pigtUVb607H/MakxoQ+Gd9aEIMu
	 tiKbji5PNCkH5EkbuWHPkt4qbpNEVyY3/tV8bjHKFU4+hbOJ6PRZ+qlFdmlrR5j1iLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vthNVyGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2455606A33E;
	Thu, 19 Nov 2026 02:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vthNVyGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D73F1F000C4;
	Thu, 19 Nov 2026 02:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056832;
	bh=8Tt26JC9EdfzGHvv/Kk5Sr5Z7s1DIbz9T4TXnnmnDOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vthNVyGEKXbjfLMaaCWX/Xp34TWEx73jjBaKyL8qcCH/63PDeekRIImJXOftke9Io
	 l+MElGi/736oCkCh6mMD7EticxdsgS93rd9B2jzPDMZYXyaHZB1eqAu/KtUQGyVUDv
	 4qX8xj/i/3kKGoV8vyEnBc3dtT9uIvINcen6bsX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2077/2214] ibmveth: wait for the RX poll to return before freeing the RX queue
Date: Wed, 18 Nov 2026 16:02:33 +0100
Message-ID: <20261118150133.713823253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f09d19f6f8400..43cfcf68443d5 100644
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



