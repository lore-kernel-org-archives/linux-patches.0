Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A5D3568F8;
	Tue, 26 Aug 2025 14:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217524; cv=none; b=ai+71gxmizRH3bL2+xWZlAyePVgu/rVcnGFmW2owFbrp8aQ/dOcsgIfUtqaTYtWTA+CW4/DdtNMtTU0K8/8yft1azuZf2n6c7YxTEjNaC1v6+yeQ3f7rBIWCrjDal9dd0qQPnM4j+i0BK8ukVU5IosaIIqZvf6quk+QYxu63Tug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217524; c=relaxed/simple;
	bh=k9KDNcDVmyEUUe/3ZinkO6u9leQxos2+50D0nLP32FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tqy0ffFIsDfJFJX3ff7NZBDMHQv4w6SHvmbU0d2vbbgcKQUwCg8X3vP4QA6a4lvok7TfgynXXlho9Bp7mAreWwtGEGOFYJEGmVZZonoQ+HDr3CQkRUUi2OEZEKcpB9Lwva8uEU9PjeBlMHzIJ2W3zTgZmlDvIt6oIUVpSm9LPPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axUP+D0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axUP+D0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50229C4CEF1;
	Tue, 26 Aug 2025 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217524;
	bh=k9KDNcDVmyEUUe/3ZinkO6u9leQxos2+50D0nLP32FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axUP+D0MQLTmhL+t3/2fmPtes9ie44ma31ajB3rs3yfsc7GLrY7MNhxiPQ9KHpIyL
	 lSrVtNIKKnDC6YEBEvrIjgwV50sJ3oOd/bQdOmeOQicwsIpdIjFVO96NXuIsYvC5bN
	 UwR7mqOxdRz72JzPn+Ltn6Rix62pTIqda9Mc8mNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+afad90ffc8645324afe5@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/523] pptp: ensure minimal skb length in pptp_xmit()
Date: Tue, 26 Aug 2025 13:06:26 +0200
Message-ID: <20250826110928.800394014@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit de9c4861fb42f0cd72da844c3c34f692d5895b7b ]

Commit aabc6596ffb3 ("net: ppp: Add bound checking for skb data
on ppp_sync_txmung") fixed ppp_sync_txmunge()

We need a similar fix in pptp_xmit(), otherwise we might
read uninit data as reported by syzbot.

BUG: KMSAN: uninit-value in pptp_xmit+0xc34/0x2720 drivers/net/ppp/pptp.c:193
  pptp_xmit+0xc34/0x2720 drivers/net/ppp/pptp.c:193
  ppp_channel_bridge_input drivers/net/ppp/ppp_generic.c:2290 [inline]
  ppp_input+0x1d6/0xe60 drivers/net/ppp/ppp_generic.c:2314
  pppoe_rcv_core+0x1e8/0x760 drivers/net/ppp/pppoe.c:379
  sk_backlog_rcv+0x142/0x420 include/net/sock.h:1148
  __release_sock+0x1d3/0x330 net/core/sock.c:3213
  release_sock+0x6b/0x270 net/core/sock.c:3767
  pppoe_sendmsg+0x15d/0xcb0 drivers/net/ppp/pppoe.c:904
  sock_sendmsg_nosec net/socket.c:712 [inline]
  __sock_sendmsg+0x330/0x3d0 net/socket.c:727
  ____sys_sendmsg+0x893/0xd80 net/socket.c:2566
  ___sys_sendmsg+0x271/0x3b0 net/socket.c:2620
  __sys_sendmmsg+0x2d9/0x7c0 net/socket.c:2709

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+afad90ffc8645324afe5@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68887d86.a00a0220.b12ec.00cd.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Link: https://patch.msgid.link/20250729080207.1863408-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pptp.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 05a75b5a8b68..1b306562f916 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -159,9 +159,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	int len;
 	unsigned char *data;
 	__u32 seq_recv;
-
-
-	struct rtable *rt;
+	struct rtable *rt = NULL;
 	struct net_device *tdev;
 	struct iphdr  *iph;
 	int    max_headroom;
@@ -179,16 +177,20 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 
 	if (skb_headroom(skb) < max_headroom || skb_cloned(skb) || skb_shared(skb)) {
 		struct sk_buff *new_skb = skb_realloc_headroom(skb, max_headroom);
-		if (!new_skb) {
-			ip_rt_put(rt);
+
+		if (!new_skb)
 			goto tx_error;
-		}
+
 		if (skb->sk)
 			skb_set_owner_w(new_skb, skb->sk);
 		consume_skb(skb);
 		skb = new_skb;
 	}
 
+	/* Ensure we can safely access protocol field and LCP code */
+	if (!pskb_may_pull(skb, 3))
+		goto tx_error;
+
 	data = skb->data;
 	islcp = ((data[0] << 8) + data[1]) == PPP_LCP && 1 <= data[2] && data[2] <= 7;
 
@@ -262,6 +264,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	return 1;
 
 tx_error:
+	ip_rt_put(rt);
 	kfree_skb(skb);
 	return 1;
 }
-- 
2.39.5



