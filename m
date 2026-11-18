Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042205;
	b=p/zi35SJNdlU4B+F4BSLAOb+ZfwJTvO1DXvCDU5wD6ucsVN7b9KiNPIVKkjE2qJFHnGC
	 sy6OGHtevp4j0fWS6QzwA0bIUFOn8LT7u5EpVL1abGVhSzLf6/1gN3Ox0/xG8Fj2pQbtW
	 Cti8yx28TdT7zi1C53XHocCe/IyJxZLsdEhoEjTjTDcMyBl47ZxpyxrLO+F0pktrCdLd7
	 MOUHe6pbjeb8HHy+nKvwqv/1CKK2y6J6sYqyHKd8HoBUkrTQ5MHaTNo15U23QpVKnfXSg
	 NN4tKYe9d1e0KoGH30ZTBC33YSR/w3Yz5Oi+iQTAxNTwPbFFBMxJQw8U/ECJxLV3Bgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q2TKJKVChgUDZULwCDAh/QVmcdsaX+li2srXebuFI8c=;
	b=LcztaEZIZ/tAMweROySTtk6f1T9SJjfA2lyR0D5WpUF15lKWz+VAHmBgPLyWnM0peesf
	 EBdWqpbfDMWIs+7gYyhKuwAQasiC8aQn9rYumvw/WMOD3YU8CuSehS8qlb3Le2vHeCJmb
	 iBKqTlggxw0Ym65bYrkDG9SzaZNWMbeBhjs0RB4jrOs5M+IEoXkXdkhavnCjUOpEcH9JE
	 p0L2drbtOq7Ho+nIIBOqsXX20bsXHsgMq6BzlB9HC0fAH3wHdG+2AWR4Pq1/9dgp5i68W
	 WNjLTZbF/leBGjoIQ8v2vD556rOywD5QJVaaeJPplBC9Ji0aMWd+B+fbyJTEhRczfNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uA/zNPVw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BF2606A325;
	Wed, 18 Nov 2026 22:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uA/zNPVw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFC71F000C4;
	Wed, 18 Nov 2026 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042204;
	bh=Q2TKJKVChgUDZULwCDAh/QVmcdsaX+li2srXebuFI8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uA/zNPVwklBaywLyc4J4RHZUTcHRrEPPTkLHFl/zYg6ChSGYuj0r0s5IXJ/JKJ26f
	 1A+F7gmZ+e8WAtvrKCYedt+kM1ZVhb+VI/F6c+lY4H2AWml+8qQX+Yohtvx5Td3fE+
	 BUGS/JJUwhUVVB+2UcOJbHECG6/T1FpJ8UcCLCGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3087/3318] ibmveth: wait for the RX poll to return before freeing the RX queue
Date: Wed, 18 Nov 2026 16:01:49 +0100
Message-ID: <20261118150452.658772503@linuxfoundation.org>
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
index 04dfeb5ea7f94..b2f2d7d8422c0 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -639,6 +639,7 @@ static int ibmveth_open(struct net_device *netdev)
 			 netdev);
 	if (rc != 0) {
 		napi_disable(&adapter->napi);
+		synchronize_net();
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
 		goto out_free_buffer_pools;
@@ -696,6 +697,11 @@ static int ibmveth_close(struct net_device *netdev)
 	netdev_dbg(netdev, "close starting\n");
 
 	napi_disable(&adapter->napi);
+	/* napi_disable() returns once ibmveth_poll() has called
+	 * napi_complete_done(), but the poll still re-enables the
+	 * interrupt and reads the RX queue after that.
+	 */
+	synchronize_net();
 
 	netif_tx_disable(netdev);
 
-- 
2.53.0



