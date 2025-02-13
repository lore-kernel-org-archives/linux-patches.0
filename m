Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65C326B080;
	Thu, 13 Feb 2025 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459311; cv=none; b=W37SdYi+NV9A/ybpjL0glK7Vr3x2rBqDhx7ZVrN5HTNJOIIDJCBGgriAKT+tSPpDztd0fgWuu4bdh4VeDGAySPpAqBCCwQ/AjqFxgQrDJJoTi+A7A6qCqzbcFlnPloesEJZn9UcQtpr8USCDoUaL1f1+mnsZDXQNnto9GKR7AwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459311; c=relaxed/simple;
	bh=dRBYiIEzqp+CeU/BxEfuTcJwaxpGQfxLl+bAu2M8VlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASgoW0t26iJd/jw62JfSKHTzzDqyi2kmcbPwXTQhA//W/TtTfk6hJPdlD9EUsrT5iLGzzAZ7dK1ZUABAhMdUsXAyJQCh4ZFcxvVwu7NejYMME9lsmnypSddQgx0+NqoxlV1RqWheIrM1pVXsGNaANyTmp37XqTL7gwHQNcVp5X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rws6F3RS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rws6F3RS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5360CC4CED1;
	Thu, 13 Feb 2025 15:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459310;
	bh=dRBYiIEzqp+CeU/BxEfuTcJwaxpGQfxLl+bAu2M8VlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rws6F3RSmmC5FNQkrX35sU1apy4jW2duawvxKZ5kx5SDqFHp3MAod1i0/WKFWOB6E
	 V1FsC/irMMp/bw17NUOfK09i4Huq+VAU3mcb25NexeBv+hc11tlojztwoaNKxgILOE
	 8iU+Sbz9fhaCNe7Vp/3tFJlUfj/Detp4hJ6ZGMfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Klute <fiona.klute@gmx.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH 6.13 227/443] wifi: rtw88: sdio: Fix disconnection after beacon loss
Date: Thu, 13 Feb 2025 15:26:32 +0100
Message-ID: <20250213142449.374819520@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fiona Klute <fiona.klute@gmx.de>

commit fb2fcfbe5eef9ae26b0425978435ae1308951e51 upstream.

This is the equivalent of commit 28818b4d871b ("wifi: rtw88: usb: Fix
disconnection after beacon loss") for SDIO chips.
Tested on Pinephone (RTL8723CS), random disconnections became rare,
instead of a frequent nuisance.

Cc: stable@vger.kernel.org
Signed-off-by: Fiona Klute <fiona.klute@gmx.de>
Tested-by: Vasily Khoruzhick <anarsoul@gmail.com> # Tested on Pinebook
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250106135434.35936-1-fiona.klute@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1192,6 +1192,8 @@ static void rtw_sdio_indicate_tx_status(
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hw *hw = rtwdev->hw;
 
+	skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
+
 	/* enqueue to wait for tx report */
 	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
 		rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);


