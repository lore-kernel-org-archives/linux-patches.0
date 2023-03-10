Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1EE847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B4BC433D2;
	Fri, 10 Mar 2023 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678455995;
	bh=erJIb9Hr0YbucJckBfGCz07Quml/JdTbXYBKdidNY4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsRZbtqKQrJIHYPSkGJRyyQ+BwDvw1UTN4KQM19apeTiW+8/0W/Zl/B4Y4BMddx8S
	 6X9y84d8nk2M7ey9n5jOxzdwY+3cDmWu5Sf8OcnrBLVPV9P1deBXSgOPGdVKMTY9Nk
	 hGlP1lUejmJGGGKc6VRKr+S6yIpEpm7q8CnLz0/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Coffin <alex.coffin@matician.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 046/193] Bluetooth: L2CAP: Fix potential user-after-free
Date: Fri, 10 Mar 2023 14:37:08 +0100
Message-Id: <20230310133712.516962742@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit df5703348813235874d851934e957c3723d71644 ]

This fixes all instances of which requires to allocate a buffer calling
alloc_skb which may release the chan lock and reacquire later which
makes it possible that the chan is disconnected in the meantime.

Fixes: a6a5568c03c4 ("Bluetooth: Lock the L2CAP channel when sending")
Reported-by: Alexander Coffin <alex.coffin@matician.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 24 ------------------------
 net/bluetooth/l2cap_sock.c |  8 ++++++++
 2 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index a5a19be51aff0..9fdd2260961e6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2517,14 +2517,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 		if (IS_ERR(skb))
 			return PTR_ERR(skb);
 
-		/* Channel lock is released before requesting new skb and then
-		 * reacquired thus we need to recheck channel state.
-		 */
-		if (chan->state != BT_CONNECTED) {
-			kfree_skb(skb);
-			return -ENOTCONN;
-		}
-
 		l2cap_do_send(chan, skb);
 		return len;
 	}
@@ -2568,14 +2560,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 		if (IS_ERR(skb))
 			return PTR_ERR(skb);
 
-		/* Channel lock is released before requesting new skb and then
-		 * reacquired thus we need to recheck channel state.
-		 */
-		if (chan->state != BT_CONNECTED) {
-			kfree_skb(skb);
-			return -ENOTCONN;
-		}
-
 		l2cap_do_send(chan, skb);
 		err = len;
 		break;
@@ -2596,14 +2580,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 		 */
 		err = l2cap_segment_sdu(chan, &seg_queue, msg, len);
 
-		/* The channel could have been closed while segmenting,
-		 * check that it is still connected.
-		 */
-		if (chan->state != BT_CONNECTED) {
-			__skb_queue_purge(&seg_queue);
-			err = -ENOTCONN;
-		}
-
 		if (err)
 			break;
 
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 13d070e7738db..47a16f6e741b8 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1415,6 +1415,14 @@ static struct sk_buff *l2cap_sock_alloc_skb_cb(struct l2cap_chan *chan,
 	if (!skb)
 		return ERR_PTR(err);
 
+	/* Channel lock is released before requesting new skb and then
+	 * reacquired thus we need to recheck channel state.
+	 */
+	if (chan->state != BT_CONNECTED) {
+		kfree_skb(skb);
+		return ERR_PTR(-ENOTCONN);
+	}
+
 	skb->priority = sk->sk_priority;
 
 	bt_cb(skb)->l2cap.chan = chan;
-- 
2.39.2



