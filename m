Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7177E2D3ED6;
	Tue, 12 Aug 2025 18:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023731; cv=none; b=MLDNRrtQWsjgvWez7cIoTw4DPYQ5MRAaY6V0EVUVx74u33QyW/OAj3wDpPyvoGnt4uqbwptVfvlMt3GZaWvmmeeRLDVPWpT4FA38bUnM8W+AxxWj6CouXROiptdzRN/Qs+5B3rPyRfwmjEa4LgXUYoUOi+uPSquF1XeBvrFx4jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023731; c=relaxed/simple;
	bh=MLsYnC8DCn19E6wvqi+OwQHysMIHW9e99a0rvqEk7M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFaqxb+XhyumKpiahrzUyxrQXzmXDE/t14X1zHe6ihLVCMcgSXYCzmuDYfWnvtZX/2QlPa0Q4oeyWHP8n9Z8Z2EkeJuHfJVuI1Rixte2o/0OaJLUd2FcmKQt+1rf6OyEFBDrZrTwCdH5iDpFwLq8qFcXN3Ivhz+1xdcQ1nqPGqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzK9ORjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzK9ORjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62E3C4CEF0;
	Tue, 12 Aug 2025 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023731;
	bh=MLsYnC8DCn19E6wvqi+OwQHysMIHW9e99a0rvqEk7M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzK9ORjR7hwagxpTYKbeahyqEGRBdyTss00GyAl9mcB5Q8VhqfUUlDVVIaqrvRPHq
	 K6pbojL7qSCID85c01vgeQ45B3LuEH/mXQ1I/d7sXyrKcTcvXbQurtJSQPxdpxhYnO
	 xP9DBLQuxiB2YrDk7BZuFwdMHvEHBP5ImX4u8PrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 164/627] wifi: rtl818x: Kill URBs before clearing tx status queue
Date: Tue, 12 Aug 2025 19:27:39 +0200
Message-ID: <20250812173425.529043103@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 16d8fd74dbfca0ea58645cd2fca13be10cae3cdd ]

In rtl8187_stop() move the call of usb_kill_anchored_urbs() before clearing
b_tx_status.queue. This change prevents callbacks from using already freed
skb due to anchor was not killed before freeing such skb.

 BUG: kernel NULL pointer dereference, address: 0000000000000080
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] SMP NOPTI
 CPU: 7 UID: 0 PID: 0 Comm: swapper/7 Not tainted 6.15.0 #8 PREEMPT(voluntary)
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
 RIP: 0010:ieee80211_tx_status_irqsafe+0x21/0xc0 [mac80211]
 Call Trace:
  <IRQ>
  rtl8187_tx_cb+0x116/0x150 [rtl8187]
  __usb_hcd_giveback_urb+0x9d/0x120
  usb_giveback_urb_bh+0xbb/0x140
  process_one_work+0x19b/0x3c0
  bh_worker+0x1a7/0x210
  tasklet_action+0x10/0x30
  handle_softirqs+0xf0/0x340
  __irq_exit_rcu+0xcd/0xf0
  common_interrupt+0x85/0xa0
  </IRQ>

Tested on RTL8187BvE device.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c1db52b9d27e ("rtl8187: Use usb anchor facilities to manage urbs")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250617135634.21760-1-d.dulov@aladdin.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index 220ac5bdf279..8a57d6c72335 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -1041,10 +1041,11 @@ static void rtl8187_stop(struct ieee80211_hw *dev, bool suspend)
 	rtl818x_iowrite8(priv, &priv->map->CONFIG4, reg | RTL818X_CONFIG4_VCOOFF);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
+	usb_kill_anchored_urbs(&priv->anchored);
+
 	while ((skb = skb_dequeue(&priv->b_tx_status.queue)))
 		dev_kfree_skb_any(skb);
 
-	usb_kill_anchored_urbs(&priv->anchored);
 	mutex_unlock(&priv->conf_mutex);
 
 	if (!priv->is_rtl8187b)
-- 
2.39.5



