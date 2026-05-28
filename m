Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F744330D35;
	Thu, 28 May 2026 20:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000409; cv=none; b=H5ASY6gqlU4TN5x2TS32zP5+ig9CxiU+BFQxNU7rBSQpHr1NP/Rfx2Lgvhj3C6+WuHKO+NemQzhg2ghUmgM9vntuItbKahcfw6EEw9GRrIjVN8YXVxoHg98uhlKQHBONOEXhkTGmBQlR0ams4AXEtysa+Bam2IemrG35cZSk+aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000409; c=relaxed/simple;
	bh=zssesHPdSqexwjspS1VpgxQ5kQXoJp7I2wGnVPDNTYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrMjX9H8g6tfNkhqQ235Xnhzp3xFplkHjzM1scPAPQKxQsJ5JGCZdoZQWKzBEsjkp8Sw4JVm7bgSU1Tknp5PQ3ZAx2575cIep3SZYYKwEt07Q8eMhmP3UEqNoxa3WA4ubzTu74ny69pE0W1xugUT4trPp0gQ1zvuuWqrX2dnV/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oD6KJszi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oD6KJszi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1DA1F000E9;
	Thu, 28 May 2026 20:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000407;
	bh=jHrsLjkPi3At+KYRZTVVCx0tb1aOeW7KJWJlfPYzaRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oD6KJszixZrzNzuD640UPjTNtiGlj6/4410f3kzYfbnJPTyc9pzffklFBovR/n7+k
	 n2zhIdFFSrtIDAM1AteXkYzOVxUBvJ5eZkDmZupm4WHm3B3YHLgk3fd8HHq9WZKXos
	 XlbwAI33mtEWKzbMFhtT5cU65sfpUD7OY8ftrsRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/272] net/mlx5e: Use ip6_dst_lookup instead of ipv6_dst_lookup_flow for MAC init
Date: Thu, 28 May 2026 21:46:48 +0200
Message-ID: <20260528194630.342805089@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

commit e35d7da8dd9e55b37c3e8ab548f6793af0c2ab49 upstream.

Replace ipv6_stub->ipv6_dst_lookup_flow() with ip6_dst_lookup() in
mlx5e_ipsec_init_macs() since IPsec transformations are not needed
during Security Association setup - only basic routing information is
required for nexthop MAC address resolution.

This resolves an issue where XfrmOutNoStates error counter would be
incremented when xfrm policy is configured before xfrm state, as the
IPsec-aware routing function would attempt policy checks during SA
initialization.

Fixes: 71670f766b8f ("net/mlx5e: Support routed networks during IPsec MACs initialization")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1765284977-1363052-7-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index e2915d3143e6b..c1b6893389fdf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -348,9 +348,8 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 		rt_dst_entry = &rt->dst;
 		break;
 	case AF_INET6:
-		rt_dst_entry = ipv6_stub->ipv6_dst_lookup_flow(
-			dev_net(netdev), NULL, &fl6, NULL);
-		if (IS_ERR(rt_dst_entry))
+		if (!IS_ENABLED(CONFIG_IPV6) ||
+		    ip6_dst_lookup(dev_net(netdev), NULL, &rt_dst_entry, &fl6))
 			goto neigh;
 		break;
 	default:
-- 
2.53.0



