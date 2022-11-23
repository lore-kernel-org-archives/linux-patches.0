Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5381C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDE2C433D6;
	Wed, 23 Nov 2022 09:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194526;
	bh=T/e3MNvNW8CQmNRDyQI97IB/PJdxQjND73c0YgecIrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+mYWM1Y3cYe9De1/ZrmhT2JOMUJYRtRtN1zfG7XTIgYeEbYgDY1z9koUW3ZiaWb/
	 Re1uKME9qeSaY4QVcPQcOXj2Bij15vXDHmDQZj0A9+Tw1CkzQWCBvW6rHTnxfAvOMH
	 TBt6wjp8P0MDD9MGM9fa2NsEdLpLr1ddp8wWNx2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 102/114] macvlan: enforce a consistent minimal mtu
Date: Wed, 23 Nov 2022 09:51:29 +0100
Message-Id: <20221123084555.810110831@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

commit b64085b00044bdf3cd1c9825e9ef5b2e0feae91a upstream.

macvlan should enforce a minimal mtu of 68, even at link creation.

This patch avoids the current behavior (which could lead to crashes
in ipv6 stack if the link is brought up)

$ ip link add macvlan1 link eno1 mtu 8 type macvlan  # This should fail !
$ ip link sh dev macvlan1
5: macvlan1@eno1: <BROADCAST,MULTICAST> mtu 8 qdisc noop
    state DOWN mode DEFAULT group default qlen 1000
    link/ether 02:47:6c:24:74:82 brd ff:ff:ff:ff:ff:ff
$ ip link set macvlan1 mtu 67
Error: mtu less than device minimum.
$ ip link set macvlan1 mtu 68
$ ip link set macvlan1 mtu 8
Error: mtu less than device minimum.

Fixes: 91572088e3fd ("net: use core MTU range checking in core net infra")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1137,7 +1137,7 @@ void macvlan_common_setup(struct net_dev
 {
 	ether_setup(dev);
 
-	dev->min_mtu		= 0;
+	/* ether_setup() has set dev->min_mtu to ETH_MIN_MTU. */
 	dev->max_mtu		= ETH_MAX_MTU;
 	dev->priv_flags	       &= ~IFF_TX_SKB_SHARING;
 	netif_keep_dst(dev);


