Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624308;
	b=eGdc8iMZ+P4wgzTfl/of+Sif9USD6Y/UYHWtOArbO7bToE/3K4i3V5lUHhEbD2m23IG5
	 JhwV/3NHnjmX+jfmwPpgNfwdbudVAhtlszy2OB+9rDXNZX2qhivLI0qkbgmx+cR+tywJS
	 DNOp7RvdKAkqMfZaE0wVfNaZ3zd/JwG5rCzwyyp7gw7apuPgdP2DLCxfzudFkIxp9jnzQ
	 JlKu7EsPhdidYr6jci4DRPf1TKYk3vq5dUcCYAlkpmKrwxe9p7NM+Dvx007gdfb0z4sl7
	 /HjUchBCxstMb7dQqebUCF0eHinSJSZVuPGJXK0eYJKSDBOD/wMPyTdpZyBVDnhGHJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NWs+9fO3qJnKOtw2Mld/Bzom6Gs3y6PcvWSTxXexgNo=;
	b=aQxColbqWVwVypwZuBh3xsJQTr1mTm4C+vWcUAGjUMThkDF0xQnEVJ7jLU2m6uvw5m/w
	 sp0b3dN7FTej6smwJnahYMm7vuNHpqyKs3ZWhvEkignAH1Iw7oMCzNpovkg6cqKVYwxbA
	 lypa3la6lSvn7ueH3tLn1HDcGER1gv4VBUcie2QiS5kVvZmEIJZdMXQABnHKCBFNWSpOr
	 J/cIZzexg0YkGU1/HnflSpkix6Xzo/IJcIsREPB+B5XzcNW55ydiYo6s0bh9K2KG7UvJP
	 HNEvAsTiboY0P9eF2t3ymYF2b9q/oDSb7diEX970EUyFMZrIrCyt2Ji33ytdk88VToQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2k16svZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BD2606A336;
	Wed, 25 Nov 2026 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2k16svZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2391F000C6;
	Wed, 25 Nov 2026 16:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624308;
	bh=NWs+9fO3qJnKOtw2Mld/Bzom6Gs3y6PcvWSTxXexgNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2k16svZqPt/iqlBbWZQACCnRVpKf/gPfmIFv9+MX/9VmvZ3tlYaOGDDBkbVOMaTq
	 xslbzet+g5S8u0uP/So0JYqZFy+ICgs2SFI2sZmg+0ITzm/45b2BpCu3LniU+jrN0H
	 zF8cCIoF/KKw/xMmM+vSbqzBuwno4ivrPVvdtMUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2344fb8002f3ef5b1712@syzkaller.appspotmail.com,
	Akhil Arul <akhilarul324@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/816] Bluetooth: hci_core: Fix queuing rx_work while workqueue is drained
Date: Wed, 25 Nov 2026 15:28:19 +0100
Message-ID: <20261125143852.692119646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c7529bcc9f0e0..4890498036049 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2962,8 +2962,14 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
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
@@ -2996,6 +3002,7 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 	case HCI_ISODATA_PKT:
 		break;
 	default:
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -3009,6 +3016,8 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 	skb_queue_tail(&hdev->rx_q, skb);
 	queue_work(hdev->workqueue, &hdev->rx_work);
 
+	rcu_read_unlock();
+
 	return 0;
 }
 EXPORT_SYMBOL(hci_recv_frame);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index fdf073a8f8b9b..b29d996feab6b 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5508,6 +5508,11 @@ int hci_dev_close_sync(struct hci_dev *hdev)
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



