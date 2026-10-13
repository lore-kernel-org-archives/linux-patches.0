Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2AB35CB9C;
	Tue, 13 Oct 2026 12:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895304; cv=none; b=JDB5vA6BN4TZ8tNwK3hlazf57HRrXdRSPu5S80SuJE8D2V2VyL0mofgbBETzPFJy2tCwpmAHvda+uaB5NIo1oicvByq2acrbRkyWZX9n04yFcCp6Z7qPM+obM3o2YojEo+g4/TBVdgCytT9b5pqrBPPU5eEHjsp9oXKamyeE9Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895304; c=relaxed/simple;
	bh=KzMZ9rwAHH/OL3Zf2VPvr384Z297ZRgn7BuuXHWaUr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HANVdr72fUSb5Do8xOAEAUdbMGrg0OkB9aPgRC5zc7Ox1GrQqJOn4LuyOw913zd1TyelJGnNq3dNOjnn0vdItr3iOR+66x4gIGkD+Yz/YNTvpMsYRZKJ/FaX4r6OnQ51sVGcQowlBMcftfk5mAzgo8TdZFUBE63nhIxF6o0kOgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnogleZe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnogleZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1DE1F000FF;
	Tue, 13 Oct 2026 12:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895303;
	bh=JIOaZfonTq2ODEgz289Kx2PVr2KK4vBtc8qwX6oNmlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnogleZeDJmSJv2aFqNG8XBSSSHREs+8X9A7icPe/zIbG6MN/zagEfmNQN9iKiwac
	 0RdTdivLDNiE4C7Qt5cyQZ7py9mAqa5pq+ckmzz0qRzrrACftoUX5RIKE63d5SLboJ
	 8N24inD4N2ZSWW2TOTL2lTEKSHOBkhAVM5p1OaoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 185/497] Bluetooth: hci_core: Serialize fragmented ISO packet queueing
Date: Tue, 13 Oct 2026 13:35:52 +0200
Message-ID: <20261013112912.280113966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 1a572db43c057566771b485598ad2e66cb390821 upstream.

The fragmented path in hci_queue_iso() calls __skb_queue_tail() without
holding conn->data_q.lock. The socket lock serializes senders, but the
transmit worker can concurrently remove packets from this queue using
skb_dequeue().

After an insertion saves the old tail pointer, hci_sched_iso() can dequeue
that packet and pass it to the driver. The driver can free the packet
before the insertion resumes and writes to the old tail's next pointer,
causing a use-after-free. Concurrent updates can also corrupt the queue.

KASAN reported:

  BUG: KASAN: slab-use-after-free in hci_send_iso+0xc7d/0xe10
  Call Trace:
   hci_send_iso+0xc7d/0xe10
   iso_sock_sendmsg+0x710/0x900
   __sys_sendto+0x34a/0x3a0

  Allocated by task 86:
   __alloc_skb+0xdd/0x820
   alloc_skb_with_frags+0x7e/0x770
   sock_alloc_send_pskb+0x67a/0x820
   bt_skb_sendmsg.constprop.0+0xc0/0x6c0
   iso_sock_sendmsg+0x44e/0x900

  Freed by task 90:
   kmem_cache_free+0xcb/0x3d0
   vhci_read+0x33f/0x4d0
   vfs_read+0x177/0xa20

Hold the queue lock across the entire fragment batch, as hci_queue_acl()
does, to serialize insertion against dequeue while preserving fragment
ordering.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3368,6 +3368,8 @@ static void hci_queue_iso(struct hci_con
 
 		skb_shinfo(skb)->frag_list = NULL;
 
+		spin_lock_bh(&queue->lock);
+
 		__skb_queue_tail(queue, skb);
 
 		do {
@@ -3382,6 +3384,8 @@ static void hci_queue_iso(struct hci_con
 
 			__skb_queue_tail(queue, skb);
 		} while (list);
+
+		spin_unlock_bh(&queue->lock);
 	}
 
 	bt_dev_dbg(hdev, "hcon %p queued %d", conn, skb_queue_len(queue));


