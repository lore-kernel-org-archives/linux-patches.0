Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B6817966F;
	Wed,  3 Jul 2024 11:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004879; cv=none; b=L+3LMalhdpIVWQVSn8GH7b4y8GzNifK6efB67n3rPkUYMKGB6N2b9QTCKRjS9H/ejtip55lporT7U2iD+Z3QbVvIoaheIewYs/+DlznVDxkM1HYhPzoej5NygCAAnU7g0+WQ5juQ0be3BiYXsYYmD7El62BwUmDcuB8CL6cFadY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004879; c=relaxed/simple;
	bh=DbkVV5hF7EdfSgpr61V+IEtIzRT+mmVhsVNfPhtH2Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/CsFDDwTF9brCMIv1lDvp8RMaS3jrB7AKMjhrtVMYCLAKia+bBYm4kPBrA6IH6aiihnQrOg85YQ6TCKtdWHmvapYVmH+arvBVQJIMUNPS3ZuR11xI5RTC0c7xqNEo7ySPcgjmL2CBy8oW6K9Wnp8bjO1YZbFNLM0vISDGRiXvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+UZNU5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+UZNU5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CE4C2BD10;
	Wed,  3 Jul 2024 11:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004879;
	bh=DbkVV5hF7EdfSgpr61V+IEtIzRT+mmVhsVNfPhtH2Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+UZNU5zx3s4yHR8Ps2M74bIjxfLhBdGj9fI8XAEr3U4bb7kLzwYlrdWolyarFswQ
	 31pmUvIunB+WtIf9Twqh3/+e3MXs1Wh8l3IbDC1xDJdyvkz42e+KCvGI7mHfVUgF9u
	 09929yB+XCjKp0pRmMTbE1OfXo1Wu5RUFAbSoIYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/290] r8169: improve rtl8169_start_xmit
Date: Wed,  3 Jul 2024 12:39:27 +0200
Message-ID: <20240703102911.196700578@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 41294e6a434d4f19e957c55b275ea0324f275009 ]

Improve the following in rtl8169_start_xmit:
- tp->cur_tx can be accessed in parallel by rtl_tx(), therefore
  annotate the race by using WRITE_ONCE
- avoid checking stop_queue a second time by moving the doorbell check
- netif_stop_queue() uses atomic operation set_bit() that includes a
  full memory barrier on some platforms, therefore use
  smp_mb__after_atomic to avoid overhead

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/80085451-3eaf-507a-c7c0-08d607c46fbc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c71e3a5cffd5 ("r8169: Fix possible ring buffer corruption on fragmented Tx packets.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0847b64fbb2f4..b678fd1436a4c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4331,7 +4331,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	/* rtl_tx needs to see descriptor changes before updated tp->cur_tx */
 	smp_wmb();
 
-	tp->cur_tx += frags + 1;
+	WRITE_ONCE(tp->cur_tx, tp->cur_tx + frags + 1);
 
 	stop_queue = !rtl_tx_slots_avail(tp, MAX_SKB_FRAGS);
 	if (unlikely(stop_queue)) {
@@ -4340,13 +4340,6 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		 */
 		smp_wmb();
 		netif_stop_queue(dev);
-		door_bell = true;
-	}
-
-	if (door_bell)
-		rtl8169_doorbell(tp);
-
-	if (unlikely(stop_queue)) {
 		/* Sync with rtl_tx:
 		 * - publish queue status and cur_tx ring index (write barrier)
 		 * - refresh dirty_tx ring index (read barrier).
@@ -4354,11 +4347,15 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		 * status and forget to wake up queue, a racing rtl_tx thread
 		 * can't.
 		 */
-		smp_mb();
+		smp_mb__after_atomic();
 		if (rtl_tx_slots_avail(tp, MAX_SKB_FRAGS))
 			netif_start_queue(dev);
+		door_bell = true;
 	}
 
+	if (door_bell)
+		rtl8169_doorbell(tp);
+
 	return NETDEV_TX_OK;
 
 err_dma_1:
-- 
2.43.0



