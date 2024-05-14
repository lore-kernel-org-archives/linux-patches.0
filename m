Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7176311D;
	Tue, 14 May 2024 11:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685840; cv=none; b=PHTBDy/VtxitptDcqAh5azoYGLnkENGGjBNjXEykTq/1Gjg2npHimSH8Y9TBE7NKUiEcq0kYz/aaMksSDMfncnUqme1M9xKkgdQx+C+pG5WvWAXMpTMlm7lZEB3vBJNqogwXH1lvRGZBxYfDfZ5zgqd8IxN7QWPrvvzAUbPf520=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685840; c=relaxed/simple;
	bh=j+pLFbfApcy6MVNLWUYYzw6I9CX3aYdauLE71ny85FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpN5hbaUSmS2zRii3PNK/efmJSCGMy7/VgCNCRNucH8Ikv14Bmxle4sQ3AH4KG/Qgi07ejns7ZUsqDyNnYrHL96cy9yd/Ovy64d6k7yu8OXkS1k7Mx1bRVkQWIUuxp/MZSG+qm13NX38wsRaBj6srXamRNy2NnNWb8LpBxOk+ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFKrFgrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFKrFgrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86FFC2BD10;
	Tue, 14 May 2024 11:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685840;
	bh=j+pLFbfApcy6MVNLWUYYzw6I9CX3aYdauLE71ny85FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFKrFgrA0DhJWu+3VSJQrBUkI533mYIGMty4yEP3lIbaInAX9FoL+8NlNyQJeOHQ+
	 2wKdp0/e2ybXRz1FuwUEI6ohm4mg9JKE7KwB+uV30Gv5aBAD+RfcTKXfwYNcYFzCHY
	 sbIz+g8A8eh6Yusqf+yJOfPAVPbTAEyxJC5NtG5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 257/301] net: bcmgenet: synchronize use of bcmgenet_set_rx_mode()
Date: Tue, 14 May 2024 12:18:48 +0200
Message-ID: <20240514101041.960441917@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3353,7 +3353,9 @@ static void bcmgenet_netif_start(struct
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
 	/* Start the network engine */
+	netif_addr_lock_bh(dev);
 	bcmgenet_set_rx_mode(dev);
+	netif_addr_unlock_bh(dev);
 	bcmgenet_enable_rx_napi(priv);
 
 	umac_enable_set(priv, CMD_TX_EN | CMD_RX_EN, true);


