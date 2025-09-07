Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDF520E005;
	Sun,  7 Sep 2025 20:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277915; cv=none; b=suJZQz+6W7Y0N8O3RZz5Vt4JfBkbc4e4kb5ZcOZTsVJw8Y9soUXT/6YwIiTHCBuUBB7xAWpKZ1bUgGnH7rUOG7Uw3ca4PWDVZi+jnwmRx8oxsGrkyPxza2C9TbPayLLwR0dUwhgb4DsU/pwiM5n24+RZP7k5XGQEer8Rxs5Dy0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277915; c=relaxed/simple;
	bh=v5SJ2cQo3mVtD9OZr0NkrFEfGhAdlywM2c9dSFprOoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyjKdKGqe8XftU0T0WayKX6RY23SXxAmVqZo6xh/eq9WIbvc8P8NOJKTcd9TPSiNwEWj3lsLlfIiXkg9OkMbgU32Q+3hBED1rg5aGQTsRQkugrpHiV+YYA3yBfi35qevgR3JCwfSq9UL3M/n5Hz6Gqs8dfwVe0ZJQTU4LePaUy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwdFC4Fx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwdFC4Fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89E1C4CEF0;
	Sun,  7 Sep 2025 20:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277915;
	bh=v5SJ2cQo3mVtD9OZr0NkrFEfGhAdlywM2c9dSFprOoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwdFC4Fx6sHVRTj5kvf28lr3jYqWmMc91akYoVPSyb0EwXqU2O9n3CSoW0NAYlIUe
	 9uLwRMhMCqRWTfIThcG0+P5pAiqgVOpn4B6ol6H5z/aaWWCtfM20HnSYPN8AL4aanX
	 pvVT90sweuJYBE+hQb+oKqqFrT0x0mcycnmuBklI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.16 119/183] wifi: mt76: mt7925u: use connac3 tx aggr check in tx complete
Date: Sun,  7 Sep 2025 21:59:06 +0200
Message-ID: <20250907195618.620473824@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit c22769de25095c6777e8acb68a1349a3257fc955 upstream.

MT7925 is a connac3 device; using the connac2 helper mis-parses
TXWI and breaks AMPDU/BA accounting. Use the connac3-specific
helper mt7925_tx_check_aggr() instead,

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Reported-by: Nick Morrow <morrownr@gmail.com>
Tested-by: Nick Morrow <morrownr@gmail.com>
Tested-on: Netgear A9000 USB WiFi adapter
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250818020203.992338-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1449,7 +1449,7 @@ void mt7925_usb_sdio_tx_complete_skb(str
 	sta = wcid_to_sta(wcid);
 
 	if (sta && likely(e->skb->protocol != cpu_to_be16(ETH_P_PAE)))
-		mt76_connac2_tx_check_aggr(sta, txwi);
+		mt7925_tx_check_aggr(sta, e->skb, wcid);
 
 	skb_pull(e->skb, headroom);
 	mt76_tx_complete_skb(mdev, e->wcid, e->skb);


