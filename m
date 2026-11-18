Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039242;
	b=0NCJn6gO0hyLai3vjGtxZ3gJJ1VkmDhbf/27/hjjKwFpRErky+bdVOa1E8be1CBJ6x8T
	 sSl/RtXWAIOuzvtcHTN/3o5cidAkH798hKhMNzi7Bjjz8GD35AvtWNX/3Z+F3RET5lRF3
	 HzFveoKBZhyQlpDDopG60SkGnr6pEPDe1tc43PQHIdZ0QxtKo48Ezh4BEx8JRHWowuGOb
	 33szkYBz4xz27LYiUXrdm16wJX3opscbT176FQ4G1o9jblVEs3fCZrJmYspH53TRjdRzV
	 pTPa8FkXpfL7koEbWLLJ4wDt3Z6jK16Nf+i/XKm8/XcI+oJKarHYgTqU/08UQt4jkfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0IuyKCu0iElOQxppc1FaXw4NZB5RX0R+Qldr8eC/9+A=;
	b=bKxbiVvvMn1e58dd00ixvgHUUBprsfMhU0P/IgQPcfIaPMlSR1ZjKM/9ZEFulManlVfN
	 SOkMQTqYKRGEum58vCffgFdiBN+rOXiDTuFEOsGo5nKgFpXRQMLJJbllAZXploK/3cPlt
	 SQgeyCi77SevVXiZSH99YLWUHgFgr+h4U1JQ0ZQLV/b6MG151Wa4Rry9zwWrm591qnSxE
	 TnGnx9hWJAJjkKyg7mHaOlZtO6XIX6/PZg2EoEGWcT+ANh69DH9GeDfrhpfQ1hZH6UCK9
	 4kp2uXpyHi9kKJClYoQjAFi0J3exlJepSMyYR2KxOhcbiemzZ/ZPhYfFHck2rVMorcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFOedCJ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E51A606A331;
	Wed, 18 Nov 2026 22:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFOedCJ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5289E1F000C7;
	Wed, 18 Nov 2026 22:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039241;
	bh=0IuyKCu0iElOQxppc1FaXw4NZB5RX0R+Qldr8eC/9+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFOedCJ7Wmq8JsQU0CKn6Eb5CSkkroTKGNacdWZZQl4dC1/8dxpBGn/ta5o+CJz+T
	 DDk7KIV3yw8jbKHPP/ANVcrVC/sJf6kiRs7KtGT8nbCc3Qo1b8pjU30Uh9aovIqMK0
	 gXt7HpKzgcAI0y0ah8e0k9DzUAIKBr71UBtOVrPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2030/3318] staging: octeon: schedule the TX cleanup tasklet every 1024th packet
Date: Wed, 18 Nov 2026 15:44:12 +0100
Message-ID: <20261118150422.943609430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e54b4a413dc40..4c66d43b66ee1 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -483,7 +483,7 @@ netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 			cvmx_fau_fetch_and_add32(FAU_TOTAL_TX_TO_CLEAN, 1);
 	}
 
-	if (total_to_clean & 0x3ff) {
+	if ((total_to_clean & 0x3ff) == 0) {
 		/*
 		 * Schedule the cleanup tasklet every 1024 packets for
 		 * the pathological case of high traffic on one port
-- 
2.53.0



