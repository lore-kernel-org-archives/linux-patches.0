Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F753264FA0;
	Tue,  8 Apr 2025 11:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110895; cv=none; b=X9G9kEEOBPSq8XWq/hxaZpVScMpx2yQHZHYdSxIvliNfHplqjwlKFWz5EBeGHhgHoYy9gtbgIM7vMKojOP9YBlOlllgcJPC48EdOpWoMcIxrH3LCOoS+KG4SmqeMa0zNCKD5CCRz7x52pRxaHLXZJkp+w3wP4w4PGp9l0aqYHt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110895; c=relaxed/simple;
	bh=xjWNz6U+D37hAkKGkxk1TGD4d8QXLWqes+fTnr6lNfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFYxrD/OppdB3l8IV5Qdl7owfTxuJuBkxGOHBYQE4XQGTc8fIPZ7T/p/BTyszgqgpxHJHovLmDXSoBL4u5v+4HFiR3XR4847Tz3ZoBoSqzX29juaEv8lvv4aiakcj4HEV8OfxtFAbudMAYWtrkljqb7+fzpgQKdWUrTJuxL4gzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEKiMPZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEKiMPZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94067C4CEE5;
	Tue,  8 Apr 2025 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110894;
	bh=xjWNz6U+D37hAkKGkxk1TGD4d8QXLWqes+fTnr6lNfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEKiMPZkUnGvutCNhetjSm9Yc4IpCTSF9CzeYBuLcM9qBc0zP/IQAUz8NzPQmOdqn
	 47816qFOJrFLjHhNs3v93Kd7TR3AxwpCvaE6T4/9XIs+ZADP7plIo1NmC+HcFY8JJ7
	 IpF8bAO7SlyZHmlnLk7ekpK46zyXh74TOistcrVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxim@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Joe Damato <jdamato@fastly.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 234/731] net/mlx5e: Fix ethtool -N flow-type ip4 to RSS context
Date: Tue,  8 Apr 2025 12:42:11 +0200
Message-ID: <20250408104919.724183750@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit 3865bec60683b86d39a5d8d6c34a1d269adaa84c ]

There commands can be used to add an RSS context and steer some traffic
into it:

    # ethtool -X eth0 context new
    New RSS context is 1
    # ethtool -N eth0 flow-type ip4 dst-ip 1.1.1.1 context 1
    Added rule with ID 1023

However, the second command fails with EINVAL on mlx5e:

    # ethtool -N eth0 flow-type ip4 dst-ip 1.1.1.1 context 1
    rmgr: Cannot insert RX class rule: Invalid argument
    Cannot insert classification rule

It happens when flow_get_tirn calls flow_type_to_traffic_type with
flow_type = IP_USER_FLOW or IPV6_USER_FLOW. That function only handles
IPV4_FLOW and IPV6_FLOW cases, but unlike all other cases which are
common for hash and spec, IPv4 and IPv6 defines different contants for
hash and for spec:

    #define	TCP_V4_FLOW	0x01	/* hash or spec (tcp_ip4_spec) */
    #define	UDP_V4_FLOW	0x02	/* hash or spec (udp_ip4_spec) */
    ...
    #define	IPV4_USER_FLOW	0x0d	/* spec only (usr_ip4_spec) */
    #define	IP_USER_FLOW	IPV4_USER_FLOW
    #define	IPV6_USER_FLOW	0x0e	/* spec only (usr_ip6_spec; nfc only) */
    #define	IPV4_FLOW	0x10	/* hash only */
    #define	IPV6_FLOW	0x11	/* hash only */

Extend the switch in flow_type_to_traffic_type to support both, which
fixes the failing ethtool -N command with flow-type ip4 or ip6.

Fixes: 248d3b4c9a39 ("net/mlx5e: Support flow classification into RSS contexts")
Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
Tested-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250319124508.3979818-1-maxim@isovalent.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 773624bb2c5d5..d68230a7b9f46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -884,8 +884,10 @@ static int flow_type_to_traffic_type(u32 flow_type)
 	case ESP_V6_FLOW:
 		return MLX5_TT_IPV6_IPSEC_ESP;
 	case IPV4_FLOW:
+	case IP_USER_FLOW:
 		return MLX5_TT_IPV4;
 	case IPV6_FLOW:
+	case IPV6_USER_FLOW:
 		return MLX5_TT_IPV6;
 	default:
 		return -EINVAL;
-- 
2.39.5



