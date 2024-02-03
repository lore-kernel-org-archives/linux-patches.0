Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA20D171C7;
	Sat,  3 Feb 2024 04:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933540; cv=none; b=U+hxiwAbeGTWSUpGIeI6YbKUGCv1XrrorVp/l0t5a6mpr05kvvLfuS+1OnLDivOi6vS1plLy7uMdj1X0wk1JHxU5K7HstzCax3pVoSfvPUOvhOTSZo250SYyONoYudIqiKqiL3TKSuD3TTkglc1wwv5pA5QJ3DuIm8f1NnypXPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933540; c=relaxed/simple;
	bh=UD+X5NWI3EUsYRePQDFuzli/6cEbFh3bxGAjL1Y1jI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNgW9aEcoDEZmF6Ewos4yKcrFEl+sSZqGqR8upP0QDuhWTg6HSjzfiRMuFlGkFKFBE9iGjvc5cv5zFU/jCRV08bKQ8XxxHkl1K0UHoAmxyILILLT5bxrnhpDXcdEHxGFCHzgj/PabwckXXWMhPM+AjPzvzr8IkV6xQQ0vGIRX4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGLWt0yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGLWt0yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8375BC43390;
	Sat,  3 Feb 2024 04:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933540;
	bh=UD+X5NWI3EUsYRePQDFuzli/6cEbFh3bxGAjL1Y1jI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGLWt0yfS23nlL0GlhADyl5HjVqn5WoHJIX/E27ldOHwmFzRN7x/n9D7yMYpjkZ5w
	 cAJQZMmLbrjpjyoR9okVlRr88Ws7LwKtHTvy6nXxWZbwjx58bXRC6/7BVIoQiB1OEW
	 EThGvP+WLNt/y3aE4Dpqtt8FlWkjjHMhkeUJEz6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/322] wifi: ath9k: Fix potential array-index-out-of-bounds read in ath9k_htc_txstatus()
Date: Fri,  2 Feb 2024 20:03:03 -0800
Message-ID: <20240203035401.938033832@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minsuk Kang <linuxlovemin@yonsei.ac.kr>

[ Upstream commit 2adc886244dff60f948497b59affb6c6ebb3c348 ]

Fix an array-index-out-of-bounds read in ath9k_htc_txstatus(). The bug
occurs when txs->cnt, data from a URB provided by a USB device, is
bigger than the size of the array txs->txstatus, which is
HTC_MAX_TX_STATUS. WARN_ON() already checks it, but there is no bug
handling code after the check. Make the function return if that is the
case.

Found by a modified version of syzkaller.

UBSAN: array-index-out-of-bounds in htc_drv_txrx.c
index 13 is out of range for type '__wmi_event_txstatus [12]'
Call Trace:
 ath9k_htc_txstatus
 ath9k_wmi_event_tasklet
 tasklet_action_common
 __do_softirq
 irq_exit_rxu
 sysvec_apic_timer_interrupt

Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231113065756.1491991-1-linuxlovemin@yonsei.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 672789e3c55d..d6a3f001dacb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -652,9 +652,10 @@ void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event)
 	struct ath9k_htc_tx_event *tx_pend;
 	int i;
 
-	for (i = 0; i < txs->cnt; i++) {
-		WARN_ON(txs->cnt > HTC_MAX_TX_STATUS);
+	if (WARN_ON_ONCE(txs->cnt > HTC_MAX_TX_STATUS))
+		return;
 
+	for (i = 0; i < txs->cnt; i++) {
 		__txs = &txs->txstatus[i];
 
 		skb = ath9k_htc_tx_get_packet(priv, __txs);
-- 
2.43.0



