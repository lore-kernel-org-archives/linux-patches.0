Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E693BBF2;
	Tue, 14 May 2024 11:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687459; cv=none; b=MtaYhTiP1+K0Hwufiikz5X6G31urT1Cl887f1QIc+xD4ZYHtLZz6Y53uXcoJZS/+wEAE3PisNGHXEr62WRqbRxqDEYMhyBpsMRvaFq58/0+W9q6r/B9+jDRXCJCO3yNiD/LOlRF7NkwSfe1vwj3JeFhtudA1yV5tTQMOMZbgmbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687459; c=relaxed/simple;
	bh=Ekw/4RAxDq+taFsiHltTRt/e31uxS52l/BsYZKtW1c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZNYgA3gInQWZx5BhjGTsUSTvZzxMEptxtC+ZJYT/HOy3UfaBrehYOAYBTBKyy7gxk8jjI7Uz3T/NzrXTtsFSSAM18QzK3wPMA2IKCT2ipSe8hEboIk20HoTuSgJuO7tA6e79lz0MhoB2TwGEL8xBBpH+sy2PH+AKD3GMjTJ348=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVr+BeJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVr+BeJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0C0C2BD10;
	Tue, 14 May 2024 11:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687459;
	bh=Ekw/4RAxDq+taFsiHltTRt/e31uxS52l/BsYZKtW1c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVr+BeJfIi73z80H7n85l5rU/9WtgCaIcA8yQ6VVxI6qqtTv6LwuTTBHRPXuV3oLU
	 JKlNEZLRP9CVsU91N+mabhTN0/PUEIoceNW3AUeLwHWoWWXWwtY+pR7puXj4I3HoYH
	 aHJEx1hbv1R5na0lDgHSSFKJ5NTvP06SJ4b7RlUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 104/111] net: bcmgenet: synchronize use of bcmgenet_set_rx_mode()
Date: Tue, 14 May 2024 12:20:42 +0200
Message-ID: <20240514101001.085654105@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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
@@ -3306,7 +3306,9 @@ static void bcmgenet_netif_start(struct
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
 	/* Start the network engine */
+	netif_addr_lock_bh(dev);
 	bcmgenet_set_rx_mode(dev);
+	netif_addr_unlock_bh(dev);
 	bcmgenet_enable_rx_napi(priv);
 
 	umac_enable_set(priv, CMD_TX_EN | CMD_RX_EN, true);


