Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA49327AC5C;
	Thu, 15 Jan 2026 17:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498749; cv=none; b=HBaCiswpijouj68kn8KQTnRvJRq78jYhM8TPB3aC6zxEwCDIL7DuM6P1uMGQT/51jkfmZEFt6PXAR7yaEFn3C37NdNR/OiLvcg0BdIroxde6CrZNd1UUh/Ar41rt7aV4+XpSgxohPR1aA2IDIPtnaPWnDKGXAH1uLBBrm+KXADQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498749; c=relaxed/simple;
	bh=3xHGqtTal0thJBjK6VSnkOdW+fHJvakWI/zXIj5oHvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0+ws8bxmvxEMA//SwRk+Z/MyD9uDs2hUYuur3/5m/9Atu6p6UqDbwv7/PRVnPN+4RVLNJdTIbYGy3UgD/NvaFf9NmZGHptA+ZNnO+wi2NVObkF88wFp/XWoGMvf+CPrpH61u81ny+xfWj/SkQX0CLjAM4MbtmOYoFRQGM0wq7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZDlI8kR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZDlI8kR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79C9C116D0;
	Thu, 15 Jan 2026 17:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498749;
	bh=3xHGqtTal0thJBjK6VSnkOdW+fHJvakWI/zXIj5oHvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZDlI8kRsSeCY/hjlrC58MNZcsZ11yFZ/PxwE6tHOo3RwMPZaIXT/gI+0kg3+onZx
	 +y+jvSBcfBAebF3XDDpWp3WehggmZuMRciSg0sSIW/4oDF8l7VHTWJF194NkdnV2In
	 nIqBAekHyxsUksRgynTT8sImIgu9DxlZ+cSq8PlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58b44a770a1585795351@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 541/554] arp: do not assume dev_hard_header() does not change skb->head
Date: Thu, 15 Jan 2026 17:50:07 +0100
Message-ID: <20260115164305.907390409@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index ef69321886798..5a76164980344 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -542,7 +542,7 @@ struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 
 	skb_reserve(skb, hlen);
 	skb_reset_network_header(skb);
-	arp = skb_put(skb, arp_hdr_len(dev));
+	skb_put(skb, arp_hdr_len(dev));
 	skb->dev = dev;
 	skb->protocol = htons(ETH_P_ARP);
 	if (!src_hw)
@@ -550,12 +550,13 @@ struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
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



