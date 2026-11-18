Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021466;
	b=T3R1d5z6Pw6hlhi0Lua53WEywcyqklWsw39PD83+MEXsXgBQYaQDHb1Bdn3w7kI8Jwjy
	 7G2BTK+YV1cZ3RRfI2YXkKg/VNbJk8gGitb0UTGCnofUHwxmoHzNeI4dH8GB9biwaMoIr
	 Zo5wxIvUuRfkflpx0RK9SyXO0k2fBoweRqSqKm0iK7RTIkQm7S468ru/Yva0VEJWT7z+f
	 XaQfhovCCHWQ+Ves5FPCrxjN/P2a8OtluzTz0K8hvKNCCNMtPodS3l36YfwhVQf4GL8n/
	 ySivOxURFO3lUqS4mU58aU2TuZfLHVe+u82T8AMgDagsdcSciMHhPrAdsz3QZDvI7Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t8owJNI4sT/5HWPjAa0uRx7GWlofZX3eVhU3iWq0VWU=;
	b=1JNqggcjOzhiZnSQ0Oka4ZbpAFT4N0CsmUHkYCVYtkBiw9XO5yzs4ZmxjX7WyZWFnvpC
	 XRj6JqJm6wT4IL8lUvD0CFdqg52Wml1H0kVwZVqJA1lgAeQq9Igpm5uFdUlO2bncpCN55
	 S8adS32qMrPfqGFpAAfhdaOL2EkZ7Jm/nYleroGXdHL22aJOFM6rQ0bxgUqfE/xK4hQq3
	 efTn+9x0memIj82aeltXe40a19Gu/2DhNzYQb6czPBn0HPYOb+yQtIYOF4FLd1qWzfP4j
	 L/eWyAmoM1C0McNEnC8u29nPbxIRh0tOvzri8hcyxhxSAxZXzd0riSzYrb/STVcTF+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RaA/n06Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A00560A382C;
	Wed, 18 Nov 2026 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RaA/n06Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00F61F000C5;
	Wed, 18 Nov 2026 17:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021466;
	bh=t8owJNI4sT/5HWPjAa0uRx7GWlofZX3eVhU3iWq0VWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RaA/n06YRAPkPOCZZOuPXXgTpUj2jzXL5nGvATVzfEk/RLIXUQmmcJEB+fz843Dhu
	 E/nRzoOSWy1Gkvk1jdzCY+XoxYvEqf01g/C5JQhJvNx5w4yaqy7riOtNuD19V1juQ+
	 l5o875yVkgZO4zOTMOKggNcTfzXmITgEC1W3dnxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2276/2651] ibmveth: wait for the RX poll to return before freeing the RX queue
Date: Wed, 18 Nov 2026 15:58:36 +0100
Message-ID: <20261118150407.265482736@linuxfoundation.org>
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
index f2570d637301b..85e176d0ed321 100644
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



