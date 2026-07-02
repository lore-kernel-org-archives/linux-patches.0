Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD70239D6D9;
	Thu,  2 Jul 2026 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009665; cv=none; b=dn3JsuGZASztbZstHIapvaocEO34KsWlg7CLOMmMHsYXEEAc0Mdq8n+s4E6nngh2D9bgy/P+jpMCRTM93Qlmby7NwxiCSjoPyL1E5KMHKs+B/3mWMe3nOFi6k+AaIp40vEs0ykX3Si8DIHTNcGIXdXdc1dwiIOm+G44+HB+jmWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009665; c=relaxed/simple;
	bh=JM9L6Wk4/WPLkUEs+wQJxf9ZB+K2nbqSO1h1djmxjE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWgq98BgpU3/5EUhtTNTwlbPW0uvx4CWOmoGyjRou/OpMZgFmbokSkD5DRdfEaJa7LdZBLzuKb7T5hLYeDK+fPvYoRA/Km1YM9z+2x3W/Y586eirQTC4pUBDDc780XKxpHUuz5F4nnY8QQGrxyS/ikgdHThZE56pVMkGDH/zMHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBi6lz/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBi6lz/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BDE1F00A3A;
	Thu,  2 Jul 2026 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009662;
	bh=48qorFjqTrV6JbEArSYPfZR2VjxVBsvE2AWrEXh+qao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBi6lz/XtU6KHYoDVNunWhrE2z4Gx9mbf3c8pcbJt6qOLlDqf2VSKZs7/VdC3noSX
	 Sht9NkxFYd1sMAmUgbd2mouC+K4zC2cMwvLyGh78n7qzG0MQTXlkwjBSla6dvwRw9D
	 3dU2tARJXuVEXG8VY5lksJTZceB6fGCWptAGuihU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/95] batman-adv: ensure bcast is writable before modifying TTL
Date: Thu,  2 Jul 2026 18:19:42 +0200
Message-ID: <20260702155110.028810375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 4cd6d3a4b96a8576f1fed8f9f9f17c2dc2978e0c upstream.

Before batman-adv is allowed to write to an skb, it either has to have its
own copy of the skb or used skb_cow() to ensure that the data part is not
shared.

The old implementation used a shared queue and created copies before
attempting to write to it. But with the new implementation, the broadcast
packet is already modified when it gets received. Potentially writing to
shared buffers in this process.

Adding a skb_cow() right before this operation avoids this and can at the
same time prepare it for the modifications required to rebroadcast the
packet.

Cc: stable@kernel.org
Fixes: 3f69339068f9 ("batman-adv: bcast: queue per interface, if needed")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/routing.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 970d0d7ccc981a..503c8c9381ebe9 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1198,6 +1198,12 @@ int batadv_recv_bcast_packet(struct sk_buff *skb,
 	if (batadv_is_my_mac(bat_priv, bcast_packet->orig))
 		goto free_skb;
 
+	/* create a copy of the skb, if needed, to modify it. */
+	if (skb_cow(skb, ETH_HLEN) < 0)
+		goto free_skb;
+
+	bcast_packet = (struct batadv_bcast_packet *)skb->data;
+
 	if (bcast_packet->ttl-- < 2)
 		goto free_skb;
 
-- 
2.53.0



