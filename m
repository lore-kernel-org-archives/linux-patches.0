Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B60C3438A6;
	Wed, 30 Sep 2026 18:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791458; cv=none; b=EeIRZUet9qc7l6oxiAFWLV8HthNK2+qYI94J7CxN1pyy7Lm4rncjop9e/hybp8E3kTPSb5X43QguVLqFofPM6+kAhFvCVT+qHfbN3suRNk8+iYlIl3DMQr0Fds1XWPBJLoZyNXwxo7zFnuRqCoAkpqrLxf4uzwEgxi9rmIniUzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791458; c=relaxed/simple;
	bh=7qa+efqzpFpPfRzUlKoD3THrC/Nl+o+1Z/7kzcaBsdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVA5G7UfCS+gMQXWjx8HLqr6BF8jAexuZUXyNV+mIPr86TQKmN5fNtRGu/VwXUXEntjn/Iqif5L5B7fB6lbdTr2QLjqZouxcHqoqCbtH4pFfPMwLWjgO8bJ1FM33Tj/1GazWTUKdYoIjaN5wpseWeFXs0F6bU5mTgfYZslPJKYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7IvioaM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7IvioaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CE61F00898;
	Wed, 30 Sep 2026 18:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791457;
	bh=KbFUBWVLKjSH+Nk22tinvzkOhTiW3qXTHRlcZseaYy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7IvioaMlK93/SG7J7q1PjhCk1hqldgxvuRShqDvNPLM8r5J4mflMFB6hzPX+z/fg
	 8H5ZI436CYwiH2BTT31tQNwAL8IaNiLLE6UAwX9UeamtMrjgq0+Z7ZcJfb0aRJdpWC
	 Eium2VlBOTygXpfq1u5eRrtIuHar96b5w35BHIuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/752] net: cap tx_queue_len at S16_MAX to prevent oversized ring allocations
Date: Wed, 30 Sep 2026 17:22:58 +0200
Message-ID: <20260930152404.960276247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 66ab4c59b74db7ab53a1c9083feaaede393a96a0 ]

Several subsystems allocate ring buffers sized by dev->tx_queue_len
with no upper bound. An unprivileged user (via unshare -Urn) can set a
huge tx_queue_len and exhaust global memory with ring allocations:

- pfifo_fast: pfifo_fast_init() and pfifo_fast_change_tx_queue_len()
  allocate 3 skb_array rings of tx_queue_len entries each.
- tun: tun_queue_resize() and the queue-attach path resize ptr_rings
  to tx_queue_len on the NETDEV_CHANGE_TX_QUEUE_LEN notifier.
- tap (macvtap/ipvtap): tap_queue_resize() and tap_init() resize/init
  ptr_rings to tx_queue_len on the same notifier.

netif_change_tx_queue_len() is the single entry point for IFLA_TXQLEN,
sysfs, and the SIOCSIFTXQLEN ioctl. Cap new_len at S16_MAX (32767)
there so the oversized value is rejected at set time. This takes
effect whether the device is up or down, before dev->tx_queue_len is
written, before any notifier fires, and before any ring is allocated.
The "> S16_MAX" check also subsumes the previous unsigned-long
truncation test, and a negative ifr_qlen from the ioctl lands far
above the cap after conversion, so both old failure modes are covered
by the one comparison.

tx_queue_len is ambigious: both a per-ring sizing multiplier and a
default queue-length/limit knob for consumers that allocate
nothing at set time (pfifo/bfifo/gred/plug/sfb limits, htb
direct_qlen, qfq max_classes, teql). 32767 is chosen as the largest
value NLA_POLICY_FULL_RANGE can express for the u32 IFLA_TXQLEN
policy in patch 2/3 while staying a legitimate queue length on
high-BDP paths; the ring-memory trade-off of a shared knob is
disclosed below.

Conditions to recreate the bug:
- CONFIG_NET_SCHED=y, CONFIG_VETH=y, CONFIG_USER_NS=y, CONFIG_NET_NS=y.
- Unprivileged user in a fresh user+net namespace (unshare -Urn).
- pfifo_fast: create veth pairs, set tx_queue_len to 500000, attach
  mq+pfifo_fast. ~28 iterations OOMs a 2GB guest.
- tun: create 50 tun devices with IFF_MULTI_QUEUE, set tx_queue_len to
  500000, open 8 queues each. ~1.6GB of ptr_ring allocations OOMs a
  512MB guest.
- tap: same as tun with IFF_TAP. ~960MB OOMs a 512MB guest.
- On the fixed kernel the oversized tx_queue_len is rejected with
  -ERANGE at set time (all four paths: RTM_SETLINK, RTM_NEWLINK
  create, sysfs, ioctl - the latter two via this check, the former
  two via this check and the 2/3 parse policy respectively).

Fixes: 6a643ddb5624 ("net: introduce helper dev_change_tx_queue_len()")
Reported-by: Vega <vega@nebusec.ai>
Closes: https://lore.kernel.org/netdev/20260828121902.66837-1-jhs@mojatatu.com/
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-2899.v2.20260901233641@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8aac510303a68..a4b185d83a00a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9056,7 +9056,7 @@ int dev_change_tx_queue_len(struct net_device *dev, unsigned long new_len)
 	unsigned int orig_len = dev->tx_queue_len;
 	int res;
 
-	if (new_len != (unsigned int)new_len)
+	if (new_len > S16_MAX)
 		return -ERANGE;
 
 	if (new_len != orig_len) {
-- 
2.53.0



