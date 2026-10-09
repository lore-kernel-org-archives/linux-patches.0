Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E6D19F40B;
	Fri,  9 Oct 2026 14:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557059; cv=none; b=io24K0+t9hLsjEbBpnCpE5h9bQq09P3axQ9CUzciqHVDCuBlx6XwQrArk5+y9wHXHtWvVsN+jw73VtSPAurWuadlJoZU6mGvrQ3Mtsw+LaNtt5bM9PU/ZW11y/fHfMTITf9xo4PFDicKdiVqNIwHFNTCxtVMGi0bMGdlo9emiZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557059; c=relaxed/simple;
	bh=TFIXn9uUiuF4hAkB/bfMafpF4DPD2YDk7ciyPDSgnpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVrh7nEaMCLqLJ7+bgbL7p/0NO9dKAC+kvHtGk8QgSVQFSeoGdvftuqh3w1/FYRcF50uG41+To50DhlPutHIC+Zp/rvpLhmbYhZAZ5IdxzWeUhnLgSV3YrP29hK40H/UkbmX00mjWhBS9rElj/vOVw+dDzLCgo4DawjzN5aKZp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxMjgkF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxMjgkF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2081F000FF;
	Fri,  9 Oct 2026 14:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557058;
	bh=rC6ACl2uHSiDNQDfPukoqhYoe2mBoPGhMQRYh/biLdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxMjgkF6UVjdoQ8kr0+dan0UrlxRIeeFYN4D50Rtbo7RJWCYWVuLSrn6M35g7H/01
	 LYbscZCTq5FlZIgAza4439bZzJQII8Of3vNvBnYpkNV0Wur9snyF6g/LbehdZ+Gf0Q
	 u/Y/rSOMi+WvxFTUpleu1uDFzij6kAAGay3qqeF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 289/428] Bluetooth: hci_core: Serialize fragmented ISO packet queueing
Date: Fri,  9 Oct 2026 16:10:26 +0200
Message-ID: <20261009140952.451951163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3335,6 +3335,8 @@ static void hci_queue_iso(struct hci_con
 
 		skb_shinfo(skb)->frag_list = NULL;
 
+		spin_lock_bh(&queue->lock);
+
 		__skb_queue_tail(queue, skb);
 
 		do {
@@ -3349,6 +3351,8 @@ static void hci_queue_iso(struct hci_con
 
 			__skb_queue_tail(queue, skb);
 		} while (list);
+
+		spin_unlock_bh(&queue->lock);
 	}
 
 	bt_dev_dbg(hdev, "hcon %p queued %d", conn, skb_queue_len(queue));


