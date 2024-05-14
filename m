Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F9953370;
	Tue, 14 May 2024 10:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684046; cv=none; b=aNgiuHlbfWxSIb2oLMci3K7y1lZ2a1QJ4jKaAeSuzM0E/IMEif49P8OuhAmuCe8UiV+6fHIaxHY+fX5dDI6C6vOqsU4CTigMuDzKmpRTYIui9NA34yL4dAg5X5ViN7bZ+jHMbDeDzKfiTrnyF/jmvVGK+rWmjYzuDSqaLWck3l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684046; c=relaxed/simple;
	bh=AagKtx3wM9PlM38Az96SIcTCX79Uko/VbGS1OmquG6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3pEp6rxyp3rlaYFfFt+0X0kFeAVZ3qNZmQiVVQysbVm+ML+DurVG9rKm22T9ulLAyZ5I0o0kjFcWfQhbj2S7yODBSqExk+SLaNFH6EAPLMwWvD9S1ksg1ipa1gERD95uCu9ajO5skvSHgmzzjmEYG3/Bl4iUgBEJAuK0kR6s4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13lZGvaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13lZGvaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FEEC2BD10;
	Tue, 14 May 2024 10:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684046;
	bh=AagKtx3wM9PlM38Az96SIcTCX79Uko/VbGS1OmquG6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13lZGvaHM5BKTXuRgDDHH7b1fg69MHxq5ISFbT6KZHrPEghzSIN/g6eRv25V3Pl+l
	 yL3a8kPDcCJA8PORMVbdo4EZYfnqehd7p3k9+ZanI07gxwOPKDKspj9AHI89TsHJ70
	 6XbYKIiUhd2vAzNlyPG17CC3vcyQr/cWyKTXhEQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 283/336] net: bcmgenet: synchronize use of bcmgenet_set_rx_mode()
Date: Tue, 14 May 2024 12:18:07 +0200
Message-ID: <20240514101049.302535611@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit 2dbe5f19368caae63b1f59f5bc2af78c7d522b3a upstream.

The ndo_set_rx_mode function is synchronized with the
netif_addr_lock spinlock and BHs disabled. Since this
function is also invoked directly from the driver the
same synchronization should be applied.

Fixes: 72f96347628e ("net: bcmgenet: set Rx mode before starting netif")
Cc: stable@vger.kernel.org
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2,7 +2,7 @@
 /*
  * Broadcom GENET (Gigabit Ethernet) controller driver
  *
- * Copyright (c) 2014-2020 Broadcom
+ * Copyright (c) 2014-2024 Broadcom
  */
 
 #define pr_fmt(fmt)				"bcmgenet: " fmt
@@ -3336,7 +3336,9 @@ static void bcmgenet_netif_start(struct
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
 	/* Start the network engine */
+	netif_addr_lock_bh(dev);
 	bcmgenet_set_rx_mode(dev);
+	netif_addr_unlock_bh(dev);
 	bcmgenet_enable_rx_napi(priv);
 
 	umac_enable_set(priv, CMD_TX_EN | CMD_RX_EN, true);


