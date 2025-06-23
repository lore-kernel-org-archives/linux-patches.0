Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18A82522A8;
	Mon, 23 Jun 2025 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686150; cv=none; b=iZb26tl0hg5pFvJONuxdU6TYL+8Qz/cfQ4aHtuDcp57p4OY6ypk0W8YwYOYt3NbdbClPinGqe+a1Pyl95OgacxFAj/lcmO0TvU7/kbt/ABUiF94bN8KEdClj0g8mqIpxCq12Q+fg3B2UY/m5HusBQEwhebJ59cyBh1rRg4XK8LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686150; c=relaxed/simple;
	bh=nVeBcWXAdORTwMTdDejYNBRNQxOI33wIRaeuEV1oYOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToNQP8jnI02M0L3kuiDDP0F/CETCzN2zoDHqlV1rvDK7fnyPYclze76zIF2juxUgcjyRj1oczxG79NL6BvBtxUxAJ8gkapZ6MnSMNxjZEftARFwvRQvjP6NiFd8OKZcGQWPrcQ4i152Dx8KZN1nJ6CihEhy+P1DzK3GdqtGOvHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzG1AkOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzG1AkOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755C0C4CEF0;
	Mon, 23 Jun 2025 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686149;
	bh=nVeBcWXAdORTwMTdDejYNBRNQxOI33wIRaeuEV1oYOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzG1AkOKzWefWheAF2L5Ufw/QvKdTcpyMonGIgYzdJ/Kp3opRHbeYj9j04Untb6C6
	 ZNrTHpkATqZckqbQ2utPSTCF1SyuYIu8gaarwyQzCHWe4lZhoEGBThTblSJ+xrSGt5
	 u1MvKLrJr9jy/tMHO5MN6mDTO1J2Hc4ruE//8l90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 024/414] wifi: mt76: mt7925: fix host interrupt register initialization
Date: Mon, 23 Jun 2025 15:02:41 +0200
Message-ID: <20250623130642.630171179@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Michael Lo <michael.lo@mediatek.com>

commit ca872e0ad97159375da8f3d05cac1f48239e01d7 upstream.

ensure proper interrupt handling and aligns with the hardware spec by
updating the register offset for MT_WFDMA0_HOST_INT_ENA.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250509083512.455095-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c  |    3 ---
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -482,9 +482,6 @@ static int mt7925_pci_suspend(struct dev
 
 	/* disable interrupt */
 	mt76_wr(dev, dev->irq_map->host_irq_enable, 0);
-	mt76_wr(dev, MT_WFDMA0_HOST_INT_DIS,
-		dev->irq_map->tx.all_complete_mask |
-		MT_INT_RX_DONE_ALL | MT_INT_MCU_CMD);
 
 	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0x0);
 
--- a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
@@ -28,7 +28,7 @@
 #define MT_MDP_TO_HIF			0
 #define MT_MDP_TO_WM			1
 
-#define MT_WFDMA0_HOST_INT_ENA		MT_WFDMA0(0x228)
+#define MT_WFDMA0_HOST_INT_ENA		MT_WFDMA0(0x204)
 #define MT_WFDMA0_HOST_INT_DIS		MT_WFDMA0(0x22c)
 #define HOST_RX_DONE_INT_ENA4		BIT(12)
 #define HOST_RX_DONE_INT_ENA5		BIT(13)


