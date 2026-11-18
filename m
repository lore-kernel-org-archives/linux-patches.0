Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050300;
	b=Eke0eWn5wG29Ebtodd5HxpkGH+/TG0Eq0Eub6VaeMDOkVCVyqCW/WTnv/vrIYfUZmoRi
	 02E9KDEdUknzGFvTyrPnZ9cRwB43my7h2OWn4knfzKn1Ah1BLk+R13hbXBxRqXtf28AMK
	 cYGTJCjN9bXrDn4is0jl0pCazmhiPS2l8yL/CMY5HjBNGo/N1plDr9sbxlzYDiRETOdpK
	 oNsdqNXbGzj5MJLziKFoyfYjH3Q+vQx5Zgn9/jlafFHLCbolCZkfH4XKwYMkiKFqwcuqp
	 v/fJI3Lark8hL5G8vdYz0aUlz6DetAadNRCbIwtUhlQ67JyAWUsecS2GJCTF88K2/tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zJ3u2EFfNii+NLm4glwUiXuWTizQi+EM6hR8Ecdto08=;
	b=EnA5ZL9VfZYqO8lti8Q+xEITRh4olIpj1Fhcqpia2P7RrS9caCtGxDXg37gyVecbzb8z
	 8gHCZLK5gI6ZolAHKMXHZ7TNDyOrIQ0PWqOENwwf7n239xqmpi2a5z/5OAX+PAQ8iXze3
	 ZfHf2TQuHprJ+tIvXDYIoCph6jTm2QHY8I1QLUP5BUsJl5XoNjpfj0Xk/vZ+zkAHGK0Po
	 YhCy8PcHqxWZVOfEtzMZMnS0t06hJcYqDlu1WT72IBufGD0wsfDpgZTDoo8nlkn7I5e1r
	 5izyxtG5pDIrUxBV4+nRHey7J9QLlYv6DwYAz4AA8r4qT4aCFgLiNGj9DiU6cWARB7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrwoE7BS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CC060A2603;
	Thu, 19 Nov 2026 01:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrwoE7BS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BB01F000C4;
	Thu, 19 Nov 2026 01:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050300;
	bh=zJ3u2EFfNii+NLm4glwUiXuWTizQi+EM6hR8Ecdto08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrwoE7BSEiqTpuh6cYJ0XHS0xUHAr/jep7MeNWt/w9HvvQHYkiqvQg3t2pK5VrXEg
	 098NXCnw+sSsIus+cNViT9UBt5NZuPwO1bgxLjfp8qUQm4LrqZTHCKo6DG3aLoEA4s
	 SPhArUwqzMzV9nMcozSZoycDNDNXALrVB3iZVauc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2658/2857] ibmveth: wait for the RX poll to return before freeing the RX queue
Date: Wed, 18 Nov 2026 16:01:32 +0100
Message-ID: <20261118150337.281718128@linuxfoundation.org>
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



