Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A2F19E96D;
	Wed,  4 Feb 2026 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219084; cv=none; b=Ffko4izOK4lEzM9m6d2i/ad9moKKlT/SfJk3FD+HpFSQn0b7BPbdgGL3SiRggAaAZRp3V2jd6Ktzb9TVPNP7For7uAHgvJ1HORPKvhvwJyRnw7ojkBvq0/fUfL7qVfayZdNHdFLKtS8A9T/0akkwLLL4PczgnfVX++Wo8TAI7Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219084; c=relaxed/simple;
	bh=Ka343KXpa7rYpr6s1g0Egi9dZzJnDSDGZBOk9EKEBDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmGhJ9bYdntbXUbDNepQ8DC3SGCJdRLW1RKA+cs97G0vRhBj8NnvwTqCXjbRS19pVOOCvYUM2rX+0iNf3u8yXap/Lq9ndmeSJFEegR6A04XvSbEOq2pEX+rHgQqw6vuiR+O1SC27TqxvxrFxFCm9ehv/An+Igs2bt5mPvsDEUUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u55SCBaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u55SCBaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E0AC4CEF7;
	Wed,  4 Feb 2026 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219084;
	bh=Ka343KXpa7rYpr6s1g0Egi9dZzJnDSDGZBOk9EKEBDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u55SCBaXiojLXbcsaFkxtpo0Jl8k5m6KhK0nvQoSpfVtHCfOJGGHyRnuWVKCaNax4
	 icHYCgosVt/chQGYfWnnmNthdPGUsCd8mbZp1uD+0J8BPW8/pc/7UgTcJwXKujc2Vj
	 1pEQY9bqPYqCNAknZ4hvVRt8vEW2lR7z/khZrjgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/122] net/mlx5e: dont assume psp tx skbs are ipv6 csum handling
Date: Wed,  4 Feb 2026 15:40:11 +0100
Message-ID: <20260204143852.911167001@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit a62f7d62d2b115e67c7224e36ace4ef12a9650b4 ]

mlx5e_psp_handle_tx_skb() assumes skbs are ipv6 when doing a partial
TCP checksum with tso. Make correctly mlx5e_psp_handle_tx_skb() handle
ipv4 packets.

Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Link: https://patch.msgid.link/20260126-dzahka-fix-tx-csum-partial-v2-1-0a905590ea5f@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/psp_rxtx.c      | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
index 828bff1137aff..fa98d0074531b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
@@ -177,8 +177,6 @@ bool mlx5e_psp_handle_tx_skb(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct net *net = sock_net(skb->sk);
-	const struct ipv6hdr *ip6;
-	struct tcphdr *th;
 
 	if (!mlx5e_psp_set_state(priv, skb, psp_st))
 		return true;
@@ -189,11 +187,18 @@ bool mlx5e_psp_handle_tx_skb(struct net_device *netdev,
 		return false;
 	}
 	if (skb_is_gso(skb)) {
-		ip6 = ipv6_hdr(skb);
-		th = inner_tcp_hdr(skb);
+		int len = skb_shinfo(skb)->gso_size + inner_tcp_hdrlen(skb);
+		struct tcphdr *th = inner_tcp_hdr(skb);
 
-		th->check = ~tcp_v6_check(skb_shinfo(skb)->gso_size + inner_tcp_hdrlen(skb), &ip6->saddr,
-					  &ip6->daddr, 0);
+		if (skb->protocol == htons(ETH_P_IP)) {
+			const struct iphdr *ip = ip_hdr(skb);
+
+			th->check = ~tcp_v4_check(len, ip->saddr, ip->daddr, 0);
+		} else {
+			const struct ipv6hdr *ip6 = ipv6_hdr(skb);
+
+			th->check = ~tcp_v6_check(len, &ip6->saddr, &ip6->daddr, 0);
+		}
 	}
 
 	return true;
-- 
2.51.0



