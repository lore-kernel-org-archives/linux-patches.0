Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1342B3570AE;
	Thu, 15 Jan 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497227; cv=none; b=m9N32GJ2OojiG5JURe2Qjjub9LrvSI2kc8wdTH52oYVeb3izfH0L37TLvf39kDJVB7vTH3fl0Fg5lxnsfWyYt91K/3SKEzO1OeVw0+vwXLkil8HFl1b6IVxIhO1Z/T3xw8JIuKcolqy0Ev3IkJcqlANOc6XiLNG1MoYmaRCFim8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497227; c=relaxed/simple;
	bh=iv9ThHXD59P4kw41gVgs2PYNq+uBIPWtCLdH9Y1Vzm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJ1biU0kU3ueYGWU7sGliMQjsEmg9JkpEFdn3yCgbKm7/73gBd/u65YRP2ZBev89qwZfAP1SRU4glRC4XhPVgzUP5JA01SZ/PZqImf5tCvDGZ02GqQNqFH/eA17girBYIKWIuMrZJe9QebWKRids3sbxfXMS60mlGufY+8/CpCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0nphlXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0nphlXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6414DC116D0;
	Thu, 15 Jan 2026 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497227;
	bh=iv9ThHXD59P4kw41gVgs2PYNq+uBIPWtCLdH9Y1Vzm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0nphlXgaAhcBxO8mIGIiY8CUr/4nH8sgFquAuSsrwaOPD3j96ucTc3YVhpWAPBks
	 aclzualuHhDYp1xdMLe93RK3kGzP5hIzT54f4GvroFZszIJIo3uceYCzeOBp1qAxPm
	 64/KCBkjPs9g8K+PPRWmUepnpDryTII5bD2m9CAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58b44a770a1585795351@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 51/72] arp: do not assume dev_hard_header() does not change skb->head
Date: Thu, 15 Jan 2026 17:49:01 +0100
Message-ID: <20260115164145.343584993@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 50e2b4939d8e9..fc8c7a34b53e6 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -563,7 +563,7 @@ struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 
 	skb_reserve(skb, hlen);
 	skb_reset_network_header(skb);
-	arp = skb_put(skb, arp_hdr_len(dev));
+	skb_put(skb, arp_hdr_len(dev));
 	skb->dev = dev;
 	skb->protocol = htons(ETH_P_ARP);
 	if (!src_hw)
@@ -571,12 +571,13 @@ struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
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



