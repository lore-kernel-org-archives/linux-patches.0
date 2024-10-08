Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBBA1DEFEA;
	Tue,  8 Oct 2024 12:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391296; cv=none; b=BGU1v4PNCDkWDS95BpLgxzZp1mGXD/TsMFo9tLS/lI3p9F1B4GVZ+jMHgJcuUZYqSSi1yiKyLUJJfnwzpNqk+GDVdcTRs4A7HJaeYhmt5B8fYawtA4Ob3CYdJTX55aL1TIXICGHDwgCuREwSQSIT8Ab2E2BwYGp46b4zIQN3/fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391296; c=relaxed/simple;
	bh=czDl1iIxdBBDRRxRiZIE8TQAuuPxjP9pSELDOKzAqLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ny05h++qU2REV7m4EX4cDgWWDomeKVgdIWxKEcnlJTS7Vn7vRX4iAYnYq5Tl4NBDKELA7DdX7ntrRAcLB+uW3P2nY4hgXV0r/JkvxjenF0GKTQ+G3FrXyB7+iW7a21VWILFIh7slttaqSnEH9aN+CHsLtmFht/JmEfx8icloMSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNQ615xt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNQ615xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CA2C4CEC7;
	Tue,  8 Oct 2024 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391296;
	bh=czDl1iIxdBBDRRxRiZIE8TQAuuPxjP9pSELDOKzAqLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNQ615xtGoR9iRofzGlw4zGnmB6yqd+QodBRt3h8Z2x9Buy/l22vASi45ZhUaZkPb
	 20nCDgpTsiOCx60NUNDTZcTe4jYw7n1EIGQRbzNdQdPJmoyTL69385xsRUWRAG1+Id
	 yNXNbFz9NN7o3hR7JOM6x+tWCMDwduim7Y2YtG18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 038/558] net: Fix gso_features_check to check for both dev->gso_{ipv4_,}max_size
Date: Tue,  8 Oct 2024 14:01:08 +0200
Message-ID: <20241008115703.721796911@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 23d90c7e915f0..59fb3cb8538fd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5035,6 +5035,15 @@ netif_get_gro_max_size(const struct net_device *dev, const struct sk_buff *skb)
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
index f66e614078832..03fb8ae459c0e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3504,7 +3504,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	if (gso_segs > READ_ONCE(dev->gso_max_segs))
 		return features & ~NETIF_F_GSO_MASK;
 
-	if (unlikely(skb->len >= READ_ONCE(dev->gso_max_size)))
+	if (unlikely(skb->len >= netif_get_gso_max_size(dev, skb)))
 		return features & ~NETIF_F_GSO_MASK;
 
 	if (!skb_shinfo(skb)->gso_type) {
-- 
2.43.0



