Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DD527733;
	Tue, 16 Jul 2024 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145007; cv=none; b=FizQajWXDeZovJyKvte8Lyg1uSrHytqt13dhIzNJf5oaw2oRmLoX8Wc7ZlO343AejOn0eqWtHtsKDwJ5R/FEnoQHPaO6vUi9SfGua4bJxqHTiI1EIA/hoz5QU+vroEtdG7gl9rrkilGWcKisP8bN1NNm3xiyb1dgoUrwiLT7Mug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145007; c=relaxed/simple;
	bh=njuW7f0YnixF7X0+N2TvmOmUd7VHAjjlw2aw7RYGRcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bt0yextngFV4Oe955S/cvmSbnIly5lgACOaDt14+ZDHvJ1KpkNr6kL5lCmUjkUhzOf7PHxmU/5JPuswF7+7OOdajKHQJ/2JMaA7MYdUgy0lBM0JJUhjz1JnWoqrRfkhelArBSYHiRwA7zXsmITXQpMP/lXlMacITKOAkG/xLJv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BECP8C33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BECP8C33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E76C116B1;
	Tue, 16 Jul 2024 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145007;
	bh=njuW7f0YnixF7X0+N2TvmOmUd7VHAjjlw2aw7RYGRcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BECP8C33F5uhwK56MA0M3/raXk1sMAMrBEP2aKaHgxR3BuNVPRqbY5Uzebp4eY4OH
	 nbR8P0uMVCU3NIiu/5SWqpNRX/PYXzz99g2teVn7dCxdOd+EGJNAK6ADeZ8n0vf/el
	 gJ8j/pihV5U73EKfxQ57IuMmdu14AjWgT121chjg=
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
Subject: [PATCH 6.9 068/143] net: ks8851: Fix potential TX stall after interface reopen
Date: Tue, 16 Jul 2024 17:31:04 +0200
Message-ID: <20240716152758.594309082@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


