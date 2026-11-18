Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047856;
	b=4omDrRNDZTS1FwSkxDfPWnA07Bkl5vw4T4L+gBY+MwlKzBESkUdVCbxCpXE2XE+9Z3DT
	 uVoNms2FY+BbCr8swEkIsTrau/Ac14dYwgoDpmWQubQjA+doQPG4RkXzAagI6IdhY/4Rh
	 Tt5c3rHvAWPWd5conBA9Hkc5fFPujXjgoFDII8iTYfpjFNopohrIKCsfUHCNyoGyUnnTY
	 zC7BFLH2+aKv5DgI3CTqCV7aZhojKWRK6qWPCswyQEhbvg0qw3x27R+7BWK35t+toIcAC
	 HXhF7TdGpS/5utbErSDWO3W1NIyYokr9uMJuVQYGQXRm11ZCaCxD3preShUUTVZhjqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4PlwTsDNDBulrTWQqQyOGo5cdXakQ2NXuZmgiaTAA2g=;
	b=XTplfYNMfmVhuN9SsrzpA5LI+8f+qQH5k0LmsEhdbewcO8BwP5vG7gzkO5+wM0tC3h/m
	 +yKhw7WD+mctNg5HIKMprD4Rb8U9rSifIS+/yZdePPq1zdIQ0INuTyLmGiGRHMsMSZ1/M
	 ihG0HWTTzG7Y8xRzjnw3HqW40BSksozXYu8hyefXzKvXkPKpaGh6yjuBgRx8ae3/QSnSU
	 +R0xGYlh6s5IGWH5xYylq2xXH/9guUPcO/zWN0wgbfOvqVzpZWfPxOWhC8xyeG8AvWEYF
	 ck8CD83BaPaxmbUDbOriN8WyEoo4nvGXDzImoJtOsGW15JvNKxK5DtqN4FczI0KwnzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JImWv50Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF82606A31C;
	Thu, 19 Nov 2026 00:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JImWv50Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38AD1F000C6;
	Thu, 19 Nov 2026 00:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047856;
	bh=4PlwTsDNDBulrTWQqQyOGo5cdXakQ2NXuZmgiaTAA2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JImWv50Zrsor4DcSGnbhhJyHuT+pAiOCpknEVYTRIJOl9N4zmv4e147l0lbw3I2LW
	 p8I/CwfBR9BhZeI9wIC9xT92faaf3QpWgnnCfH05PpKRdwX3o4Ja06jmMwMRG2uB6B
	 DdxMObuSFom5iCf5bnLcAmcAe1UJGxdyEt3Y2f2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1771/2857] staging: octeon: schedule the TX cleanup tasklet every 1024th packet
Date: Wed, 18 Nov 2026 15:46:45 +0100
Message-ID: <20261118150305.049024869@linuxfoundation.org>
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

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit db57f6517bf65523968ae29cd34a790bfa7d32af ]

cvm_oct_xmit() means to schedule the cleanup tasklet once every 1024
packets, as its comment says, to cover the pathological case of heavy
traffic on one port delaying the cleanup of another port blocked
waiting for it.

The test is inverted: total_to_clean & 0x3ff is true for 1023 of every
1024 values, and false only on the multiples of 1024. So the tasklet is
scheduled on nearly every packet, and skipped on exactly the packet the
comment wants. That costs one TASKLET softirq per transmitted packet,
each walking every port and doing an FAU fetch-and-add per non-empty
queue, and it buys nothing for this port, which already frees its
completed skbs inline from the skb_to_free value it reads out of the
FAU.

Test the mask against zero. On a CN50XX board (2 cores at 300MHz)
carrying ~6.9k transmitted packets/s, TASKLET softirqs drop from 7133/s
to 597/s with no throughput change; the freeing work is conserved, so
this removes softirq entries, not work.

Fixes: 4898c560103f ("Staging: Octeon:  Free transmit SKBs in a timely manner")
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260820113239.8169-1-orgads@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 9244bccc7afb9..de6c2fd9ae8d8 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -485,7 +485,7 @@ netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 			cvmx_fau_fetch_and_add32(FAU_TOTAL_TX_TO_CLEAN, 1);
 	}
 
-	if (total_to_clean & 0x3ff) {
+	if ((total_to_clean & 0x3ff) == 0) {
 		/*
 		 * Schedule the cleanup tasklet every 1024 packets for
 		 * the pathological case of high traffic on one port
-- 
2.53.0



