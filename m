Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027570;
	b=knobRZIB3GrQgg6898Avbe8+E3QJhYYGY2aZSehVxUYRBCdQrKuRWwnwHf+aUJ4Il5a9
	 Ykl6lIqw5YFKCrb3eU/Wl4VoDokCL4RR7KHDFbpOgJkH2PyEZCW2iIZB4Ei9xdhHckfR+
	 A9usYiPLpe925aRxdZdEfXI6GBfU+xp30iLMdSJQrRh2l5u+RZhpdI6pFeCGupyw/CZj2
	 RQA55Y3Pc4Bu0OPSc0x5UngpDKeZG4zA7InenTv4rA/CK+qmcaZXtmv03FJMsfsXCC32I
	 DxFRiHAeOk0OPVDvoF8qP9ODsoXRbtjwg62htfQoRpURQKjlL1ePRjRXVMTTzi4/6Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OzmYP2JccwjmFlVjCabtt75N4Lvf96vSBitDmpzsRxw=;
	b=ddCtI+Ub6N0qKNUD9wD+9aHH/VB/d7Ku5xOz02o8VnO8HYY/QNFUyufrAGmCx80sFjPk
	 WJMKnWdYhq/fgAjU6XI9RJJlUsqiSvaa7j/T1/COxgkEufsaZcm3C3vJ4rI8SSQYTFPGx
	 LL63labQwMJ+sEBWv0sWQfktKyGIautR/Sixq5fNNbVacZOU5qAd8Xw99KvdWPCUm91P3
	 m3rjhsPZGBtM4di7C4QLzfFQkiAd1CBiXgvUnLBu4pYwTfe25oazSCQV91a0+CoK9Ld5W
	 l9ulDKvurdTTVtJ+ggGJRUz+co1yZ7+jSaFHfL4lnBS4kufBWoz/0cR2QboUedSwbqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZCEGk3Tf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D33606A331;
	Wed, 18 Nov 2026 18:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZCEGk3Tf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B4D1F000C4;
	Wed, 18 Nov 2026 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027570;
	bh=OzmYP2JccwjmFlVjCabtt75N4Lvf96vSBitDmpzsRxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZCEGk3TfccnRFBDq+bLeOdhWryUesDepvKr7oFs57FXmM+/IIwwyfLB8ILW0LAOUk
	 iuOKjWuxTtnwlo4suLfiqtpyZvTENj/8kg810GLdDjR9a1MOf7GB1dOdXi4ZvEukav
	 y+SXuDwaIh1ibtqTlF0ivdcQnBqWSpOSrx+WFsQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1837/2151] ibmveth: wait for in-flight transmits in ibmveth_close()
Date: Wed, 18 Nov 2026 15:59:32 +0100
Message-ID: <20261118150228.716229774@linuxfoundation.org>
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
index 8fddded94a5b6..6a0751c862cf4 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -835,7 +835,7 @@ static int ibmveth_close(struct net_device *netdev)
 
 	napi_disable(&adapter->napi);
 
-	netif_tx_stop_all_queues(netdev);
+	netif_tx_disable(netdev);
 
 	h_vio_signal(adapter->vdev->unit_address, VIO_IRQ_DISABLE);
 
-- 
2.53.0



