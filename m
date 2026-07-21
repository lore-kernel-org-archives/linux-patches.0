Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAA1136351;
	Tue, 21 Jul 2026 20:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665809; cv=none; b=c9zZif19M92WoTpe3MaIJLmVoBSohL/Z7L46NwjJ2fRrHy1EaoBMlmu8dgpiZuF0FA7wkvGM345WFwTrqnggT5JRxRXd+eZFdQPvdTgBhUGpGfbfiNd7+bvUqoNqflebS4Cf60A4HC38TDlg1R4Yfl6/0hsUcjQiZcYY7RpakUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665809; c=relaxed/simple;
	bh=KDwFOINa++G+LV7sMUHwdgYmnt5FS0qLgW49eX0y0sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eso2NBJ2b/egp3d4bEBVRHJiah+D3EQDAYl/X7E0fk6gbga8m2+65/oUqHEsO0qcAN9vya3AKsHbvY7AE/bsoUenDCOR8ciPMcQBAMCGWTqpb2MGokC6pLrlRsgOICzhIHf9aHXTgwV/c6S0HTYtxAG2tW2MyzQbFGNolcKs8cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrWXfKgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrWXfKgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE551F000E9;
	Tue, 21 Jul 2026 20:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665808;
	bh=H4Utr2rsIJx8ZxMriHZpx2HR/5oKVYi/47XJ+nloSmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrWXfKglv3UmCqu+qLQkf9+ycPLHYSEWVAOCK8UgHZgrO4ivNuLM999W1Igp72kl1
	 cUcriTF+7Xf4G2EPg+Zv//g/sqZhiAg04Ef0407kQIPnPJr56VVbz8/Ks9WZuPyO4t
	 Fqw5jERsPXpy+I8FLeBbg3rx+C2vAjafovne44o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0443/1266] ipv6: guard against possible NULL deref in __in6_dev_stats_get()
Date: Tue, 21 Jul 2026 17:14:40 +0200
Message-ID: <20260721152451.751792949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index facb7a469efad6..e596f57f680dc1 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -334,8 +334,11 @@ static inline struct inet6_dev *__in6_dev_get(const struct net_device *dev)
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



