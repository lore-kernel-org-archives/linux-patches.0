Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C2E1DDA24;
	Tue,  8 Oct 2024 12:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389578; cv=none; b=mQ3lrzeU0U9cLDX44zGH7qjY0t9VKEhH59RRexlNSLu6O55OqL/4AfP5ZBJG8IPqzJdrHzJlv5VefhqtWlBjUY0VtPKKyJzodWC8Lx9P6mLzKNYtUZgNRK3QrA5jgBpt5E6688T+qJoy9NZIlMrmVFk1E7LwD4UiUnnab3/eJCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389578; c=relaxed/simple;
	bh=05lbY+7BvHRpDhWkTfGOZRzPijxc0dZuXIqzJh5xCdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViBX7AG+H0cwjj9ytx1ASX1e83MQJrkpafiOLrB2NVgf1M3K1uMZxeM5VIdFj4u7Yhg3pbvZvBuBi9UlXlPvKZkhVEzS2D1MEzYdvY7BLL9ry9KOl1zB6PN3VRlC88TpPCzoQfS+6rqjHM29VIVrHs15pSdQLDzOa3LsmNRrkE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2s4bJ8sP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2s4bJ8sP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E14FC4CEC7;
	Tue,  8 Oct 2024 12:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389577;
	bh=05lbY+7BvHRpDhWkTfGOZRzPijxc0dZuXIqzJh5xCdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2s4bJ8sPIT+2CjmUVmnOaG4n6PX4oRzFhCWCJalFnI/tgVqItKI38sathHALT0LUC
	 sFhzFS6qkuPi9RiMSK9ahEQeeBVyAclT4MbI/Ev7uInsgH0d2zzutD7cmYidqdj8e+
	 MpQHLPa8hU2Szam83wXCMAxozyGVKDwsJztVBsZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 035/482] net: Fix gso_features_check to check for both dev->gso_{ipv4_,}max_size
Date: Tue,  8 Oct 2024 14:01:38 +0200
Message-ID: <20241008115649.681918689@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e609c959a939660c7519895f853dfa5624c6827a ]

Commit 24ab059d2ebd ("net: check dev->gso_max_size in gso_features_check()")
added a dev->gso_max_size test to gso_features_check() in order to fall
back to GSO when needed.

This was added as it was noticed that some drivers could misbehave if TSO
packets get too big. However, the check doesn't respect dev->gso_ipv4_max_size
limit. For instance, a device could be configured with BIG TCP for IPv4,
but not IPv6.

Therefore, add a netif_get_gso_max_size() equivalent to netif_get_gro_max_size()
and use the helper to respect both limits before falling back to GSO engine.

Fixes: 24ab059d2ebd ("net: check dev->gso_max_size in gso_features_check()")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240923212242.15669-2-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 9 +++++++++
 net/core/dev.c            | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 84a445ca4749a..238aaed5d7236 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5009,6 +5009,15 @@ netif_get_gro_max_size(const struct net_device *dev, const struct sk_buff *skb)
 	       READ_ONCE(dev->gro_ipv4_max_size);
 }
 
+static inline unsigned int
+netif_get_gso_max_size(const struct net_device *dev, const struct sk_buff *skb)
+{
+	/* pairs with WRITE_ONCE() in netif_set_gso(_ipv4)_max_size() */
+	return skb->protocol == htons(ETH_P_IPV6) ?
+	       READ_ONCE(dev->gso_max_size) :
+	       READ_ONCE(dev->gso_ipv4_max_size);
+}
+
 static inline bool netif_is_macsec(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_MACSEC;
diff --git a/net/core/dev.c b/net/core/dev.c
index 2b4819b610b8a..d7380a6ecfabb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3502,7 +3502,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	if (gso_segs > READ_ONCE(dev->gso_max_segs))
 		return features & ~NETIF_F_GSO_MASK;
 
-	if (unlikely(skb->len >= READ_ONCE(dev->gso_max_size)))
+	if (unlikely(skb->len >= netif_get_gso_max_size(dev, skb)))
 		return features & ~NETIF_F_GSO_MASK;
 
 	if (!skb_shinfo(skb)->gso_type) {
-- 
2.43.0



