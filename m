Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC9142DFEC;
	Tue, 21 Jul 2026 19:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662309; cv=none; b=AC3EFeYUbRXRb6GOkdXrWZ6cpFRdXN4SBSblu4vcr1fNpu1qeUTWy0+D7SkuLo+VhShUhgSirE6Iynb2MtYhseN3Btl8wDan8x9lqQLMhWArXg1Ephj0uPiSMkWEdGVs11a1LWsg37S+rK/G/7MZB5mqasiOvUnygeTrLVQW8EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662309; c=relaxed/simple;
	bh=cnI7VBYnGJ/vqabb1yKCa73sTYgWxO4yfEKTNSBweys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5PX57IfVE6Qz/v2e9tsqSp+ZUP5J6WU6bY+WBuu/QoptneQiFcvR0CT6BLV4daWdMkcJ0oYKm17Ppm0O0HCgt/2HsQTp0S/YegWlOq6cZPGdIigifnCTuxnN99a0N70w/yQxqI8oEYV1jFJ8J5dR8i8agsj+A0Mybu4GSls8IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyzerB/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyzerB/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744D51F000E9;
	Tue, 21 Jul 2026 19:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662307;
	bh=SN19s3h9Kg7hVb/5OuijKfIc29gXYZ6qKZnR6+hfsCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyzerB/uzPcqaLD2qDP/gi2+griWPzZTxlmGEIQSWsacSoO7IONNDcZ2vC6h8zn26
	 usx+EXvA3cJ6GzOQWZeFsGnI1X6TzW/CuO/NtZid23HxrxW+2RZ/sshfqoy/7OpRTG
	 ZGJLALDSQYsNjBfEpjjiFwkMzTAfTQLS2TqSC5lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wayen.Yan" <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0395/1276] net: airoha: Fix always-true condition in PPE1 queue reservation loop
Date: Tue, 21 Jul 2026 17:13:58 +0200
Message-ID: <20260721152454.945637665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen.Yan <win847@gmail.com>

[ Upstream commit c66f8511a8109fa50767941b26d3623e316fde02 ]

In airoha_fe_pse_ports_init(), the inner condition for PPE1 queue
reservation is identical to the for-loop bound, making it always true
and the else branch dead code:

  for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_PPE1]; q++) {
      if (q < pse_port_num_queues[FE_PSE_PORT_PPE1])  /* always true */
          set RSV_PAGES;
      else
          set 0;  /* unreachable */
  }

The intended behavior is to reserve pages only for the first half of
the queues, matching the PPE2 implementation on line 334 which
correctly uses the /2 divisor. Fix the PPE1 condition accordingly.

Fixes: 23020f049327 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Wayen.Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/6a2ca3de.ad59c0a6.147df9.2ac1@mx.google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index 0f70dda9344114..4dab9237006d4b 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -1238,7 +1238,7 @@ static void airoha_fe_pse_ports_init(struct airoha_eth *eth)
 					 PSE_QUEUE_RSV_PAGES);
 	/* PPE1 */
 	for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_PPE1]; q++) {
-		if (q < pse_port_num_queues[FE_PSE_PORT_PPE1])
+		if (q < pse_port_num_queues[FE_PSE_PORT_PPE1] / 2)
 			airoha_fe_set_pse_oq_rsv(eth, FE_PSE_PORT_PPE1, q,
 						 PSE_QUEUE_RSV_PAGES);
 		else
-- 
2.53.0



