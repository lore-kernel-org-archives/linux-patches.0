Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EBF1DE2C4;
	Tue,  8 Oct 2024 12:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389574; cv=none; b=gUXuBti3I4kI5yEffA4mP/QmY9frilQhPP52BEW9sNnU+seZftEBfPc/pZHnusBi68I+5VX8D9Gofkgr2zBOha2kCaLo1WyHteXME7Cx1bgcJoU/vC1535QPq/Lh2t9Zsfb+WUDfDzLhJJdZpEsyrr8wWUbfvR3YgQ8MjQ+au88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389574; c=relaxed/simple;
	bh=0Suqf0+K+TmsSk6wr04Oo2ehgvyLTey7pd5VwwFYAuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOj7yOMpv04Fp6aZEwWUH+ksGTzrE72PCacJG/R0E4YEn7M1+aZ/ZctHN6Vp969zBz2k/fhk3r3iKJxT1KgPvTGOJBFKx2TAcatdEm+vZxkuPohnPEiTYIccsMQjVX7wPw16ibEDd7dc6ecblLGH92bbmbhChr4DE0Oto0XOSTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gI0mpK4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gI0mpK4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC44C4CEC7;
	Tue,  8 Oct 2024 12:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389574;
	bh=0Suqf0+K+TmsSk6wr04Oo2ehgvyLTey7pd5VwwFYAuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gI0mpK4INP2VujGZ2yOI5zMDn9NiNnyGLg29hy0ZIhX9pVPSANZixMmK8LuIUnRdz
	 2IisC6WnzQyLydlQzLhTn9Vv7VpBarC0IIsV+yD4aRa8012AKOWBLZJwv7tpYE7ByB
	 TLUOiYvAK8f+XkV4FExzc4xZ3vHbHaTi6l7LpUMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 034/482] net: Add netif_get_gro_max_size helper for GRO
Date: Tue,  8 Oct 2024 14:01:37 +0200
Message-ID: <20241008115649.641824359@linuxfoundation.org>
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

[ Upstream commit e8d4d34df715133c319fabcf63fdec684be75ff8 ]

Add a small netif_get_gro_max_size() helper which returns the maximum IPv4
or IPv6 GRO size of the netdevice.

We later add a netif_get_gso_max_size() equivalent as well for GSO, so that
these helpers can be used consistently instead of open-coded checks.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240923212242.15669-1-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: e609c959a939 ("net: Fix gso_features_check to check for both dev->gso_{ipv4_,}max_size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 9 +++++++++
 net/core/gro.c            | 9 ++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d20c6c99eb887..84a445ca4749a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5000,6 +5000,15 @@ void netif_set_tso_max_segs(struct net_device *dev, unsigned int segs);
 void netif_inherit_tso_max(struct net_device *to,
 			   const struct net_device *from);
 
+static inline unsigned int
+netif_get_gro_max_size(const struct net_device *dev, const struct sk_buff *skb)
+{
+	/* pairs with WRITE_ONCE() in netif_set_gro(_ipv4)_max_size() */
+	return skb->protocol == htons(ETH_P_IPV6) ?
+	       READ_ONCE(dev->gro_max_size) :
+	       READ_ONCE(dev->gro_ipv4_max_size);
+}
+
 static inline bool netif_is_macsec(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_MACSEC;
diff --git a/net/core/gro.c b/net/core/gro.c
index b3b43de1a6502..87708483a5f46 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -98,7 +98,6 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	unsigned int headlen = skb_headlen(skb);
 	unsigned int len = skb_gro_len(skb);
 	unsigned int delta_truesize;
-	unsigned int gro_max_size;
 	unsigned int new_truesize;
 	struct sk_buff *lp;
 	int segs;
@@ -112,12 +111,8 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	if (p->pp_recycle != skb->pp_recycle)
 		return -ETOOMANYREFS;
 
-	/* pairs with WRITE_ONCE() in netif_set_gro(_ipv4)_max_size() */
-	gro_max_size = p->protocol == htons(ETH_P_IPV6) ?
-			READ_ONCE(p->dev->gro_max_size) :
-			READ_ONCE(p->dev->gro_ipv4_max_size);
-
-	if (unlikely(p->len + len >= gro_max_size || NAPI_GRO_CB(skb)->flush))
+	if (unlikely(p->len + len >= netif_get_gro_max_size(p->dev, p) ||
+		     NAPI_GRO_CB(skb)->flush))
 		return -E2BIG;
 
 	if (unlikely(p->len + len >= GRO_LEGACY_MAX_SIZE)) {
-- 
2.43.0



