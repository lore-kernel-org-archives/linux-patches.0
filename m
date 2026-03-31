Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09D24266AE;
	Tue, 31 Mar 2026 16:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975958; cv=none; b=kZktJUND+QVljR+VnAwRTpjWvfMvu6pf3AsnLD+fNMjHFQlS5uUcn369V/nmodODBIwWtnylt9AfDsMyQPon59UUuAz0Jz5iVt/SiS2Jt5wiQzMMzXPvTmb5szQIz88I7loYYIVO5W7hg926tAic27j9ufyjNUkafTFxlJk0cs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975958; c=relaxed/simple;
	bh=l0OYJJZhfw6oVfvoYhwSrPmj0zwUsDBKeHtSzJwDLzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UanDTtfivuXg+yKKKxeXU+bFS4XjTL02C6VMKJj/dXg2LsE4a5qr8ABX7inAnneWRTQ6a3nCDcUgZW0dyUPanX6mmF+vf9fG30tmk8J2PxNusnbTA8WpqRMsi3rSAh3qPLanZijV5jG+xaprC/vG2cSuA3jcUPBqpriZdE3yJtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2fDQ9Ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2fDQ9Ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342CDC19423;
	Tue, 31 Mar 2026 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975958;
	bh=l0OYJJZhfw6oVfvoYhwSrPmj0zwUsDBKeHtSzJwDLzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2fDQ9IaupdiL0nPN6549kMevf8z4TWwWWgTzfpZRAolRaWKeBnPYWWYqpQ7vdWaL
	 4uztzMPoO2ffesEE7f5PweG2G3WXZRQ9mzO7XSnuBNEjeJiG4p30HKJ0uB1L7k9HQ9
	 uHhCTvZa4xo6103jy11BoH1jBm4unOLG/Qu/qQIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xietangxin <xietangxin@yeah.net>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 153/244] virtio_net: Fix UAF on dst_ops when IFF_XMIT_DST_RELEASE is cleared and napi_tx is false
Date: Tue, 31 Mar 2026 18:21:43 +0200
Message-ID: <20260331161747.418206930@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: xietangxin <xietangxin@yeah.net>

commit ba8bda9a0896746053aa97ac6c3e08168729172c upstream.

A UAF issue occurs when the virtio_net driver is configured with napi_tx=N
and the device's IFF_XMIT_DST_RELEASE flag is cleared
(e.g., during the configuration of tc route filter rules).

When IFF_XMIT_DST_RELEASE is removed from the net_device, the network stack
expects the driver to hold the reference to skb->dst until the packet
is fully transmitted and freed. In virtio_net with napi_tx=N,
skbs may remain in the virtio transmit ring for an extended period.

If the network namespace is destroyed while these skbs are still pending,
the corresponding dst_ops structure has freed. When a subsequent packet
is transmitted, free_old_xmit() is triggered to clean up old skbs.
It then calls dst_release() on the skb associated with the stale dst_entry.
Since the dst_ops (referenced by the dst_entry) has already been freed,
a UAF kernel paging request occurs.

fix it by adds skb_dst_drop(skb) in start_xmit to explicitly release
the dst reference before the skb is queued in virtio_net.

Call Trace:
 Unable to handle kernel paging request at virtual address ffff80007e150000
 CPU: 2 UID: 0 PID: 6236 Comm: ping Kdump: loaded Not tainted 7.0.0-rc1+ #6 PREEMPT
  ...
  percpu_counter_add_batch+0x3c/0x158 lib/percpu_counter.c:98 (P)
  dst_release+0xe0/0x110  net/core/dst.c:177
  skb_release_head_state+0xe8/0x108 net/core/skbuff.c:1177
  sk_skb_reason_drop+0x54/0x2d8 net/core/skbuff.c:1255
  dev_kfree_skb_any_reason+0x64/0x78 net/core/dev.c:3469
  napi_consume_skb+0x1c4/0x3a0 net/core/skbuff.c:1527
  __free_old_xmit+0x164/0x230  drivers/net/virtio_net.c:611 [virtio_net]
  free_old_xmit drivers/net/virtio_net.c:1081 [virtio_net]
  start_xmit+0x7c/0x530 drivers/net/virtio_net.c:3329 [virtio_net]
  ...

Reproduction Steps:
NETDEV="enp3s0"

config_qdisc_route_filter() {
    tc qdisc del dev $NETDEV root
    tc qdisc add dev $NETDEV root handle 1: prio
    tc filter add dev $NETDEV parent 1:0 \
	protocol ip prio 100 route to 100 flowid 1:1
    ip route add 192.168.1.100/32 dev $NETDEV realm 100
}

test_ns() {
    ip netns add testns
    ip link set $NETDEV netns testns
    ip netns exec testns ifconfig $NETDEV  10.0.32.46/24
    ip netns exec testns ping -c 1 10.0.32.1
    ip netns del testns
}

config_qdisc_route_filter

test_ns
sleep 2
test_ns

Fixes: f2fc6a54585a ("[NETNS][IPV6] route6 - move ip6_dst_ops inside the network namespace")
Cc: stable@vger.kernel.org
Signed-off-by: xietangxin <xietangxin@yeah.net>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Fixes: 0287587884b1 ("net: better IFF_XMIT_DST_RELEASE support")
Link: https://patch.msgid.link/20260312025406.15641-1-xietangxin@yeah.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3178,6 +3178,7 @@ static netdev_tx_t start_xmit(struct sk_
 	/* Don't wait up for transmitted skbs to be freed. */
 	if (!use_napi) {
 		skb_orphan(skb);
+		skb_dst_drop(skb);
 		nf_reset_ct(skb);
 	}
 


