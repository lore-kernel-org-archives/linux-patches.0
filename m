Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C031DF25E;
	Tue,  8 Oct 2024 13:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393114; cv=none; b=C9Ycg0MqXh764Yzg++Sc+RNIEnB7JDwRSvL0mhIeMTpKZR/ZmDWKaDeCXYoHuEma9JKv7FjozzntnjVDj3wHwJ91hRCSeKIfzYD3vDDkLQ2tCiy/fBwBIKbK3D04FVJTiHZYAf2lqLlwfDxKznUe4ORieUZxBcq6se7LW17hdxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393114; c=relaxed/simple;
	bh=xMTNw4YxaV7b7HUFNHai1pikViQxj7RzBh5qfb9+yug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heNjwp5K84G1M2eNXMmaXYcFPBqHZ9IeekXMuqDFeUdNfQ1Ap4HBMJiJ7yG4vrfo+aoOVapsBMuIW5F8wXkSVuH4/0v87j9aEbftw6oGfOftZaxgg+hhCHXlfPvkoKt7c9uDXBEVPl3jkUzF/cN7S9NTIM7S5fwbSB5rIRp3bQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUpKXyIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUpKXyIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838F4C4CECC;
	Tue,  8 Oct 2024 13:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393114;
	bh=xMTNw4YxaV7b7HUFNHai1pikViQxj7RzBh5qfb9+yug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUpKXyIwREO8aY7+6MhHSpPu7Gaz3HsHnjsAZlUobpPb/H/JjSo+xc+U5cBOmJ5zL
	 j3attpC5s2XqzY3WwIw6Tib7pTvInkLSAUyp5Yi10u0UHwQ3bJkcLIBKdr8qLnn1q/
	 qF8SiGY8ZI/2a4RfkarbXr+QiArQB46jgafv8OtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/386] net: Fix gso_features_check to check for both dev->gso_{ipv4_,}max_size
Date: Tue,  8 Oct 2024 14:04:31 +0200
Message-ID: <20241008115630.507100530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e4f02e638b9d9..8f5ac20b4c03d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5038,6 +5038,15 @@ netif_get_gro_max_size(const struct net_device *dev, const struct sk_buff *skb)
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
index 5a5bd339f11eb..decfa7cbba50a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3500,7 +3500,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	if (gso_segs > READ_ONCE(dev->gso_max_segs))
 		return features & ~NETIF_F_GSO_MASK;
 
-	if (unlikely(skb->len >= READ_ONCE(dev->gso_max_size)))
+	if (unlikely(skb->len >= netif_get_gso_max_size(dev, skb)))
 		return features & ~NETIF_F_GSO_MASK;
 
 	if (!skb_shinfo(skb)->gso_type) {
-- 
2.43.0



