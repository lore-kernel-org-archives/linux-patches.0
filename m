Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210658;
	b=b++oBLxVCuU6G9NmtPkFCIHEhoRJbG2xZpDCTC+W8FH8Sdyma4ArXynDaoCPMum4HsAP
	 gD8Z1h784I4f/LB7TlOeZ720zWTHR82wMnwXHbI+tfnLTji1tQ9/JiA0Z6Ti3U2ILx1qP
	 Zuqy5LoYcE115oTIDF9FiHlEwEuWQWtDqn+kCcykrnFP0lM6SaGk10NYYGMnRz/72+Do2
	 jUqSzgw5eKKue3moK6saSzyFZRJzwBhKNdBn3Jni9XO2HmOJ7e5aLKrartSh+in+m2aS1
	 /hJsT4KbMK9GZZWt4AZPMjX3wG7yZXFcNTmUR8Fs1E2m/LhukhXS4Z3hE4rJoF8n30A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lq23yrwNp+OIX8hE53UFFj3I+uz5DFXyEeQWdIAO3FA=;
	b=nK1rfdLWwMOuPCkxajRDKs3ZNuzeUVcFO50V+4aa4i21wmEHwLzELGFMyLK8qiJefx1t
	 rz+yFCIcbAIsOFl8qsvV+O/0dS2QIQg2Kq+FhZqrs8MBIhdWnLHwL4z0BCdVkYCeusjhE
	 XB8ZFbLSQS9fdPVErbqirjvPB6GI29ui7CNuSqHwzmFUnUzach1qwVWMvkzJ1g+tXjXjV
	 qssrWANFzxmzz5dX6ulF3tTyeiFts9VZYb/SGBL8nVffcH3Od+Lnpb9tJ06xo/jH7CQbP
	 Mr/7UkvOf6lRo7ffjawtmbJuMonB2n0ZMld2q5ECtNnzMPtLLbFEkoYToHucvY04GQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hw7qVBTo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42966606A31A;
	Wed, 28 Oct 2026 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hw7qVBTo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623AF1F031E2;
	Wed, 28 Oct 2026 18:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210657;
	bh=lq23yrwNp+OIX8hE53UFFj3I+uz5DFXyEeQWdIAO3FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hw7qVBTohqlv+ILNKdfdfby+uH7CcH4BRKpRFK0bQIwmQ5hROOlx2OV+T3cjJquxJ
	 /t753zdUNrLBsc/f4RFBeAu3/bSFlG8aRtTla6qmjjjANv67MdhAXiluvBz5fXyMWB
	 qTt+9pcDde/GdtqBG5MZhGBxY7V1aP3bDf+TICJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/571] wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown
Date: Wed, 28 Oct 2026 17:54:10 +0100
Message-ID: <20261028170010.464239910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit d9be5e75530772fc31637070d51e5717d6aeaa2a ]

wcn36xx_dxe_deinit() tears down the TX ack timer with timer_delete(),
which only dequeues the timer and does not wait for a callback that is
already executing; the preceding free_irq() calls synchronize the
interrupt handlers only. The callback, wcn36xx_dxe_tx_timer(), can
therefore be running past the teardown and use the wcn freed along
with the ieee80211_hw in wcn36xx_remove(): it takes wcn->dxe_lock,
reads wcn->tx_ack_skb and passes wcn->hw to
ieee80211_tx_status_irqsafe().

Fix this by using timer_shutdown_sync(), which waits for a running
callback and also prevents the timer from being rearmed again. The
timer is set up again by wcn36xx_dxe_init() on the next start, so the
start/stop cycle is unaffected.

This issue was found by an in-house static analysis tool.

Fixes: fdf21cc37149 ("wcn36xx: Add TX ack support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260910020907.3353-1-fanwu01@zju.edu.cn
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ Adapted the patch to replace del_timer() instead of timer_delete(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index e1a35c2eadb6c..f3d850edbdbc7 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -1007,7 +1007,7 @@ void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
 
 	free_irq(wcn->tx_irq, wcn);
 	free_irq(wcn->rx_irq, wcn);
-	del_timer(&wcn->tx_ack_timer);
+	timer_shutdown_sync(&wcn->tx_ack_timer);
 
 	if (wcn->tx_ack_skb) {
 		ieee80211_tx_status_irqsafe(wcn->hw, wcn->tx_ack_skb);
-- 
2.53.0



