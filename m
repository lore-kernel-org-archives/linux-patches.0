Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208397;
	b=sSoy9rSs4Jm1ctKaYhO5xyMbiUQytR81ksXQSzfRmBUbZ+WGIE4RaPVBlcN16wRz9OM8
	 ZF19EynFWCUu2aNZf4WmcXnmSEUrcKcE3uCnLS0WMD7Wol3rOVXfi9fOdjeMCEDWDaoiZ
	 kpq7KQKqv9bZ/FINStQIZZhRRe/3rdcuS5PT0FlPjQ5TDFbo9KlptfCEVikyzbydbZ/Kk
	 0K7IOZ3UQBBUPTmYqLXecPWQ+XZ5yJ62BhCq5ovSTtqFzor7GiuXH6lYniCEwMSImuIoG
	 h6dh8MAg2eVf7il3jAjtd+M/HvCXe00PBc7f/B6cYA5B6ElsIkBWh5X4Ol+wNwwQ5JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ZceTCZ4qirpfZ7dypdagBDJdOkGvTQLN7V2XEAO02E=;
	b=WSGxSXL/JkKzGnVBVAuDL1EsPLiKVzy1vGkb6GITlBkIjtZhITh5ob0pBt8SkBNMFFBD
	 hsun2bgFMgdQTz15mTSmJbWEBJ9fqDIMcIhByfLniCT9berhdaOT4BuxgkgXAqF+KLwOQ
	 3yZd+/69ejZFSY4eTsoaddjnjtZQRrv4wQO2J0xqKgxVa6lozrr5xSr8KogXptT+eq0CK
	 5RyDrRH1TRyoP/pq6aNkC++Oorzx9euk4Jqr2F925gLlSg+vGp/jDGiwxk6Mpj6exDIJ1
	 DZIwF0aQSWb3IaRdMx4KchojKuq6ULytCxlIu5Ule1LcHgmzjdc0+1moe11udhfPTwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VXQfnpa8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDF2606A31C;
	Wed, 28 Oct 2026 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VXQfnpa8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4BA1F01825;
	Wed, 28 Oct 2026 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208397;
	bh=+ZceTCZ4qirpfZ7dypdagBDJdOkGvTQLN7V2XEAO02E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXQfnpa8MmgSICcFm/GcfJevPcffy1J4wdwaAGJNBkdFR8GyJlH7aaEJtJ/Le4Icx
	 JnOWTUQUjVLDrlABsYeHTvM+GBVW+Jy+/rXgS6PLsRgHwYAfvo4VFrfXCax+dBoEj7
	 dv4bE+E7DESVamGVBsRpw1txArPrSihI4ttfEfy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/516] wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown
Date: Wed, 28 Oct 2026 17:54:18 +0100
Message-ID: <20261028170006.028366000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
[ Replaced unavailable timer_shutdown_sync() with timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 6c62ffc799a2b..6840aca0dd3ec 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -1007,7 +1007,7 @@ void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
 
 	free_irq(wcn->tx_irq, wcn);
 	free_irq(wcn->rx_irq, wcn);
-	del_timer(&wcn->tx_ack_timer);
+	timer_delete_sync(&wcn->tx_ack_timer);
 
 	if (wcn->tx_ack_skb) {
 		ieee80211_tx_status_irqsafe(wcn->hw, wcn->tx_ack_skb);
-- 
2.53.0



