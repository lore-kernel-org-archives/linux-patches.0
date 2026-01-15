Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F7537C117;
	Thu, 15 Jan 2026 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496646; cv=none; b=XgJIDX7749Qt5kQ837TcYH5gTCbmkyQITLut0NIbED9OZh2+SwFIPrMMVUkcWtzXGYJy2gu/sF56nBVofjy8QF1BAZIXV2SSJdbqQrydNcXTX2nMGSi3uTDhJHv6GcINnOMo/NVTVnQP7clwQBJjqspgHwnIfjQhOwO1U0RLvfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496646; c=relaxed/simple;
	bh=ul6nZNbJ6E3YjNrxzqlv4h3/WqjrNap+4ej9jHcVZ7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAWXtkwerDChcwN9JVkbINxTjkhyyOlHOhjmiI3menhora2jNG2Wuyv5oeeqZDzLh3IHa3oGo9+w/AEjs8UxIU2p/pkoEKQxWYwbuuPGVjUJa3YPsT4hq+bdt3xgRiZMFdA0SkikZ0I82TQBylVbhPra0DcAwgq5KmvcL8FKHi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptFPPkHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptFPPkHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763B6C116D0;
	Thu, 15 Jan 2026 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496645;
	bh=ul6nZNbJ6E3YjNrxzqlv4h3/WqjrNap+4ej9jHcVZ7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptFPPkHPCOfYA/rGANZwF3lxYXygYHC5ubUg4Fgra3SLOQ9LEuBEZbqn9TY9JP6IW
	 2VFFhkZsjEvBBch7E3+8A7OQLbEHPpm204iksAnsfoUOZDraVZa7OwJhcyiwWi6kLE
	 brYJV4t4WNVwa5F2jEW39ZupzUcfbjLKSDzPXb2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58b44a770a1585795351@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/119] arp: do not assume dev_hard_header() does not change skb->head
Date: Thu, 15 Jan 2026 17:48:20 +0100
Message-ID: <20260115164155.017612509@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c92510f5e3f82ba11c95991824a41e59a9c5ed81 ]

arp_create() is the only dev_hard_header() caller
making assumption about skb->head being unchanged.

A recent commit broke this assumption.

Initialize @arp pointer after dev_hard_header() call.

Fixes: db5b4e39c4e6 ("ip6_gre: make ip6gre_header() robust")
Reported-by: syzbot+58b44a770a1585795351@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260107212250.384552-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/arp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 8fb48f42581ce..7822b21445148 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -564,7 +564,7 @@ struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 
 	skb_reserve(skb, hlen);
 	skb_reset_network_header(skb);
-	arp = skb_put(skb, arp_hdr_len(dev));
+	skb_put(skb, arp_hdr_len(dev));
 	skb->dev = dev;
 	skb->protocol = htons(ETH_P_ARP);
 	if (!src_hw)
@@ -572,12 +572,13 @@ struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 	if (!dest_hw)
 		dest_hw = dev->broadcast;
 
-	/*
-	 *	Fill the device header for the ARP frame
+	/* Fill the device header for the ARP frame.
+	 * Note: skb->head can be changed.
 	 */
 	if (dev_hard_header(skb, dev, ptype, dest_hw, src_hw, skb->len) < 0)
 		goto out;
 
+	arp = arp_hdr(skb);
 	/*
 	 * Fill out the arp protocol part.
 	 *
-- 
2.51.0



