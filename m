Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032726;
	b=oN0zFzBYMPhE207stTnYl1WSS/rwwWTMXAalYwapeIE1U8TY2i5eLyo9LxQ05QiupLs+
	 rvkdsi52YQrOGWsG7MMlwiJXsH5oanPdoVwNYmSKizBE9yL+qpPdgrVIJ27sb3NIDTJOX
	 yx3Tah5Fvy2+9BCRaO0R/oXFgPjWyV9+gs7Sy+Vck+VvdRuGOsW/fwtUiehuNCEtdu+I5
	 /pvnOTqQG20emCTrB5SvZ7lCkBqbvcUWQQT3p4i9uk5vlTWIczFkCM4o10f3xlV0/OPMt
	 CiKHU0J3CUX4X77w/ucwXmAFS61c7of/veAwR/tMpF3xesZ1K0/UpvaahUqRcSll39g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a/s8gdqvs0NHl8SuIEH6psh2XbFWHwWIusfKYxbbopE=;
	b=nuhi2xVaUjyL5w+ObsADiXqaidtLznzVwtq53ik80k5svZ4uynnK0fVKJKjTW9qXFb5P
	 9h6jKP46vS2THeIoNunZKxHwwLTe1+v6nOvD2w3Z2jMTtyqRQ3rzPoGJOT2JG3svY0Sth
	 rUwNaZa7cts40ZIpGXBOUjx0PMBRI8euacViNPWc6/qovngxdeCig2h/J1Wq7whZPDD8o
	 pyFwBRsByAY+XOnwXBocawNa5T8IJ6TOGrJTuxCOoNQNERJrHgfBEntGCYuFaCa+IvSCX
	 jj8Ami3m8QelwPHlcxFrfzYhdsiqRN10KdzYJxvxjA9sogU/Obw6vYAtpu/UcJiDqcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi9W7E1C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645CE606A325;
	Wed, 18 Nov 2026 20:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi9W7E1C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEDF1F000C4;
	Wed, 18 Nov 2026 20:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032726;
	bh=a/s8gdqvs0NHl8SuIEH6psh2XbFWHwWIusfKYxbbopE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pi9W7E1CEaJPD+cjBSW4Jt/5XmgoQotb8J1sOSOciNJObv4Fa9sgZKnBp3CucyIp4
	 d07BZyTuFoD8npAGsW1K2055wLWJZrPjk3wQHLq+CL29McUyDtfLhXPbgIVYpTMr5l
	 oGyES5/8kyghyZz5+aw87NBgq3cCOTZCChOmVMKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1470/1756] ibmveth: wait for the RX poll to return before freeing the RX queue
Date: Wed, 18 Nov 2026 15:59:57 +0100
Message-ID: <20261118150107.541366815@linuxfoundation.org>
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
index 1a42d26027e7b..afddb6a0d3e50 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -616,6 +616,7 @@ static int ibmveth_open(struct net_device *netdev)
 			 netdev);
 	if (rc != 0) {
 		napi_disable(&adapter->napi);
+		synchronize_net();
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
 		goto out_free_buffer_pools;
@@ -673,6 +674,11 @@ static int ibmveth_close(struct net_device *netdev)
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



