Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5616212C81F;
	Wed,  7 Aug 2024 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043038; cv=none; b=g4gqjejuOwJdM+qLFp+/RoPp6ZTOypfCWf9y3BCC7CpuWg0ldQ0rjGvsdGzHmLdKAh7B1d3/zoM1nqX6BcbL/V7Zyd4V3dTIML6U1R2w9kFW3E9oWumbc0cPMb8w89qbGth9lfYJMw632ABGxigrexfuRJLH1Nb2LCaI6JM2jFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043038; c=relaxed/simple;
	bh=eJy6Fo+ddtW4ZjLeaZIVmPTin1B7TVGEMEXA2ym9eeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OamaDB7l/qs/DehUDByM23LnJM0+OJSseGVEpD+2VGx/GuQS9m0MTHSn+eZrTq9/zKt8h+WOJwv1v9X8JNaQRAEpHxDn6yauD0nIqmDk4eRd1H3VSplOaKlKDydlqJTAh9ub7BdpPMM6SaTDomyJuOMoTYpuub1kiQntWsRSTu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFovs5J5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFovs5J5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66D6C32781;
	Wed,  7 Aug 2024 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043038;
	bh=eJy6Fo+ddtW4ZjLeaZIVmPTin1B7TVGEMEXA2ym9eeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFovs5J5YerssKiMNsKkqb6O0Jzd19eIysj5bqDGR51nAAWFGA/bbPq60HOZYKhQE
	 7J1ElE8AC6+/0gmJokqwCBTEgXjRjkiFwYfjwC5Jv1tT1TF7RwB46LlcZqwU4kljiy
	 eG5HVU/qUSgpoaj+kC3AE6wgXscAfQUc+lRwCYYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <andy.chiu@sifive.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 038/123] net: axienet: start napi before enabling Rx/Tx
Date: Wed,  7 Aug 2024 16:59:17 +0200
Message-ID: <20240807150022.070047144@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chiu <andy.chiu@sifive.com>

[ Upstream commit 799a829507506924add8a7620493adc1c3cfda30 ]

softirq may get lost if an Rx interrupt comes before we call
napi_enable. Move napi_enable in front of axienet_setoptions(), which
turns on the device, to address the issue.

Link: https://lists.gnu.org/archive/html/qemu-devel/2024-07/msg06160.html
Fixes: cc37610caaf8 ("net: axienet: implement NAPI and GRO receive")
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index c29809cd92015..fa510f4e26008 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2219,9 +2219,9 @@ static void axienet_dma_err_handler(struct work_struct *work)
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 	axienet_set_mac_address(ndev, NULL);
 	axienet_set_multicast_list(ndev);
-	axienet_setoptions(ndev, lp->options);
 	napi_enable(&lp->napi_rx);
 	napi_enable(&lp->napi_tx);
+	axienet_setoptions(ndev, lp->options);
 }
 
 /**
-- 
2.43.0



