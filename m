Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5453438AE;
	Sat, 30 May 2026 17:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162879; cv=none; b=LctLV4nM/lhn07oC/yCJvbPPhq8IHL5SHHCeHUzWQvn8t1VR39Y/1or5czXLXxmzsjPM0+ld/ghqwH2SV555y9DI4bHg+Twlw5/0MG1su3YvvXqEMgcwKmxBFL3DyI/Smn2EXLW1MHGeWEcbRZlcCjODh//raEaR4FqgmRzhz3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162879; c=relaxed/simple;
	bh=cLgWMYVZCQ74nH/hxP6Ntx0Q3NzL7QwxE/XUwxcKgtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTWznyQWfirFvmuPJzXb6kaI+kXojkuFKJnuXqVynSv0QwkmsXKzNbinbHM/7XhUEu8eIJGLaPs5xlc2ok45enanIlStJx8rKBg6hdbZ4rNNRKzgdFGphS5CJs5nrn9RA1c166vFcbL+CGREWLeouG3SxjHOBRPzM+e2rRhDrnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inNpD/+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inNpD/+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18FD1F00893;
	Sat, 30 May 2026 17:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162878;
	bh=SR9HnDclxjSp5EeRfcRAsIQVIfp2GGUgGczbr008ZJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=inNpD/+oejQdbxd9+6YY6svNehgu8EpFMiUz8KOnt8dxlmfs5erGB2jukWY1HBOui
	 /EdUjk1fgrngCMVw7ElIOXlKLQ3fhZ5eliWt1KIzBN/G9GNUioNMVnNFaOdoRzTPVm
	 zFqGkS54ElVafvwUl9R8pOCHOeRkkbAq5YduVVlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezar Bulinaru <cbulinaru@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/776] net: tap: NULL pointer derefence in dev_parse_header_protocol when skb->dev is null
Date: Sat, 30 May 2026 17:56:44 +0200
Message-ID: <20260530160242.662292699@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Cezar Bulinaru <cbulinaru@gmail.com>

commit 4f61f133f354853bc394ec7d6028adb9b02dd701 upstream.

Fixes a NULL pointer derefence bug triggered from tap driver.
When tap_get_user calls virtio_net_hdr_to_skb the skb->dev is null
(in tap.c skb->dev is set after the call to virtio_net_hdr_to_skb)
virtio_net_hdr_to_skb calls dev_parse_header_protocol which
needs skb->dev field to be valid.

The line that trigers the bug is in dev_parse_header_protocol
(dev is at offset 0x10 from skb and is stored in RAX register)
  if (!dev->header_ops || !dev->header_ops->parse_protocol)
  22e1:   mov    0x10(%rbx),%rax
  22e5:	  mov    0x230(%rax),%rax

Setting skb->dev before the call in tap.c fixes the issue.

BUG: kernel NULL pointer dereference, address: 0000000000000230
RIP: 0010:virtio_net_hdr_to_skb.constprop.0+0x335/0x410 [tap]
Code: c0 0f 85 b7 fd ff ff eb d4 41 39 c6 77 cf 29 c6 48 89 df 44 01 f6 e8 7a 79 83 c1 48 85 c0 0f 85 d9 fd ff ff eb b7 48 8b 43 10 <48> 8b 80 30 02 00 00 48 85 c0 74 55 48 8b 40 28 48 85 c0 74 4c 48
RSP: 0018:ffffc90005c27c38 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888298f25300 RCX: 0000000000000010
RDX: 0000000000000005 RSI: ffffc90005c27cb6 RDI: ffff888298f25300
RBP: ffffc90005c27c80 R08: 00000000ffffffea R09: 00000000000007e8
R10: ffff88858ec77458 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000014 R14: ffffc90005c27e08 R15: ffffc90005c27cb6
FS:  0000000000000000(0000) GS:ffff88858ec40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000230 CR3: 0000000281408006 CR4: 00000000003706e0
Call Trace:
 tap_get_user+0x3f1/0x540 [tap]
 tap_sendmsg+0x56/0x362 [tap]
 ? get_tx_bufs+0xc2/0x1e0 [vhost_net]
 handle_tx_copy+0x114/0x670 [vhost_net]
 handle_tx+0xb0/0xe0 [vhost_net]
 handle_tx_kick+0x15/0x20 [vhost_net]
 vhost_worker+0x7b/0xc0 [vhost]
 ? vhost_vring_call_reset+0x40/0x40 [vhost]
 kthread+0xfa/0x120
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30

Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kovalev: bp to fix CVE-2022-50073 ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 53eadd82f9b8c..a08adca412b41 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -703,11 +703,22 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_hdr(skb)->h_proto;
 
+	rcu_read_lock();
+	tap = rcu_dereference(q->tap);
+	if (!tap) {
+		kfree_skb(skb);
+		rcu_read_unlock();
+		return total_len;
+	}
+	skb->dev = tap->dev;
+
 	if (vnet_hdr_len) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
 					    tap_is_little_endian(q));
-		if (err)
+		if (err) {
+			rcu_read_unlock();
 			goto err_kfree;
+		}
 	}
 
 	skb_probe_transport_header(skb);
@@ -717,8 +728,6 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-	rcu_read_lock();
-	tap = rcu_dereference(q->tap);
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
 		skb_zcopy_init(skb, msg_control);
@@ -727,14 +736,8 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		uarg->callback(NULL, uarg, false);
 	}
 
-	if (tap) {
-		skb->dev = tap->dev;
-		dev_queue_xmit(skb);
-	} else {
-		kfree_skb(skb);
-	}
+	dev_queue_xmit(skb);
 	rcu_read_unlock();
-
 	return total_len;
 
 err_kfree:
-- 
2.53.0



