Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FEF26FD9B;
	Mon, 29 Dec 2025 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025203; cv=none; b=XTcgbf5UgFDQ9xt+nLAG2wXDee56vUbywGXYaVS6FSgO308Whx71o92i5LbT4e2WmzUMFAPZpjkUDlok8rN4KJH576nv1gOJ1fxNZwWS+zoKy0ulGXuESjvYzDeEqsFMXds+DTytZ5GxsK4nNqn2td4gy3tFMfadRXTyVAMeItg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025203; c=relaxed/simple;
	bh=qfWTQseO8pTETxvqM3j5zXImKPYm8HDZRNx9qMaaRSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUwBKppJ5kAxX2iZnNBOYMhMfiYeFjJ59/MFky3FuewWvyJEho9mEB0s4gbKX0VgYzBL7jlBOvbhsGKN9el7AKZz7KCMxSX82w9W/sOxKUB+qSQPtY4jPK8qkFdDUyfgQU3NMk/s+XLCTlzfTSvaARP62B9I81ZsoJy2ixrf5pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgt0qlg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgt0qlg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF12C4CEF7;
	Mon, 29 Dec 2025 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025202;
	bh=qfWTQseO8pTETxvqM3j5zXImKPYm8HDZRNx9qMaaRSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgt0qlg6I8W4id+iEy9GEU84UqtM2QSWRR0aw49y5oOvTgcQXBW72EnBmPBkaGTX7
	 TQisGXfW6V3rgKSLpnJ/gdksWDLL57Fz7sq99rIVzyjlYuVa5GtTTXG58kL+84XQ27
	 YEbTnPDjTxrRTDyhEAOtUiq6hl77fr7DKyUMmRGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/430] net/mlx5e: Use ip6_dst_lookup instead of ipv6_dst_lookup_flow for MAC init
Date: Mon, 29 Dec 2025 17:08:19 +0100
Message-ID: <20251229160727.933288842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit e35d7da8dd9e55b37c3e8ab548f6793af0c2ab49 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 35d9530037a65..6c79b9cea2efb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -342,9 +342,8 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
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
2.51.0



