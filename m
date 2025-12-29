Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A190233123A;
	Mon, 29 Dec 2025 16:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025205; cv=none; b=sG5W9mJsEER1B5RgKtgpMselWInoDfZIRs7kOs+QPnwYU0MmdXD8tMe8ZAJIh7BJQi+lXTGBsEq52sTy3dm3Tkeu+SzQqqScuSnQBwUHKKhLkIfZro0sYFr6Uu0vw6PEKXJHlT044i5GD/q+eg1rSebm9ByYCTe8sd5L82MlPZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025205; c=relaxed/simple;
	bh=2jnPQxBmmRCLHslNiTp1LrWneVJhK6b1j6gT4kxXFeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pputmbuaHAIBH/qmtyz82gJAp3TOxrJfbJQuYGlbLYMU8QronJ/tQ0Sjb6LHsUsLLw2YTqEVQuvIX/NqwYgiLjO+rvrII8HoVwLid3euWY/TvTjh5VoOvbpWlikCB3efIrWmgHdyFLZhyYVTLrVPSr8sbdXCSeEbAeUb0PNOWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpd4aSVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpd4aSVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2590CC4CEF7;
	Mon, 29 Dec 2025 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025205;
	bh=2jnPQxBmmRCLHslNiTp1LrWneVJhK6b1j6gT4kxXFeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpd4aSVlPMCM5WYT8V2lFhSFIjKnx7oPQheVQDa2QT12bBUfRFXeCCp4pPLlzmeH0
	 xt8vz/My6yrzNXwsdm+C/MhkuaKE5fJ6558oZmcBB0qVeH+FliNLt1LD2S+8/R9o6p
	 5tpgwdtXg/j4N2hMNb5nB2VOJpcWOao6f4RlmqCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/430] net/mlx5e: Trigger neighbor resolution for unresolved destinations
Date: Mon, 29 Dec 2025 17:08:20 +0100
Message-ID: <20251229160727.970697822@linuxfoundation.org>
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

[ Upstream commit 9ab89bde13e5251e1d0507e1cc426edcdfe19142 ]

When initializing the MAC addresses for an outbound IPsec packet offload
rule in mlx5e_ipsec_init_macs, the call to dst_neigh_lookup is used to
find the next-hop neighbor (typically the gateway in tunnel mode).
This call might create a new neighbor entry if one doesn't already
exist. This newly created entry starts in the INCOMPLETE state, as the
kernel hasn't yet sent an ARP or NDISC probe to resolve the MAC
address. In this case, neigh_ha_snapshot will correctly return an
all-zero MAC address.

IPsec packet offload requires the actual next-hop MAC address to
program the rule correctly. If the neighbor state is INCOMPLETE when
the rule is created, the hardware rule is programmed with an all-zero
destination MAC address. Packets sent using this rule will be
subsequently dropped by the receiving network infrastructure or host.

This patch adds a check specifically for the outbound offload path. If
neigh_ha_snapshot returns an all-zero MAC address, it proactively
calls neigh_event_send(n, NULL). This ensures the kernel immediately
sends the initial ARP or NDISC probe if one isn't already pending,
accelerating the resolution process. This helps prevent the hardware
rule from being programmed with an invalid MAC address and avoids
packet drops due to unresolved neighbors.

Fixes: 71670f766b8f ("net/mlx5e: Support routed networks during IPsec MACs initialization")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1765284977-1363052-8-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 6c79b9cea2efb..a8fb4bec369cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -358,6 +358,9 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 
 	neigh_ha_snapshot(addr, n, netdev);
 	ether_addr_copy(dst, addr);
+	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT &&
+	    is_zero_ether_addr(addr))
+		neigh_event_send(n, NULL);
 	dst_release(rt_dst_entry);
 	neigh_release(n);
 	return;
-- 
2.51.0



