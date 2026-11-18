Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027573;
	b=NF6y57kAh9zpLfZOSk7GWLF44u5ZDg0thr1S1cujTcUzocvRQnk77TiV66zEz+tBZ+DD
	 ce9j9FU+drsXsIRr0X6aRP1oT45YwoxDEm/bx0ccPgUakvNNReRi+fZEjFyv6bOrst3rD
	 oW/onN7OcA8L9lWHzeo40VDXCk7UFKd2DHFFVihjZs5yX1dmei6aaj6H48jnQPvqeGF/G
	 TP6125wU0wZxLjlS8yS/Xpcff6qasx+7smNAgspPNjb5SoJQNuz/qAfdLqDRNEBFptN2F
	 jajObl7TR+KPqdfklRLi/fKkcbnmfF5DeVSeushw46Q4u9Kqud4sFMR3YYGOLLaef4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eYjrgvvFF0yKNycj983gLaJrmnJfza8QRgEFC/a2zFQ=;
	b=gLKvrsBJLjF40x0HSJa6d1GBpgUE4gKxvNDtp2M3lH2ygjMkPUe4cUXto0w2dUy2uCmt
	 jNX38hECy5HLsANp5o3PVopGcqhDzLYvBpd61KEsfp9lM75hrHzz5ff+fLhT4XrTOXaqA
	 C87HkMqmLkRejheQYjZj+bZXDlzGlfh/aCgPI+pQ7C2farDZaiDnHRw/BSOPKJtXNyD6b
	 qonPmZgIbnW8tceruvrLoFvqFD0cDnrnKWv9huLsSDdlyay36TVjBdWFiFnJVzK61urjC
	 TE/3fo1ODcMLuTwpUxbXNoSTnrUtzr1vftgyy4f3iTdeQ3toc0tesLWi8hhHbcKsP/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wUQgAuHP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCFC60A2605;
	Wed, 18 Nov 2026 18:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wUQgAuHP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5251F000C5;
	Wed, 18 Nov 2026 18:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027573;
	bh=eYjrgvvFF0yKNycj983gLaJrmnJfza8QRgEFC/a2zFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUQgAuHPS8h2gHROoyq5PEXHaJ0xutIdtXXTPZfAAuExqs5xnfIqUPbZRNyi2KXT8
	 iHSTR4h1JyfPAi6r1RMXxsxJr1reqgHXyannttvJ4h1klypBYj3ee5cGUw8WOb4jk/
	 V1p3Ef/1sqFfR+UIq1LhFHVOVTpEkzsHIch0k3sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1838/2151] ibmveth: wait for the RX poll to return before freeing the RX queue
Date: Wed, 18 Nov 2026 15:59:33 +0100
Message-ID: <20261118150228.752500606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6a0751c862cf4..024afa9645bc5 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -768,6 +768,7 @@ static int ibmveth_open(struct net_device *netdev)
 			 netdev);
 	if (rc != 0) {
 		napi_disable(&adapter->napi);
+		synchronize_net();
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
 		goto out_free_buffer_pools;
@@ -834,6 +835,11 @@ static int ibmveth_close(struct net_device *netdev)
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



