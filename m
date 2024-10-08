Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC3C1DE88F;
	Tue,  8 Oct 2024 13:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393111; cv=none; b=TL7v9F/cHcmkj+YBzGIPPC4TOgg0AyKTHOGX1UuGrmfjXxkUBtjBRBdEdNHVSuqPxZE/cIlTRnnwPqi9GryXIuG+TYUoPkaxpB+POIEXbgY/EXWLFYjUrxRDOi8wTwT7dPBc7wwBfCY1Ak/Fc63QRmm+6XxfyGw0Xr9hPjJuri4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393111; c=relaxed/simple;
	bh=U8rfSdoAnLF2g1JZCL0pgFCDxLH8Hph5wxz2NU86MoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed/ni2FthMniQ1HW+P7nUTn5hJz42grlLm+yvifo6B/D9n1g1BCJrb5eabGzYP1C2iRL4Q7dSVosRaisNabjHK14lacnsXY1auup/nptRvtUXfLRsa6muVB7vA9u2v9yHDp/hG8EfBSyVUp3ExOKsV60ftU64RHRmeoFNCXcBnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=St9+840d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="St9+840d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B47EC4CEC7;
	Tue,  8 Oct 2024 13:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393110;
	bh=U8rfSdoAnLF2g1JZCL0pgFCDxLH8Hph5wxz2NU86MoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=St9+840dfr5ubb7EziE+QwAs3SFBZtiaOO6Xc/MObXWmH+EBLHBQKD5jewzEKvJcY
	 QEJkvVL/P/1ameqXJtZk38tZLqYVXi/VscoOBKHoLPAKj9hNC3xqIp3ZOFVGHMIeUj
	 IRFr3DUmq+2Z/UAdANPG/QSOWZKDc897U+i1DT28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/386] net: Add netif_get_gro_max_size helper for GRO
Date: Tue,  8 Oct 2024 14:04:30 +0200
Message-ID: <20241008115630.468029453@linuxfoundation.org>
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
index b8e60a20416ba..e4f02e638b9d9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5029,6 +5029,15 @@ void netif_set_tso_max_segs(struct net_device *dev, unsigned int segs);
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
index 31e40f25fdf10..85d3f686ba539 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -100,7 +100,6 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	unsigned int headlen = skb_headlen(skb);
 	unsigned int len = skb_gro_len(skb);
 	unsigned int delta_truesize;
-	unsigned int gro_max_size;
 	unsigned int new_truesize;
 	struct sk_buff *lp;
 	int segs;
@@ -114,12 +113,8 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
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



