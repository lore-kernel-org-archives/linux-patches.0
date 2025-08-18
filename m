Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779CE1F462D;
	Mon, 18 Aug 2025 13:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522163; cv=none; b=XGJzPs+ilWMTXMKZvT9xwTnpXsq78lttaWjdcQ1fGsjY9f+A9bfS37Si9xCAfKM+CZyjakhWXPloTJtbhMU+O6rnzzdwu2pZuXWb9Rv1a+nMCIpi4BE4+bqsmw87nkDGJYMW1MgCw3KzFdXgsHi+BF74o9zZFGqdnHBi0MxtQrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522163; c=relaxed/simple;
	bh=IqHEy9sfWbNXQqZ8lnC6MQyCVyXrGO4TTmlThjeB/88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJb+F18uldozytp6ED43Lq8wMdtimST/suLijrBD3RrpTRm1RAXq+1ZxZa83OU3hzXpdXd8RMXPWzSYjWOhtKJd078wZ79UkxoN3uKj9I2N0+p82mf8c/XmElXrW1uzGtvykoztKlCZZmBJNRCY64DOK7mZvywEZ6W67pc4Zcc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiwA6xJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiwA6xJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1292C4CEEB;
	Mon, 18 Aug 2025 13:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522163;
	bh=IqHEy9sfWbNXQqZ8lnC6MQyCVyXrGO4TTmlThjeB/88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiwA6xJbO3MuKCEdEqJGupvMEzbQsh+R7cSXtjtqe+lmvI24LuPbr1GBSQlk+mQOG
	 o6VxqXe0DmeVZBLQR3oskJvWEOuVFMIi8tXJ57JI75uFUlJ8vNeMP90x5kwJO5kq9O
	 Hibb17G4K0g21Z+8E59xSdyLAb7Bzbuv5IbtLivE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/444] wifi: rtlwifi: fix possible skb memory leak in `_rtl_pci_rx_interrupt()`.
Date: Mon, 18 Aug 2025 14:44:21 +0200
Message-ID: <20250818124457.645592254@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 44c0e191004f0e3aa1bdee3be248be14dbe5b020 ]

The function `_rtl_pci_init_one_rxdesc()` can fail even when the new
`skb` is passed because of a DMA mapping error.  If it fails, the `skb`
is not saved in the rx ringbuffer and thus lost.

Compile tested only

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250616105631.444309-4-fourier.thomas@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 898f597f70a9..2741c3beac4c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -802,13 +802,19 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		skb = new_skb;
 no_new:
 		if (rtlpriv->use_new_trx_flow) {
-			_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)buffer_desc,
-						 rxring_idx,
-						 rtlpci->rx_ring[rxring_idx].idx);
+			if (!_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)buffer_desc,
+						      rxring_idx,
+						      rtlpci->rx_ring[rxring_idx].idx)) {
+				if (new_skb)
+					dev_kfree_skb_any(skb);
+			}
 		} else {
-			_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)pdesc,
-						 rxring_idx,
-						 rtlpci->rx_ring[rxring_idx].idx);
+			if (!_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)pdesc,
+						      rxring_idx,
+						      rtlpci->rx_ring[rxring_idx].idx)) {
+				if (new_skb)
+					dev_kfree_skb_any(skb);
+			}
 			if (rtlpci->rx_ring[rxring_idx].idx ==
 			    rtlpci->rxringcount - 1)
 				rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc,
-- 
2.39.5



