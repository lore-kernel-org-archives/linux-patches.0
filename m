Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E627349B1C;
	Thu,  2 Jul 2026 16:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010956; cv=none; b=KCJCYmpHwTZFUD3/WQbUG8ukD4zG/KAPY3lEaZEj66n7IeoaEof+uCQqq2So5xmbip6YJMTpnjRYt4WLoPd2QEt/rr5yoSqD2mxEzjUV+jKOQBmbWFA+psjuDAtBSao03yBYD/M/rzl2+8meMmpQI/5xgjydnIlsmDqjzR6824w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010956; c=relaxed/simple;
	bh=8Ces0H+qmk3PgmQegNyVwl2i8UQ/lTh3V4hEn/ACFlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHsU5UO9/Zi1GZ7eGashrY8BuyJol5sypiGiyI/Skz5SsJcL/YIytKvtQUksgkmSfNhuyUf/KlmllOGVvg9kVtxvytdurXQXx+qRo6XE4cwYmj0yJQqYcMVefS0qB30gnlz2uy6wwIbEpg3iRzS28r5jVZdixzfm3iW9zy6/GZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVXGOg95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVXGOg95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A417C1F000E9;
	Thu,  2 Jul 2026 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010955;
	bh=McmlWikbX9E+QO3lVtc4tdSNxdORvJYy6WB0VBZCD8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVXGOg95YjNDgUbxxh3zwi9GZmOjZwvhdEUKq80SOTo6Uq2/Uf7JmqzK4OSJ7o6G/
	 Z1TJfPDT6JZfK9S+nllb5JlqkB3vvzy1dKLgBO/Y8WTW4AgkbTqvp5VGjcnXCFF+fV
	 zhWS/PfgwN96sA4YFDNrJY1xQp2seUVnSghVMYU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/175] batman-adv: ensure bcast is writable before modifying TTL
Date: Thu,  2 Jul 2026 18:20:03 +0200
Message-ID: <20260702155117.917382352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 163cd43c4821b6..747c3ff1c253b0 100644
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



