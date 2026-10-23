Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774030;
	b=E/UrsVkrUBLWQ3lo9yWoWtHniMPcycg5V91+PGDUkbOW2uz1m4E47HJhjcs3Enef2dtd
	 eB8QGnIBeJBpLjTsPO++TMtRcM/82aE7KMnp8qrbIF0WOFIkKHDzlz3LPJzARaL/27CKX
	 j16MqPs0lPDniGI6ffNmZMiWICavMJxrPS901hkmyta7LrbkPYnR4FfXKzfJGH7Qvvlgx
	 CCGDwCuENDCmHfj5X2bcfMRUXuiLZlfZAgQtFKY0kHFrtqSraAI3FpHCEfkayqb4ZPG/q
	 pluzB1ZUBnliW0j57ASnDXJghUANHbWOFXUvx/+BCDKpR3+Van/lRVqpNz7UPgCtBsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0mSZ4uqn10HHEYZ/NDgcpgbV7m9NmOmPqLCaouL4k98=;
	b=jjND2UbgLrFByUu0FMil2ss9Gki16EVEYcYejJceZE4gAu6MYJE1VXjhzINDq6ygvcFm
	 N+0/uYum4FpDt5j9M3lktybMaXKb2fRmwYaqmoip+KtRlfQSSbjLbEE7zVxnG79oQrFed
	 9MkGCHK7R2Xoz6lSl14X5Z3oEhjeLWECJGVkP5HQ59RUjhiA/4yb65lxL7tGZ4Ak4imQN
	 /LGB0YhGltur7I1sjkAp/JUGdkuAtbaw7E9c0ip/VTrLmu4eWKPbWNzeXiCzkecgxIFp/
	 rGCxo4dTcdF/Sm6pC30yGFEeMvPNi5JelDZJd/GhpCHxQPHod47KFvroZNeM3/vqc+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=duTlx1uO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EBC606A31A;
	Fri, 23 Oct 2026 16:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=duTlx1uO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52A11F01825;
	Fri, 23 Oct 2026 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774029;
	bh=0mSZ4uqn10HHEYZ/NDgcpgbV7m9NmOmPqLCaouL4k98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duTlx1uOdN2V1UMGhpdkSUATUdXDAiiNK76HsbS5c9kiPdEwZnFXwctIeulojAh8U
	 YzzmfV3SrQQFih8GyUsJhwZ7HGMCqMVEdkcyDpNg3E4eW44SLsZQz9euizZHwJESuZ
	 Lx4lNSb6wpX8W+P3N9JGCAC6fosRz5iAGEppGxb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/193] net: bcmgenet: unshare the skb before writing the control block
Date: Fri, 23 Oct 2026 18:35:36 +0200
Message-ID: <20261023163715.602340641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 89771ce4f8f67dcffae561b2ccac95c0f6e3aa01 ]

bcmgenet stores first_cb, last_cb and bytes_sent in the skb control
block and reads them back on completion to free the skb and credit BQL.
ether_setup() leaves IFF_TX_SKB_SHARING set, so the stack can resubmit
a shared skb that is still in the ring. The next transmit overwrites
last_cb, so the earlier slots complete without crediting their bytes
and BQL stalls the queue until the watchdog resets it.

Unshare the skb before writing the control block.

Reproduce with pktgen in clone_skb mode, which hands the driver the same
skb while earlier copies are still in the ring:

  modprobe pktgen
  pg=/proc/net/pktgen
  echo "add_device eth0" > $pg/kpktgend_0
  echo "dst_mac AA:BB:CC:DD:EE:FF" > $pg/eth0
  echo "dst 192.0.2.1" > $pg/eth0
  echo "clone_skb 8" > $pg/eth0
  echo "count 0" > $pg/eth0
  echo start > $pg/pgctrl &
  sleep 5
  echo stop > $pg/pgctrl
  wait
  cat /sys/class/net/eth0/queues/tx-0/byte_queue_limits/inflight

inflight stays nonzero on the now idle queue. clone_skb 0 leaves it at
zero.

Fixes: f48bed16a756 ("net: bcmgenet: Free skb after last Tx frag")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261009-nb-genet-shared-skb-net-v1-1-c6d0a841977d@tipi-net.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 5a891cf59f108..75bfd74b391b3 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2149,6 +2149,16 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto out;
 	}
 
+	/* We store Tx state in the control block, so the skb must not be
+	 * shared, but ether_setup() leaves IFF_TX_SKB_SHARING set.
+	 */
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb) {
+		BCMGENET_STATS64_INC((&ring->stats64), dropped);
+		ret = NETDEV_TX_OK;
+		goto out;
+	}
+
 	/* Retain how many bytes will be sent on the wire, without TSB inserted
 	 * by transmit checksum offload
 	 */
-- 
2.53.0



