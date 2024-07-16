Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B6219AD59;
	Tue, 16 Jul 2024 15:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145386; cv=none; b=jzfok2iy2C76sUx+VNag8G6nxczEImAwRQ9Tz3j3JXL8eGcG9N5DDIeBKoUd4DpDRbQvCOk2JT9Vf/oL+md+ptbzPfJ6S6m5330naZblh6qQeSFjWuMylrvlHGDOotCPEPRY3+a23qv8YK3PujBK2Eigmi7ikNjDKR/oq7DMt48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145386; c=relaxed/simple;
	bh=gAN4rPO1rDlM4Jgl9KFPBLbS35m5zXKZv76hC6c4Uvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Frpw6Vqe5hOhqFZzSi2zzS3aSN9ejXSrmD+ZJuinTD8batDyvYoszBFzgqE8Y5ibVfoNxBwBs2i6rykA+okSYbpn8YpK+AcveN0eGe5sA3wu9mrdiEIcgvsuxQCfMy0Iy9AFbxirb2+wXF2HuEJEIwudaj4F8lTdZ+krQpc9+is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vg+roO45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vg+roO45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA50DC4AF10;
	Tue, 16 Jul 2024 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145384;
	bh=gAN4rPO1rDlM4Jgl9KFPBLbS35m5zXKZv76hC6c4Uvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vg+roO45cPAmJiyUAbHkthL8oKVUf1TXryFWEG2SKoeV4ChX4lxW+VVe3s5OaN2AH
	 vOJJSGGUDlZpr3gAHajBNb60gWkUlTpT7aH7pglB6Ic0zindR0Iwtdk7do1X3OGWcf
	 lXWLB/H2NbcuAfypA39v/P4il6ocjiUdzoxCEoUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	Ronald Wahl <ronald.wahl@raritan.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 6.1 49/96] net: ks8851: Fix potential TX stall after interface reopen
Date: Tue, 16 Jul 2024 17:32:00 +0200
Message-ID: <20240716152748.392942744@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Wahl <ronald.wahl@raritan.com>

commit 7a99afef17af66c276c1d6e6f4dbcac223eaf6ac upstream.

The amount of TX space in the hardware buffer is tracked in the tx_space
variable. The initial value is currently only set during driver probing.

After closing the interface and reopening it the tx_space variable has
the last value it had before close. If it is smaller than the size of
the first send packet after reopeing the interface the queue will be
stopped. The queue is woken up after receiving a TX interrupt but this
will never happen since we did not send anything.

This commit moves the initialization of the tx_space variable to the
ks8851_net_open function right before starting the TX queue. Also query
the value from the hardware instead of using a hard coded value.

Only the SPI chip variant is affected by this issue because only this
driver variant actually depends on the tx_space variable in the xmit
function.

Fixes: 3dc5d4454545 ("net: ks8851: Fix TX stall caused by TX buffer overrun")
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240709195845.9089-1-rwahl@gmx.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/micrel/ks8851_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -482,6 +482,7 @@ static int ks8851_net_open(struct net_de
 	ks8851_wrreg16(ks, KS_IER, ks->rc_ier);
 
 	ks->queued_len = 0;
+	ks->tx_space = ks8851_rdreg16(ks, KS_TXMIR);
 	netif_start_queue(ks->netdev);
 
 	netif_dbg(ks, ifup, ks->netdev, "network device up\n");
@@ -1101,7 +1102,6 @@ int ks8851_probe_common(struct net_devic
 	int ret;
 
 	ks->netdev = netdev;
-	ks->tx_space = 6144;
 
 	ks->gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
 	ret = PTR_ERR_OR_ZERO(ks->gpio);


