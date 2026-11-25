Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621271;
	b=5Yq/FITIXDQAS0PGkxtEQzydAW3t9MtVr1M3R9W1ckwXASeaqHrypEgLNd+imiYhFJbo
	 3s/ub0SW4gIU8gXNh/bt3+6IpUjFFYdPXa+JX2Ykqpqvd5C/ITxIkjIlM1EWT0Bhd6ItZ
	 3buB16VAbhqtfMkulqGrp9tdwOv1ZaVI4B0wAonU1on9KA2AO87jXeieHWAwqLkGMyJqS
	 IqFu2GJRwbC/7wBwBuVs9oJxrfNLzDh+D/JVC+B/IUhJSEHJnU5q3GQ55A8mKumbSkzTE
	 s8IHyfSwvMKadS6VdKPDtTyM+K9wkPQ093ehwwffW/P1ZRBnveceL/n0OrVnWp7u6ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29SkRZC7qauTaXQVI3y3jetGqZBV8UTahy9o+sfSG34=;
	b=3FcrPjHxK4YdGWVpL0JORGEhNpeWzHdSdgMamsmLtRFx8J9Qh6dcQIe5CdUTUx0ERNFj
	 z2Q7wjYIGXwycQqj2IXsj8sR2iFF3kimsvM329lL5u8OP9iiD0Q10MAm7J83koNuCqlHR
	 ivHv4QGnOWhh1+6R3gDB6rRl8S3EQW3u+qklmqrhFMLJucm9pkp4HtBAiYP5x2puE/cvc
	 5oQUHlKkuKbOWq+85e8haAkZpFfDeqz4rT4cCO+4Eh1XPOCIqTvUfoPtWIxKjRkTkZsQ6
	 arilA6qm1eW/+hi7OQDz+XGQCQNO+FrVtljtfNQE4WzrCEj6QCA91utbE3rzItK1v8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MghP/x5B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F64606BF79;
	Wed, 25 Nov 2026 15:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MghP/x5B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABAB1F000E6;
	Wed, 25 Nov 2026 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621270;
	bh=29SkRZC7qauTaXQVI3y3jetGqZBV8UTahy9o+sfSG34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MghP/x5BUhp8+Zfkekfbu7TwB5siFnm0sOIbfvTsN51N2VlMdguHY7VN1F2NJEGYE
	 lCrDBX4WxA0v+lwPtGGV+mIuHNYEW0uzANA7tDIbzgMxh0P6Zyshe9A6NzrNpo655U
	 oppQLmqRYsd9aLS8orcx6oABwe/y8HffbdSdSp20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2344fb8002f3ef5b1712@syzkaller.appspotmail.com,
	Akhil Arul <akhilarul324@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/990] Bluetooth: hci_core: Fix queuing rx_work while workqueue is drained
Date: Wed, 25 Nov 2026 15:25:42 +0100
Message-ID: <20261125143826.191617029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Akhil Arul <akhilarul324@gmail.com>

[ Upstream commit 19b4e5701712f74d005cc66a36374559e8dfd281 ]

hci_recv_frame() drops a frame unless HCI_UP or HCI_INIT is set, but the
check is not synchronized with hci_dev_close_sync().  A driver can pass
the check, then close clears HCI_UP, flushes rx_work and starts
drain_workqueue(), and the late queue_work() of rx_work hits the
draining workqueue:

  workqueue: cannot queue hci_rx_work on wq hci0
  WARNING: kernel/workqueue.c:2352 at __queue_work+0x2c0/0x780
  Call Trace:
   queue_work_on+0xb2/0xc0
   hci_recv_frame+0x18f/0x330
   vhci_write+0x174/0x240
   vfs_write+0x271/0x680
   ksys_write+0x7c/0x110

Skipping the queue_work() while HCI_CMD_DRAIN_WORKQUEUE is set, as done
for tx_work, does not work for rx_work: the flag covers the whole close,
and events still have to be received in that window, for the commands
sent by hdev->shutdown() and for the reset done with
HCI_QUIRK_RESET_ON_CLOSE.

Run hci_recv_frame() under rcu_read_lock() and wait with
synchronize_rcu() once HCI_UP has been cleared, so that every caller
which still saw HCI_UP has queued its work before the workqueue is
drained, and later callers drop the frame.

HCI_INIT does not reopen that window.  Apart from the
HCI_QUIRK_RESET_ON_CLOSE reset, which runs after drain_workqueue() has
returned, it is only set by hci_dev_init_sync() during open, and open
and close are serialized by hci_req_sync_lock.  So once the grace period
has ended, nothing can pass the check and queue rx_work until the drain
is over.

Tested in qemu with the syzbot C reproducer, one run per boot: the
warning showed up on 12 of 30 boots before and on none of 42 boots after.
Bringing a vhci controller up and down 50 times behaves the same with
and without this change.

Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
Reported-by: syzbot+2344fb8002f3ef5b1712@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2344fb8002f3ef5b1712
Signed-off-by: Akhil Arul <akhilarul324@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 9 +++++++++
 net/bluetooth/hci_sync.c | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 49788a7bdba29..e4caf79c2d7c3 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2940,8 +2940,14 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	u8 dev_pkt_type;
 
+	/* Pairs with synchronize_rcu() in hci_dev_close_sync(), so rx_work is
+	 * not queued once the workqueue is being drained.
+	 */
+	rcu_read_lock();
+
 	if (!hdev || (!test_bit(HCI_UP, &hdev->flags)
 		      && !test_bit(HCI_INIT, &hdev->flags))) {
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return -ENXIO;
 	}
@@ -2976,6 +2982,7 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 	case HCI_DRV_PKT:
 		break;
 	default:
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -2989,6 +2996,8 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 	skb_queue_tail(&hdev->rx_q, skb);
 	queue_work(hdev->workqueue, &hdev->rx_work);
 
+	rcu_read_unlock();
+
 	return 0;
 }
 EXPORT_SYMBOL(hci_recv_frame);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6967da50aef05..5be062fdeb967 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5503,6 +5503,11 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 		return err;
 	}
 
+	/* Wait for hci_recv_frame() callers that still saw HCI_UP, so that
+	 * none of them queues rx_work while the workqueue is drained below.
+	 */
+	synchronize_rcu();
+
 	hci_leds_update_powered(hdev, false);
 
 	/* Flush RX and TX works */
-- 
2.53.0



