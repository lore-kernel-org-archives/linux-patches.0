Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D83E35C682;
	Tue, 21 Jul 2026 22:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671591; cv=none; b=ZcKyhL2vjqG149p+YN1QcMUFw4Lrif2VKZTRRGuizYdAgEVWrnNtmsAuiCOGO6ChBlVSSxoWPUO0CnOJwIlBCzF6vPPixPTWQl/YA6fyk5I0/BoD384of1yRhuC59r6o4lrfSXggKr4erI6wB3p4b4tJegS5B1o1gmilnDq1rgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671591; c=relaxed/simple;
	bh=PR3nBNTgdsqayAf3kbIJ0Qg5HZsjlTjBMT1xfptyS6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIsYEAOW5si7dYXxHDKTwaH1ikb2NlcAMz3rYWwEnJ/oWEQ4OfkWGZIphaJZAciwwnfhOl7SZZ6zQoNaYzetaZBO6BjDX/+zLZ5iIeS8UWQMOo7yAdAZZPYezAevpGO5AL3s/yUcf8yMXHv6ndDuyMKtXu05HUr2ZLBlOU5TpOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GC927WB9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GC927WB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941E41F000E9;
	Tue, 21 Jul 2026 22:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671590;
	bh=8cySC0frBvlUtQRs0EIfWbtfdXiJ+9KNWskIABfg8B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GC927WB9f2bAE3uwTxs/dwA09767p2QhquH9ymdemVX8O9xaIVxLELg6LDitvQb7t
	 W+E+VZrWpx2kdtovtxP5GkTH4YHBeePTuG1kxZeodQIHoqNEk9d5I/HD1+7+YrN7XR
	 tG96fremaE5kWUIPJ01aiPDocxT96M5PdE9Ge/cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/843] ipv6: guard against possible NULL deref in __in6_dev_stats_get()
Date: Tue, 21 Jul 2026 17:18:22 +0200
Message-ID: <20260721152412.028744220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

[ Upstream commit 507541c2a8eeb76c02bd2511958f73a8cfa3e1bc ]

dev_get_by_index_rcu() could return NULL if the original physical
device is unregistered.

Found by Sashiko.

Fixes: e1ae5c2ea478 ("vrf: Increment Icmp6InMsgs on the original netdev")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260526145529.3587126-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/addrconf.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 5cf1a73774078a..39da955b0326f7 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -332,8 +332,11 @@ static inline struct inet6_dev *__in6_dev_get(const struct net_device *dev)
 static inline struct inet6_dev *__in6_dev_stats_get(const struct net_device *dev,
 						    const struct sk_buff *skb)
 {
-	if (netif_is_l3_master(dev))
+	if (netif_is_l3_master(dev)) {
 		dev = dev_get_by_index_rcu(dev_net(dev), inet6_iif(skb));
+		if (!dev)
+			return NULL;
+	}
 	return __in6_dev_get(dev);
 }
 
-- 
2.53.0



