Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400747E58D;
	Wed, 21 Feb 2024 13:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522515; cv=none; b=O05C5gQwIRPRF+x4xvnpOYAVLymnnLq+TrZUxs/6Pug0PqpTRqtNXUNWnV9ri58o52CPq3Kl/9zpgBFdDJe1f3e8E49T4UB3BLZ1uDVl7OKL019iZgIEljRxfamoNYGWv4fqf9CG3oIGv+d0lRgc9HgufaNXzrDJ+nhbDEuTyxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522515; c=relaxed/simple;
	bh=tVfzMxPNbWpjqt+WSWQtwPj61Wph+HKmnb1xIyhQbRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jrb1Xdl/+8V+sUqQKLEKv9yMb6oPcY5VkQLjdocJg+Ta011fWk2ap4iznO54iqqXMxTItelQQYUMMOc0G/M3sRzEadA0Nl8UdJt/IfAH7wBXKyJZP2HPtQOoORTdHLaUjWphwdl7Nvuw2KjZUZhWJIY+9P06l++9EcSQ1BdExoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nR9XhBn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nR9XhBn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EB4C433F1;
	Wed, 21 Feb 2024 13:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522514;
	bh=tVfzMxPNbWpjqt+WSWQtwPj61Wph+HKmnb1xIyhQbRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nR9XhBn0/NnfxAc/IOvGjtZyAl1bBjrHDazbIx+46q6yhbCHKxh5zdonmCbUPZWWb
	 i3vCSk4oHziPbsCzxq6N2J1aixYCl+w1My2iHT1zId6odDrdgXBWWPIFUXPrYYcQhS
	 gBFTFqyHs2q66SpEREMQ91Lcf2EaWV0Pz9hHngrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/476] wifi: ath9k: Fix potential array-index-out-of-bounds read in ath9k_htc_txstatus()
Date: Wed, 21 Feb 2024 14:03:47 +0100
Message-ID: <20240221130014.407668649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



