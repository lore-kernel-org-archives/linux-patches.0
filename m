Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0A030B53F;
	Thu,  2 Jul 2026 16:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010068; cv=none; b=tBgyTMvygXqfyQnMk8vp2mvyowKehsg46+eTG08uBzkA7Yu+OJmXPiceWUhrdtbpO4LKW3RrtjtJnkTeyUlY3+95H0wnyNeD9Jv16aYB6KytuR659G2MtZ7jScz4Rl1G/ZyWOv09FiTe/dIvQMet+XkHobpXXlrLrmj1+lBt19o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010068; c=relaxed/simple;
	bh=YCH1QZplEMbeViJ/udIKZXDqy/Qc5y6beF9L8D4wBkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mK1/slIxkyVC++o4DsAMfI9MU9NhZYP0fGgKcWU4Gp8ADwdCCKqCMypxOPqxsUhn+IwXm/z7Py7wip+0+PnCrYDl/gqkY4b+ildvbSYPS/TvM36+SH4Hh45fCYnMpyCsK2bz4LjAqV7xBaiM2ok3Qbt7D8vR7KflAxCdtUYsSUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udw7FHyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udw7FHyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9B01F000E9;
	Thu,  2 Jul 2026 16:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010067;
	bh=3RA8Mk8XPSBVP20hsrI1/q3TispE8fQE+6/7XjiGt74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udw7FHyTQxpQlPgisitE1uK0H7zH6qXmyyiG39bXMk3ilRHukpgksou3kb6LNgLQ2
	 ni5FQCGEnJTY9NJs85irQ0TfdjzDpYRfUwyIzSWE02BVQYK1XzhLjCdRPgtPP1BPvB
	 o5gOazfWBljkwb1wba1HXLGhScH9zRQbC8YbG6E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/129] batman-adv: ensure bcast is writable before modifying TTL
Date: Thu,  2 Jul 2026 18:19:40 +0200
Message-ID: <20260702155113.406610847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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
index 83f31494ea4d92..0709f42c54b496 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1199,6 +1199,12 @@ int batadv_recv_bcast_packet(struct sk_buff *skb,
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



