Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55ED51AFD2;
	Wed, 30 Sep 2026 17:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788455; cv=none; b=KIOlD2MdbCCuhhUCAfXXp4/ymndVkP6RfO2PDxqdFWmBdn746Ne3jXO3VJdTtEgpwSp+BVbsGnP4gg3BuIOdyBVOBC8W1OURN2yz+/6PKHHd6sVQFZWu/5TEYxjHuXOWlH7sFqYlgrj5NYDxp7fnF0PpYHfPjIQM0oD1azK0B0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788455; c=relaxed/simple;
	bh=DihMCQ3qQOf7PDzjHYtXH+Bw4P7qE6kG/yDnqghP6DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tysqr5qa+Kb2HbeWkxIoqP0LWNs/ymA8EUYRlDGd6nIswTgG5CiUy8HYZHUkMtFh2ShlCy/8nP0OA96eSxc7GnXF4vb3t0cJ6m2DXT2rKGUqQOx0tstE8KePDTRLQcaC5w0q8jgWN37QUfZOGw1nE39XDon3pM6/IVz6KjxNX7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=av0s65NU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="av0s65NU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AD11F000FF;
	Wed, 30 Sep 2026 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788453;
	bh=3PA9VGEpxcTTixpgfQVtnWNFurdRB1UHBktkh/xgDJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=av0s65NUNpkG6J1RyGp4bQ7zZqgH6XmlW/LWU8iYkKEqgtAI9OU7qjjlUDtKxweVU
	 vb63XWTQEkMiYjHKecEdiTG+N7797/HtLWbSEFUODTV3wFntXHfomiQlwY2RZja+vK
	 9EY69n7qHKZednJxcizaBr2ZUHXo6Znv+rTWMFfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/877] Bluetooth: hci_core: Print number of packets in conn->data_q
Date: Wed, 30 Sep 2026 17:17:21 +0200
Message-ID: <20260930152417.540166528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 3c34d6428740e47b29ae3afd85d6f9eb656a3ea3 ]

This attempts to print the number of packets pending to be transmitted
in the conn->data_q.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 6610c6fe4b89 ("Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index f68238406ad2e..24f2119c7abfa 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3273,6 +3273,8 @@ static void hci_queue_acl(struct hci_chan *chan, struct sk_buff_head *queue,
 
 		spin_unlock_bh(&queue->lock);
 	}
+
+	bt_dev_dbg(hdev, "chan %p queued %d", chan, skb_queue_len(queue));
 }
 
 void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
@@ -3304,6 +3306,10 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb)
 	hci_skb_pkt_type(skb) = HCI_SCODATA_PKT;
 
 	skb_queue_tail(&conn->data_q, skb);
+
+	bt_dev_dbg(hdev, "hcon %p queued %d", conn,
+		   skb_queue_len(&conn->data_q));
+
 	queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
@@ -3363,6 +3369,8 @@ static void hci_queue_iso(struct hci_conn *conn, struct sk_buff_head *queue,
 			__skb_queue_tail(queue, skb);
 		} while (list);
 	}
+
+	bt_dev_dbg(hdev, "hcon %p queued %d", conn, skb_queue_len(queue));
 }
 
 void hci_send_iso(struct hci_conn *conn, struct sk_buff *skb)
-- 
2.53.0



